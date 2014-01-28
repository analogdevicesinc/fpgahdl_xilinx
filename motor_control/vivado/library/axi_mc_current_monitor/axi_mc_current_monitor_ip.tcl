# ip

source ../scripts/adi_ip.tcl

adi_ip_create axi_mc_current_monitor
adi_ip_files axi_mc_current_monitor [list \
  "../common/ad_rst.v" \
  "../common/axis_inf.v" \
  "../common/dma_core.v" \
  "../common/ad_mem.v" \
  "../common/up_axi.v" \
  "../common/up_delay_cntrl.v" \
  "../common/up_drp_cntrl.v" \
  "../common/up_adc_common.v" \
  "../common/up_adc_channel.v" \
  "dec256sinc24b.v" \
  "ad7401.v" \
  "axi_mc_current_monitor.v" ]

adi_ip_properties axi_mc_current_monitor

set_property physical_name {s_axi_aclk} [ipx::get_port_map CLK \
  [ipx::get_bus_interface s_axi_signal_clock [ipx::current_core]]]

ipx::remove_bus_interface {signal_clock} [ipx::current_core]

set_property interface_mode {master} [ipx::get_bus_interface s_axis_s2mm [ipx::current_core]]

ipx::save_core [ipx::current_core]


