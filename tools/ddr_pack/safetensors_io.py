"""Minimal safetensors loader (BF16 / F32 / F16) without PyTorch."""

from __future__ import annotations

import json
import struct
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterator, Tuple

import numpy as np

from fp16_codec import bf16_bytes_to_f32


@dataclass(frozen=True)
class TensorInfo:
    name: str
    dtype: str
    shape: Tuple[int, ...]
    data: bytes


def _read_header(path: Path) -> Tuple[dict, int]:
    with path.open("rb") as f:
        header_size = struct.unpack("<Q", f.read(8))[0]
        header = json.loads(f.read(header_size).decode("utf-8"))
        data_offset = 8 + header_size
    return header, data_offset


def iter_tensors(path: str | Path) -> Iterator[TensorInfo]:
    path = Path(path)
    header, data_offset = _read_header(path)
    with path.open("rb") as f:
        blob = f.read()
    for name, info in header.items():
        if name == "__metadata__":
            continue
        start, end = info["data_offsets"]
        yield TensorInfo(
            name=name,
            dtype=info["dtype"],
            shape=tuple(info["shape"]),
            data=blob[data_offset + start : data_offset + end],
        )


def load_tensors(path: str | Path) -> Dict[str, TensorInfo]:
    return {t.name: t for t in iter_tensors(path)}


def tensor_to_f32(info: TensorInfo) -> np.ndarray:
    """Return tensor as float32 numpy array in logical shape."""
    if info.dtype == "BF16":
        arr = bf16_bytes_to_f32(info.data).reshape(info.shape)
        return arr.astype(np.float32)
    if info.dtype == "F16":
        u16 = np.frombuffer(info.data, dtype="<u2").reshape(info.shape)
        return u16.astype("<f2").astype(np.float32)
    if info.dtype == "F32":
        return np.frombuffer(info.data, dtype="<f4").reshape(info.shape).astype(np.float32)
    raise ValueError(f"unsupported dtype {info.dtype} for {info.name}")
