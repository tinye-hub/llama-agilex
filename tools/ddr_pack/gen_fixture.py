#!/usr/bin/env python3
"""
Generate a small DDR fixture for DdrAgent M1 simulation (no model required).

Writes known FP16 patterns at:
  token 0 embed @ 0x0000_0000
  token 1 embed @ 0x0000_1000
  L0 norm1 gamma @ 0x1F50_0000
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np

from ddr_image import DdrImage
from ddr_memory_map import VECTOR_DIM, emb_row_base, gamma_addr, sanity_check
from fp16_codec import f32_to_fp16_bytes
from metadata import write_global_header


def _fp16_pattern(base: float, dim: int = VECTOR_DIM) -> bytes:
    vals = np.arange(dim, dtype=np.float32) * 0.01 + base
    return f32_to_fp16_bytes(vals)


def gen_fixture(output: Path) -> None:
    sanity_check()
    image = DdrImage()

    image.write(emb_row_base(0), _fp16_pattern(0.0))
    image.write(emb_row_base(1), _fp16_pattern(1.0))
    image.write(gamma_addr(0, 0), f32_to_fp16_bytes(np.ones(VECTOR_DIM, dtype=np.float32)))

    write_global_header(image, attn_scale_bytes=0, ffn_scale_bytes=0, ffn_scale_offset=0)
    image.save(output)

    # Also emit a tiny 16 KiB slice for quick sim preload
    slice_path = output.with_suffix(".slice.bin")
    slice_path.write_bytes(image.read(0, 0x2000) + image.read(0x1F50_0000, 0x1000))
    print(f"fixture: {output} (1 GiB sparse zeros + 3 regions)")
    print(f"slice:   {slice_path} (12 KiB: embed0 + embed1 + gamma)")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Generate DDR fixture for M1 sim")
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("ddr_fixture.bin"),
        help="Output DDR image (default: ddr_fixture.bin)",
    )
    args = parser.parse_args(argv)
    gen_fixture(args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
