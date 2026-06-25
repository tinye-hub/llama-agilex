# ddrMemoryMap module — run from: src/scala/ddrMemoryMap/
#
#   make sv       Scala DdrMemoryMap -> gen/sv/ddr_memory_map_pkg.sv
#   make check    run DdrMemoryMap.sanityCheck()
#   make clean    remove gen/
#
# Simulation policy (verilator / questa / colored PASS): ../doc/simulation-conventions.md

SCALA_ROOT := $(abspath ..)
SBT        ?= sbt -batch
GEN_DIR    := gen/sv

.PHONY: all help sv verilog check clean

all: sv

help:
	@echo "ddrMemoryMap Makefile (cwd=$(CURDIR))"
	@echo "  sv (default)  -> $(GEN_DIR)/ddr_memory_map_pkg.sv"
	@echo "  verilog       alias for sv"
	@echo "  check         sbt runMain ddrMemoryMap.DdrMemoryMapCheck"
	@echo "  clean         remove gen/"
	@echo "  Sim policy:   ../doc/simulation-conventions.md"

sv:
	cd $(SCALA_ROOT) && DDR_MAP_GEN_DIR=ddrMemoryMap/$(GEN_DIR) $(SBT) "runMain ddrMemoryMap.DdrMemoryMapGen"

verilog: sv

check:
	cd $(SCALA_ROOT) && $(SBT) "runMain ddrMemoryMap.DdrMemoryMapCheck"

clean:
	rm -rf gen
