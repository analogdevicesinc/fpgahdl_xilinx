
set NUM_EXTRA_INTERRUPTS 4
set NUM_EXTRA_AXI_SLAVES 9
set NUM_EXTRA_GPIOS 0

source ../../base_system/zed/system_bd.tcl

set position_i [ create_bd_port -dir I -from 2 -to 0 position_i ]

set adc_ia_dat_i [ create_bd_port -dir I adc_ia_dat_i ]
set adc_ib_dat_i [ create_bd_port -dir I adc_ib_dat_i ]
set adc_it_dat_i [ create_bd_port -dir I adc_it_dat_i ]
set adc_vbus_dat_i [ create_bd_port -dir I adc_vbus_dat_i ]
set adc_ia_clk_o [ create_bd_port -dir O adc_ia_clk_o ]
set adc_ib_clk_o [ create_bd_port -dir O adc_ib_clk_o ]
set adc_it_clk_o [ create_bd_port -dir O adc_it_clk_o ]
set adc_vbus_clk_o [ create_bd_port -dir O adc_vbus_clk_o ]

set adc_ia_dat_d_i [ create_bd_port -dir I adc_ia_dat_d_i ]
set adc_ib_dat_d_i [ create_bd_port -dir I adc_ib_dat_d_i ]
set adc_it_dat_d_i [ create_bd_port -dir I adc_it_dat_d_i ]
set adc_ia_clk_d_o [ create_bd_port -dir O adc_ia_clk_d_o ]
set adc_ib_clk_d_o [ create_bd_port -dir O adc_ib_clk_d_o ]
set adc_it_clk_d_o [ create_bd_port -dir O adc_it_clk_d_o ]

set fmc_m1_fault_i [ create_bd_port -dir I fmc_m1_fault_i ]
set fmc_m1_en_o [ create_bd_port -dir O fmc_m1_en_o ]

set pwm_al_o [ create_bd_port -dir O pwm_al_o ]
set pwm_ah_o [ create_bd_port -dir O pwm_ah_o ]
set pwm_cl_o [ create_bd_port -dir O pwm_cl_o ]
set pwm_ch_o [ create_bd_port -dir O pwm_ch_o ]
set pwm_bl_o [ create_bd_port -dir O pwm_bl_o ]
set pwm_bh_o [ create_bd_port -dir O pwm_bh_o ]

set gpo_o [ create_bd_port -dir O -from 7 -to 0 gpo_o ]

set vp_in [ create_bd_port -dir I vp_in ]
set vn_in [ create_bd_port -dir I vn_in ]
set vauxp0 [ create_bd_port -dir I vauxp0 ]
set vauxn0 [ create_bd_port -dir I vauxn0 ]
set vauxp8 [ create_bd_port -dir I vauxp8 ]
set vauxn8 [ create_bd_port -dir I vauxn8 ]
set muxaddr_out [ create_bd_port -dir O -from 4 -to 0 muxaddr_out ]

# instance: processing_system7_1

set_property -dict [ list CONFIG.PCW_USE_S_AXI_HP1 {1} ] $processing_system7_1


set axi_mc_current_monitor_1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_current_monitor:1.0 axi_mc_current_monitor_1 ]
set axi_mc_current_monitor_2 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_current_monitor:1.0 axi_mc_current_monitor_2 ]
set axi_mc_speed_1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_speed:1.0 axi_mc_speed_1 ]
set axi_mc_torque_ctrl_1 [ create_bd_cell -type ip -vlnv analog.com:user:axi_mc_torque_ctrl:1.0 axi_mc_torque_ctrl_1 ]

set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.0 axi_dma_0 ]
set_property -dict [ list CONFIG.c_include_sg {0} CONFIG.c_sg_length_width {23} CONFIG.c_include_mm2s {0} CONFIG.c_m_axi_s2mm_data_width {64} CONFIG.c_s_axis_s2mm_tdata_width {64} CONFIG.c_s2mm_burst_size {256}  ] $axi_dma_0

