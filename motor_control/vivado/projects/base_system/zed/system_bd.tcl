proc adi_connect_irq {name irq pin} {
	connect_bd_net -net [format "axi_%s_interrupt" $name] [get_bd_pins [format "xlconcat_1/In%s" $irq]] [get_bd_pins $pin]
}

set NUM_INTERRUPTS [expr $NUM_EXTRA_INTERRUPTS + 2]
set NUM_AXI_SLAVES [expr $NUM_EXTRA_AXI_SLAVES + 6]
set NUM_GPIOS [expr $NUM_EXTRA_GPIOS + 27]

# create board design
# interface ports

set DDR [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR]
set GPIO_0 [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0]
set FIXED_IO [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO]

# interface ports

set hdmi_out_clk    [create_bd_port -dir O hdmi_out_clk]
set hdmi_hsync      [create_bd_port -dir O hdmi_hsync]
set hdmi_vsync      [create_bd_port -dir O hdmi_vsync]
set hdmi_data_e     [create_bd_port -dir O hdmi_data_e]
set hdmi_data       [create_bd_port -dir O -from 15 -to 0 hdmi_data]
set hdmi_int        [create_bd_port -dir I hdmi_int]

set i2s_mclk        [create_bd_port -dir O -type clk i2s_mclk]
set i2s_bclk        [create_bd_port -dir O i2s_bclk]
set i2s_lrclk       [create_bd_port -dir O i2s_lrclk]
set i2s_sdata_out   [create_bd_port -dir O i2s_sdata_out]
set i2s_sdata_in    [create_bd_port -dir I i2s_sdata_in]

set iic_mux_scl_I   [create_bd_port -dir I -from 1 -to 0 iic_mux_scl_I]
set iic_mux_scl_O   [create_bd_port -dir O -from 1 -to 0 iic_mux_scl_O]
set iic_mux_scl_T   [create_bd_port -dir O iic_mux_scl_T]
set iic_mux_sda_I   [create_bd_port -dir I -from 1 -to 0 iic_mux_sda_I]
set iic_mux_sda_O   [create_bd_port -dir O -from 1 -to 0 iic_mux_sda_O]
set iic_mux_sda_T   [create_bd_port -dir O iic_mux_sda_T ]

set otg_vbusoc      [create_bd_port -dir I otg_vbusoc]

set spdif_out       [create_bd_port -dir O spdif_out]

# instance: processing_system7_1

set processing_system7_1  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.2 processing_system7_1]
set_property -dict [list CONFIG.PCW_IMPORT_BOARD_PRESET {ZedBoard}] $processing_system7_1
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $processing_system7_1
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_CLK0_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_RST0_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO $NUM_GPIOS] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_DMA0 {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_DMA1 {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_DMA2 {1}] $processing_system7_1

# instance: interrupts

set xlconcat_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 xlconcat_1]
set_property -dict [list CONFIG.NUM_PORTS $NUM_INTERRUPTS] $xlconcat_1

# instance: hdmi

set axi_clkgen_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_clkgen_1]
set axi_hdmi_tx_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_tx_1]

set axi_vdma_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.0 axi_vdma_1]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_vdma_1
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_vdma_1
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_vdma_1

# instance: audio

set clkgen_audio_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.0 clkgen_audio_1]
set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000}] $clkgen_audio_1
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288}] $clkgen_audio_1

set axi_spdif_tx_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_1]
set_property -dict [list CONFIG.C_DMA_TYPE {1}] $axi_spdif_tx_1
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_spdif_tx_1
set_property -dict [list CONFIG.C_HIGHADDR {0xffffffff}] $axi_spdif_tx_1
set_property -dict [list CONFIG.C_BASEADDR {0x00000000}] $axi_spdif_tx_1

set axi_i2s_adi_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_i2s_adi:1.0 axi_i2s_adi_1]
set_property -dict [list CONFIG.C_DMA_TYPE {1}] $axi_i2s_adi_1
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_i2s_adi_1
set_property -dict [list CONFIG.C_HIGHADDR {0xffffffff}] $axi_i2s_adi_1
set_property -dict [list CONFIG.C_BASEADDR {0x00000000}] $axi_i2s_adi_1

# I2C

