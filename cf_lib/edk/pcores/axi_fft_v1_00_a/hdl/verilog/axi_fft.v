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
// This module computes FFT based on Xilinx's IP core.

`timescale 1ns/100ps

module axi_fft (

  // common clock

  axis_clk,

  // dma read interface

  m_axis_mm2s_tvalid,
  m_axis_mm2s_tdata,
  m_axis_mm2s_tkeep,
  m_axis_mm2s_tlast,
  m_axis_mm2s_tready,

  // dma write interface

  s_axis_s2mm_tvalid,
  s_axis_s2mm_tdata,
  s_axis_s2mm_tkeep,
  s_axis_s2mm_tlast,
  s_axis_s2mm_tready,

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

  // monitor outputs for chipscope

  fft_mon_sync,
  fft_mon_data);

  // FFT size select (maximum is 64k)

  parameter   PCORE_ID = 0;
  parameter   PCORE_DEVICE_TYPE = 0;
  parameter   PCORE_FFT_SEL = 0;
  parameter   PCORE_FFT_MON_ADDR_WIDTH = 10;
  parameter   C_S_AXI_MIN_SIZE = 32'hffff;
  parameter   C_BASEADDR = 32'hffffffff;
  parameter   C_HIGHADDR = 32'h00000000;

  // common clock

  input           axis_clk;

  // dma read interface

  input           m_axis_mm2s_tvalid;
  input   [15:0]  m_axis_mm2s_tdata;
  input   [ 1:0]  m_axis_mm2s_tkeep;
  input           m_axis_mm2s_tlast;
  output          m_axis_mm2s_tready;

  // dma write interface

  output          s_axis_s2mm_tvalid;
  output  [63:0]  s_axis_s2mm_tdata;
  output  [ 7:0]  s_axis_s2mm_tkeep;
  output          s_axis_s2mm_tlast;
  input           s_axis_s2mm_tready;

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

  // monitor outputs for chipscope

  output          fft_mon_sync;
  output  [63:0]  fft_mon_data;

  // clocks & resets

  wire            up_rstn;
  wire            up_clk;
  wire            clk;

  // internal signals

  wire            adc_valid_s;
  wire  [15:0]    adc_data_s;
  wire            adc_last_s;
  wire            adc_ready_s;
  wire            fft_valid_s;
  wire    [63:0]  fft_data_s;
  wire            fft_last_s;
  wire            fft_ready_s;
  wire            win_valid_s;
  wire    [15:0]  win_data_s;
  wire            win_last_s;
  wire            win_ready_s;
  wire    [15:0]  win_incr_s;
  wire            win_enable_s;
  wire            fft_mag_valid_s;
  wire    [31:0]  fft_mag_data_s;
  wire            fft_mag_last_s;
  wire    [19:0]  fft_status_s;
  wire            cfg_valid_s;
  wire    [31:0]  cfg_data_s;
  wire            up_sel_s;
  wire            up_wr_s;
  wire    [13:0]  up_addr_s;
  wire    [31:0]  up_wdata_s;
  wire    [31:0]  up_rdata_s;
  wire            up_ack_s;

  // signal name changes

  assign up_rstn = s_axi_aresetn;
  assign up_clk = s_axi_aclk;
  assign clk = axis_clk;

  assign adc_valid_s = m_axis_mm2s_tvalid;
  assign adc_data_s = m_axis_mm2s_tdata;
  assign adc_last_s = m_axis_mm2s_tlast;
  assign m_axis_mm2s_tready = adc_ready_s;
  assign s_axis_s2mm_tvalid = fft_valid_s;
  assign s_axis_s2mm_tdata = fft_data_s;
  assign s_axis_s2mm_tkeep = 8'hff;
  assign s_axis_s2mm_tlast = fft_last_s;
  assign fft_ready_s = s_axis_s2mm_tready;

  // windowing

  axi_fft_win i_fft_win (
    .clk (clk),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_last (adc_last_s),
    .adc_ready (adc_ready_s),
    .win_valid (win_valid_s),
    .win_data (win_data_s),
    .win_last (win_last_s),
    .win_ready (win_ready_s),
    .win_incr (win_incr_s),
    .win_enable (win_enable_s));

  // floating point fft

  axi_fft_core #(.PCORE_FFT_SEL(PCORE_FFT_SEL)) i_fft_core (
    .clk (clk),
    .win_valid (win_valid_s),
    .win_data (win_data_s),
    .win_last (win_last_s),
    .win_ready (win_ready_s),
    .fft_valid (fft_valid_s),
    .fft_data (fft_data_s),
    .fft_last (fft_last_s),
    .fft_ready (fft_ready_s),
    .fft_mag_valid (fft_mag_valid_s),
    .fft_mag_data (fft_mag_data_s),
    .fft_mag_last (fft_mag_last_s),
    .fft_status (fft_status_s),
    .cfg_valid (cfg_valid_s),
    .cfg_data (cfg_data_s));

  // fft monitor

  axi_fft_mon #(.PCORE_FFT_MON_ADDR_WIDTH(PCORE_FFT_MON_ADDR_WIDTH)) i_fft_mon (
    .clk (clk),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_last (adc_last_s),
    .adc_ready (adc_ready_s),
    .win_valid (win_valid_s),
    .win_data (win_data_s),
    .win_last (win_last_s),
    .win_ready (win_ready_s),
    .fft_mag_valid (fft_mag_valid_s),
    .fft_mag_data (fft_mag_data_s),
    .fft_mag_last (fft_mag_last_s),
    .fft_mon_sync (fft_mon_sync),
    .fft_mon_data (fft_mon_data));

  // up fft

  up_fft i_up_fft (
    .clk (clk),
    .rst (),
    .cfg_valid (cfg_valid_s),
    .cfg_data (cfg_data_s),
    .win_enable (win_enable_s),
    .win_incr (win_incr_s),
    .fft_status (fft_status_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_s),
    .up_ack (up_ack_s));

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
    .up_rdata (up_rdata_s),
    .up_ack (up_ack_s));

endmodule

// ***************************************************************************
// ***************************************************************************
