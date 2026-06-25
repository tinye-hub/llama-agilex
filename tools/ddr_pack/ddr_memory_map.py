"""
DDR logical address map — Python mirror of src/scala/ddrMemoryMap/DdrMemoryMap.scala.

Authoritative spec: src/scala/ddrMemoryMap/doc/ddr-memory-map.md
"""

from __future__ import annotations

# Layout identity
LAYOUT_MAGIC = 0x4C4D3332  # "LM32"
LAYOUT_VERSION = 1

# Geometry
VECTOR_DIM = 2048
FP16_BYTES = 2
ROW_BYTES = 0x1000
VOCAB_SIZE = 128_256
GAMMA_COUNT = 33
N_LAYERS = 16
MAX_CONTEXT_LEN = 1024

# Region bases / sizes
EMB_BASE = 0x0000_0000
EMB_SIZE = VOCAB_SIZE * ROW_BYTES

RMS_GAMMA_BASE = 0x1F50_0000
RMS_GAMMA_SIZE = GAMMA_COUNT * ROW_BYTES

ATTN_BASE = 0x2000_0000
ATTN_LAYER_STRIDE = 0x0050_0000
ATTN_SIZE = N_LAYERS * ATTN_LAYER_STRIDE

FFN_BASE = 0x2500_0000
FFN_LAYER_STRIDE = 0x0180_0000
FFN_SIZE = N_LAYERS * FFN_LAYER_STRIDE

KV_BASE = 0x3D00_0000
KV_LAYER_STRIDE = 0x0020_0000
KV_TOKEN_STRIDE = 0x0000_0800
KV_VEC_BYTES = 0x0000_0400
KV_SIZE = N_LAYERS * KV_LAYER_STRIDE

META_BASE = 0x3F00_0000
META_SIZE = 0x0100_0000
META_GLOBAL_HEADER_SIZE = 0x1000
META_ATTN_SCALE_BASE = META_BASE + 0x0000_1000
META_FFN_SCALE_BASE = META_BASE + 0x0020_0000

EXT_BASE = 0x4000_0000

# Active PL mirror on DE25-Nano LPDDR4B
DDR_IMAGE_SIZE = 0x4000_0000  # 1 GiB

# Attention sub-matrix offsets (within one layer)
ATTN_WQ_OFFSET = 0x0000_0000
ATTN_WK_OFFSET = 0x0020_0000
ATTN_WV_OFFSET = 0x0028_0000
ATTN_WO_OFFSET = 0x0030_0000

# FFN sub-matrix offsets (within one layer)
FFN_GATE_OFFSET = 0x0000_0000
FFN_UP_OFFSET = 0x0080_0000
FFN_DOWN_OFFSET = 0x0100_0000

# Norm kinds (scheduler / tuser)
NORM_NORM1 = 0
NORM_NORM2 = 1
NORM_FINAL = 2

# INT4 quantization (GEMV INT4_G128)
INT4_GROUP_SIZE = 128
INT4_MAX = 15


class NormKind:
    NORM1 = NORM_NORM1
    NORM2 = NORM_NORM2
    FINAL = NORM_FINAL


def is_valid_token_id(token_id: int) -> bool:
    return 0 <= token_id < VOCAB_SIZE


def emb_row_base(token_id: int) -> int:
    if not is_valid_token_id(token_id):
        raise ValueError(f"token_id out of range: {token_id}")
    return EMB_BASE + token_id * ROW_BYTES


def gamma_index(layer: int, norm_kind: int) -> int:
    if norm_kind == NORM_FINAL:
        return GAMMA_COUNT - 1
    if not (0 <= layer < N_LAYERS):
        raise ValueError(f"layer out of range: {layer}")
    if norm_kind not in (NORM_NORM1, NORM_NORM2):
        raise ValueError(f"invalid norm_kind: {norm_kind}")
    return layer * 2 + norm_kind


def gamma_addr(layer: int, norm_kind: int) -> int:
    return RMS_GAMMA_BASE + gamma_index(layer, norm_kind) * ROW_BYTES


def attn_layer_base(layer: int) -> int:
    if not (0 <= layer < N_LAYERS):
        raise ValueError(f"layer out of range: {layer}")
    return ATTN_BASE + layer * ATTN_LAYER_STRIDE


def w_q(layer: int) -> int:
    return attn_layer_base(layer) + ATTN_WQ_OFFSET


def w_k(layer: int) -> int:
    return attn_layer_base(layer) + ATTN_WK_OFFSET


def w_v(layer: int) -> int:
    return attn_layer_base(layer) + ATTN_WV_OFFSET


def w_o(layer: int) -> int:
    return attn_layer_base(layer) + ATTN_WO_OFFSET


def ffn_layer_base(layer: int) -> int:
    if not (0 <= layer < N_LAYERS):
        raise ValueError(f"layer out of range: {layer}")
    return FFN_BASE + layer * FFN_LAYER_STRIDE


def gate_proj(layer: int) -> int:
    return ffn_layer_base(layer) + FFN_GATE_OFFSET


def up_proj(layer: int) -> int:
    return ffn_layer_base(layer) + FFN_UP_OFFSET


def down_proj(layer: int) -> int:
    return ffn_layer_base(layer) + FFN_DOWN_OFFSET


def int4_payload_bytes(num_weights: int) -> int:
    if num_weights % 2 != 0:
        raise ValueError("INT4 payload requires an even number of weights")
    return num_weights // 2


def sanity_check() -> None:
    assert EMB_SIZE == 0x1F50_0000
    assert emb_row_base(0) == 0x0000_0000
    assert emb_row_base(1) == 0x0000_1000
    assert emb_row_base(128_255) == 0x1F4F_F000
    assert gamma_addr(0, NORM_NORM1) == 0x1F50_0000
    assert gamma_addr(0, NORM_FINAL) == 0x1F52_0000
    assert w_q(0) == ATTN_BASE
    assert gate_proj(0) == FFN_BASE
