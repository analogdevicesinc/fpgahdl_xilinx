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

module cf_dds_top (

  vdma_clk,
  vdma_valid,
  vdma_data,
  vdma_ready,
  vdma_ovf,
  vdma_unf,

  dac_div3_clk,
  dds_master_enable,
  dds_master_frame,
  dds_frame_0,
  dds_data_00,
  dds_data_01,
  dds_data_02,
  dds_frame_1,
  dds_data_10,
  dds_data_11,
  dds_data_12,

  up_dds_psel,
  up_dds_sel,
  up_dds_init_1a,
  up_dds_incr_1a,
  up_dds_scale_1a,
  up_dds_init_1b,
  up_dds_incr_1b,
  up_dds_scale_1b,
  up_dds_init_2a,
  up_dds_incr_2a,
  up_dds_scale_2a,
  up_dds_init_2b,
  up_dds_incr_2b,
  up_dds_scale_2b,
  up_dds_data_1a,
  up_dds_data_1b,
  up_dds_data_2a,
  up_dds_data_2b,
  up_intp_enable,
  up_intp_scale_a,
  up_intp_scale_b,

  vdma_dbg_data,
  vdma_dbg_trigger,

  dac_dbg_data,
  dac_dbg_trigger);

  input           vdma_clk;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;
  output          vdma_ovf;
  output          vdma_unf;

  input           dac_div3_clk;
  input           dds_master_enable;
  input           dds_master_frame;
  output  [ 2:0]  dds_frame_0;
  output  [15:0]  dds_data_00;
  output  [15:0]  dds_data_01;
  output  [15:0]  dds_data_02;
  output  [ 2:0]  dds_frame_1;
  output  [15:0]  dds_data_10;
  output  [15:0]  dds_data_11;
  output  [15:0]  dds_data_12;

  input           up_dds_psel;
  input           up_dds_sel;
  input   [15:0]  up_dds_init_1a;
  input   [15:0]  up_dds_incr_1a;
  input   [ 3:0]  up_dds_scale_1a;
  input   [15:0]  up_dds_init_1b;
  input   [15:0]  up_dds_incr_1b;
  input   [ 3:0]  up_dds_scale_1b;
  input   [15:0]  up_dds_init_2a;
  input   [15:0]  up_dds_incr_2a;
  input   [ 3:0]  up_dds_scale_2a;
  input   [15:0]  up_dds_init_2b;
  input   [15:0]  up_dds_incr_2b;
  input   [ 3:0]  up_dds_scale_2b;
  input   [15:0]  up_dds_data_1a;
  input   [15:0]  up_dds_data_1b;
  input   [15:0]  up_dds_data_2a;
  input   [15:0]  up_dds_data_2b;
  input           up_intp_enable;
  input   [15:0]  up_intp_scale_a;
  input   [15:0]  up_intp_scale_b;

  output  [198:0] vdma_dbg_data;
  output  [ 7:0]  vdma_dbg_trigger;

  output  [195:0] dac_dbg_data;
  output  [ 7:0]  dac_dbg_trigger;

  reg     [ 1:0]  dds_sel_m1 = 'd0;
  reg     [ 1:0]  dds_sel = 'd0;
  reg             dds_master_frame_d = 'd0;
  reg             dds_enable_m1 = 'd0;
  reg             dds_enable_m2 = 'd0;
  reg             dds_enable_m3 = 'd0;
  reg             dds_enable_m4 = 'd0;
  reg     [15:0]  ddsp_data_1a = 'd0;
  reg     [15:0]  ddsp_data_1b = 'd0;
  reg     [15:0]  ddsp_data_2a = 'd0;
  reg     [15:0]  ddsp_data_2b = 'd0;
  reg             dds_enable = 'd0;
  reg             ddsp_sel = 'd0;
  reg     [ 2:0]  ddsp_frame_0 = 'd0;
  reg     [15:0]  ddsp_data_00 = 'd0;
  reg     [15:0]  ddsp_data_01 = 'd0;
  reg     [15:0]  ddsp_data_02 = 'd0;
  reg     [ 2:0]  ddsp_frame_1 = 'd0;
  reg     [15:0]  ddsp_data_10 = 'd0;
  reg     [15:0]  ddsp_data_11 = 'd0;
  reg     [15:0]  ddsp_data_12 = 'd0;
  reg     [ 2:0]  dds_frame_0 = 'd0;
  reg     [15:0]  dds_data_00 = 'd0;
  reg     [15:0]  dds_data_01 = 'd0;
  reg     [15:0]  dds_data_02 = 'd0;
  reg     [ 2:0]  dds_frame_1 = 'd0;
  reg     [15:0]  dds_data_10 = 'd0;
  reg     [15:0]  dds_data_11 = 'd0;
  reg     [15:0]  dds_data_12 = 'd0;

  wire            dds_master_frame_s;
  wire    [15:0]  ddsx_data_00_s;
  wire    [15:0]  ddsx_data_01_s;
  wire    [15:0]  ddsx_data_02_s;
  wire    [15:0]  ddsx_data_10_s;
  wire    [15:0]  ddsx_data_11_s;
  wire    [15:0]  ddsx_data_12_s;
  wire    [15:0]  ddsv_data_00_s;
  wire    [15:0]  ddsv_data_01_s;
  wire    [15:0]  ddsv_data_02_s;
  wire    [15:0]  ddsv_data_10_s;
  wire    [15:0]  ddsv_data_11_s;
  wire    [15:0]  ddsv_data_12_s;

  assign dds_master_frame_s = dds_master_frame & ~dds_master_frame_d;

  always @(posedge dac_div3_clk) begin
    dds_sel_m1 <= {up_dds_psel, up_dds_sel};
    dds_sel <= dds_sel_m1;
    dds_master_frame_d <= dds_master_frame;
    dds_enable_m1 <= dds_master_enable;
    dds_enable_m2 <= dds_enable_m1;
    dds_enable_m3 <= dds_enable_m2;
    dds_enable_m4 <= dds_enable_m3;
    if ((dds_enable_m2 == 1'b1) && (dds_enable_m3 == 1'b0)) begin
      ddsp_data_1a <= up_dds_data_1a;
      ddsp_data_1b <= up_dds_data_1b;
      ddsp_data_2a <= up_dds_data_2a;
      ddsp_data_2b <= up_dds_data_2b;
    end
  end

  always @(posedge dac_div3_clk) begin
    dds_enable <= dds_enable_m4;
    ddsp_sel <= ~ddsp_sel;
    if (dds_enable == 1'b0) begin
      ddsp_frame_0 <= 3'd0;
      ddsp_data_00 <= 16'd0;
      ddsp_data_01 <= 16'd0;
      ddsp_data_02 <= 16'd0;
      ddsp_frame_1 <= 3'd0;
      ddsp_data_10 <= 16'd0;
      ddsp_data_11 <= 16'd0;
      ddsp_data_12 <= 16'd0;
    end else if (ddsp_sel == 1'b0) begin
      ddsp_frame_0 <= 3'b101;
      ddsp_data_00 <= ddsp_data_1a;
      ddsp_data_01 <= ddsp_data_1b;
      ddsp_data_02 <= ddsp_data_1a;
      ddsp_frame_1 <= 3'b101;
      ddsp_data_10 <= ddsp_data_2a;
      ddsp_data_11 <= ddsp_data_2b;
      ddsp_data_12 <= ddsp_data_2a;
    end else begin
      ddsp_frame_0 <= 3'b010;
      ddsp_data_00 <= ddsp_data_1b;
      ddsp_data_01 <= ddsp_data_1a;
      ddsp_data_02 <= ddsp_data_1b;
      ddsp_frame_1 <= 3'b010;
      ddsp_data_10 <= ddsp_data_2b;
      ddsp_data_11 <= ddsp_data_2a;
      ddsp_data_12 <= ddsp_data_2b;
    end
  end

  always @(posedge dac_div3_clk) begin
    case (dds_sel)
      2'b10: begin
        dds_frame_0 <= ddsp_frame_0;
        dds_data_00 <= ddsp_data_00;
        dds_data_01 <= ddsp_data_01;
        dds_data_02 <= ddsp_data_02;
        dds_frame_1 <= ddsp_frame_1;
        dds_data_10 <= ddsp_data_10;
        dds_data_11 <= ddsp_data_11;
        dds_data_12 <= ddsp_data_12;
      end
      2'b01: begin
        dds_frame_0 <= {2'd0, dds_master_frame_s};
        dds_data_00 <= ddsv_data_00_s;
        dds_data_01 <= ddsv_data_01_s;
        dds_data_02 <= ddsv_data_02_s;
        dds_frame_1 <= {2'd0, dds_master_frame_s};
        dds_data_10 <= ddsv_data_10_s;
        dds_data_11 <= ddsv_data_11_s;
        dds_data_12 <= ddsv_data_12_s;
      end
      default: begin
        dds_frame_0 <= {2'd0, dds_master_frame_s};
        dds_data_00 <= ddsx_data_00_s;
        dds_data_01 <= ddsx_data_01_s;
        dds_data_02 <= ddsx_data_02_s;
        dds_frame_1 <= {2'd0, dds_master_frame_s};
        dds_data_10 <= ddsx_data_10_s;
        dds_data_11 <= ddsx_data_11_s;
        dds_data_12 <= ddsx_data_12_s;
      end
    endcase
  end

  cf_ddsx i_ddsx (
    .dac_div3_clk (dac_div3_clk),
    .dds_master_enable (dds_master_enable),
    .dds_data_00 (ddsx_data_00_s),
    .dds_data_01 (ddsx_data_01_s),
    .dds_data_02 (ddsx_data_02_s),
    .dds_data_10 (ddsx_data_10_s),
    .dds_data_11 (ddsx_data_11_s),
    .dds_data_12 (ddsx_data_12_s),
    .up_dds_init_1a (up_dds_init_1a),
    .up_dds_incr_1a (up_dds_incr_1a),
    .up_dds_scale_1a (up_dds_scale_1a),
    .up_dds_init_1b (up_dds_init_1b),
    .up_dds_incr_1b (up_dds_incr_1b),
    .up_dds_scale_1b (up_dds_scale_1b),
    .up_dds_init_2a (up_dds_init_2a),
    .up_dds_incr_2a (up_dds_incr_2a),
    .up_dds_scale_2a (up_dds_scale_2a),
    .up_dds_init_2b (up_dds_init_2b),
    .up_dds_incr_2b (up_dds_incr_2b),
    .up_dds_scale_2b (up_dds_scale_2b),
    .debug_data (),
    .debug_trigger ());

  cf_ddsv i_ddsv (
    .vdma_clk (vdma_clk),
    .vdma_valid (vdma_valid),
    .vdma_data (vdma_data),
    .vdma_ready (vdma_ready),
    .vdma_ovf (vdma_ovf),
    .vdma_unf (vdma_unf),
    .dac_div3_clk (dac_div3_clk),
    .dds_master_enable (dds_master_enable),
    .dds_data_00 (ddsv_data_00_s),
    .dds_data_01 (ddsv_data_01_s),
    .dds_data_02 (ddsv_data_02_s),
    .dds_data_10 (ddsv_data_10_s),
    .dds_data_11 (ddsv_data_11_s),
    .dds_data_12 (ddsv_data_12_s),
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