set axi_iic_base [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_base]

set util_i2c_mixer_1 [create_bd_cell -type ip -vlnv analog.com:user:util_i2c_mixer:1.0 util_i2c_mixer_1]

set util_vector_logic_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:1.0 util_vector_logic_1]
set_property -dict [list CONFIG.C_SIZE {1}] $util_vector_logic_1
set_property -dict [list CONFIG.C_OPERATION {not}] $util_vector_logic_1

# vcc & gnd

set sys_const_vcc_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.0 sys_const_vcc_1]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] [get_bd_cells sys_const_vcc_1]

set sys_const_gnd_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.0 sys_const_gnd_1]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {0}] [get_bd_cells sys_const_gnd_1]

# instance: interconnects

set axi_interconnect_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.0 axi_interconnect_1]
set_property -dict [list CONFIG.NUM_MI $NUM_AXI_SLAVES] $axi_interconnect_1

set axi_interconnect_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.0 axi_interconnect_2]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_interconnect_2

# interface connections

connect_bd_intf_net -intf_net processing_system7_1_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_1/DDR]
connect_bd_intf_net -intf_net processing_system7_1_gpio_0 [get_bd_intf_ports GPIO_0] [get_bd_intf_pins /processing_system7_1/GPIO_0] 
connect_bd_intf_net -intf_net processing_system7_1_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_1/FIXED_IO]

connect_bd_net -net sys_const_gnd_s \
  [get_bd_pins sys_const_gnd_1/const] \
  [get_bd_pins clkgen_audio_1/reset]

