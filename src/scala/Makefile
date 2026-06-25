# src/scala — aggregate simulation across modules
#
#   make verilator              serial on login node
#   make questa                 serial (or NC_RUN blocking per module)
#   make sim                    serial: verilator + questa
#   make regression             sim PARALLEL=1 — full matrix via NC_RUN_BG (recommended CI)
#   make verilator PARALLEL=1   all modules via NC_RUN_BG (Taskerlist:b 4GB)
#
# PARALLEL=1: nc run -r Taskerlist:b OSREL:RHEL8 RAM/4GB CORES/4 ... (no -I)
# make regression auto-sources ../../activate.sh if NC_RUN_BG is unset
# Logs: ../../out/logs/latest/

SCALA_ROOT := $(abspath .)
REPO_ROOT  := $(abspath ../..)
SCRIPTS    := $(SCALA_ROOT)/scripts
SBT        ?= sbt -batch
DDR_IMAGE  ?= $(REPO_ROOT)/tools/ddr_pack/out/ddr_image_m1.bin
PARALLEL   ?= 0

export PATH := $(SCRIPTS):$(PATH)
export DDR_IMAGE
export PARALLEL

.PHONY: all help verilator questa sim regression

all: sim

help:
	@echo "src/scala Makefile (cwd=$(CURDIR))"
	@echo "  verilator              Verilator smoke (serial)"
	@echo "  questa                 Questa FP golden (serial)"
	@echo "  sim                    verilator + questa (serial)"
	@echo "  regression             verilator + questa, all parallel (NC_RUN_BG)"
	@echo "  * PARALLEL=1           per-target parallel (verilator / questa / sim)"
	@echo ""
	@echo "  make regression        # same as make sim PARALLEL=1"
	@echo "  make verilator PARALLEL=1"
	@echo "  make questa PARALLEL=1"
	@echo ""
	@echo "Modules:"
	@echo "  rmsNorm         verilator, questa"
	@echo "  ddrAgent        verilator, questa"
	@echo "  top             verilator, questa"
	@echo "  llamaScheduler  verilator only"
	@echo ""
	@echo "  PARALLEL=$(PARALLEL)  DDR_IMAGE=$(DDR_IMAGE)"
	@echo "  regression sources ../../activate.sh if needed"
	@echo "  Logs:  $(REPO_ROOT)/out/logs/latest/"
	@echo "  Policy: doc/simulation-conventions.md"

verilator questa sim:
	@$(SCRIPTS)/sim-matrix.sh $@

regression:
	@PARALLEL=1 $(SCRIPTS)/sim-matrix.sh sim
