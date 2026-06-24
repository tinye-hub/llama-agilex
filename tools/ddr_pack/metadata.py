"""Write GlobalHeader into DDR metadata region."""

from __future__ import annotations

import struct

from ddr_memory_map import (
    ATTN_BASE,
    ATTN_SIZE,
    DDR_IMAGE_SIZE,
    EMB_BASE,
    EMB_SIZE,
    FFN_BASE,
    FFN_SIZE,
    KV_BASE,
    KV_SIZE,
    LAYOUT_MAGIC,
    LAYOUT_VERSION,
    META_BASE,
    META_ATTN_SCALE_BASE,
    RMS_GAMMA_BASE,
    RMS_GAMMA_SIZE,
    INT4_GROUP_SIZE,
)
from ddr_image import DdrImage


def build_global_header(
    attn_scale_bytes: int,
    ffn_scale_bytes: int,
    ffn_scale_offset: int,
) -> bytes:
    fields = [
        ("I", LAYOUT_MAGIC),
        ("I", LAYOUT_VERSION),
        ("I", EMB_BASE),
        ("I", EMB_SIZE & 0xFFFFFFFF),
        ("I", RMS_GAMMA_BASE),
        ("I", RMS_GAMMA_SIZE),
        ("I", ATTN_BASE),
        ("I", ATTN_SIZE & 0xFFFFFFFF),
        ("I", FFN_BASE),
        ("I", FFN_SIZE & 0xFFFFFFFF),
        ("I", KV_BASE),
        ("I", KV_SIZE & 0xFFFFFFFF),
        ("I", META_BASE),
        ("I", DDR_IMAGE_SIZE),
        ("I", META_ATTN_SCALE_BASE),
        ("I", attn_scale_bytes),
        ("I", ffn_scale_offset),
        ("I", ffn_scale_bytes),
        ("I", INT4_GROUP_SIZE),
    ]
    buf = bytearray(256)
    off = 0
    for fmt, val in fields:
        struct.pack_into(f"<{fmt}", buf, off, val)
        off += struct.calcsize(fmt)
    return bytes(buf)


def write_global_header(
    image: DdrImage,
    attn_scale_bytes: int,
    ffn_scale_bytes: int,
    ffn_scale_offset: int,
) -> None:
    image.write(META_BASE, build_global_header(attn_scale_bytes, ffn_scale_bytes, ffn_scale_offset))
