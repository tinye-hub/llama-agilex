#!/usr/bin/env python3
"""Generate Questa golden vectors for SerialSafeSoftmaxAxiTop."""

from __future__ import annotations

import argparse
import math
import random
import struct
from pathlib import Path

_REPO = Path(__file__).resolve().parents[2]


def _u16_to_f32(u: int) -> float:
    return struct.unpack("<e", struct.pack("<H", u & 0xFFFF))[0]


def stable_softmax_fp16(scores_u16: list[int]) -> list[int]:
    x = [_u16_to_f32(v) for v in scores_u16]
    m = max(x)
    e = [math.exp(v - m) for v in x]
    s = sum(e)
    if s == 0.0:
        y = [1.0 / len(x)] * len(x)
    else:
        y = [v / s for v in e]
    return [struct.unpack("<H", struct.pack("<e", float(v)))[0] for v in y]


def write_hex_lines(path: Path, u16: list[int]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        for v in u16:
            f.write(f"{v & 0xFFFF:04x}\n")


def f32_to_fp16_u16(val: float) -> int:
    return struct.unpack("<H", struct.pack("<e", float(val)))[0]


def make_case(out_dir: Path, length: int, seed: int, user: int) -> None:
    rng = random.Random(seed)
    raw = [rng.gauss(-2.0, 3.0) for _ in range(length)]
    if length >= 3:
        raw[0] = -20.0
        raw[1] = 8.0
        raw[-1] = -1.0
    scores_u16 = [f32_to_fp16_u16(v) for v in raw]
    weights_u16 = stable_softmax_fp16(scores_u16)

    case_dir = out_dir / f"len{length}"
    case_dir.mkdir(parents=True, exist_ok=True)
    write_hex_lines(case_dir / "input_scores.txt", scores_u16)
    write_hex_lines(case_dir / "expected_weights.txt", weights_u16)
    with (case_dir / "meta.txt").open("w", encoding="utf-8") as f:
        f.write(f"len={length}\n")
        f.write(f"user=0x{user & 0x7FFF:04x}\n")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "-o",
        "--out-dir",
        type=Path,
        default=_REPO / "src" / "scala" / "attention" / "softmax" / "test" / "questa" / "golden_refs",
    )
    ap.add_argument("--cases", type=int, nargs="+", default=[1, 16, 128])
    ap.add_argument("--seed", type=int, default=42)
    args = ap.parse_args()

    for i, n in enumerate(args.cases):
        make_case(args.out_dir, n, seed=args.seed + i * 17, user=0x00A5 + i)

    print(f"Wrote {len(args.cases)} cases under {args.out_dir}")


if __name__ == "__main__":
    main()
