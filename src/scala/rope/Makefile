# rope module — run from: src/scala/rope/
#
#   make tables           Generate RoPETableInit.scala (cos/sin ROM)
#   make verilog          Spinal -> gen/verilog/
#   make questa           Questa FP golden (SerialRoPEAxiTop)
#   make quartus          Quartus syn+fit+sta on SerialRoPEAxiTop (no bitstream)
#   make quartus-report   fit + STA summary table

SCALA_ROOT  := $(abspath ..)
REPO_ROOT   := $(abspath ../../..)
QUARTUS     ?= quartus_sh
PROJECT     := serial_rope_axi_top
SBT         ?= sbt -batch

ROPE_HEAD_DIM ?= 64
ROPE_MAX_POS  ?= 1024

NC_RUN ?=
NC_RUN_GUI ?=
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
QUESTA_WLF  := $(QUESTA_WORK)/tb_serial_rope_axi.wlf

ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help tables verilog questa questa-run questa-view \
	quartus quartus-report quartus-all clean clean-questa clean-quartus

all: verilog

help:
	@echo "rope Makefile (cwd=$(CURDIR))"
	@echo "  tables           ROPE_MAX_POS=$(ROPE_MAX_POS) ROPE_HEAD_DIM=$(ROPE_HEAD_DIM)"
	@echo "  verilog          -> gen/verilog/SerialRoPEAxiTop.v"
	@echo "  questa           verilog + Questa golden (ROPE_MAX_POS=$(ROPE_MAX_POS))"
	@echo "  questa WAVE=1    + WLF $(QUESTA_WLF)"
	@echo "  quartus          Quartus syn+fit+sta (ROPE_MAX_POS=$(ROPE_MAX_POS))"
	@echo "  quartus-report   Fit + STA summary table"
	@echo "  quartus-all      quartus + quartus-report"
	@echo "  clean            remove gen/, questa work/, quartus build artifacts"

tables:
	cd $(REPO_ROOT) && python3 tools/rope_golden/gen_rope_tables.py \
	  --max-pos $(ROPE_MAX_POS) --head-dim $(ROPE_HEAD_DIM) \
	  --scala-out src/scala/rope/scala/RoPETableInit.scala \
	  --golden-dir src/scala/rope/test/questa/golden_refs

verilog: tables
	cd $(SCALA_ROOT) && ROPE_HEAD_DIM=$(ROPE_HEAD_DIM) ROPE_MAX_POS=$(ROPE_MAX_POS) \
	  $(SBT) "runMain rope.RopeGen"

ifeq ($(VIEW),1)
questa: questa-view
else
questa: questa-run
endif

questa-run: verilog
	cd $(QUESTA_DIR) && ROPE_HEAD_DIM=$(ROPE_HEAD_DIM) ROPE_MAX_POS=$(ROPE_MAX_POS) \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF))",) \
	  $(NC_RUN) ./run.sh axi

questa-view:
	@test -f $(QUESTA_WLF) || { echo "Missing $(QUESTA_WLF) — run: make questa WAVE=1"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF))

clean-questa:
	rm -rf test/questa/work

quartus: verilog
	$(SCALA_ROOT)/scripts/quartus-run.sh quartus -t scripts/synth_fit_sta.tcl

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
	printf '\n$(PROJECT)  ROPE_HEAD_DIM=$(ROPE_HEAD_DIM) ROPE_MAX_POS=$(ROPE_MAX_POS)\n\n'; \
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

clean-quartus:
	rm -rf quartus/db quartus/incremental_db quartus/output_files quartus/.qws \
	       quartus/*.qws quartus/cdb quartus/serv_req_info.txt \
	       quartus/qdb quartus/dni quartus/default.qsf quartus/default.*.rpt \
	       quartus/*.qsf.backup quartus/tmp-clearbox

clean: clean-questa clean-quartus
	rm -rf gen/verilog
