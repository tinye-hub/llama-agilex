"""Byte-addressable DDR image backing store."""

from __future__ import annotations

import mmap
from pathlib import Path

from ddr_memory_map import DDR_IMAGE_SIZE


class DdrImage:
    """1 GiB logical DDR mirror (zeros by default)."""

    def __init__(self, size: int = DDR_IMAGE_SIZE) -> None:
        self.size = size
        self._data = bytearray(size)

    def write(self, addr: int, payload: bytes) -> None:
        if addr < 0 or addr + len(payload) > self.size:
            raise ValueError(
                f"write out of range: addr=0x{addr:X} len={len(payload)} size=0x{self.size:X}"
            )
        self._data[addr : addr + len(payload)] = payload

    def read(self, addr: int, length: int) -> bytes:
        if addr < 0 or addr + length > self.size:
            raise ValueError(
                f"read out of range: addr=0x{addr:X} len={length} size=0x{self.size:X}"
            )
        return bytes(self._data[addr : addr + length])

    def to_bytes(self) -> bytes:
        return bytes(self._data)

    def save(self, path: str | Path) -> None:
        path = Path(path)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(self._data)

    @classmethod
    def load(cls, path: str | Path, size: int = DDR_IMAGE_SIZE) -> "DdrImage":
        raw = Path(path).read_bytes()
        if len(raw) > size:
            raise ValueError(f"file size 0x{len(raw):X} exceeds DDR image size 0x{size:X}")
        img = cls(size=size)
        img._data[: len(raw)] = raw
        return img

    @classmethod
    def open_mmap(cls, path: str | Path, size: int = DDR_IMAGE_SIZE) -> "DdrImage":
        """Load via mmap for large images (read-mostly)."""
        path = Path(path)
        img = cls(size=size)
        with path.open("r+b") as f:
            if f.seek(0, 2) < size:
                f.truncate(size)
            mm = mmap.mmap(f.fileno(), size, access=mmap.ACCESS_COPY)
            img._data = bytearray(mm)
        return img