set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.0 axi_dma_1 ]
set_property -dict [ list CONFIG.c_include_sg {0} CONFIG.c_sg_length_width {23} CONFIG.c_include_mm2s {0} CONFIG.c_s2mm_burst_size {256}  ] $axi_dma_1

set axi_dma_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.0 axi_dma_2 ]
set_property -dict [ list CONFIG.c_include_sg {0} CONFIG.c_sg_length_width {23} CONFIG.c_include_mm2s {0} CONFIG.c_m_axi_s2mm_data_width {32} CONFIG.c_s_axis_s2mm_tdata_width {32} CONFIG.c_s2mm_burst_size {256}  ] $axi_dma_2

set axi_dma_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.0 axi_dma_3 ]
set_property -dict [ list CONFIG.c_include_sg {0} CONFIG.c_sg_length_width {23} CONFIG.c_include_mm2s {0} CONFIG.c_m_axi_s2mm_data_width {64} CONFIG.c_s_axis_s2mm_tdata_width {64} CONFIG.c_s2mm_burst_size {256}  ] $axi_dma_3

set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.0 axi_mem_intercon ]
set_property -dict [ list CONFIG.NUM_SI {4} CONFIG.NUM_MI {1}  ] $axi_mem_intercon

set xadc_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.0 xadc_wiz_1 ]
set_property -dict [ list CONFIG.XADC_STARUP_SELECTION {simultaneous_sampling} ] $xadc_wiz_1
set_property -dict [ list CONFIG.OT_ALARM {false} ] $xadc_wiz_1
set_property -dict [ list CONFIG.USER_TEMP_ALARM {false} ] $xadc_wiz_1
set_property -dict [ list CONFIG.VCCINT_ALARM {false} ] $xadc_wiz_1
set_property -dict [ list CONFIG.VCCAUX_ALARM {false} ] $xadc_wiz_1
set_property -dict [ list CONFIG.ENABLE_EXTERNAL_MUX {true} ] $xadc_wiz_1
set_property -dict [ list CONFIG.EXTERNAL_MUX_CHANNEL {VAUXP0_VAUXN0} ] $xadc_wiz_1
set_property -dict [ list CONFIG.CHANNEL_ENABLE_VAUXP0_VAUXN0 {true} ] $xadc_wiz_1
set_property -dict [ list CONFIG.CHANNEL_ENABLE_VAUXP1_VAUXN1 {false}  ] $xadc_wiz_1

