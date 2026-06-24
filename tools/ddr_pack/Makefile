# DDR weight packer — see README.md

PYTHON ?= $(abspath ../../llama-fpga/pdf-env/bin/python3)
MODEL  ?= /userworkqum/tinye/llama/LLMs-from-scratch/ch05/07_gpt_to_llama/Llama-3.2-1B-Instruct/model.safetensors
OUTDIR ?= out

.PHONY: all fixture pack pack-m1 verify clean

all: fixture

fixture:
	@mkdir -p $(OUTDIR)
	$(PYTHON) gen_fixture.py --output $(OUTDIR)/ddr_fixture.bin

pack-m1:
	@mkdir -p $(OUTDIR)
	$(PYTHON) pack_weights.py --model $(MODEL) --output $(OUTDIR)/ddr_image_m1.bin --fp16-only

pack:
	@mkdir -p $(OUTDIR)
	$(PYTHON) pack_weights.py --model $(MODEL) --output $(OUTDIR)/ddr_image.bin

verify:
	$(PYTHON) -c "from ddr_memory_map import sanity_check; sanity_check(); print('ddr_memory_map OK')"

clean:
	rm -rf $(OUTDIR)
