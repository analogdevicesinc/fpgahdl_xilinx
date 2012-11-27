# tcl script to change frequency

set dac_addr 0x74200000
set adc_addr 0x79020000
set ddr_addr 0x00000000
set fft_addr 0x7de00000
set dma_adc_addr 0x40420000
set dma_fft_addr 0x40400000

proc polldata {addr mask data} {
  set rmask $rdata
  while {$rmask == $data} {
    set rdata "0x[string range [mrd $addr] end-8 end]"
    set rmask [expr {$rdata & $mask}]
  }
}

set fin [lindex $argv 0]
connect arm hw
stop

mwr [expr {($dac_addr + 0x04)}] 0x00000001
mwr [expr {($dac_addr + 0x08)}] [expr {(((0x10000 * $fin)/500) | 0x00000001)}]
mwr [expr {($dac_addr + 0x0c)}] [expr {(((0x10000 * $fin)/500) | 0x00000001)}]
mwr [expr {($dac_addr + 0x10)}] [expr {(((0x10000 * $fin)/500) | 0x40000001)}]
mwr [expr {($dac_addr + 0x14)}] [expr {(((0x10000 * $fin)/500) | 0x40000001)}]
mwr [expr {($dac_addr + 0x04)}] 0x00000003

mwr [expr {($dma_adc_addr + 0x030)}] 0x00000004
mwr [expr {($dma_adc_addr + 0x030)}] 0x00000000
mwr [expr {($dma_adc_addr + 0x030)}] 0x00000001
mwr [expr {($dma_adc_addr + 0x048)}] $ddr_addr
mwr [expr {($dma_adc_addr + 0x058)}] 0x00001000
mwr [expr {($adc_addr + 0x00c)}] 0x00000000
mwr [expr {($adc_addr + 0x010)}] 0x0000000f
mwr [expr {($adc_addr + 0x014)}] 0x0000000f
mwr [expr {($adc_addr + 0x00c)}] 0x000101ff
polldata [expr {($adc_addr + 0x010)}] 0x1 0x1

mwr [expr {($fft_addr + 0x18)}] 0x00000000
mwr [expr {($fft_addr + 0x18)}] 0x00000008
mwr [expr {($fft_addr + 0x0c)}] 0x00000001
mwr [expr {($fft_addr + 0x10)}] 0x00000001
mwr [expr {($fft_addr + 0x08)}] 0x000000ff
mwr [expr {($fft_addr + 0x04)}] 0x000d570a

mwr [expr {($dma_fft_addr + 0x00)}] 0x00000000
mwr [expr {($dma_fft_addr + 0x00)}] 0x00000001
mwr [expr {($dma_fft_addr + 0x18)}] $ddr_addr
mwr [expr {($dma_fft_addr + 0x28)}] 0x00001000
mwr [expr {($dma_fft_addr + 0x30)}] 0x00000000
mwr [expr {($dma_fft_addr + 0x30)}] 0x00000001
mwr [expr {($dma_fft_addr + 0x48)}] [expr {($ddr_addr + 0x2000)}]
mwr [expr {($dma_fft_addr + 0x58)}] 0x00001000
polldata [expr {($dma_fft_addr + 0x034)}] 0x2 0x0

disconnect 64
exit