# instance: interconnects
connect_bd_intf_net -intf_net axi_interconnect_1_m06_axi [get_bd_intf_pins axi_interconnect_1/M06_AXI] [get_bd_intf_pins axi_mc_current_monitor_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m07_axi [get_bd_intf_pins axi_interconnect_1/M07_AXI] [get_bd_intf_pins axi_mc_speed_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m08_axi [get_bd_intf_pins axi_interconnect_1/M08_AXI] [get_bd_intf_pins axi_mc_torque_ctrl_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m09_axi [get_bd_intf_pins axi_interconnect_1/M09_AXI] [get_bd_intf_pins axi_mc_current_monitor_2/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m10_axi [get_bd_intf_pins axi_interconnect_1/M10_AXI] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
connect_bd_intf_net -intf_net axi_interconnect_1_m11_axi [get_bd_intf_pins axi_interconnect_1/M11_AXI] [get_bd_intf_pins axi_dma_1/S_AXI_LITE]
connect_bd_intf_net -intf_net axi_interconnect_1_m12_axi [get_bd_intf_pins axi_interconnect_1/M12_AXI] [get_bd_intf_pins axi_dma_2/S_AXI_LITE]
connect_bd_intf_net -intf_net axi_interconnect_1_m13_axi [get_bd_intf_pins axi_interconnect_1/M13_AXI] [get_bd_intf_pins axi_dma_3/S_AXI_LITE]
connect_bd_intf_net -intf_net axi_interconnect_1_m14_axi [get_bd_intf_pins axi_interconnect_1/M14_AXI] [get_bd_intf_pins xadc_wiz_1/s_axi_lite]
connect_bd_intf_net -intf_net axi_mem_intercon_m00_axi [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_1/S_AXI_HP1]
connect_bd_intf_net -intf_net axi_dma_0_m_axi_s2mm [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
connect_bd_intf_net -intf_net axi_dma_1_m_axi_s2mm [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S01_AXI]
connect_bd_intf_net -intf_net axi_dma_2_m_axi_s2mm [get_bd_intf_pins axi_dma_2/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S02_AXI]
connect_bd_intf_net -intf_net axi_dma_3_m_axi_s2mm [get_bd_intf_pins axi_dma_3/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S03_AXI]
connect_bd_intf_net -intf_net axi_mc_speed_1_s_axis_s2mm [get_bd_intf_pins axi_dma_2/S_AXIS_S2MM] [get_bd_intf_pins axi_mc_speed_1/s_axis_s2mm]
connect_bd_intf_net -intf_net axi_mc_current_monitor_1_s_axis_s2mm [get_bd_intf_pins axi_mc_current_monitor_1/s_axis_s2mm] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
connect_bd_intf_net -intf_net axi_mc_torque_ctrl_1_s_axis_s2mm [get_bd_intf_pins axi_mc_torque_ctrl_1/s_axis_s2mm] [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM]
connect_bd_intf_net -intf_net axi_mc_current_monitor_2_s_axis_s2mm [get_bd_intf_pins axi_mc_current_monitor_2/s_axis_s2mm] [get_bd_intf_pins axi_dma_3/S_AXIS_S2MM]


# interface connections

# axi-lite clock and reset
 connect_bd_net -net processing_system7_1_fclk_clk0 \
 [get_bd_pins axi_interconnect_1/M06_ACLK] \
 [get_bd_pins axi_interconnect_1/M07_ACLK] \
 [get_bd_pins axi_interconnect_1/M08_ACLK] \
 [get_bd_pins axi_interconnect_1/M09_ACLK] \
 [get_bd_pins axi_interconnect_1/M10_ACLK] \
 [get_bd_pins axi_interconnect_1/M11_ACLK] \
 [get_bd_pins axi_interconnect_1/M12_ACLK] \
 [get_bd_pins axi_mem_intercon/ACLK] \
 [get_bd_pins axi_mem_intercon/M00_ACLK] \
 [get_bd_pins axi_mem_intercon/S00_ACLK] \
 [get_bd_pins axi_mem_intercon/S01_ACLK] \
 [get_bd_pins axi_mem_intercon/S02_ACLK] \
 [get_bd_pins axi_mem_intercon/S03_ACLK] \
 [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] \
 [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] \
 [get_bd_pins axi_dma_2/m_axi_s2mm_aclk] \
 [get_bd_pins axi_dma_3/m_axi_s2mm_aclk] \
 [get_bd_pins axi_dma_0/s_axi_lite_aclk] \
 [get_bd_pins axi_dma_1/s_axi_lite_aclk] \
 [get_bd_pins axi_dma_2/s_axi_lite_aclk] \
 [get_bd_pins axi_dma_3/s_axi_lite_aclk] \
 [get_bd_pins processing_system7_1/S_AXI_HP1_ACLK] \
 [get_bd_pins axi_mc_torque_ctrl_1/s_axi_aclk] \
 [get_bd_pins axi_mc_torque_ctrl_1/ref_clk] \
 [get_bd_pins axi_mc_torque_ctrl_1/s_axis_s2mm_clk] \
 [get_bd_pins axi_mc_current_monitor_1/s_axi_aclk] \
 [get_bd_pins axi_mc_current_monitor_1/s_axis_s2mm_clk] \
 [get_bd_pins axi_mc_current_monitor_1/ref_clk] \
 [get_bd_pins axi_mc_speed_1/s_axi_aclk] \
 [get_bd_pins axi_mc_speed_1/s_axis_s2mm_clk] \
 [get_bd_pins axi_mc_speed_1/ref_clk] \
 [get_bd_pins axi_mc_current_monitor_2/s_axi_aclk] \
 [get_bd_pins axi_mc_current_monitor_2/s_axis_s2mm_clk] \
 [get_bd_pins axi_mc_current_monitor_2/ref_clk] \
 [get_bd_pins xadc_wiz_1/s_axi_aclk] \
 [get_bd_pins axi_interconnect_1/M14_ACLK]

connect_bd_net -net processing_system7_1_fclk_reset0_n \
  [get_bd_pins processing_system7_1/FCLK_RESET0_N] \
  [get_bd_pins axi_interconnect_1/ARESETN] \
  [get_bd_pins axi_interconnect_1/M06_ARESETN] \
  [get_bd_pins axi_interconnect_1/M07_ARESETN] \
  [get_bd_pins axi_interconnect_1/M08_ARESETN] \
  [get_bd_pins axi_interconnect_1/M09_ARESETN] \
  [get_bd_pins axi_interconnect_1/M10_ARESETN] \
  [get_bd_pins axi_interconnect_1/M11_ARESETN] \
  [get_bd_pins axi_interconnect_1/M12_ARESETN] \
  [get_bd_pins axi_clkgen_1/s_axi_aresetn] \
  [get_bd_pins axi_mc_current_monitor_1/s_axi_aresetn] \
  [get_bd_pins axi_mc_speed_1/s_axi_aresetn] \
  [get_bd_pins axi_mc_torque_ctrl_1/s_axi_aresetn] \
  [get_bd_pins axi_dma_0/axi_resetn] \
  [get_bd_pins axi_dma_1/axi_resetn] \
  [get_bd_pins axi_dma_2/axi_resetn] \
  [get_bd_pins axi_mem_intercon/ARESETN] \
  [get_bd_pins axi_mem_intercon/M00_ARESETN] \
  [get_bd_pins axi_mem_intercon/S00_ARESETN] \
  [get_bd_pins axi_mem_intercon/S01_ARESETN] \
  [get_bd_pins axi_mem_intercon/S02_ARESETN] \
  [get_bd_pins axi_mem_intercon/S03_ARESETN] \
  [get_bd_pins axi_dma_3/axi_resetn] \
  [get_bd_pins axi_mc_current_monitor_2/s_axi_aresetn] \
  [get_bd_pins xadc_wiz_1/s_axi_aresetn] \
  [get_bd_pins axi_interconnect_1/M14_ARESETN]


connect_bd_net -net axi_mc_speed_1_position_o [get_bd_pins axi_mc_speed_1/position_o] [get_bd_pins axi_mc_torque_ctrl_1/position_i]
connect_bd_net -net axi_mc_speed_1_new_speed_o [get_bd_pins axi_mc_speed_1/new_speed_o] [get_bd_pins axi_mc_torque_ctrl_1/new_speed_i]
connect_bd_net -net axi_mc_speed_1_speed_o [get_bd_pins axi_mc_speed_1/speed_o] [get_bd_pins axi_mc_torque_ctrl_1/speed_i]
connect_bd_net -net position_i_1 [get_bd_ports position_i] [get_bd_pins axi_mc_speed_1/position_i] [get_bd_pins axi_mc_speed_1/bemf_i]

connect_bd_net -net axi_mc_torque_ctrl_1_sensors_o [get_bd_pins axi_mc_torque_ctrl_1/sensors_o] [get_bd_pins axi_mc_speed_1/hall_bemf_i]
connect_bd_net -net adc_ia_dat_i_1 [get_bd_ports adc_ia_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_ia_dat_i]
connect_bd_net -net adc_ib_dat_i_1 [get_bd_ports adc_ib_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_ib_dat_i]
connect_bd_net -net adc_it_dat_i_1 [get_bd_ports adc_it_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_it_dat_i]
connect_bd_net -net adc_vbus_dat_i_1 [get_bd_ports adc_vbus_dat_i] [get_bd_pins axi_mc_current_monitor_1/adc_vbus_dat_i]

connect_bd_net -net axi_mc_current_monitor_1_it_o [get_bd_pins axi_mc_current_monitor_1/it_o] [get_bd_pins axi_mc_torque_ctrl_1/it_i]
connect_bd_net -net axi_mc_current_monitor_1_i_ready_o [get_bd_pins axi_mc_current_monitor_1/i_ready_o] [get_bd_pins axi_mc_torque_ctrl_1/i_ready_i]
connect_bd_net -net axi_mc_current_monitor_1_adc_ia_clk_o [get_bd_ports adc_ia_clk_o] [get_bd_pins axi_mc_current_monitor_1/adc_ia_clk_o]
connect_bd_net -net axi_mc_current_monitor_1_adc_ib_clk_o [get_bd_ports adc_ib_clk_o] [get_bd_pins axi_mc_current_monitor_1/adc_ib_clk_o]
connect_bd_net -net axi_mc_current_monitor_1_adc_it_clk_o [get_bd_ports adc_it_clk_o] [get_bd_pins axi_mc_current_monitor_1/adc_it_clk_o]
connect_bd_net -net axi_mc_current_monitor_1_adc_vbus_clk_o [get_bd_ports adc_vbus_clk_o] [get_bd_pins axi_mc_current_monitor_1/adc_vbus_clk_o]

connect_bd_net -net fmc_m1_fault_i_1 [get_bd_ports fmc_m1_fault_i] [get_bd_pins axi_mc_torque_ctrl_1/fmc_m1_fault_i]

connect_bd_net -net axi_mc_torque_ctrl_1_fmc_m1_en_o [get_bd_ports fmc_m1_en_o] [get_bd_pins axi_mc_torque_ctrl_1/fmc_m1_en_o]
connect_bd_net -net axi_mc_torque_ctrl_1_pwm_al_o [get_bd_ports pwm_al_o] [get_bd_pins axi_mc_torque_ctrl_1/pwm_al_o]
connect_bd_net -net axi_mc_torque_ctrl_1_pwm_ah_o [get_bd_ports pwm_ah_o] [get_bd_pins axi_mc_torque_ctrl_1/pwm_ah_o]
connect_bd_net -net axi_mc_torque_ctrl_1_pwm_cl_o [get_bd_ports pwm_cl_o] [get_bd_pins axi_mc_torque_ctrl_1/pwm_cl_o]
connect_bd_net -net axi_mc_torque_ctrl_1_pwm_ch_o [get_bd_ports pwm_ch_o] [get_bd_pins axi_mc_torque_ctrl_1/pwm_ch_o]
connect_bd_net -net axi_mc_torque_ctrl_1_pwm_bl_o [get_bd_ports pwm_bl_o] [get_bd_pins axi_mc_torque_ctrl_1/pwm_bl_o]
connect_bd_net -net axi_mc_torque_ctrl_1_pwm_bh_o [get_bd_ports pwm_bh_o] [get_bd_pins axi_mc_torque_ctrl_1/pwm_bh_o]

connect_bd_net -net adc_ia_dat_d_i [get_bd_ports adc_ia_dat_d_i] [get_bd_pins axi_mc_current_monitor_2/adc_ia_dat_i]
connect_bd_net -net axi_mc_current_monitor_2_adc_ia_clk_o [get_bd_ports adc_ia_clk_d_o] [get_bd_pins axi_mc_current_monitor_2/adc_ia_clk_o]
connect_bd_net -net adc_ib_dat_d_i [get_bd_ports adc_ib_dat_d_i] [get_bd_pins axi_mc_current_monitor_2/adc_ib_dat_i]
connect_bd_net -net axi_mc_current_monitor_2_adc_ib_clk_o [get_bd_ports adc_ib_clk_d_o] [get_bd_pins axi_mc_current_monitor_2/adc_ib_clk_o]
connect_bd_net -net adc_it_dat_d_i [get_bd_ports adc_it_dat_d_i] [get_bd_pins axi_mc_current_monitor_2/adc_it_dat_i]
connect_bd_net -net axi_mc_current_monitor_2_adc_it_clk_o [get_bd_ports adc_it_clk_d_o] [get_bd_pins axi_mc_current_monitor_2/adc_it_clk_o]
connect_bd_net -net axi_mc_torque_ctrl_1_gpo_o [get_bd_ports gpo_o] [get_bd_pins axi_mc_torque_ctrl_1/gpo_o]

connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_1/In2]
connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_1/In3]
connect_bd_net -net axi_dma_2_s2mm_introut [get_bd_pins axi_dma_2/s2mm_introut] [get_bd_pins xlconcat_1/In4]
connect_bd_net -net axi_dma_3_s2mm_introut [get_bd_pins axi_dma_3/s2mm_introut] [get_bd_pins xlconcat_1/In5]

connect_bd_net -net vp_in_1 [get_bd_ports vp_in] [get_bd_pins xadc_wiz_1/vp_in]
connect_bd_net -net vn_in_1 [get_bd_ports vn_in] [get_bd_pins xadc_wiz_1/vn_in]
connect_bd_net -net vauxp0_1 [get_bd_ports vauxp0] [get_bd_pins xadc_wiz_1/vauxp0]
connect_bd_net -net vauxn0_1 [get_bd_ports vauxn0] [get_bd_pins xadc_wiz_1/vauxn0]
connect_bd_net -net vauxp8_1 [get_bd_ports vauxp8] [get_bd_pins xadc_wiz_1/vauxp8]
connect_bd_net -net vauxn8_1 [get_bd_ports vauxn8] [get_bd_pins xadc_wiz_1/vauxn8]
connect_bd_net -net xadc_wiz_1_muxaddr_out [get_bd_ports muxaddr_out] [get_bd_pins xadc_wiz_1/muxaddr_out]

# address map

create_bd_addr_seg -range 0x10000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG4
create_bd_addr_seg -range 0x10000 -offset 0x40440000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG7
create_bd_addr_seg -range 0x10000 -offset 0x40480000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_dma_2/S_AXI_LITE/Reg] SEG8
create_bd_addr_seg -range 0x10000 -offset 0x404C0000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_dma_3/S_AXI_LITE/Reg] SEG10
create_bd_addr_seg -range 0x10000 -offset 0x40500000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_mc_current_monitor_1/s_axi/axi_lite] SEG1
create_bd_addr_seg -range 0x10000 -offset 0x40540000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_mc_torque_ctrl_1/s_axi/axi_lite] SEG3
create_bd_addr_seg -range 0x10000 -offset 0x40580000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_mc_speed_1/s_axi/axi_lite] SEG2
create_bd_addr_seg -range 0x10000 -offset 0x405C0000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_mc_current_monitor_2/s_axi/axi_lite] SEG11
create_bd_addr_seg -range 0x10000 -offset 0x43200000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs xadc_wiz_1/s_axi_lite/Reg] SEG12
create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_1/S_AXI_HP1/HP1_DDR_LOWOCM] SEG1
create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_1/S_AXI_HP1/HP1_DDR_LOWOCM] SEG1
create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_2/Data_S2MM] [get_bd_addr_segs processing_system7_1/S_AXI_HP1/HP1_DDR_LOWOCM] SEG2
create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_3/Data_S2MM] [get_bd_addr_segs processing_system7_1/S_AXI_HP1/HP1_DDR_LOWOCM] SEG1

