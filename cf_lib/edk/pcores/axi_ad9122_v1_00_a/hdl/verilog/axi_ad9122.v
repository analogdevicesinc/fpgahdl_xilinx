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

module axi_ad9122 (

  // dac interface

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_frame_out_p,
  dac_frame_out_n,
  dac_data_out_p,
  dac_data_out_n,

  // master/slave

  dac_enable_out,
  dac_enable_in,

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

  dac_div_clk,
  dac_dbg_trigger,
  dac_dbg_data);

  // parameters

  parameter   PCORE_ID = 0;
  parameter   PCORE_DEVICE_TYPE = 0;
  parameter   PCORE_SERDES_DDR_N = 1;
  parameter   PCORE_MMCM_BUFIO_N = 1;
  parameter   PCORE_IODELAY_GROUP = "dev_if_delay_group";
  parameter   C_S_AXI_MIN_SIZE = 32'hffff;
  parameter   C_BASEADDR = 32'hffffffff;
  parameter   C_HIGHADDR = 32'h00000000;

  // dac interface

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output          dac_frame_out_p;
  output          dac_frame_out_n;
  output  [15:0]  dac_data_out_p;
  output  [15:0]  dac_data_out_n;

  // master/slave

  output          dac_enable_out;
  input           dac_enable_in;

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

  output          dac_div_clk;
  output  [ 7:0]  dac_dbg_trigger;
  output [135:0]  dac_dbg_data;

  // internal clocks and resets

  wire            dac_rst;
  wire            mmcm_rst;
  wire            drp_rst;
  wire            up_clk;
  wire            up_rstn;
  wire            vdma_clk;

  // internal signals

  wire            dac_frame_i0_s;
  wire    [15:0]  dac_data_i0_s;
  wire            dac_frame_i1_s;
  wire    [15:0]  dac_data_i1_s;
  wire            dac_frame_i2_s;
  wire    [15:0]  dac_data_i2_s;
  wire            dac_frame_i3_s;
  wire    [15:0]  dac_data_i3_s;
  wire            dac_frame_q0_s;
  wire    [15:0]  dac_data_q0_s;
  wire            dac_frame_q1_s;
  wire    [15:0]  dac_data_q1_s;
  wire            dac_frame_q2_s;
  wire    [15:0]  dac_data_q2_s;
  wire            dac_frame_q3_s;
  wire    [15:0]  dac_data_q3_s;
  wire            dac_status_s;
  wire            drp_sel_s;
  wire            drp_wr_s;
  wire    [11:0]  drp_addr_s;
  wire    [15:0]  drp_wdata_s;
  wire    [15:0]  drp_rdata_s;
  wire            drp_ack_t_s;
  wire            vdma_fs_s;
  wire            vdma_valid_s;
  wire    [63:0]  vdma_data_s;
  wire            vdma_ready_s;
  wire            up_sel_s;
  wire            up_wr_s;
  wire    [13:0]  up_addr_s;
  wire    [31:0]  up_wdata_s;
  wire    [31:0]  up_rdata_s;
  wire            up_ack_s;

  // debug signals

  assign dac_dbg_trigger[0] = dac_frame_i0_s;
  assign dac_dbg_trigger[1] = dac_frame_i1_s;
  assign dac_dbg_trigger[2] = dac_frame_i2_s;
  assign dac_dbg_trigger[3] = dac_frame_i3_s;
  assign dac_dbg_trigger[4] = dac_frame_q0_s;
  assign dac_dbg_trigger[5] = dac_frame_q1_s;
  assign dac_dbg_trigger[6] = dac_frame_q2_s;
  assign dac_dbg_trigger[7] = dac_frame_q3_s;

  assign dac_dbg_data[ 15:  0] = dac_data_i0_s;
  assign dac_dbg_data[ 31: 16] = dac_data_i1_s;
  assign dac_dbg_data[ 47: 32] = dac_data_i2_s;
  assign dac_dbg_data[ 63: 48] = dac_data_i3_s;
  assign dac_dbg_data[ 79: 64] = dac_data_q0_s;
  assign dac_dbg_data[ 95: 80] = dac_data_q1_s;
  assign dac_dbg_data[111: 96] = dac_data_q2_s;
  assign dac_dbg_data[127:112] = dac_data_q3_s;
  assign dac_dbg_data[128:128] = dac_frame_i0_s;
  assign dac_dbg_data[129:129] = dac_frame_i1_s;
  assign dac_dbg_data[130:130] = dac_frame_i2_s;
  assign dac_dbg_data[131:131] = dac_frame_i3_s;
  assign dac_dbg_data[132:132] = dac_frame_q0_s;
  assign dac_dbg_data[133:133] = dac_frame_q1_s;
  assign dac_dbg_data[134:134] = dac_frame_q2_s;
  assign dac_dbg_data[135:135] = dac_frame_q3_s;

  // signal name changes

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign vdma_clk = m_axis_mm2s_clk;
  assign vdma_valid_s = m_axis_mm2s_tvalid;
  assign vdma_data_s = m_axis_mm2s_tdata;
  assign m_axis_mm2s_fsync = vdma_fs_s;
  assign m_axis_mm2s_tready = vdma_ready_s; 

  // device interface

  axi_ad9122_if #(
    .PCORE_DEVICE_TYPE (PCORE_DEVICE_TYPE),
    .PCORE_SERDES_DDR_N (PCORE_SERDES_DDR_N),
    .PCORE_MMCM_BUFIO_N (PCORE_MMCM_BUFIO_N))
  i_if (
    .dac_clk_in_p (dac_clk_in_p),
    .dac_clk_in_n (dac_clk_in_n),
    .dac_clk_out_p (dac_clk_out_p),
    .dac_clk_out_n (dac_clk_out_n),
    .dac_frame_out_p (dac_frame_out_p),
    .dac_frame_out_n (dac_frame_out_n),
    .dac_data_out_p (dac_data_out_p),
    .dac_data_out_n (dac_data_out_n),
    .dac_rst (dac_rst),
    .dac_clk (),
    .dac_div_clk (dac_div_clk),
    .dac_status (dac_status_s),
    .dac_frame_i0 (dac_frame_i0_s),
    .dac_data_i0 (dac_data_i0_s),
    .dac_frame_i1 (dac_frame_i1_s),
    .dac_data_i1 (dac_data_i1_s),
    .dac_frame_i2 (dac_frame_i2_s),
    .dac_data_i2 (dac_data_i2_s),
    .dac_frame_i3 (dac_frame_i3_s),
    .dac_data_i3 (dac_data_i3_s),
    .dac_frame_q0 (dac_frame_q0_s),
    .dac_data_q0 (dac_data_q0_s),
    .dac_frame_q1 (dac_frame_q1_s),
    .dac_data_q1 (dac_data_q1_s),
    .dac_frame_q2 (dac_frame_q2_s),
    .dac_data_q2 (dac_data_q2_s),
    .dac_frame_q3 (dac_frame_q3_s),
    .dac_data_q3 (dac_data_q3_s),
    .mmcm_rst (mmcm_rst),
    .drp_clk (up_clk),
    .drp_rst (drp_rst),
    .drp_sel (drp_sel_s),
    .drp_wr (drp_wr_s),
    .drp_addr (drp_addr_s),
    .drp_wdata (drp_wdata_s),
    .drp_rdata (drp_rdata_s),
    .drp_ack_t (drp_ack_t_s));

  // core

  axi_ad9122_core #(.PCORE_ID(PCORE_ID)) i_core (
    .dac_div_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_frame_i0 (dac_frame_i0_s),
    .dac_data_i0 (dac_data_i0_s),
    .dac_frame_i1 (dac_frame_i1_s),
    .dac_data_i1 (dac_data_i1_s),
    .dac_frame_i2 (dac_frame_i2_s),
    .dac_data_i2 (dac_data_i2_s),
    .dac_frame_i3 (dac_frame_i3_s),
    .dac_data_i3 (dac_data_i3_s),
    .dac_frame_q0 (dac_frame_q0_s),
    .dac_data_q0 (dac_data_q0_s),
    .dac_frame_q1 (dac_frame_q1_s),
    .dac_data_q1 (dac_data_q1_s),
    .dac_frame_q2 (dac_frame_q2_s),
    .dac_data_q2 (dac_data_q2_s),
    .dac_frame_q3 (dac_frame_q3_s),
    .dac_data_q3 (dac_data_q3_s),
    .dac_status (dac_status_s),
    .dac_enable_out (dac_enable_out),
    .dac_enable_in (dac_enable_in),
    .vdma_clk (vdma_clk),
    .vdma_fs (vdma_fs_s),
    .vdma_valid (vdma_valid_s),
    .vdma_data (vdma_data_s),
    .vdma_ready (vdma_ready_s),
    .mmcm_rst (mmcm_rst),
    .drp_rst (drp_rst),
    .drp_sel (drp_sel_s),
    .drp_wr (drp_wr_s),
    .drp_addr (drp_addr_s),
    .drp_wdata (drp_wdata_s),
    .drp_rdata (drp_rdata_s),
    .drp_ack_t (drp_ack_t_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_s),
    .up_ack (up_ack_s));

  // up bus interface

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
    .up_rdata (up_rdata_s),
    .up_ack (up_ack_s));

endmodule

// ***************************************************************************
// ***************************************************************************