connect_bd_intf_net -intf_net processing_system7_1_m_axi_gp0 [get_bd_intf_pins processing_system7_1/M_AXI_GP0] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
connect_bd_intf_net -intf_net axi_interconnect_1_m00_axi [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins axi_clkgen_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m01_axi [get_bd_intf_pins axi_interconnect_1/M01_AXI] [get_bd_intf_pins axi_iic_base/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m02_axi [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins axi_vdma_1/S_AXI_LITE]
connect_bd_intf_net -intf_net axi_interconnect_1_m03_axi [get_bd_intf_pins axi_interconnect_1/M03_AXI] [get_bd_intf_pins axi_hdmi_tx_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m04_axi [get_bd_intf_pins axi_interconnect_1/M04_AXI] [get_bd_intf_pins axi_i2s_adi_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m05_axi [get_bd_intf_pins axi_interconnect_1/M05_AXI] [get_bd_intf_pins axi_spdif_tx_1/s_axi]

connect_bd_intf_net -intf_net axi_vdma_1_m_axi_mm2s [get_bd_intf_pins axi_vdma_1/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_2/S00_AXI]
connect_bd_intf_net -intf_net axi_interconnect_2_m00_axi [get_bd_intf_pins axi_interconnect_2/M00_AXI] [get_bd_intf_pins processing_system7_1/S_AXI_HP0]

# axi-lite clock and reset

connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins processing_system7_1/FCLK_CLK0] \
  [get_bd_pins processing_system7_1/M_AXI_GP0_ACLK] \
  [get_bd_pins processing_system7_1/S_AXI_HP0_ACLK] \
  [get_bd_pins processing_system7_1/DMA0_ACLK] \
  [get_bd_pins processing_system7_1/DMA1_ACLK] \
  [get_bd_pins processing_system7_1/DMA2_ACLK]\
  [get_bd_pins axi_interconnect_1/ACLK] \
  [get_bd_pins axi_interconnect_1/S00_ACLK] \
  [get_bd_pins axi_interconnect_1/M*_ACLK] \
  [get_bd_pins axi_interconnect_2/ACLK] \
  [get_bd_pins axi_interconnect_2/S00_ACLK] \
  [get_bd_pins axi_interconnect_2/M00_ACLK] \
  [get_bd_pins axi_clkgen_1/s_axi_aclk] \
  [get_bd_pins axi_clkgen_1/drp_clk] \
  [get_bd_pins axi_hdmi_tx_1/s_axi_aclk] \
  [get_bd_pins axi_hdmi_tx_1/m_axis_mm2s_clk] \
  [get_bd_pins axi_vdma_1/s_axi_lite_aclk] \
  [get_bd_pins axi_vdma_1/m_axi_mm2s_aclk] \
  [get_bd_pins axi_vdma_1/m_axis_mm2s_aclk] \
  [get_bd_pins axi_i2s_adi_1/S_AXI_ACLK] \
  [get_bd_pins axi_i2s_adi_1/DMA_REQ_RX_ACLK] \
  [get_bd_pins axi_i2s_adi_1/DMA_REQ_TX_ACLK] \
  [get_bd_pins axi_spdif_tx_1/S_AXI_ACLK] \
  [get_bd_pins axi_spdif_tx_1/DMA_REQ_ACLK] \
  [get_bd_pins axi_iic_base/s_axi_aclk] \

connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins processing_system7_1/FCLK_RESET0_N] \
  [get_bd_pins axi_interconnect_1/ARESETN] \
  [get_bd_pins axi_interconnect_1/S00_ARESETN] \
  [get_bd_pins axi_interconnect_1/M*_ARESETN] \
  [get_bd_pins axi_clkgen_1/s_axi_aresetn] \
  [get_bd_pins axi_hdmi_tx_1/s_axi_aresetn] \
  [get_bd_pins axi_vdma_1/axi_resetn] \
  [get_bd_pins axi_interconnect_2/ARESETN] \
  [get_bd_pins axi_interconnect_2/S00_ARESETN] \
  [get_bd_pins axi_interconnect_2/M00_ARESETN] \
  [get_bd_pins axi_i2s_adi_1/S_AXI_ARESETN] \
  [get_bd_pins axi_i2s_adi_1/DMA_REQ_RX_RSTN] \
  [get_bd_pins axi_i2s_adi_1/DMA_REQ_TX_RSTN] \
  [get_bd_pins axi_spdif_tx_1/S_AXI_ARESETN] \
  [get_bd_pins axi_spdif_tx_1/DMA_REQ_RSTN] \
  [get_bd_pins axi_iic_base/s_axi_aresetn] \

# hdmi clock

connect_bd_net -net processing_system7_1_fclk_clk1 [get_bd_pins processing_system7_1/FCLK_CLK1] \
  [get_bd_pins axi_clkgen_1/clk] \
  [get_bd_pins clkgen_audio_1/clk_in1] \

connect_bd_net -net axi_clkgen_1_clk [get_bd_pins axi_clkgen_1/clk_0] [get_bd_pins axi_hdmi_tx_1/hdmi_clk]

# interrupts

connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins processing_system7_1/IRQ_F2P]

adi_connect_irq hdmi_vdma 0 axi_vdma_1/mm2s_introut
adi_connect_irq iic_base 1 axi_iic_base/iic2intc_irpt

# hdmi external ports

connect_bd_net -net axi_hdmi_tx_1_hdmi_out_clk [get_bd_ports hdmi_out_clk] [get_bd_pins axi_hdmi_tx_1/hdmi_out_clk]
connect_bd_net -net axi_hdmi_tx_1_hdmi_hsync [get_bd_ports hdmi_hsync] [get_bd_pins axi_hdmi_tx_1/hdmi_16_hsync]
connect_bd_net -net axi_hdmi_tx_1_hdmi_vsync [get_bd_ports hdmi_vsync] [get_bd_pins axi_hdmi_tx_1/hdmi_16_vsync]
connect_bd_net -net axi_hdmi_tx_1_hdmi_data_e [get_bd_ports hdmi_data_e] [get_bd_pins axi_hdmi_tx_1/hdmi_16_data_e]
connect_bd_net -net axi_hdmi_tx_1_hdmi_data [get_bd_ports hdmi_data] [get_bd_pins axi_hdmi_tx_1/hdmi_16_data]

# hdmi vdma ports

connect_bd_net -net axi_hdmi_tx_1_m_axis_mm2s_tvalid [get_bd_pins axi_vdma_1/m_axis_mm2s_tvalid] [get_bd_pins axi_hdmi_tx_1/m_axis_mm2s_tvalid]
connect_bd_net -net axi_hdmi_tx_1_m_axis_mm2s_tdata [get_bd_pins axi_vdma_1/m_axis_mm2s_tdata] [get_bd_pins axi_hdmi_tx_1/m_axis_mm2s_tdata]
connect_bd_net -net axi_hdmi_tx_1_m_axis_mm2s_tkeep [get_bd_pins axi_vdma_1/m_axis_mm2s_tkeep] [get_bd_pins axi_hdmi_tx_1/m_axis_mm2s_tkeep]
connect_bd_net -net axi_hdmi_tx_1_m_axis_mm2s_tlast [get_bd_pins axi_vdma_1/m_axis_mm2s_tlast] [get_bd_pins axi_hdmi_tx_1/m_axis_mm2s_tlast]
connect_bd_net -net axi_hdmi_tx_1_m_axis_mm2s_tready [get_bd_pins axi_vdma_1/m_axis_mm2s_tready] [get_bd_pins axi_hdmi_tx_1/m_axis_mm2s_tready]

connect_bd_net -net axi_hdmi_tx_1_mm2s_fsync [get_bd_pins axi_hdmi_tx_1/m_axis_mm2s_fsync] \
  [get_bd_pins axi_vdma_1/mm2s_fsync] \
  [get_bd_pins axi_hdmi_tx_1/m_axis_mm2s_fsync_ret] \

# audio

connect_bd_net -net clkgen_audio_clk_122 [get_bd_ports i2s_mclk] \
  [get_bd_pins clkgen_audio_1/clk_out1] \
  [get_bd_pins axi_i2s_adi_1/DATA_CLK_I] \
  [get_bd_pins axi_spdif_tx_1/spdif_data_clk] \

connect_bd_net -net i2s_bclk_s [get_bd_ports i2s_bclk] [get_bd_pins axi_i2s_adi_1/BCLK_O]
connect_bd_net -net i2s_lrclk_s [get_bd_ports i2s_lrclk] [get_bd_pins axi_i2s_adi_1/LRCLK_O]
connect_bd_net -net i2s_sdata_out_s [get_bd_ports i2s_sdata_out] [get_bd_pins axi_i2s_adi_1/SDATA_O]
connect_bd_net -net i2s_sdata_in_s [get_bd_ports i2s_sdata_in] [get_bd_pins axi_i2s_adi_1/SDATA_I]

connect_bd_intf_net -intf_net axi_i2s_adi_dma_req_tx [get_bd_intf_pins processing_system7_1/DMA1_REQ] [get_bd_intf_pins axi_i2s_adi_1/DMA_REQ_TX]
connect_bd_intf_net -intf_net axi_i2s_adi_dma_ack_tx [get_bd_intf_pins processing_system7_1/DMA1_ACK] [get_bd_intf_pins axi_i2s_adi_1/DMA_ACK_TX]
connect_bd_intf_net -intf_net axi_i2s_adi_dma_req_rx [get_bd_intf_pins processing_system7_1/DMA2_REQ] [get_bd_intf_pins axi_i2s_adi_1/DMA_REQ_RX]
connect_bd_intf_net -intf_net axi_i2s_adi_dma_ack_rx [get_bd_intf_pins processing_system7_1/DMA2_ACK] [get_bd_intf_pins axi_i2s_adi_1/DMA_ACK_RX]

connect_bd_intf_net -intf_net axi_spdif_dma_req_tx [get_bd_intf_pins processing_system7_1/DMA0_REQ] [get_bd_intf_pins axi_spdif_tx_1/DMA_REQ]
connect_bd_intf_net -intf_net axi_spdif_dma_ack_tx [get_bd_intf_pins processing_system7_1/DMA0_ACK] [get_bd_intf_pins axi_spdif_tx_1/DMA_ACK]

connect_bd_net -net spdif_out_s [get_bd_ports spdif_out] [get_bd_pins axi_spdif_tx_1/spdif_tx_o]

connect_bd_net -net axi_iic_base_scl_i [get_bd_pins axi_iic_base/scl_i] [get_bd_pins util_i2c_mixer_1/upstream_scl_O]
connect_bd_net -net axi_iic_base_scl_o [get_bd_pins axi_iic_base/scl_o] [get_bd_pins util_i2c_mixer_1/upstream_scl_I]
connect_bd_net -net axi_iic_base_scl_t [get_bd_pins axi_iic_base/scl_t] [get_bd_pins util_i2c_mixer_1/upstream_scl_T]
connect_bd_net -net axi_iic_base_sda_i [get_bd_pins axi_iic_base/sda_i] [get_bd_pins util_i2c_mixer_1/upstream_sda_O]
connect_bd_net -net axi_iic_base_sda_o [get_bd_pins axi_iic_base/sda_o] [get_bd_pins util_i2c_mixer_1/upstream_sda_I]
connect_bd_net -net axi_iic_base_sda_t [get_bd_pins axi_iic_base/sda_t] [get_bd_pins util_i2c_mixer_1/upstream_sda_T]

connect_bd_net -net util_i2c_mixer_1_downstream_scl_i [get_bd_ports iic_mux_scl_I] [get_bd_pins util_i2c_mixer_1/downstream_scl_I]
connect_bd_net -net util_i2c_mixer_1_downstream_scl_o [get_bd_ports iic_mux_scl_O] [get_bd_pins util_i2c_mixer_1/downstream_scl_O]
connect_bd_net -net util_i2c_mixer_1_downstream_scl_t [get_bd_ports iic_mux_scl_T] [get_bd_pins util_i2c_mixer_1/downstream_scl_T]
connect_bd_net -net util_i2c_mixer_1_downstream_sda_i [get_bd_ports iic_mux_sda_I] [get_bd_pins util_i2c_mixer_1/downstream_sda_I]
connect_bd_net -net util_i2c_mixer_1_downstream_sda_o [get_bd_ports iic_mux_sda_O] [get_bd_pins util_i2c_mixer_1/downstream_sda_O]
connect_bd_net -net util_i2c_mixer_1_downstream_sda_t [get_bd_ports iic_mux_sda_T] [get_bd_pins util_i2c_mixer_1/downstream_sda_T]

connect_bd_net -net vector_logic_1_o [get_bd_pins util_vector_logic_1/Res] [get_bd_pins processing_system7_1/USB0_VBUS_PWRFAULT]
connect_bd_net -net vector_logic_1_i [get_bd_pins util_vector_logic_1/Op1] [get_bd_ports otg_vbusoc]

# address map

create_bd_addr_seg -range 0x00010000 -offset 0x70e00000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_hdmi_tx_1/s_axi/axi_lite] SEG5
create_bd_addr_seg -range 0x00010000 -offset 0x79000000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_clkgen_1/s_axi/axi_lite] SEG6

