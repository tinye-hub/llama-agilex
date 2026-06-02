#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
sbt -batch "runMain util.UtilIpWrappersGen"
echo "--- BlackBox instances in generated Verilog ---"
grep -E "^\s*(fp16ToFp32|fp32ToFp16|fp32Rsqrt|fp32MultAcc|fp32Add)\s" gen/util_ip_wrappers/UtilIpWrappersTop.v | head -20 || true
