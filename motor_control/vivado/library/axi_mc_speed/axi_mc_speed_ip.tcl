# ip

source ../scripts/adi_ip.tcl

adi_ip_create axi_mc_speed
adi_ip_files axi_mc_speed [list \
  "../common/ad_mem.v" \
  "../common/ad_rst.v" \
  "../common/ad_mul_u16.v" \
  "../common/axis_inf.v" \
  "../common/dma_core.v" \
  "../common/up_axi.v" \
  "../common/up_delay_cntrl.v" \
  "../common/up_drp_cntrl.v" \
  "../common/up_adc_common.v" \
  "debouncer.v" \
  "speed_detector.v" \
  "delay_30_degrees.v" \
  "axi_mc_speed.v" ]

adi_ip_properties axi_mc_speed

set_property physical_name {s_axi_aclk} [ipx::get_port_map CLK \
  [ipx::get_bus_interface s_axi_signal_clock [ipx::current_core]]]

ipx::remove_bus_interface {signal_clock} [ipx::current_core]

set_property interface_mode {master} [ipx::get_bus_interface s_axis_s2mm [ipx::current_core]]

ipx::save_core [ipx::current_core]


