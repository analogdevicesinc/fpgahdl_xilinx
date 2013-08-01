// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//    
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad9361 (

  // physical interface (receive)

  rx_clk_in_p,
  rx_clk_in_n,
  rx_frame_in_p,
  rx_frame_in_n,
  rx_data_in_p,
  rx_data_in_n,

  // physical interface (transmit)

  tx_clk_out_p,
  tx_clk_out_n,
  tx_frame_out_p,
  tx_frame_out_n,
  tx_data_out_p,
  tx_data_out_n,

  // physical interface (data control)

  enable,
  txnrx,

  // delay clock

  delay_clk,

  // common clock

  clk,

  // dma interface

  s_axis_s2mm_clk,
  s_axis_s2mm_tvalid,
  s_axis_s2mm_tdata,
  s_axis_s2mm_tkeep,
  s_axis_s2mm_tlast,
  s_axis_s2mm_tready,

  // vdma interface

  m_axis_mm2s_clk,
  m_axis_mm2s_fsync,
  m_axis_mm2s_tvalid,
  m_axis_mm2s_tdata,
  m_axis_mm2s_tkeep,
  m_axis_mm2s_tlast,
  m_axis_mm2s_tready,

  // axi interface

  s_axi_aclk,
  s_axi_aresetn,
  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rdata,
  s_axi_rresp,
  s_axi_rready,

  // monitor/debug signals

  adc_mon_valid,
  adc_mon_data,
  dev_dbg_trigger,
  dev_dbg_data);

  // parameters

  parameter   PCORE_ID = 0;
  parameter   PCORE_BUFTYPE = 0;
  parameter   PCORE_IODELAY_GROUP = "dev_if_delay_group";
  parameter   C_S_AXI_MIN_SIZE = 32'hffff;
  parameter   C_BASEADDR = 32'hffffffff;
  parameter   C_HIGHADDR = 32'h00000000;

  // physical interface (receive)

  input           rx_clk_in_p;
  input           rx_clk_in_n;
  input           rx_frame_in_p;
  input           rx_frame_in_n;
  input   [ 5:0]  rx_data_in_p;
  input   [ 5:0]  rx_data_in_n;

  // physical interface (transmit)

  output          tx_clk_out_p;
  output          tx_clk_out_n;
  output          tx_frame_out_p;
  output          tx_frame_out_n;
  output  [ 5:0]  tx_data_out_p;
  output  [ 5:0]  tx_data_out_n;

  // physical interface (data control)

  output          enable;
  output          txnrx;

  // delay clock

  input           delay_clk;

  // common clock

  output          clk;

  // dma interface

  input           s_axis_s2mm_clk;
  output          s_axis_s2mm_tvalid;
  output  [63:0]  s_axis_s2mm_tdata;
  output  [ 7:0]  s_axis_s2mm_tkeep;
  output          s_axis_s2mm_tlast;
  input           s_axis_s2mm_tready;

  // vdma interface

  input           m_axis_mm2s_clk;
  output          m_axis_mm2s_fsync;
  input           m_axis_mm2s_tvalid;
  input   [63:0]  m_axis_mm2s_tdata;
  input   [ 7:0]  m_axis_mm2s_tkeep;
  input           m_axis_mm2s_tlast;
  output          m_axis_mm2s_tready;

  // axi interface

  input           s_axi_aclk;
  input           s_axi_aresetn;
  input           s_axi_awvalid;
  input   [31:0]  s_axi_awaddr;
  output          s_axi_awready;
  input           s_axi_wvalid;
  input   [31:0]  s_axi_wdata;
  input   [ 3:0]  s_axi_wstrb;
  output          s_axi_wready;
  output          s_axi_bvalid;
  output  [ 1:0]  s_axi_bresp;
  input           s_axi_bready;
  input           s_axi_arvalid;
  input   [31:0]  s_axi_araddr;
  output          s_axi_arready;
  output          s_axi_rvalid;
  output  [31:0]  s_axi_rdata;
  output  [ 1:0]  s_axi_rresp;
  input           s_axi_rready;

  // monitor/debug interface

  output  [ 1:0]  adc_mon_valid;
  output [116:0]  adc_mon_data;
  output  [ 3:0]  dev_dbg_trigger;
  output [297:0]  dev_dbg_data;

  // internal registers

  reg     [31:0]  up_rdata = 'd0;
  reg             up_ack = 'd0;

  // internal clocks and resets

  wire            up_clk;
  wire            up_rstn;
  wire            dma_clk;
  wire            vdma_clk;
  wire            delay_rst;

  // internal signals

  wire            adc_valid_s;
  wire    [11:0]  adc_data_i1_s;
  wire    [11:0]  adc_data_q1_s;
  wire    [11:0]  adc_data_i2_s;
  wire    [11:0]  adc_data_q2_s;
  wire            adc_status_s;
  wire            adc_r1_mode_s;
  wire            dac_valid_s;
  wire    [11:0]  dac_data_i1_s;
  wire    [11:0]  dac_data_q1_s;
  wire    [11:0]  dac_data_i2_s;
  wire    [11:0]  dac_data_q2_s;
  wire            dac_r1_mode_s;
  wire            delay_sel_s;
  wire            delay_rwn_s;
  wire    [ 7:0]  delay_addr_s;
  wire    [ 4:0]  delay_wdata_s;
  wire    [ 4:0]  delay_rdata_s;
  wire            delay_ack_t_s;
  wire            delay_locked_s;
  wire            dma_valid_s;
  wire            dma_last_s;
  wire    [63:0]  dma_data_s;
  wire            dma_ready_s;
  wire            vdma_fs_s;
  wire            vdma_valid_s;
  wire    [63:0]  vdma_data_s;
  wire            vdma_ready_s;
  wire            up_sel_s;
  wire            up_wr_s;
  wire    [13:0]  up_addr_s;
  wire    [31:0]  up_wdata_s;
  wire    [31:0]  up_rdata_rx_s;
  wire            up_ack_rx_s;
  wire    [31:0]  up_rdata_tx_s;
  wire            up_ack_tx_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  assign dma_clk = s_axis_s2mm_clk;
  assign dma_ready_s = s_axis_s2mm_tready;
  assign s_axis_s2mm_tvalid = dma_valid_s;
  assign s_axis_s2mm_tdata  = dma_data_s;
  assign s_axis_s2mm_tlast = dma_last_s;
  assign s_axis_s2mm_tkeep = 8'hff;

  assign vdma_clk = m_axis_mm2s_clk;
  assign vdma_valid_s = m_axis_mm2s_tvalid;
  assign vdma_data_s = m_axis_mm2s_tdata;
  assign m_axis_mm2s_fsync = vdma_fs_s;
  assign m_axis_mm2s_tready = vdma_ready_s; 

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_ack <= 'd0;
    end else begin
      up_rdata <= up_rdata_rx_s | up_rdata_tx_s;
      up_ack <= up_ack_rx_s | up_ack_tx_s;
    end
  end

  // device interface

  axi_ad9361_dev_if i_dev_if (
    .rx_clk_in_p (rx_clk_in_p),
    .rx_clk_in_n (rx_clk_in_n),
    .rx_frame_in_p (rx_frame_in_p),
    .rx_frame_in_n (rx_frame_in_n),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .tx_clk_out_p (tx_clk_out_p),
    .tx_clk_out_n (tx_clk_out_n),
    .tx_frame_out_p (tx_frame_out_p),
    .tx_frame_out_n (tx_frame_out_n),
    .tx_data_out_p (tx_data_out_p),
    .tx_data_out_n (tx_data_out_n),
    .enable (enable),
    .txnrx (txnrx),
    .clk (clk),
    .adc_valid (adc_valid_s),
    .adc_data_i1 (adc_data_i1_s),
    .adc_data_q1 (adc_data_q1_s),
    .adc_data_i2 (adc_data_i2_s),
    .adc_data_q2 (adc_data_q2_s),
    .adc_status (adc_status_s),
    .adc_r1_mode (adc_r1_mode_s),
    .dac_valid (dac_valid_s),
    .dac_data_i1 (dac_data_i1_s),
    .dac_data_q1 (dac_data_q1_s),
    .dac_data_i2 (dac_data_i2_s),
    .dac_data_q2 (dac_data_q2_s),
    .dac_r1_mode (dac_r1_mode_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_sel (delay_sel_s),
    .delay_rwn (delay_rwn_s),
    .delay_addr (delay_addr_s),
    .delay_wdata (delay_wdata_s),
    .delay_rdata (delay_rdata_s),
    .delay_ack_t (delay_ack_t_s),
    .delay_locked (delay_locked_s),
    .dev_dbg_trigger (dev_dbg_trigger),
    .dev_dbg_data (dev_dbg_data));

  // receive

  axi_ad9361_rx i_rx (
    .adc_clk (clk),
    .adc_valid (adc_valid_s),
    .adc_data_i1 (adc_data_i1_s),
    .adc_data_q1 (adc_data_q1_s),
    .adc_data_i2 (adc_data_i2_s),
    .adc_data_q2 (adc_data_q2_s),
    .adc_status (adc_status_s),
    .adc_r1_mode (adc_r1_mode_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_sel (delay_sel_s),
    .delay_rwn (delay_rwn_s),
    .delay_addr (delay_addr_s),
    .delay_wdata (delay_wdata_s),
    .delay_rdata (delay_rdata_s),
    .delay_ack_t (delay_ack_t_s),
    .delay_locked (delay_locked_s),
    .dma_clk (dma_clk),
    .dma_valid (dma_valid_s),
    .dma_last (dma_last_s),
    .dma_data (dma_data_s),
    .dma_ready (dma_ready_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_rx_s),
    .up_ack (up_ack_rx_s),
    .adc_mon_valid (adc_mon_valid),
    .adc_mon_data (adc_mon_data));

  // transmit

  axi_ad9361_tx i_tx (
    .dac_clk (clk),
    .dac_valid (dac_valid_s),
    .dac_data_i1 (dac_data_i1_s),
    .dac_data_q1 (dac_data_q1_s),
    .dac_data_i2 (dac_data_i2_s),
    .dac_data_q2 (dac_data_q2_s),
    .dac_r1_mode (dac_r1_mode_s),
    .vdma_clk (vdma_clk),
    .vdma_fs (vdma_fs_s),
    .vdma_valid (vdma_valid_s),
    .vdma_data (vdma_data_s),
    .vdma_ready (vdma_ready_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_tx_s),
    .up_ack (up_ack_tx_s));

  // axi interface

  up_axi #(
    .PCORE_BASEADDR (C_BASEADDR),
    .PCORE_HIGHADDR (C_HIGHADDR))
  i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata),
    .up_ack (up_ack));

endmodule

// ***************************************************************************
// ***************************************************************************
