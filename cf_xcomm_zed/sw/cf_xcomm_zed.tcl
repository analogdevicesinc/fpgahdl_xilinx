# tcl script to init arm and run sdk

fpga -debugdevice devicenr 2 -f sw/cf_xcomm_zed.bit
connect arm hw
source sw/ps7_init.tcl
ps7_init
dow sw/cf_xcomm_zed.elf
run
disconnect 64
exit
