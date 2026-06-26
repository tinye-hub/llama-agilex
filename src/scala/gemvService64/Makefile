# gemvService64 module — run from: src/scala/gemvService64/
#
#   make verilog          Spinal -> gen/verilog/GemvService64.v  (K/M default 2048)
#   make verilator        Verilator smoke (control-flow; FP golden -> questa)
#   make questa           Questa + real Quartus FP IPs (K/M overridable)
#
# See doc/gemv-m2a-design.md (§14 phases a1-a4, §15 verification).

SCALA_ROOT  := $(abspath ..)
REPO_ROOT   := $(abspath ../../..)
# Llama 3.2 1B W_Q: K = vectorDim, M = output rows (both 2048 by default).
K           ?= 2048
M           ?= 2048
SBT         ?= sbt -batch

NC_RUN ?=
NC_RUN_GUI ?=
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export VERILATOR_REAL_MAKE := /usr/bin/make

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
QUESTA_WLF  := $(QUESTA_WORK)/tb_gemv_service64.wlf

# WAVE=1 on questa records $(QUESTA_WLF) (large; slow).
ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help verilog verilog-mac verilator verilator-mac verilator-service \
	questa questa-run questa-view questa-mac questa-service questa-compile \
	clean clean-verilator clean-questa

all: verilog

help:
	@echo "gemvService64 Makefile (cwd=$(CURDIR))"
	@echo "  verilog          K=$(K) M=$(M) -> gen/verilog/GemvService64.v"
	@echo "  verilog-mac      a1 MAC core only -> gen/verilog/GemvMacBeat.v"
	@echo "  verilator        Verilator control-flow smoke (K=$(K) M=$(M))"
	@echo "  verilator-mac    a1 GemvMacBeat + GemvActBuffer smoke"
	@echo "  verilator-service  end-to-end tile-engine control-flow smoke"
	@echo "  questa           GemvService64 INT4 GEMV FP golden (K=$(K) M=$(M))"
	@echo "  questa K=2048 M=4     full K, few output rows (smoke)"
	@echo "  questa WAVE=1    questa + WLF $(QUESTA_WLF)"
	@echo "  questa VIEW=1    Open $(QUESTA_WLF) in Questa GUI ($(NC_RUN_GUI) vsim -view)"
	@echo "  questa-mac       a1 GemvMacBeat FP golden"
	@echo "  questa-service   alias for questa"
	@echo "  questa-compile   Questa compile only (IP + DUT + TB)"
	@echo ""
	@echo "  NC_RUN:     $(if $(NC_RUN),$(NC_RUN),(empty — local run))"
	@echo "  NC_RUN_GUI: $(if $(NC_RUN_GUI),$(NC_RUN_GUI),(empty — local run))"
	@echo "  Batch EDA:  source ../../../set_env.sh  then make questa"
	@echo "  Sim policy:  ../doc/simulation-conventions.md"
	@echo "  clean            Remove gen/ and questa work/"

verilog:
	cd $(SCALA_ROOT) && GEMV_DIM=$(K) GEMV_MAX_ROWS=$(M) $(SBT) "runMain gemvService64.GemvServiceGen"

verilog-mac:
	cd $(SCALA_ROOT) && $(SBT) "runMain gemvService64.GemvMacBeatGen"

verilator-mac:
	cd $(SCALA_ROOT) && GEMV_DIM=$(K) GEMV_MAX_ROWS=$(M) \
	  $(SCALA_ROOT)/scripts/sbt-runmain.sh gemvService64.GemvMacBeatSim

verilator-service:
	cd $(SCALA_ROOT) && GEMV_DIM=$(K) GEMV_MAX_ROWS=$(M) \
	  $(SCALA_ROOT)/scripts/sbt-runmain.sh gemvService64.GemvService64Sim

verilator: verilator-mac verilator-service

# --- Questa (real Quartus FP IPs; FP golden) ---
ifeq ($(VIEW),1)
questa: questa-view
else
questa: questa-run
endif

questa-service: questa

questa-run:
	cd $(SCALA_ROOT) && GEMV_DIM=$(K) GEMV_MAX_ROWS=$(M) $(SBT) "runMain gemvService64.GemvServiceGen"
	cd $(QUESTA_DIR) && \
	  GEMV_DIM=$(K) GEMV_MAX_ROWS=$(M) GEMV_K=$(K) GEMV_M=$(M) \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF))",) \
	  $(NC_RUN) ./run.sh service

questa-view:
	@test -f $(QUESTA_WLF) || { \
	  echo "Missing $(QUESTA_WLF) — run: make questa WAVE=1"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF))

questa-mac: verilog-mac
	cd $(QUESTA_DIR) && $(NC_RUN) ./run.sh mac

questa-compile: verilog-mac
	cd $(QUESTA_DIR) && $(NC_RUN) ./run.sh compile

clean-questa:
	rm -rf $(QUESTA_DIR)/work $(QUESTA_DIR)/transcript $(QUESTA_DIR)/*.wlf

clean-verilator:
	rm -rf gen/sim

clean: clean-verilator clean-questa
	rm -rf gen/verilog
