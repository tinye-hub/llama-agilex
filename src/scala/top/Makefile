# top module — run from: src/scala/top/
#
#   make verilog          Spinal -> gen/verilog/LlamaM1Top.v  (Quartus FP IP, 256-bit AXI)
#   make verilog-sim      same with RmsNorm sim stubs (no Quartus black boxes)
#   make questa-m1        M1 graduation test: Questa + real FP IPs + FP golden check
#   make sim              Verilator smoke test (control-flow only, FP values = 0 by design)
#
# NOTE: Verilator cannot simulate Quartus Agilex IP blackboxes.
#       FP numerical accuracy MUST be verified via questa-m1 (Questa + real IPs).
#       See .cursor/rules/questa-simulation.mdc for details.

SCALA_ROOT  := $(abspath ..)
REPO_ROOT   := $(abspath ../../..)
DIM         ?= 2048
SBT         ?= sbt -batch
DDR_IMAGE   ?= $(REPO_ROOT)/tools/ddr_pack/out/ddr_image_m1.bin

NC_RUN      ?=
NC_RUN_GUI  ?=
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export VERILATOR_REAL_MAKE := /usr/bin/make
export DDR_IMAGE

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
QUESTA_WLF  := $(QUESTA_WORK)/tb_llama_m1_top.wlf

ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help verilog verilog-sim questa-compile questa-m1 questa-m1-wave questa-wave \
        sim clean clean-sim clean-questa

all: verilog

help:
	@echo "top Makefile (cwd=$(CURDIR))"
	@echo "  verilog          -> gen/verilog/LlamaM1Top.v (Quartus FP IP, 256-bit AXI)"
	@echo "  verilog-sim      -> gen/verilog/LlamaM1Top.v (timing stubs, no real FP)"
	@echo "  questa-m1        verilog + Questa M1 graduation test (FP golden check)"
	@echo "  questa-m1-wave   questa-m1 + waveform $(QUESTA_WLF)"
	@echo "  questa-wave      Open $(QUESTA_WLF) in Questa GUI"
	@echo "  sim              Verilator control-flow smoke test (NO FP accuracy)"
	@echo "  clean            remove gen/"
	@echo ""
	@echo "  NC_RUN:     $(if $(NC_RUN),$(NC_RUN),(empty — local run))"
	@echo "  DDR_IMAGE:  $(DDR_IMAGE)"

verilog:
	cd $(SCALA_ROOT) && LLAMA_M1_DIM=$(DIM) LLAMA_M1_GEN_DIR=top/gen/verilog \
	  $(SBT) "runMain top.LlamaM1Gen"

verilog-sim:
	cd $(SCALA_ROOT) && LLAMA_M1_DIM=$(DIM) LLAMA_M1_SIM_IP=1 LLAMA_M1_GEN_DIR=top/gen/verilog \
	  $(SBT) "runMain top.LlamaM1Gen"

questa-compile: verilog
	cd $(QUESTA_DIR) && DDR_IMAGE="$(DDR_IMAGE)" $(NC_RUN) ./run.sh compile

questa-m1: verilog
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(QUESTA_DIR) && DDR_IMAGE="$(DDR_IMAGE)" $(NC_RUN) ./run.sh m1

questa-m1-wave: verilog
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(QUESTA_DIR) && DDR_IMAGE="$(DDR_IMAGE)" QUESTA_WAVE=1 \
	  QUESTA_WLF="$(abspath $(QUESTA_WLF))" $(NC_RUN) ./run.sh m1

questa-wave:
	@test -f $(QUESTA_WLF) || { \
	  echo "Missing $(QUESTA_WLF) — run: make questa-m1-wave"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF))

sim: clean-sim
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(SCALA_ROOT) && DDR_IMAGE="$(DDR_IMAGE)" $(SBT) "runMain top.LlamaM1TopSim"

clean-sim:
	rm -rf gen/sim 2>/dev/null || true

clean-questa:
	rm -rf test/questa/work test/questa/transcript

clean: clean-sim clean-questa
	rm -rf gen
