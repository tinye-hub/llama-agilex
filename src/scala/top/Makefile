# top module — run from: src/scala/top/
#
#   make verilog          Spinal -> gen/verilog/LlamaM1Top.v  (Quartus FP IP, 256-bit AXI)
#   make verilog-sim      same with RmsNorm sim stubs (no Quartus black boxes)
#   make questa           Questa M1 graduation: real FP IPs + FP golden
#   make questa-m2a       Questa M2a graduation: M1 + L0 W_Q GEMV
#   make quartus-m2a      Quartus syn+fit+sta on LlamaM2aTop (no bitstream)
#
# Questa variants:  make questa WAVE=1   |   make questa VIEW=1
#
# FP numerical accuracy MUST be verified via Questa (real Quartus IPs).
# See .cursor/rules/questa-simulation.mdc for details.

SCALA_ROOT  := $(abspath ..)
REPO_ROOT   := $(abspath ../../..)
QUARTUS     ?= quartus_sh
PROJECT     := llama_m2a_top
DIM         ?= 2048
M           ?= 2048
SBT         ?= sbt -batch
DDR_IMAGE_M1  ?= $(REPO_ROOT)/tools/ddr_pack/out/ddr_image_m1.bin
DDR_IMAGE_M2A ?= $(REPO_ROOT)/tools/ddr_pack/out/ddr_image.bin

NC_RUN      ?=
NC_RUN_GUI  ?=
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export LLAMA_M2A_DIM := $(DIM)
export LLAMA_M2A_M   := $(M)

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
QUESTA_WLF_M1  := $(QUESTA_WORK)/tb_llama_m1_top.wlf
QUESTA_WLF_M2A := $(QUESTA_WORK)/tb_llama_m2a_top.wlf

ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help verilog verilog-sim verilog-m2a questa-compile questa-compile-m2a \
        questa questa-m1 questa-m2a questa-run questa-run-m1 questa-run-m2a \
        questa-view questa-view-m1 questa-view-m2a \
        quartus-m2a quartus-m2a-report quartus-m2a-all \
        clean clean-questa clean-quartus

all: verilog

help:
	@echo "top Makefile (cwd=$(CURDIR))"
	@echo "  verilog          -> gen/verilog/LlamaM1Top.v (Quartus FP IP, 256-bit AXI)"
	@echo "  verilog-sim      -> gen/verilog/LlamaM1Top.v (timing stubs, no real FP)"
	@echo "  questa-m1        verilog + Questa M1 graduation (FP golden check)"
	@echo "  questa-m2a       verilog-m2a + Questa M2a (K=$(DIM) M=$(M), ddr_image.bin)"
	@echo "  questa-m2a M=4   smoke: few output rows, full K (default in make regression)"
	@echo "  questa           alias for questa-m1"
	@echo "  questa WAVE=1    M1 WLF $(QUESTA_WLF_M1); M2a WLF $(QUESTA_WLF_M2A)"
	@echo "  questa VIEW=1    Open WLF in Questa GUI ($(NC_RUN_GUI) vsim -view)"
	@echo "  questa-compile   Questa compile only"
	@echo "  quartus-m2a      verilog-m2a + Quartus syn+fit+sta (NC_RUN batch after activate.sh)"
	@echo "  quartus-m2a-report  fit + STA summary table"
	@echo "  quartus-m2a-all   quartus-m2a + report"
	@echo "  NC_RUN= make quartus-m2a-all  run on login node, skip nc batch"
	@echo "  clean            remove gen/"
	@echo ""
	@echo "  NC_RUN:     $(if $(NC_RUN),$(NC_RUN),(empty — local run))"
	@echo "  DDR_IMAGE m1:  $(DDR_IMAGE_M1)"
	@echo "  DDR_IMAGE m2a: $(DDR_IMAGE_M2A)"
	@echo "  Sim policy:  ../doc/simulation-conventions.md"

verilog:
	cd $(SCALA_ROOT) && LLAMA_M1_DIM=$(DIM) LLAMA_M1_GEN_DIR=top/gen/verilog \
	  $(SBT) "runMain top.LlamaM1Gen"

verilog-sim:
	cd $(SCALA_ROOT) && LLAMA_M1_DIM=$(DIM) LLAMA_M1_SIM_IP=1 LLAMA_M1_GEN_DIR=top/gen/verilog \
	  $(SBT) "runMain top.LlamaM1Gen"

