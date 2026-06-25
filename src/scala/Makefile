# src/scala — aggregate simulation across modules
#
#   make verilator    rmsNorm + ddrAgent + top + llamaScheduler
#   make questa       rmsNorm + ddrAgent + top
#   make sim          verilator then questa, one summary table at the end
#
# Each submodule runs sequentially; failures do not stop later modules.
# Summary parses ********** PASS ********** / ********** FAIL ********** from output.
#
# Questa on batch nodes: source ../../set_env.sh  (exports NC_RUN)
# M1 DDR image: make -C ../../tools/ddr_pack pack-m1

SCALA_ROOT := $(abspath .)
REPO_ROOT  := $(abspath ../..)
SCRIPTS    := $(SCALA_ROOT)/scripts
SBT        ?= sbt -batch
DDR_IMAGE  ?= $(REPO_ROOT)/tools/ddr_pack/out/ddr_image_m1.bin

export PATH := $(SCRIPTS):$(PATH)
export DDR_IMAGE

.PHONY: all help verilator questa sim

all: sim

help:
	@echo "src/scala Makefile (cwd=$(CURDIR))"
	@echo "  verilator   Run all Verilator smoke tests"
	@echo "  questa      Run all Questa FP golden tests"
	@echo "  sim         verilator + questa (default)"
	@echo ""
	@echo "Modules:"
	@echo "  rmsNorm         verilator, questa"
	@echo "  ddrAgent        verilator, questa"
	@echo "  top             verilator, questa"
	@echo "  llamaScheduler  verilator only (no Questa TB yet)"
	@echo ""
	@echo "  DDR_IMAGE=$(DDR_IMAGE)"
	@echo "  Policy: doc/simulation-conventions.md"

verilator questa sim:
	@$(SCRIPTS)/sim-matrix.sh $@
