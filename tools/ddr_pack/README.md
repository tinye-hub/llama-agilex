# DDR weight packer

Offline tool to pack HuggingFace `model.safetensors` into a **1 GiB logical DDR image**
matching [`DdrMemoryMap.scala`](../../src/scala/common/DdrMemoryMap.scala).

## Quick start

```bash
# From repo root (uses llama-fpga/pdf-env Python with numpy)
make -C tools/ddr_pack fixture

# Milestone 1 only: embedding + RMSNorm gamma (~501 MiB payload)
make -C tools/ddr_pack pack-m1 MODEL=/path/to/model.safetensors

# Full Plan A image: FP16 embed/γ + INT4 attention/FFN + metadata (~1 GiB)
make -C tools/ddr_pack pack MODEL=/path/to/model.safetensors
```

Default model path (if `MODEL` unset):

```text
/userworkqum/tinye/llama/LLMs-from-scratch/ch05/07_gpt_to_llama/Llama-3.2-1B-Instruct/model.safetensors
```

## Output layout

| Region | Address | Content |
|:---|:---|:---|
| Embedding | `0x0000_0000` | 128256 × 2048 FP16 (BF16→FP16) |
| RMSNorm γ | `0x1F50_0000` | 33 × 2048 FP16 |
| Attention | `0x2000_0000` | 16 layers INT4 payload (G128) |
| FFN | `0x2500_0000` | 16 layers INT4 payload (G128) |
| KV cache | `0x3D00_0000` | zeros (runtime) |
| Metadata | `0x3F00_0000` | GlobalHeader + scale tables |

KV cache is left zeroed; it is filled at inference time.

## Weight mapping (HF → DDR)

| HuggingFace key | DDR |
|:---|:---|
| `model.embed_tokens.weight` | `emb_row_base(token_id)` |
| `model.layers.{L}.input_layernorm.weight` | `gamma_addr(L, norm1)` |
| `model.layers.{L}.post_attention_layernorm.weight` | `gamma_addr(L, norm2)` |
| `model.norm.weight` | `gamma_addr(0, final_norm)` |
| `model.layers.{L}.self_attn.{q,k,v,o}_proj.weight` | `w_q/k/v/o(L)` |
| `model.layers.{L}.mlp.{gate,up,down}_proj.weight` | `gate/up/down_proj(L)` |

## INT4 metadata

- Quantization: **symmetric signed INT4** (`group_size=128` along K), UINT4 0..15 → -8..7.
- Payload: 2 nibbles/byte, low nibble first (matches GEMV tile 64 weights = 32 B).
- Scale table: **2 B/group** (`scale_fp16` only); implicit zero = 8.

Scale tables are written contiguously in the metadata region:

1. Attn scales at `META_ATTN_SCALE_BASE` (`0x3F00_1000`)
2. FFN scales immediately after attn table (~`0x3F281000`)
3. `ffn_scale_offset` recorded in GlobalHeader

Total metadata scales ≈ 14.5 MiB (fits in 16 MiB `META` region).

## Files

| File | Role |
|:---|:---|
| `ddr_memory_map.py` | Address constants (mirror of Scala) |
| `safetensors_io.py` | Pure-Python safetensors reader (BF16, no torch) |
| `fp16_codec.py` | BF16/FP16 conversion |
| `quantize_int4.py` | INT4_G128 quant + pack |
| `ddr_image.py` | 1 GiB byte image |
| `pack_weights.py` | Main packer CLI |
| `gen_fixture.py` | Tiny fixture for DdrAgent sim |

## Python environment

Uses `llama-fpga/pdf-env` (numpy) by default. Override:

```bash
make pack PYTHON=/your/python3
```

No PyTorch required — BF16 weights are decoded directly from safetensors bytes.
