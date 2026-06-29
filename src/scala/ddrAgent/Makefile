# ddrAgent — run from: src/scala/ddrAgent/
#
#   make verilog-m1    Spinal -> gen/verilog/DdrAgentM1.v
#   make verilog-m2a   Spinal -> gen/verilog/DdrAgentM2.v
#   make questa-m1     Questa DdrAgentM1 + ddr_image_m1.bin
#   make questa-m2a    Questa DdrAgentM2 + ddr_fixture.bin (W_Q tiles)
#
# `make questa` is an alias for `questa-m1`.
# Questa variants:  make questa-m2a WAVE=1   |   make questa-m2a VIEW=1

SCALA_ROOT := $(abspath ..)
REPO_ROOT  := $(abspath ../../..)
SBT        ?= sbt -batch
DDR_IMAGE_M1  ?= $(REPO_ROOT)/tools/ddr_pack/out/ddr_image_m1.bin
DDR_IMAGE_M2A ?= $(REPO_ROOT)/tools/ddr_pack/out/ddr_fixture.bin
AXI_WIDTH  ?= 256

NC_RUN ?=
NC_RUN_GUI ?=
export NC_RUN
export NC_RUN_GUI

export PATH := $(SCALA_ROOT)/scripts:$(PATH)
export DDR_AGENT_AXI_WIDTH := $(AXI_WIDTH)

QUESTA_DIR      := test/questa
QUESTA_WORK     := $(QUESTA_DIR)/work
QUESTA_WLF_M1   := $(QUESTA_WORK)/tb_ddr_agent_m1.wlf
QUESTA_WLF_M2A  := $(QUESTA_WORK)/tb_ddr_agent_m2a.wlf

ifeq ($(WAVE),1)
export QUESTA_WAVE := 1
endif

.PHONY: all help verilog verilog-m1 verilog-m2a \
	questa questa-m1 questa-m2a questa-compile questa-compile-m1 questa-compile-m2a \
	questa-run questa-run-m1 questa-run-m2a questa-view questa-view-m1 questa-view-m2a \
	clean clean-questa

all: questa

help:
	@echo "ddrAgent Makefile (cwd=$(CURDIR))"
	@echo "  verilog-m1       AXI_WIDTH=$(AXI_WIDTH) -> gen/verilog/DdrAgentM1.v"
	@echo "  verilog-m2a      AXI_WIDTH=$(AXI_WIDTH) -> gen/verilog/DdrAgentM2.v"
	@echo "  questa-m1        verilog-m1 + Questa M1 TB"
	@echo "  questa-m2a       verilog-m2a + Questa M2a TB (GEMV_WEIGHT tiles)"
	@echo "  questa           alias for questa-m1"
	@echo "  questa WAVE=1    record WLF (m1: $(QUESTA_WLF_M1), m2a: $(QUESTA_WLF_M2A))"
	@echo "  clean            remove gen/ + questa work/"
	@echo ""
	@echo "  M2a fixture: make -C $(REPO_ROOT)/tools/ddr_pack fixture"

verilog-m1:
	cd $(SCALA_ROOT) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) $(SBT) "runMain ddrAgent.DdrAgentM1Gen"

verilog-m2a:
	cd $(SCALA_ROOT) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) $(SBT) "runMain ddrAgent.DdrAgentM2Gen"

verilog: verilog-m1

questa-compile-m1: verilog-m1
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE_M1)" \
	  $(NC_RUN) ./run.sh compile-m1

questa-compile-m2a: verilog-m2a
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE_M2A)" \
	  $(NC_RUN) ./run.sh compile-m2a

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

questa-run-m1: verilog-m1
	@test -f "$(DDR_IMAGE_M1)" || { \
	  echo "Missing $(DDR_IMAGE_M1) — run: make -C $(REPO_ROOT)/tools/ddr_pack pack-m1"; exit 1; }
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE_M1)" \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF_M1))",) \
	  $(if $(filter 1,$(DEBUG)),DDR_AGENT_DEBUG=1,) \
	  $(NC_RUN) ./run.sh m1

questa-run-m2a: verilog-m2a
	@test -f "$(DDR_IMAGE_M2A)" || { \
	  echo "Missing $(DDR_IMAGE_M2A) — run: make -C $(REPO_ROOT)/tools/ddr_pack fixture"; exit 1; }
	cd $(QUESTA_DIR) && DDR_AGENT_AXI_WIDTH=$(AXI_WIDTH) DDR_IMAGE="$(DDR_IMAGE_M2A)" \
	  $(if $(filter 1,$(WAVE)),QUESTA_WLF="$(abspath $(QUESTA_WLF_M2A))",) \
	  $(if $(filter 1,$(DEBUG)),DDR_AGENT_DEBUG=1,) \
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

clean-questa:
	rm -rf test/questa/work test/questa/transcript test/questa/etch*

clean: clean-questa
	rm -rf gen/verilog
