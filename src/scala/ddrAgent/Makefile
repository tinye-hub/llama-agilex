# ddrAgent — run from: src/scala/ddrAgent/
#
#   make verilog       Spinal -> gen/verilog/
#   make verilator     Verilator DdrAgentM1Sim (64-bit AXI)
#   make questa        Questa DdrAgentM1 + file-backed AXI DDR (256-bit default)
#
# Questa variants:  make questa WAVE=1   |   make questa VIEW=1   |   make questa DEBUG=1
# Verilator PASS/FAIL colors: scripts/sbt-runmain.sh (see doc/simulation-conventions.md)

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

.PHONY: all help verilog verilator questa-compile questa questa-run questa-view \
	clean clean-verilator clean-questa

all: verilator

help:
	@echo "ddrAgent Makefile (cwd=$(CURDIR))"
	@echo "  verilog          AXI_WIDTH=$(AXI_WIDTH) -> gen/verilog/DdrAgentM1.v"
	@echo "  verilator        Verilator DdrAgentM1Sim (64-bit AXI, DDR_IMAGE=$(DDR_IMAGE))"
	@echo "  questa           verilog + Questa (AXI_WIDTH=$(AXI_WIDTH))"
	@echo "  questa DEBUG=1   questa + verbose AXI/state log (DDR_AGENT_DEBUG)"
	@echo "  questa WAVE=1    questa + WLF $(QUESTA_WLF)"
	@echo "  questa VIEW=1    Open $(QUESTA_WLF) in Questa GUI ($(NC_RUN_GUI) vsim -view)"
	@echo "  questa-compile   Questa compile only"
	@echo "  clean            remove gen/"
	@echo ""
	@echo "  NC_RUN:     $(if $(NC_RUN),$(NC_RUN),(empty — local run))"
	@echo "  Batch EDA:  source ../../../set_env.sh  then make questa"
	@echo "  Sim policy:  ../doc/simulation-conventions.md"

verilog:
	cd $(SCALA_ROOT) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) $(SBT) "runMain ddrAgent.DdrAgentM1Gen"

verilator: clean-verilator
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(SCALA_ROOT) && DDR_IMAGE="$(DDR_IMAGE)" \
	  $(SCALA_ROOT)/scripts/sbt-runmain.sh ddrAgent.DdrAgentM1Sim

questa-compile: verilog
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE)" \
	  $(NC_RUN) ./run.sh compile

ifeq ($(VIEW),1)
questa: questa-view
else
questa: questa-run
endif

questa-run: verilog
	@test -f "$(DDR_IMAGE)" || { \
	  echo "Missing $(DDR_IMAGE) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE)" \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF))",) \
	  $(if $(filter 1,$(DEBUG)),DDR_AGENT_DEBUG=1,) \
	  $(NC_RUN) ./run.sh m1

questa-view:
	@test -f $(QUESTA_WLF) || { \
	  echo "Missing $(QUESTA_WLF) — run: make questa WAVE=1"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF))

clean-verilator:
	rm -rf gen/sim 2>/dev/null || true

clean-questa:
	rm -rf test/questa/work test/questa/transcript test/questa/etch*

clean: clean-verilator clean-questa
	rm -rf gen/verilog
