# util — Quartus FP IP wrappers (fp32Exp, fp32Div) + Questa smoke test
#
#   make verilog    -> gen/verilog/Fp32ExpDivSmokeTop.v
#   make questa     -> Questa only (no Verilator)

SCALA_ROOT  := $(abspath ..)
REPO_ROOT   := $(abspath ../../..)
SBT         ?= sbt -batch
NC_RUN      ?=
export NC_RUN

export PATH := $(SCALA_ROOT)/scripts:$(PATH)

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work

.PHONY: all help verilog questa questa-compile clean clean-questa

all: verilog

help:
	@echo "util Makefile (cwd=$(CURDIR))"
	@echo "  verilog         Fp32ExpDivSmokeTop.v"
	@echo "  questa          verilog + Questa fp32Exp/fp32Div smoke"
	@echo "  questa-compile  compile only"

verilog:
	cd $(SCALA_ROOT) && $(SBT) "runMain util.Fp32ExpDivGen"

questa-compile: verilog
	cd test/questa && $(NC_RUN) ./run.sh compile

questa: verilog
	cd test/questa && $(NC_RUN) ./run.sh exp_div

clean-questa:
	rm -rf $(QUESTA_WORK)

clean: clean-questa
	rm -rf gen
