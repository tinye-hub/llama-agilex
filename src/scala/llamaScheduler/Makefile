# llamaScheduler — run from: src/scala/llamaScheduler/
#
#   make verilator    Verilator LlamaSchedulerM1Sim (mock MemCmd / MemDone)
#
# Verilator PASS/FAIL colors: scripts/sbt-runmain.sh (see doc/simulation-conventions.md)

SCALA_ROOT := $(abspath ..)
SBT        ?= sbt -batch

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export VERILATOR_REAL_MAKE := /usr/bin/make

.PHONY: all help verilator clean clean-verilator

all: verilator

help:
	@echo "llamaScheduler Makefile (cwd=$(CURDIR))"
	@echo "  verilator    Verilator LlamaSchedulerM1Sim"
	@echo "  clean        remove gen/"
	@echo "  Sim policy:  ../doc/simulation-conventions.md"

verilator: clean-verilator
	cd $(SCALA_ROOT) && $(SCALA_ROOT)/scripts/sbt-runmain.sh llamaScheduler.LlamaSchedulerM1Sim

clean-verilator:
	rm -rf gen/sim 2>/dev/null || true

clean: clean-verilator
