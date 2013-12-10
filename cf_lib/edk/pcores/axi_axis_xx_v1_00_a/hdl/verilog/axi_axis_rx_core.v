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
// ADC channel-need to work on dual mode for pn sequence

`timescale 1ns/100ps

module axi_axis_rx_core (

  // adc interface

  adc_clk,
  adc_valid,
  adc_data,

  // dma interface

  dma_clk,
  dma_valid,
  dma_last,
  dma_data,
  dma_ready,

  // processor interface

  up_rstn,
  up_clk,
  up_sel,
  up_wr,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack);

  // parameters

  parameter       DATA_WIDTH = 64;
  localparam      DW = DATA_WIDTH - 1;

  // adc interface

  input           adc_clk;
  input           adc_valid;
  input   [DW:0]  adc_data;

  // dma interface

  input           dma_clk;
  output          dma_valid;
  output          dma_last;
  output  [DW:0]  dma_data;
  input           dma_ready;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_wr;
  input   [13:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // internal clocks and resets

  wire            adc_rst;
  wire            dma_rst;

  // internal signals

  wire            dma_ovf_s;
  wire            dma_unf_s;
  wire            dma_status_s;
  wire    [31:0]  dma_bw_s;
  wire            dma_start_s;
  wire            dma_stream_s;
  wire    [31:0]  dma_count_s;

  // dma interface

  ad_axis_dma_rx #(.DATA_WIDTH(DATA_WIDTH)) i_axis_dma_rx (
    .dma_clk (dma_clk),
    .dma_rst (dma_rst),
    .dma_valid (dma_valid),
    .dma_last (dma_last),
    .dma_data (dma_data),
    .dma_ready (dma_ready),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
    .dma_status (dma_status_s),
    .dma_bw (dma_bw_s),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data),
    .dma_start (dma_start_s),
    .dma_stream (dma_stream_s),
    .dma_count (dma_count_s));

  // processor control

  up_axis_dma_rx i_up_axis_dma_rx (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .dma_clk (dma_clk),
    .dma_rst (dma_rst),
    .dma_start (dma_start_s),
    .dma_stream (dma_stream_s),
    .dma_count (dma_count_s),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
    .dma_status (dma_status_s),
    .dma_bw (dma_bw_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata),
    .up_ack (up_ack));

endmodule

// ***************************************************************************
// ***************************************************************************

