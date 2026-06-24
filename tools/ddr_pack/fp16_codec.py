"""BF16 / FP32 / FP16 conversions for DDR packing (little-endian)."""

from __future__ import annotations

import numpy as np


def bf16_bytes_to_f32(data: bytes) -> np.ndarray:
    """Decode safetensors BF16 payload to float32."""
    if len(data) % 2 != 0:
        raise ValueError("BF16 byte length must be even")
    u16 = np.frombuffer(data, dtype="<u2")
    u32 = u16.astype(np.uint32) << 16
    return u32.view("<f4")


def f32_to_fp16_bytes(values: np.ndarray) -> bytes:
    """Encode float32 vector as little-endian IEEE754 binary16."""
    flat = np.asarray(values, dtype=np.float32).reshape(-1)
    return flat.astype("<f2").tobytes()


def f32_to_fp16_bits(values: np.ndarray) -> np.ndarray:
    flat = np.asarray(values, dtype=np.float32).reshape(-1)
    return flat.astype("<f2").view("<u2")


def fp16_bytes_to_f32(data: bytes) -> np.ndarray:
    if len(data) % 2 != 0:
        raise ValueError("FP16 byte length must be even")
    u16 = np.frombuffer(data, dtype="<u2")
    return u16.astype("<f2").astype(np.float32)


def float_to_fp16_bits(value: float) -> int:
    return int(np.float16(value).view(np.uint16))
