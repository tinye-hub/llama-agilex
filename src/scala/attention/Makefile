# attention — M2c attention umbrella (softmax + gqa)
#
#   make questa              -> softmax Questa (default)
#   make questa-softmax      -> same
#   make questa-gqa          -> GqaAttention (when implemented)
#
# Per-submodule: make -C softmax questa SOFTMAX_CASE=len16

SCALA_ROOT := $(abspath ..)
NC_RUN     ?=
export NC_RUN

SOFTMAX_CASE ?= len16

.PHONY: all help verilog golden questa questa-softmax questa-gqa clean

all: questa-softmax

help:
	@echo "attention Makefile (cwd=$(CURDIR))"
	@echo "  questa / questa-softmax   SerialSafeSoftmax Questa (SOFTMAX_CASE=$(SOFTMAX_CASE))"
	@echo "  questa-gqa                GqaAttention Questa (not implemented)"
	@echo "  verilog / golden          delegate to softmax/"

verilog golden questa questa-softmax:
	$(MAKE) -C softmax $@ SOFTMAX_CASE=$(SOFTMAX_CASE)

questa-gqa:
	$(MAKE) -C gqa questa

clean:
	$(MAKE) -C softmax clean
