"""INT4_G128 quantization and nibble packing for DDR weight regions."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Tuple

import numpy as np

from ddr_memory_map import INT4_GROUP_SIZE, INT4_MAX


@dataclass
class QuantizedMatrix:
    payload: bytes
    scales: np.ndarray  # float32 per group
    zeros: np.ndarray   # uint8 per group, 0..15
    shape: Tuple[int, int]


def _quantize_group_symmetric(values: np.ndarray) -> Tuple[np.ndarray, float]:
    """Signed INT4 symmetric: stored UINT4 0..15 maps to -8..7."""
    amax = float(np.max(np.abs(values)))
    if amax == 0.0:
        return np.full(values.shape, 8, dtype=np.uint8), 1.0
    scale = amax / 7.0
    q_signed = np.clip(np.round(values / scale), -8, 7).astype(np.int16)
    q = (q_signed + 8).astype(np.uint8)
    return q, scale


def _quantize_group(values: np.ndarray) -> Tuple[np.ndarray, float, int]:
    """Asymmetric UINT4 quant for one group of float32 values."""
    vmin = float(values.min())
    vmax = float(values.max())
    if vmax == vmin:
        scale = 1.0 if vmax == 0.0 else abs(vmax) / INT4_MAX
        zero = 0
        q = np.zeros(values.shape, dtype=np.uint8)
        return q, scale, zero

    scale = (vmax - vmin) / INT4_MAX
    zero = int(np.clip(np.round(-vmin / scale), 0, INT4_MAX))
    q = np.clip(np.round(values / scale) + zero, 0, INT4_MAX).astype(np.uint8)
    return q, scale, zero


def quantize_linear_int4(
    weight: np.ndarray,
    group_size: int = INT4_GROUP_SIZE,
    *,
    symmetric: bool = True,
) -> QuantizedMatrix:
    """
    Quantize PyTorch-style Linear weight [out_features, in_features] to INT4 payload.

    Groups are taken along in_features (K) in row-major order, matching GEMV INT4_G128.
    Default symmetric mode stores one FP16 scale per group (2 B metadata) to fit META region.
    """
    if weight.ndim != 2:
        raise ValueError(f"expected 2-D weight, got shape {weight.shape}")
    out_features, in_features = weight.shape
    if in_features % group_size != 0:
        raise ValueError(f"in_features {in_features} must be divisible by group_size {group_size}")

    groups_per_row = in_features // group_size
    num_groups = out_features * groups_per_row
    q_all = np.empty(out_features * in_features, dtype=np.uint8)
    scales = np.empty(num_groups, dtype=np.float32)
    zeros = np.empty(num_groups, dtype=np.uint8)

    gi = 0
    for row in range(out_features):
        row_data = weight[row].astype(np.float32)
        for g in range(groups_per_row):
            sl = slice(g * group_size, (g + 1) * group_size)
            if symmetric:
                q, scale = _quantize_group_symmetric(row_data[sl])
                zero = 8
            else:
                q, scale, zero = _quantize_group(row_data[sl])
            base = row * in_features + g * group_size
            q_all[base : base + group_size] = q
            scales[gi] = scale
            zeros[gi] = zero
            gi += 1

    payload = pack_uint4_nibbles(q_all)
    return QuantizedMatrix(payload=payload, scales=scales, zeros=zeros, shape=(out_features, in_features))


def pack_uint4_nibbles(values: np.ndarray) -> bytes:
    """Pack UINT4 array (0..15) little-endian nibble order: low nibble first."""
    flat = np.asarray(values, dtype=np.uint8).reshape(-1)
    if flat.size % 2 != 0:
        raise ValueError("UINT4 array must have even length")
    low = flat[0::2] & 0x0F
    high = flat[1::2] & 0x0F
    packed = low | (high << 4)
    return packed.astype(np.uint8).tobytes()


def pack_scale_zero_table(scales: np.ndarray, zeros: np.ndarray | None = None) -> bytes:
    """
    Compact scale table: uint16 scale_fp16 (LE) per INT4 group (2 bytes).

    Symmetric INT4 uses implicit zero=8 (stored nibble maps to signed -8..7).
    If zeros is provided and not all 8, a ValueError is raised — use symmetric quant.
    """
    if zeros is not None and not np.all(zeros == 8):
        raise ValueError("metadata budget fits only FP16 scale (symmetric INT4, zero=8)")
    out = bytearray(len(scales) * 2)
    for i, s in enumerate(scales):
        fp16 = np.float16(float(s)).view(np.uint16)
        out[i * 2 + 0] = fp16 & 0xFF
        out[i * 2 + 1] = (fp16 >> 8) & 0xFF
    return bytes(out)
