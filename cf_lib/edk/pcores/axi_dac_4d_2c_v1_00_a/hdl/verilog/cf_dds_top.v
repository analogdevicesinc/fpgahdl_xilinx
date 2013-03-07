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
  vdma_fs,
  vdma_valid,
  vdma_data,
  vdma_ready,
  vdma_ovf,
  vdma_unf,

  // DAC interface (to the physical interface)

  dac_div3_clk,
  dds_master_enable,
  dds_master_frame,

  // I frame/data (sample 0 is transmitted first)

  dds_frame_0,
  dds_data_00,
  dds_data_01,
  dds_data_02,

  // Q frame/data (sample 0 is transmitted first)

  dds_frame_1,
  dds_data_10,
  dds_data_11,
  dds_data_12,

  // processor signals

  up_dds_format,      // DDS format 2's compl (0x1) or offset binary (0x0)
  up_dds_psel,        // Pattern (SED) select
  up_dds_sel,         // DDS select, DDR (0x1) or DMA (0x0)
  up_dds_init_1a,     // Initial phase value (for DDSX only)
  up_dds_incr_1a,     // Increment phase value (for DDSX only)
  up_dds_scale_1a,    // Samples scale value (for DDSX only)
  up_dds_init_1b,     // Initial phase value (for DDSX only)
  up_dds_incr_1b,     // Increment phase value (for DDSX only)
  up_dds_scale_1b,    // Samples scale value (for DDSX only)
  up_dds_init_2a,     // Initial phase value (for DDSX only)
  up_dds_incr_2a,     // Increment phase value (for DDSX only)
  up_dds_scale_2a,    // Samples scale value (for DDSX only)
  up_dds_init_2b,     // Initial phase value (for DDSX only)
  up_dds_incr_2b,     // Increment phase value (for DDSX only)
  up_dds_scale_2b,    // Samples scale value (for DDSX only)
  up_dds_data_1a,     // Pattern Data (for SED only)
  up_dds_data_1b,     // Pattern Data (for SED only)
  up_dds_data_2a,     // Pattern Data (for SED only)
  up_dds_data_2b,     // Pattern Data (for SED only)
  up_intp_enable,     // Interpolate Enable (for DDR only)
  up_intp_scale_a,    // Interpolate scale value (for DDR only)
  up_intp_scale_b,    // Interpolate scale value (for DDR only)
  up_vdma_fscnt,      // VDMA fs count register

  // debug signals (for chipscope)

  vdma_dbg_data,
  vdma_dbg_trigger,

  // debug signals (for chipscope)

  dac_dbg_data,
  dac_dbg_trigger);

  // VDMA interface and status signals

  input           vdma_clk;
  output          vdma_fs;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;
  output          vdma_ovf;
  output          vdma_unf;

  // DAC interface (to the physical interface)

  input           dac_div3_clk;
  input           dds_master_enable;
  input           dds_master_frame;

  // I frame/data (sample 0 is transmitted first)

  output  [ 2:0]  dds_frame_0;
  output  [15:0]  dds_data_00;
  output  [15:0]  dds_data_01;
  output  [15:0]  dds_data_02;

  // Q frame/data (sample 0 is transmitted first)

  output  [ 2:0]  dds_frame_1;
  output  [15:0]  dds_data_10;
  output  [15:0]  dds_data_11;
  output  [15:0]  dds_data_12;

  // processor signals

  input           up_dds_format;      // DDS format 2's compl (0x1) or offset binary (0x0)
  input           up_dds_psel;        // Pattern (SED) select
  input           up_dds_sel;         // DDS select, DDR (0x1) or DMA (0x0)
  input   [15:0]  up_dds_init_1a;     // Initial phase value (for DDSX only)
  input   [15:0]  up_dds_incr_1a;     // Increment phase value (for DDSX only)
  input   [ 3:0]  up_dds_scale_1a;    // Samples scale value (for DDSX only)
  input   [15:0]  up_dds_init_1b;     // Initial phase value (for DDSX only)
  input   [15:0]  up_dds_incr_1b;     // Increment phase value (for DDSX only)
  input   [ 3:0]  up_dds_scale_1b;    // Samples scale value (for DDSX only)
  input   [15:0]  up_dds_init_2a;     // Initial phase value (for DDSX only)
  input   [15:0]  up_dds_incr_2a;     // Increment phase value (for DDSX only)
  input   [ 3:0]  up_dds_scale_2a;    // Samples scale value (for DDSX only)
  input   [15:0]  up_dds_init_2b;     // Initial phase value (for DDSX only)
  input   [15:0]  up_dds_incr_2b;     // Increment phase value (for DDSX only)
  input   [ 3:0]  up_dds_scale_2b;    // Samples scale value (for DDSX only)
  input   [15:0]  up_dds_data_1a;     // Pattern Data (for SED only)
  input   [15:0]  up_dds_data_1b;     // Pattern Data (for SED only)
  input   [15:0]  up_dds_data_2a;     // Pattern Data (for SED only)
  input   [15:0]  up_dds_data_2b;     // Pattern Data (for SED only)
  input           up_intp_enable;     // Interpolate Enable (for DDR only)
  input   [15:0]  up_intp_scale_a;    // Interpolate scale value (for DDR only)
  input   [15:0]  up_intp_scale_b;    // Interpolate scale value (for DDR only)
  input   [15:0]  up_vdma_fscnt;      // VDMA fs count register

  // debug signals (for chipscope)

  output  [198:0] vdma_dbg_data;
  output  [ 7:0]  vdma_dbg_trigger;

  // debug signals (for chipscope)

  output  [195:0] dac_dbg_data;
  output  [ 7:0]  dac_dbg_trigger;

  reg             dds_format_n_m1 = 'd0;
  reg             dds_format_n = 'd0;
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

  // Master frame pulse and enables and transfer processor signals to
  // the dac clock.

  assign dds_master_frame_s = dds_master_frame & ~dds_master_frame_d;

  always @(posedge dac_div3_clk) begin
    dds_format_n_m1 <= ~up_dds_format; // inverted here to reduce data path logic
    dds_format_n <= dds_format_n_m1;
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

  // DDS pattern generator for SED. Since OSERDES expects 6 samples, the I/Q samples
  // are muxed out on two clock cycles (I0-I1-I0 followed by I1-I0-I1)

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

  // DDS data out, SED, DDR and Xilinx IP

  always @(posedge dac_div3_clk) begin
    case (dds_sel)
      2'b10: begin  // SED (pattern)
        dds_frame_0 <= ddsp_frame_0;
        dds_data_00 <= ddsp_data_00;
        dds_data_01 <= ddsp_data_01;
        dds_data_02 <= ddsp_data_02;
        dds_frame_1 <= ddsp_frame_1;
        dds_data_10 <= ddsp_data_10;
        dds_data_11 <= ddsp_data_11;
        dds_data_12 <= ddsp_data_12;
      end
      2'b01: begin // VDMA (DDR)
        dds_frame_0 <= {2'd0, dds_master_frame_s};
        dds_data_00 <= ddsv_data_00_s;
        dds_data_01 <= ddsv_data_01_s;
        dds_data_02 <= ddsv_data_02_s;
        dds_frame_1 <= {2'd0, dds_master_frame_s};
        dds_data_10 <= ddsv_data_10_s;
        dds_data_11 <= ddsv_data_11_s;
        dds_data_12 <= ddsv_data_12_s;
      end
      default: begin // Xilinx (DDSX)
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

  // Xilinx's DDS cores

  cf_ddsx i_ddsx (
    .dac_div3_clk (dac_div3_clk),
    .dds_master_enable (dds_master_enable),
    .dds_data_00 (ddsx_data_00_s),
    .dds_data_01 (ddsx_data_01_s),
    .dds_data_02 (ddsx_data_02_s),
    .dds_data_10 (ddsx_data_10_s),
    .dds_data_11 (ddsx_data_11_s),
    .dds_data_12 (ddsx_data_12_s),
    .dds_format_n (dds_format_n),
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

  // VDMA DDR based samples

  cf_ddsv i_ddsv (
    .vdma_clk (vdma_clk),
    .vdma_fs (vdma_fs),
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
    .dds_format_n (dds_format_n),
    .up_intp_enable (up_intp_enable),
    .up_intp_scale_a (up_intp_scale_a),
    .up_intp_scale_b (up_intp_scale_b),
    .up_vdma_fscnt (up_vdma_fscnt),
    .vdma_dbg_data (vdma_dbg_data),
    .vdma_dbg_trigger (vdma_dbg_trigger),
    .dac_dbg_data (dac_dbg_data),
    .dac_dbg_trigger (dac_dbg_trigger));

endmodule

// ***************************************************************************
// ***************************************************************************

