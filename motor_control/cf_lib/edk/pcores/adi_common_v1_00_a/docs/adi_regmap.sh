#!/bin/bash

adi_regmap.pl \
	adi_regmap_common.txt \
	adi_regmap_adc.txt \
	adi_regmap_dac.txt \
	adi_regmap_jesd.txt \
	adi_regmap_ddr_cntrl.txt \
	adi_regmap_hdmi.txt \
	adi_regmap_clkgen.txt \


unix2dos adi_regmap_wiki.txt


