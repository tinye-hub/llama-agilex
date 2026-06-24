# common module — run from: src/scala/common/
#
#   make sv       Scala DdrMemoryMap -> gen/sv/ddr_memory_map_pkg.sv
#   make check    run DdrMemoryMap.sanityCheck()
#   make clean    remove gen/

SCALA_ROOT := $(abspath ..)
SBT        ?= sbt -batch
GEN_DIR    := gen/sv

.PHONY: all help sv verilog check clean

all: sv

help:
	@echo "common Makefile (cwd=$(CURDIR))"
	@echo "  sv (default)  -> $(GEN_DIR)/ddr_memory_map_pkg.sv"
	@echo "  verilog       alias for sv"
	@echo "  check         sbt runMain common.DdrMemoryMapCheck"
	@echo "  clean         remove gen/"

sv:
	cd $(SCALA_ROOT) && DDR_MAP_GEN_DIR=common/$(GEN_DIR) $(SBT) "runMain common.DdrMemoryMapGen"

verilog: sv

check:
	cd $(SCALA_ROOT) && $(SBT) "runMain common.DdrMemoryMapCheck"

clean:
	rm -rf gen
