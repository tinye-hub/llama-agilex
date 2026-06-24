# ddrAgent — run from: src/scala/ddrAgent/
#
#   make verilog       Spinal -> gen/verilog/
#   make sim           Verilator DdrAgentM1Sim
#   make questa-m1     Questa DdrAgentM1 + file-backed AXI DDR

SCALA_ROOT := $(abspath ..)
REPO_ROOT  := $(abspath ../../..)
SBT        ?= sbt -batch
DDR_IMAGE  ?= $(REPO_ROOT)/tools/ddr_pack/out/ddr_image_m1.bin
AXI_WIDTH  ?= 256

# Quartus/Questa on batch nodes: source ../../../set_env.sh  (exports NC_RUN via AAP nc).
NC_RUN ?=
NC_RUN_GUI ?=
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export VERILATOR_REAL_MAKE := /usr/bin/make
export DDR_IMAGE
export DDR_AGENT_AXI_WIDTH := $(AXI_WIDTH)

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
QUESTA_WLF  := $(QUESTA_WORK)/tb_ddr_agent_m1.wlf

ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help verilog sim questa-compile questa-m1 questa-m1-wave questa-wave \
	clean clean-sim clean-questa

all: sim

help:
	@echo "ddrAgent Makefile (cwd=$(CURDIR))"
	@echo "  verilog          AXI_WIDTH=$(AXI_WIDTH) -> gen/verilog/DdrAgentM1.v"
	@echo "  sim              Verilator DdrAgentM1Sim (64-bit AXI, DDR_IMAGE=$(DDR_IMAGE))"
	@echo "  questa-m1        verilog + Questa (AXI_WIDTH=$(AXI_WIDTH))"
	@echo "  questa-m1-debug  questa-m1 +DDR_AGENT_DEBUG (verbose AXI/state log)"
	@echo "  questa-m1-wave   same + WLF $(QUESTA_WLF) (or: make questa-m1 WAVE=1)"
	@echo "  questa-wave      Open $(QUESTA_WLF) in Questa GUI ($(NC_RUN_GUI) vsim -view)"
	@echo "  questa-compile   Questa compile only"
	@echo "  clean            remove gen/"
	@echo ""
	@echo "  NC_RUN:     $(if $(NC_RUN),$(NC_RUN),(empty — local run))"
	@echo "  Batch EDA:  source ../../../set_env.sh  then make questa-m1"

verilog:
	cd $(SCALA_ROOT) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) $(SBT) "runMain ddrAgent.DdrAgentM1Gen"

sim: clean-sim
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(SCALA_ROOT) && DDR_IMAGE="$(DDR_IMAGE)" $(SBT) "runMain ddrAgent.DdrAgentM1Sim"

questa-compile: verilog
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE)" \
	  $(NC_RUN) ./run.sh compile

questa-m1: verilog
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE)" \
	  $(NC_RUN) ./run.sh m1

questa-m1-debug: verilog
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE)" \
	  DDR_AGENT_DEBUG=1 $(NC_RUN) ./run.sh m1

questa-m1-wave: verilog
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE)" \
	  QUESTA_WAVE=1 QUESTA_WLF="$(abspath $(QUESTA_WLF))" $(NC_RUN) ./run.sh m1

questa-wave:
	@test -f $(QUESTA_WLF) || { \
	  echo "Missing $(QUESTA_WLF) — run: make questa-m1-wave"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF))

clean-sim:
	rm -rf gen/sim 2>/dev/null || true

clean-questa:
	rm -rf test/questa/work test/questa/transcript test/questa/etch*

clean: clean-sim clean-questa
	rm -rf gen/verilog
