#!/usr/bin/env python3
"""
Pack Llama 3.2 1B safetensors into a 1 GiB DDR image (Plan A / DdrMemoryMap).

Usage:
  python pack_weights.py --model /path/to/model.safetensors --output ddr_image.bin
  python pack_weights.py --model ... --output ddr_image.bin --fp16-only   # M1: embed + gamma
"""

from __future__ import annotations

import argparse
import sys
import time
from pathlib import Path

import numpy as np

from ddr_image import DdrImage
from ddr_memory_map import (
    META_ATTN_SCALE_BASE,
    N_LAYERS,
    NORM_FINAL,
    NORM_NORM1,
    NORM_NORM2,
    VOCAB_SIZE,
    down_proj,
    emb_row_base,
    gamma_addr,
    gate_proj,
    int4_payload_bytes,
    sanity_check,
    up_proj,
    w_k,
    w_o,
    w_q,
    w_v,
)
from fp16_codec import f32_to_fp16_bytes
from metadata import write_global_header
from quantize_int4 import pack_scale_zero_table, quantize_linear_int4
from safetensors_io import load_tensors, tensor_to_f32


def _require(tensors: dict, name: str):
    if name not in tensors:
        raise KeyError(f"missing tensor: {name}")
    return tensors[name]


def pack_embedding(image: DdrImage, tensors: dict) -> None:
    info = _require(tensors, "model.embed_tokens.weight")
    weight = tensor_to_f32(info)
    if weight.shape != (VOCAB_SIZE, 2048):
        raise ValueError(f"unexpected embed shape {weight.shape}")
    print(f"  embedding {weight.shape} BF16→FP16 …")
    for tid in range(VOCAB_SIZE):
        row = f32_to_fp16_bytes(weight[tid])
        image.write(emb_row_base(tid), row)
        if tid and tid % 20000 == 0:
            print(f"    … token {tid}/{VOCAB_SIZE}")


def pack_rms_gamma(image: DdrImage, tensors: dict) -> None:
    print("  RMSNorm gamma (33 × 2048 FP16) …")
    for layer in range(N_LAYERS):
        n1 = tensor_to_f32(_require(tensors, f"model.layers.{layer}.input_layernorm.weight"))
        n2 = tensor_to_f32(_require(tensors, f"model.layers.{layer}.post_attention_layernorm.weight"))
        image.write(gamma_addr(layer, NORM_NORM1), f32_to_fp16_bytes(n1))
        image.write(gamma_addr(layer, NORM_NORM2), f32_to_fp16_bytes(n2))
    final = tensor_to_f32(_require(tensors, "model.norm.weight"))
    image.write(gamma_addr(0, NORM_FINAL), f32_to_fp16_bytes(final))


def pack_attention_ffn(
    image: DdrImage, tensors: dict
) -> tuple[bytes, bytes, int]:
    attn_scales: list[np.ndarray] = []
    attn_zeros: list[np.ndarray] = []
    ffn_scales: list[np.ndarray] = []
    ffn_zeros: list[np.ndarray] = []

    print("  attention INT4 (16 layers) …")
    for layer in range(N_LAYERS):
        pfx = f"model.layers.{layer}.self_attn"
        specs = [
            (w_q(layer), f"{pfx}.q_proj.weight", 2048, 2048),
            (w_k(layer), f"{pfx}.k_proj.weight", 512, 2048),
            (w_v(layer), f"{pfx}.v_proj.weight", 512, 2048),
            (w_o(layer), f"{pfx}.o_proj.weight", 2048, 2048),
        ]
        for addr, key, out_f, in_f in specs:
            mat = tensor_to_f32(_require(tensors, key))
            if mat.shape != (out_f, in_f):
                raise ValueError(f"{key}: expected {(out_f, in_f)}, got {mat.shape}")
            q = quantize_linear_int4(mat)
            expected = int4_payload_bytes(out_f * in_f)
            if len(q.payload) != expected:
                raise ValueError(f"{key}: payload {len(q.payload)} != expected {expected}")
            image.write(addr, q.payload)
            attn_scales.append(q.scales)
            attn_zeros.append(q.zeros)
        print(f"    layer {layer} attention done")

    print("  FFN INT4 (16 layers) …")
    for layer in range(N_LAYERS):
        pfx = f"model.layers.{layer}.mlp"
        specs = [
            (gate_proj(layer), f"{pfx}.gate_proj.weight", 8192, 2048),
            (up_proj(layer), f"{pfx}.up_proj.weight", 8192, 2048),
            (down_proj(layer), f"{pfx}.down_proj.weight", 2048, 8192),
        ]
        for addr, key, out_f, in_f in specs:
            mat = tensor_to_f32(_require(tensors, key))
            if mat.shape != (out_f, in_f):
                raise ValueError(f"{key}: expected {(out_f, in_f)}, got {mat.shape}")
            q = quantize_linear_int4(mat)
            expected = int4_payload_bytes(out_f * in_f)
            if len(q.payload) != expected:
                raise ValueError(f"{key}: payload {len(q.payload)} != expected {expected}")
            image.write(addr, q.payload)
            ffn_scales.append(q.scales)
            ffn_zeros.append(q.zeros)
        print(f"    layer {layer} FFN done")

    attn_scale_blob = pack_scale_zero_table(np.concatenate(attn_scales))
    ffn_scale_blob = pack_scale_zero_table(np.concatenate(ffn_scales))
    ffn_scale_offset = META_ATTN_SCALE_BASE + len(attn_scale_blob)
    return attn_scale_blob, ffn_scale_blob, ffn_scale_offset


def pack_model(
    model_path: Path,
    output_path: Path,
    fp16_only: bool = False,
) -> None:
    sanity_check()
    t0 = time.time()
    print(f"Loading {model_path} …")
    tensors = load_tensors(model_path)
    print(f"  {len(tensors)} tensors")

    image = DdrImage()
    pack_embedding(image, tensors)
    pack_rms_gamma(image, tensors)

    if fp16_only:
        write_global_header(image, attn_scale_bytes=0, ffn_scale_bytes=0, ffn_scale_offset=0)
    else:
        attn_blob, ffn_blob, ffn_off = pack_attention_ffn(image, tensors)
        image.write(META_ATTN_SCALE_BASE, attn_blob)
        image.write(ffn_off, ffn_blob)
        write_global_header(image, len(attn_blob), len(ffn_blob), ffn_off)
        print(
            f"  metadata: attn_scale=0x{len(attn_blob):X} B @ 0x{META_ATTN_SCALE_BASE:08X}, "
            f"ffn_scale=0x{len(ffn_blob):X} B @ 0x{ffn_off:08X}"
        )

    print(f"Writing {output_path} (1 GiB) …")
    image.save(output_path)
    elapsed = time.time() - t0
    print(f"Done in {elapsed:.1f}s → {output_path}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Pack Llama 3.2 1B weights into DDR image")
    parser.add_argument(
        "--model",
        type=Path,
        required=True,
        help="Path to model.safetensors",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("ddr_image.bin"),
        help="Output DDR image path (default: ddr_image.bin)",
    )
    parser.add_argument(
        "--fp16-only",
        action="store_true",
        help="Pack only embedding + RMSNorm gamma (milestone 1)",
    )
    args = parser.parse_args(argv)

    if not args.model.is_file():
        print(f"error: model not found: {args.model}", file=sys.stderr)
        return 1

    pack_model(args.model, args.output, fp16_only=args.fp16_only)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
