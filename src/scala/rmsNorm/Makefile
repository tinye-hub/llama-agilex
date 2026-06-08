# rmsNorm module — run from: src/scala/rmsNorm/
#
#   make verilog          Spinal -> gen/verilog/
#   make sim              Verilator (core + AXI), DIM=2048
#   make quartus          syn + fit + sta (no bitstream)
#   make quartus-report   print fit resource summary

SCALA_ROOT  := $(abspath ..)
REPO_ROOT   := $(abspath ../../..)
QUARTUS     ?= quartus_sh
PROJECT     := rmsnorm_top
DIM         ?= 2048
SBT         ?= sbt -batch

# Quartus/Questa license: submit via nc (see repo set_env.sh). Override for local run:
#   make quartus NC_RUN=
# Or: source set_env.sh  (exports NC_RUN) before make.
NC_RUN ?= nc run -I -r Taskerlist:i OSREL:RHEL8 RAM/8GB CORES/8 CGROUP:CORES -jpp fastest,pack --
# -Ix: forward DISPLAY for Questa GUI (vsim -view). CLI sim uses NC_RUN without -Ix.
NC_RUN_GUI ?= nc run -I -Ix -r Taskerlist:i OSREL:RHEL8 RAM/8GB CORES/8 CGROUP:CORES -jpp fastest,pack --
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export VERILATOR_REAL_MAKE := /usr/bin/make
# Do not set SPINAL_VERILATOR_FLAGS=-CFLAGS -include (Verilator treats .h as RTL)

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
QUESTA_WLF  := $(QUESTA_WORK)/tb_rmsnorm_axi.wlf

# WAVE=1 on questa-axi / questa-axi-wave records $(QUESTA_WLF) (large; slow).
ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help verilog sim sim-core sim-axi \
	questa-compile questa-axi questa-axi-wave questa-wave \
	quartus quartus-report clean clean-sim clean-quartus clean-questa

all: verilog

help:
	@echo "rmsNorm Makefile (cwd=$(CURDIR))"
	@echo "  verilog         RMSNORM_DIM=$(DIM) -> gen/verilog/RmsNormAxiTop.v"
	@echo "  sim             Verilator RMSNORM_SIM_DIM=$(DIM)"
	@echo "  questa-axi       verilog + Questa (dim=$(DIM))"
	@echo "  questa-axi-wave  same + WLF $(QUESTA_WLF) (or: make questa-axi WAVE=1)"
	@echo "  questa-wave      Open $(QUESTA_WLF) in Questa GUI ($(NC_RUN_GUI) vsim -view)"
	@echo "  questa-compile   Questa compile only"
	@echo "  quartus         Quartus syn+fit+sta (no .sof/.rbf)"
	@echo "  quartus-report  Resource summary from fit"
	@echo ""
	@echo "  NC_RUN (CLI):      $(NC_RUN)"
	@echo "  NC_RUN_GUI (X11):  $(NC_RUN_GUI)"
	@echo "  Local EDA run: make quartus NC_RUN=  or  make questa-wave NC_RUN_GUI="
	@echo "  clean           Remove gen/verilog, gen/sim, quartus build dirs"

verilog:
	cd $(SCALA_ROOT) && RMSNORM_DIM=$(DIM) $(SBT) "runMain rmsNorm.RmsNormGen"

sim-core: clean-sim
	cd $(SCALA_ROOT) && RMSNORM_SIM_DIM=$(DIM) $(SBT) "runMain rmsNorm.RmsNormCoreSim"

sim-axi:
	cd $(SCALA_ROOT) && RMSNORM_SIM_DIM=$(DIM) $(SBT) "runMain rmsNorm.RmsNormAxiTopSim"

sim: sim-core sim-axi

questa-compile: verilog
	cd test/questa && RMSNORM_DIM=$(DIM) $(NC_RUN) ./run.sh compile

questa-axi: verilog
	cd $(QUESTA_DIR) && RMSNORM_DIM=$(DIM) $(NC_RUN) ./run.sh axi

questa-axi-wave: verilog
	cd $(QUESTA_DIR) && RMSNORM_DIM=$(DIM) \
	  QUESTA_WAVE=1 QUESTA_WLF="$(abspath $(QUESTA_WLF))" $(NC_RUN) ./run.sh axi

questa-wave:
	@test -f $(QUESTA_WLF) || { \
	  echo "Missing $(QUESTA_WLF) — run: make questa-axi-wave"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF))

clean-questa:
	rm -rf test/questa/work test/questa/golden_refs
	rm -rf test/questa/etch*

quartus: verilog
	cd quartus && $(NC_RUN) $(QUARTUS) -t scripts/synth_fit_sta.tcl

quartus-report:
	@if [ -f quartus/output_files/$(PROJECT).fit.rpt ]; then \
	  echo "=== $(PROJECT).fit.rpt (head) ==="; \
	  grep -E "Logic utilization|Total logic elements|ALM|DSP|RAM|M20K|Device|Family" \
	    quartus/output_files/$(PROJECT).fit.rpt | head -40; \
	elif [ -f quartus/$(PROJECT).fit.summary ]; then \
	  cat quartus/$(PROJECT).fit.summary; \
	else \
	  echo "No fit report yet — run: make quartus"; exit 1; \
	fi

clean-sim:
	rm -rf gen/sim

clean-quartus:
	rm -rf quartus/db quartus/incremental_db quartus/output_files quartus/.qws \
	       quartus/*.qws quartus/cdb quartus/serv_req_info.txt

clean: clean-sim clean-quartus clean-questa
	rm -rf gen/verilog
