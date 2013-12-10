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

module axi_axis_tx_core (

  // dac interface

  dac_clk,
  dac_rd,
  dac_valid,
  dac_data,

  // dma interface

  dma_clk,
  dma_fs,
  dma_valid,
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

  // dac interface

  input           dac_clk;
  input           dac_rd;
  output          dac_valid;
  output  [DW:0]  dac_data;

  // dma interface

  input           dma_clk;
  output          dma_fs;
  input           dma_valid;
  input   [63:0]  dma_data;
  output          dma_ready;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_wr;
  input   [13:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // internal clock and resets

  wire            dac_rst;
  wire            dma_rst;

  // internal signals

  wire            dma_ovf_s;
  wire            dma_unf_s;
  wire    [31:0]  dma_frmcnt_s;

  // dma interface

  ad_axis_dma_tx #(.DATA_WIDTH(DATA_WIDTH)) i_axis_dma_tx (
    .dma_clk (dma_clk),
    .dma_rst (dma_rst),
    .dma_fs (dma_fs),
    .dma_valid (dma_valid),
    .dma_data (dma_data),
    .dma_ready (dma_ready),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_rd (dac_rd),
    .dac_valid (dac_valid),
    .dac_data (dac_data),
    .dma_frmcnt (dma_frmcnt_s));

  // processor interface

  up_axis_dma_tx i_up_axis_dma_tx (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dma_clk (dma_clk),
    .dma_rst (dma_rst),
    .dma_frmcnt (dma_frmcnt_s),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
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
