# rmsNorm module — run from: src/scala/rmsNorm/
#
#   make verilog          Spinal -> gen/verilog/
#   make verilator        Verilator smoke (core + AXI control-flow; FP via questa)
#   make questa           Questa + real Quartus FP IPs (FP golden)
#   make quartus          syn + fit + sta (no bitstream)
#   make quartus-report   print fit resource summary

SCALA_ROOT  := $(abspath ..)
REPO_ROOT   := $(abspath ../../..)
QUARTUS     ?= quartus_sh
PROJECT     := rmsnorm_top
DIM         ?= 2048
SBT         ?= sbt -batch

# Quartus/Questa on batch nodes: source ../../../set_env.sh  (exports NC_RUN via AAP nc).
# Default: local run (NC_RUN empty). Login node without set_env.sh has /usr/bin/nc = Ncat, not AAP.
NC_RUN ?=
NC_RUN_GUI ?=
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export VERILATOR_REAL_MAKE := /usr/bin/make
# Do not set SPINAL_VERILATOR_FLAGS=-CFLAGS -include (Verilator treats .h as RTL)

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
QUESTA_WLF  := $(QUESTA_WORK)/tb_rmsnorm_axi.wlf

# WAVE=1 on questa records $(QUESTA_WLF) (large; slow).
ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help verilog verilator verilator-core verilator-axi \
	questa-compile questa questa-run questa-view \
	quartus quartus-report quartus-all clean clean-verilator clean-quartus clean-questa

all: verilog

help:
	@echo "rmsNorm Makefile (cwd=$(CURDIR))"
	@echo "  verilog          RMSNORM_DIM=$(DIM) -> gen/verilog/RmsNormAxiTop.v"
	@echo "  verilator        Verilator smoke (control-flow; FP golden -> questa)"
	@echo "  questa           verilog + Questa FP golden (dim=$(DIM))"
	@echo "  questa WAVE=1    questa + WLF $(QUESTA_WLF)"
	@echo "  questa VIEW=1    Open $(QUESTA_WLF) in Questa GUI ($(NC_RUN_GUI) vsim -view)"
	@echo "  questa-compile   Questa compile only"
	@echo "  quartus          Quartus syn+fit+sta (no .sof/.rbf)"
	@echo "  quartus-report   Fit + STA summary table"
	@echo "  quartus-all      quartus + quartus-report"
	@echo ""
	@echo "  NC_RUN:     $(if $(NC_RUN),$(NC_RUN),(empty — local run))"
	@echo "  NC_RUN_GUI: $(if $(NC_RUN_GUI),$(NC_RUN_GUI),(empty — local run))"
	@echo "  Batch EDA:  source ../../../set_env.sh  then make quartus / questa"
	@echo "  Sim policy:  ../doc/simulation-conventions.md"
	@echo "  clean           Remove gen/verilog, gen/sim, quartus build dirs"

verilog:
	cd $(SCALA_ROOT) && RMSNORM_DIM=$(DIM) $(SBT) "runMain rmsNorm.RmsNormGen"

verilator-core: clean-verilator
	cd $(SCALA_ROOT) && RMSNORM_SIM_DIM=$(DIM) $(SCALA_ROOT)/scripts/sbt-runmain.sh rmsNorm.RmsNormCoreSim

verilator-axi:
	cd $(SCALA_ROOT) && RMSNORM_SIM_DIM=$(DIM) $(SCALA_ROOT)/scripts/sbt-runmain.sh rmsNorm.RmsNormAxiTopSim

verilator: verilator-core verilator-axi

questa-compile: verilog
	cd test/questa && RMSNORM_DIM=$(DIM) $(NC_RUN) ./run.sh compile

ifeq ($(VIEW),1)
questa: questa-view
else
questa: questa-run
endif

questa-run: verilog
	cd $(QUESTA_DIR) && RMSNORM_DIM=$(DIM) \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF))",) \
	  $(NC_RUN) ./run.sh axi

questa-view:
	@test -f $(QUESTA_WLF) || { \
	  echo "Missing $(QUESTA_WLF) — run: make questa WAVE=1"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF))

clean-questa:
	rm -rf test/questa/work test/questa/golden_refs
	rm -rf test/questa/etch*

quartus: verilog
	cd quartus && $(NC_RUN) $(QUARTUS) -t scripts/synth_fit_sta.tcl

quartus-report:
	@FIT=quartus/output_files/$(PROJECT).fit.summary; \
	STA=quartus/output_files/$(PROJECT).sta.summary; \
	test -f "$$FIT" || { echo "Missing $$FIT — run: make quartus"; exit 1; }; \
	test -f "$$STA" || { echo "Missing $$STA — run: make quartus"; exit 1; }; \
	alm=$$(grep '^Logic utilization' "$$FIT" | sed 's/^[^:]*: //'); \
	bram=$$(grep '^Total block memory bits' "$$FIT" | sed 's/^[^:]*: //'); \
	ram=$$(grep '^Total RAM Blocks' "$$FIT" | sed 's/^[^:]*: //'); \
	dsp=$$(grep '^Total DSP Blocks' "$$FIT" | sed 's/^[^:]*: //'); \
	setup=$$(awk '/^Type  : Setup/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	hold=$$(awk '/^Type  : Hold/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	mpw=$$(awk '/^Type  : Minimum Pulse Width/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	printf '\n$(PROJECT)  DIM=$(DIM)\n\n'; \
	printf '| %-22s | %-36s |\n' 'Metric' 'Value'; \
	printf '|%-24s|%-38s|\n' '------------------------' '--------------------------------------'; \
	printf '| %-22s | %-36s |\n' 'Logic (ALMs)' "$$alm"; \
	printf '| %-22s | %-36s |\n' 'Block memory bits' "$$bram"; \
	printf '| %-22s | %-36s |\n' 'RAM blocks' "$$ram"; \
	printf '| %-22s | %-36s |\n' 'DSP blocks' "$$dsp"; \
	printf '| %-22s | %-36s |\n' 'Setup TNS' "$$setup"; \
	printf '| %-22s | %-36s |\n' 'Hold TNS' "$$hold"; \
	printf '| %-22s | %-36s |\n' 'Min pulse width TNS' "$$mpw"; \
	printf '\n'

quartus-all: quartus quartus-report

clean-verilator:
	rm -rf gen/sim

clean-quartus:
	rm -rf quartus/db quartus/incremental_db quartus/output_files quartus/.qws \
	       quartus/*.qws quartus/cdb quartus/serv_req_info.txt \
	       quartus/qdb quartus/dni quartus/default.qsf quartus/default.*.rpt \
	       quartus/*.qsf.backup

clean: clean-verilator clean-quartus clean-questa
	rm -rf gen/verilog
