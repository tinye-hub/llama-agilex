# llamaScheduler — run from: src/scala/llamaScheduler/
#
#   make sim    Verilator LlamaSchedulerM1Sim (mock MemCmd / MemDone)

SCALA_ROOT := $(abspath ..)
SBT        ?= sbt -batch

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export VERILATOR_REAL_MAKE := /usr/bin/make

.PHONY: all help sim clean clean-sim

all: sim

help:
	@echo "llamaScheduler Makefile (cwd=$(CURDIR))"
	@echo "  sim      Verilator LlamaSchedulerM1Sim"
	@echo "  clean    remove gen/"

sim: clean-sim
	cd $(SCALA_ROOT) && $(SBT) "runMain llamaScheduler.LlamaSchedulerM1Sim"

clean-sim:
	rm -rf gen/sim 2>/dev/null || true

clean: clean-sim