verilog-m2a:
	cd $(SCALA_ROOT) && LLAMA_M2A_DIM=$(DIM) LLAMA_M2A_M=$(M) LLAMA_M2A_GEN_DIR=top/gen/verilog \
	  $(SBT) "runMain top.LlamaM2aGen"

questa-compile-m1: verilog
	cd $(QUESTA_DIR) && DDR_IMAGE="$(DDR_IMAGE_M1)" $(NC_RUN) ./run.sh compile-m1

questa-compile-m2a: verilog-m2a
	cd $(QUESTA_DIR) && LLAMA_M2A_DIM=$(DIM) LLAMA_M2A_M=$(M) \
	  DDR_IMAGE="$(DDR_IMAGE_M2A)" $(NC_RUN) ./run.sh compile-m2a

questa-compile: questa-compile-m1

ifeq ($(VIEW),1)
questa-m1: questa-view-m1
questa-m2a: questa-view-m2a
questa: questa-m1
else
questa-m1: questa-run-m1
questa-m2a: questa-run-m2a
questa: questa-m1
endif

questa-run-m1: verilog
	@test -f "$(DDR_IMAGE_M1)" || { \
	  echo "Missing $(DDR_IMAGE_M1) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(QUESTA_DIR) && DDR_IMAGE="$(DDR_IMAGE_M1)" \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF_M1))",) \
	  $(NC_RUN) ./run.sh m1

questa-run-m2a: verilog-m2a
	@test -f "$(DDR_IMAGE_M2A)" || { \
	  echo "Missing $(DDR_IMAGE_M2A) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack"; exit 1; }
	cd $(QUESTA_DIR) && LLAMA_M2A_DIM=$(DIM) LLAMA_M2A_M=$(M) \
	  DDR_IMAGE="$(DDR_IMAGE_M2A)" \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF_M2A))",) \
	  $(NC_RUN) ./run.sh m2a

questa-run: questa-run-m1

questa-view-m1:
	@test -f $(QUESTA_WLF_M1) || { \
	  echo "Missing $(QUESTA_WLF_M1) — run: make questa-m1 WAVE=1"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF_M1))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF_M1))

questa-view-m2a:
	@test -f $(QUESTA_WLF_M2A) || { \
	  echo "Missing $(QUESTA_WLF_M2A) — run: make questa-m2a WAVE=1"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF_M2A))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF_M2A))

questa-view: questa-view-m1

quartus-m2a: verilog-m2a
	$(SCALA_ROOT)/scripts/quartus-run.sh quartus -t scripts/synth_fit_sta.tcl

quartus-m2a-report:
	@FIT=quartus/output_files/$(PROJECT).fit.summary; \
	STA=quartus/output_files/$(PROJECT).sta.summary; \
	test -f "$$FIT" || { echo "Missing $$FIT — run: make quartus-m2a"; exit 1; }; \
	test -f "$$STA" || { echo "Missing $$STA — run: make quartus-m2a"; exit 1; }; \
	alm=$$(grep '^Logic utilization' "$$FIT" | sed 's/^[^:]*: //'); \
	bram=$$(grep '^Total block memory bits' "$$FIT" | sed 's/^[^:]*: //'); \
	ram=$$(grep '^Total RAM Blocks' "$$FIT" | sed 's/^[^:]*: //'); \
	dsp=$$(grep '^Total DSP Blocks' "$$FIT" | sed 's/^[^:]*: //'); \
	setup=$$(awk '/^Type  : Setup/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	hold=$$(awk '/^Type  : Hold/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	mpw=$$(awk '/^Type  : Minimum Pulse Width/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	printf '\n$(PROJECT)  K=$(DIM) M=$(M)\n\n'; \
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

quartus-m2a-all: quartus-m2a quartus-m2a-report

clean-questa:
	rm -rf test/questa/work test/questa/transcript

clean-quartus:
	rm -rf quartus/db quartus/incremental_db quartus/output_files quartus/.qws \
	       quartus/*.qws quartus/cdb quartus/serv_req_info.txt \
	       quartus/qdb quartus/dni quartus/default.qsf quartus/default.*.rpt \
	       quartus/*.qsf.backup quartus/tmp-clearbox

clean: clean-questa clean-quartus
	rm -rf gen