create_bd_addr_seg -range 0x00010000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_vdma_1/S_AXI_LITE/Reg] SEG9

create_bd_addr_seg -range 0x00010000 -offset 0x77600000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_i2s_adi_1/S_AXI/reg0] SEG13
create_bd_addr_seg -range 0x00010000 -offset 0x75c00000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_spdif_tx_1/S_AXI/reg0] SEG14
create_bd_addr_seg -range 0x00010000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_iic_base/s_axi/Reg] SEG15

create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_1/Data_MM2S] [get_bd_addr_segs processing_system7_1/S_AXI_HP0/HP0_DDR_LOWOCM] SEG1

proc adi_add_fmc_i2c {IRQ} {

	set IIC_FMC [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_FMC]
	set axi_iic_fmc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_fmc]

	set_property -dict [list CONFIG.USE_BOARD_FLOW {true} CONFIG.IIC_BOARD_INTERFACE {IIC_FMC}] $axi_iic_fmc
	connect_bd_intf_net -intf_net axi_interconnect_1_m09_axi [get_bd_intf_pins axi_interconnect_1/M09_AXI] [get_bd_intf_pins axi_iic_fmc/s_axi]
	connect_bd_intf_net -intf_net axi_iic_fmc_iic [get_bd_intf_ports IIC_FMC] [get_bd_intf_pins axi_iic_fmc/iic]
	connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_iic_fmc/s_axi_aclk]
	connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_iic_fmc/s_axi_aresetn]

	adi_connect_irq fmc $IRQ axi_iic_fmc/iic2intc_irpt

	create_bd_addr_seg -range 0x00010000 -offset 0x41620000 [get_bd_addr_spaces processing_system7_1/Data] [get_bd_addr_segs axi_iic_fmc/s_axi/Reg] SEG12

}
