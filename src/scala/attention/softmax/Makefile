# attention/softmax — SerialSafeSoftmax
#
#   make verilog        -> gen/verilog/SerialSafeSoftmaxAxiTop.v
#   make golden         -> test/questa/golden_refs/
#   make questa         -> Questa AXI TB (SOFTMAX_CASE=len16 default)
#   make quartus        -> Quartus syn+fit+sta (no bitstream)
#   make quartus-report -> fit + STA summary table

SCALA_ROOT  := $(abspath ../..)
REPO_ROOT   := $(abspath ../../../..)
QUARTUS     ?= quartus_sh
PROJECT     := serial_safe_softmax_axi_top
SBT         ?= sbt -batch
NC_RUN      ?=
export NC_RUN

export PATH := $(SCALA_ROOT)/scripts:$(PATH)

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
SOFTMAX_CASE ?= len16
GOLDEN_PY   := $(REPO_ROOT)/tools/attention_golden/gen_softmax_refs.py

.PHONY: all help verilog golden questa questa-compile \
	quartus quartus-report quartus-all \
	clean clean-questa clean-quartus

all: verilog

help:
	@echo "attention/softmax Makefile (cwd=$(CURDIR))"
	@echo "  verilog          SerialSafeSoftmaxAxiTop.v"
	@echo "  golden           softmax reference vectors"
	@echo "  questa           verilog + golden + Questa (SOFTMAX_CASE=$(SOFTMAX_CASE))"
	@echo "  questa-compile   compile only"
	@echo "  quartus          Quartus syn+fit+sta (after activate.sh)"
	@echo "  quartus-report   fit + STA summary table"
	@echo "  quartus-all      quartus + quartus-report"

verilog:
	cd $(SCALA_ROOT) && $(SBT) "runMain attention.softmax.SoftmaxGen"

golden:
	python3 $(GOLDEN_PY) --cases 1 16 128

questa-compile: verilog
	cd $(QUESTA_DIR) && SOFTMAX_CASE=$(SOFTMAX_CASE) $(NC_RUN) ./run.sh compile

questa: verilog golden
	cd $(QUESTA_DIR) && SOFTMAX_CASE=$(SOFTMAX_CASE) $(NC_RUN) ./run.sh axi

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
	setup_wns=$$(awk '/^Type  : Setup/{f=1} f&&/^Slack/{print $$3; exit}' "$$STA"); \
	setup_tns=$$(awk '/^Type  : Setup/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	hold_tns=$$(awk '/^Type  : Hold/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	mpw_tns=$$(awk '/^Type  : Minimum Pulse Width/{f=1} f&&/^TNS/{print $$3; exit}' "$$STA"); \
	printf '\n$(PROJECT)  clk target 400 MHz (SDC period 2.5 ns)\n\n'; \
	printf '| %-22s | %-36s |\n' 'Metric' 'Value'; \
	printf '|%-24s|%-38s|\n' '------------------------' '--------------------------------------'; \
	printf '| %-22s | %-36s |\n' 'Logic (ALMs)' "$$alm"; \
	printf '| %-22s | %-36s |\n' 'Block memory bits' "$$bram"; \
	printf '| %-22s | %-36s |\n' 'RAM blocks' "$$ram"; \
	printf '| %-22s | %-36s |\n' 'DSP blocks' "$$dsp"; \
	printf '| %-22s | %-36s |\n' 'Setup WNS' "$$setup_wns"; \
	printf '| %-22s | %-36s |\n' 'Setup TNS' "$$setup_tns"; \
	printf '| %-22s | %-36s |\n' 'Hold TNS' "$$hold_tns"; \
	printf '| %-22s | %-36s |\n' 'Min pulse width TNS' "$$mpw_tns"; \
	printf '\n'

quartus-all: quartus quartus-report

clean-questa:
	rm -rf $(QUESTA_WORK)

clean-quartus:
	rm -rf quartus/db quartus/incremental_db quartus/output_files quartus/.qws \
	       quartus/*.qws quartus/cdb quartus/serv_req_info.txt \
	       quartus/qdb quartus/dni quartus/default.qsf quartus/default.*.rpt \
	       quartus/*.qsf.backup quartus/tmp-clearbox

clean: clean-questa clean-quartus
	rm -rf gen
