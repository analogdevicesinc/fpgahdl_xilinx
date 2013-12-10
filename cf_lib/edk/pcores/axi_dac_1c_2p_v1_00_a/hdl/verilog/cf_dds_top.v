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
// The DDS top includes samples generations for SED (see DAC data sheet if supported),
// DDR based DDS (through VDMA) and/or Xilinx's DDS.

`timescale 1ns/100ps

module cf_dds_top (

  // VDMA interface and status signals

  vdma_clk,
  vdma_valid,
  vdma_data,
  vdma_ready,
  vdma_ovf,
  vdma_unf,

  // DAC interface (to the physical interface)

  dac_div3_clk,
  dds_data_00,
  dds_data_01,
  dds_data_02,
  dds_data_03,
  dds_data_04,
  dds_data_05,
  dds_data_06,
  dds_data_07,
  dds_data_08,
  dds_data_09,
  dds_data_10,
  dds_data_11,

  // processor signals

  up_dds_sel,           // dds select
  up_dds_incr,          // phase increment (ddsx only)
  up_dds_enable,        // dds enable
  up_intp_enable,       // interpolate (ddr only)
  up_intp_scale_a,      // interpolation scale
  up_intp_scale_b,      // interpolation scale

  // debug signals (for chipscope)

  vdma_dbg_data,
  vdma_dbg_trigger,

  // debug signals (for chipscope)

  dac_dbg_data,
  dac_dbg_trigger);

  // VDMA interface and status signals

  input           vdma_clk;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;
  output          vdma_ovf;
  output          vdma_unf;

  // DAC interface (to the physical interface)

  input           dac_div3_clk;
  output  [13:0]  dds_data_00;
  output  [13:0]  dds_data_01;
  output  [13:0]  dds_data_02;
  output  [13:0]  dds_data_03;
  output  [13:0]  dds_data_04;
  output  [13:0]  dds_data_05;
  output  [13:0]  dds_data_06;
  output  [13:0]  dds_data_07;
  output  [13:0]  dds_data_08;
  output  [13:0]  dds_data_09;
  output  [13:0]  dds_data_10;
  output  [13:0]  dds_data_11;

  // processor signals

  input           up_dds_sel;           // dds select
  input   [15:0]  up_dds_incr;          // phase increment (ddsx only)
  input           up_dds_enable;        // dds enable
  input           up_intp_enable;       // interpolate (ddr only)
  input   [15:0]  up_intp_scale_a;      // interpolation scale
  input   [15:0]  up_intp_scale_b;      // interpolation scale

  // debug signals (for chipscope)

  output  [198:0] vdma_dbg_data;
  output  [ 7:0]  vdma_dbg_trigger;

  // debug signals (for chipscope)

  output  [292:0] dac_dbg_data;
  output  [ 7:0]  dac_dbg_trigger;

  reg             dds_sel_m1 = 'd0;
  reg             dds_sel = 'd0;
  reg             dds_enable_m1 = 'd0;
  reg             dds_enable_m2 = 'd0;
  reg             ddsv_enable = 'd0;
  reg     [13:0]  dds_data_00 = 'd0;
  reg     [13:0]  dds_data_01 = 'd0;
  reg     [13:0]  dds_data_02 = 'd0;
  reg     [13:0]  dds_data_03 = 'd0;
  reg     [13:0]  dds_data_04 = 'd0;
  reg     [13:0]  dds_data_05 = 'd0;
  reg     [13:0]  dds_data_06 = 'd0;
  reg     [13:0]  dds_data_07 = 'd0;
  reg     [13:0]  dds_data_08 = 'd0;
  reg     [13:0]  dds_data_09 = 'd0;
  reg     [13:0]  dds_data_10 = 'd0;
  reg     [13:0]  dds_data_11 = 'd0;

  wire    [13:0]  ddsx_data_00_s;
  wire    [13:0]  ddsx_data_01_s;
  wire    [13:0]  ddsx_data_02_s;
  wire    [13:0]  ddsx_data_03_s;
  wire    [13:0]  ddsx_data_04_s;
  wire    [13:0]  ddsx_data_05_s;
  wire    [13:0]  ddsx_data_06_s;
  wire    [13:0]  ddsx_data_07_s;
  wire    [13:0]  ddsx_data_08_s;
  wire    [13:0]  ddsx_data_09_s;
  wire    [13:0]  ddsx_data_10_s;
  wire    [13:0]  ddsx_data_11_s;
  wire    [13:0]  ddsv_data_00_s;
  wire    [13:0]  ddsv_data_01_s;
  wire    [13:0]  ddsv_data_02_s;
  wire    [13:0]  ddsv_data_03_s;
  wire    [13:0]  ddsv_data_04_s;
  wire    [13:0]  ddsv_data_05_s;
  wire    [13:0]  ddsv_data_06_s;
  wire    [13:0]  ddsv_data_07_s;
  wire    [13:0]  ddsv_data_08_s;
  wire    [13:0]  ddsv_data_09_s;
  wire    [13:0]  ddsv_data_10_s;
  wire    [13:0]  ddsv_data_11_s;

  // transfer processor signals to the dac clock

  always @(posedge dac_div3_clk) begin
    dds_sel_m1 <= up_dds_sel;
    dds_sel <= dds_sel_m1;
    dds_enable_m1 <= up_dds_enable;
    dds_enable_m2 <= dds_enable_m1;
    ddsv_enable <= dds_sel & dds_enable_m2;
  end

  // dds mux

  always @(posedge dac_div3_clk) begin
    dds_data_00 <= (dds_sel == 1'b1) ? ddsv_data_00_s : ddsx_data_00_s;
    dds_data_01 <= (dds_sel == 1'b1) ? ddsv_data_01_s : ddsx_data_01_s;
    dds_data_02 <= (dds_sel == 1'b1) ? ddsv_data_02_s : ddsx_data_02_s;
    dds_data_03 <= (dds_sel == 1'b1) ? ddsv_data_03_s : ddsx_data_03_s;
    dds_data_04 <= (dds_sel == 1'b1) ? ddsv_data_04_s : ddsx_data_04_s;
    dds_data_05 <= (dds_sel == 1'b1) ? ddsv_data_05_s : ddsx_data_05_s;
    dds_data_06 <= (dds_sel == 1'b1) ? ddsv_data_06_s : ddsx_data_06_s;
    dds_data_07 <= (dds_sel == 1'b1) ? ddsv_data_07_s : ddsx_data_07_s;
    dds_data_08 <= (dds_sel == 1'b1) ? ddsv_data_08_s : ddsx_data_08_s;
    dds_data_09 <= (dds_sel == 1'b1) ? ddsv_data_09_s : ddsx_data_09_s;
    dds_data_10 <= (dds_sel == 1'b1) ? ddsv_data_10_s : ddsx_data_10_s;
    dds_data_11 <= (dds_sel == 1'b1) ? ddsv_data_11_s : ddsx_data_11_s;
  end

  // ddsx (nco)

  cf_ddsx i_ddsx (
    .dac_div3_clk (dac_div3_clk),
    .dds_data_00 (ddsx_data_00_s),
    .dds_data_01 (ddsx_data_01_s),
    .dds_data_02 (ddsx_data_02_s),
    .dds_data_03 (ddsx_data_03_s),
    .dds_data_04 (ddsx_data_04_s),
    .dds_data_05 (ddsx_data_05_s),
    .dds_data_06 (ddsx_data_06_s),
    .dds_data_07 (ddsx_data_07_s),
    .dds_data_08 (ddsx_data_08_s),
    .dds_data_09 (ddsx_data_09_s),
    .dds_data_10 (ddsx_data_10_s),
    .dds_data_11 (ddsx_data_11_s),
    .up_dds_enable (up_dds_enable),
    .up_dds_incr (up_dds_incr));

  // ddsv (vdma, ddr based)

  cf_ddsv i_ddsv (
    .vdma_clk (vdma_clk),
    .vdma_valid (vdma_valid),
    .vdma_data (vdma_data),
    .vdma_ready (vdma_ready),
    .vdma_ovf (vdma_ovf),
    .vdma_unf (vdma_unf),
    .dac_div3_clk (dac_div3_clk),
    .dds_enable (ddsv_enable),
    .dds_data_00 (ddsv_data_00_s),
    .dds_data_01 (ddsv_data_01_s),
    .dds_data_02 (ddsv_data_02_s),
    .dds_data_03 (ddsv_data_03_s),
    .dds_data_04 (ddsv_data_04_s),
    .dds_data_05 (ddsv_data_05_s),
    .dds_data_06 (ddsv_data_06_s),
    .dds_data_07 (ddsv_data_07_s),
    .dds_data_08 (ddsv_data_08_s),
    .dds_data_09 (ddsv_data_09_s),
    .dds_data_10 (ddsv_data_10_s),
    .dds_data_11 (ddsv_data_11_s),
    .up_intp_enable (up_intp_enable),
    .up_intp_scale_a (up_intp_scale_a),
    .up_intp_scale_b (up_intp_scale_b),
    .vdma_dbg_data (vdma_dbg_data),
    .vdma_dbg_trigger (vdma_dbg_trigger),
    .dac_dbg_data (dac_dbg_data),
    .dac_dbg_trigger (dac_dbg_trigger));

endmodule

// ***************************************************************************
// ***************************************************************************

