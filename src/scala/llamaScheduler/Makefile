# llamaScheduler — run from: src/scala/llamaScheduler/
#
#   make verilog    Spinal -> gen/verilog/LlamaSchedulerM1.v
#   make questa     Questa unit TB (mock MemCmd / MemDone)
#
# Questa variants:  make questa WAVE=1   |   make questa VIEW=1

SCALA_ROOT := $(abspath ..)
SBT        ?= sbt -batch

NC_RUN ?=
NC_RUN_GUI ?=
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)

QUESTA_DIR  := test/questa
QUESTA_WORK := $(QUESTA_DIR)/work
QUESTA_WLF  := $(QUESTA_WORK)/tb_llama_scheduler_m1.wlf

ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help verilog questa questa-compile questa-run questa-view clean clean-questa

all: questa

help:
	@echo "llamaScheduler Makefile (cwd=$(CURDIR))"
	@echo "  verilog       -> gen/verilog/LlamaSchedulerM1.v"
	@echo "  questa        verilog + Questa M1 unit TB"
	@echo "  questa WAVE=1 record WLF $(QUESTA_WLF)"
	@echo "  questa VIEW=1 Open WLF in Questa GUI"
	@echo "  clean         remove gen/ + questa work/"
	@echo "  Sim policy:   ../doc/simulation-conventions.md"

verilog:
	cd $(SCALA_ROOT) && $(SBT) "runMain llamaScheduler.LlamaSchedulerM1Gen"

questa-compile: verilog
	cd $(QUESTA_DIR) && $(NC_RUN) ./run.sh compile

ifeq ($(VIEW),1)
questa: questa-view
else
questa: questa-run
endif

questa-run: verilog
	cd $(QUESTA_DIR) && \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF))",) \
	  $(NC_RUN) ./run.sh m1

questa-view:
	@test -f $(QUESTA_WLF) || { \
	  echo "Missing $(QUESTA_WLF) — run: make questa WAVE=1"; exit 1; }
	cd $(dir $(abspath $(QUESTA_WLF))) && \
	  $(NC_RUN_GUI) vsim -view $(notdir $(QUESTA_WLF))

clean-questa:
	rm -rf test/questa/work test/questa/transcript test/questa/etch*

clean: clean-questa
	rm -rf gen
