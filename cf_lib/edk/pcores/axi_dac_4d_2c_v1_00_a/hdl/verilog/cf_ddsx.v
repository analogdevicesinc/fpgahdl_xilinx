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

module cf_ddsx (

  // dac interface

  dac_div3_clk,
  dds_master_enable,

  // I frame/data (sample 0 is transmitted first)

  dds_data_00,
  dds_data_01,
  dds_data_02,

  // Q frame/data (sample 0 is transmitted first)

  dds_data_10,
  dds_data_11,
  dds_data_12,

  // 2's compl (0x1) or offset-bin (0x0)

  dds_format_n,

  // processor signals

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

  // debug signals (chipscope)

  debug_data,
  debug_trigger);

  // dac interface

  input           dac_div3_clk;
  input           dds_master_enable;

  // I frame/data (sample 0 is transmitted first)

  output  [15:0]  dds_data_00;
  output  [15:0]  dds_data_01;
  output  [15:0]  dds_data_02;

  // Q frame/data (sample 0 is transmitted first)

  output  [15:0]  dds_data_10;
  output  [15:0]  dds_data_11;
  output  [15:0]  dds_data_12;

  // 2's compl (0x1) or offset-bin (0x0)

  input           dds_format_n;

  // processor signals

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

  // debug signals (chipscope)

  output  [79:0]  debug_data;
  output  [ 7:0]  debug_trigger;

  reg     [ 5:0]  dds_enable_cnt = 'd0;
  reg             dds_enable_clr = 'd0;
  reg             dds_enable_int = 'd0;
  reg             dds_enable_m1 = 'd0;
  reg             dds_enable_m2 = 'd0;
  reg             dds_enable_m3 = 'd0;
  reg             dds_enable_m4 = 'd0;
  reg             dds_enable_m5 = 'd0;
  reg             dds_enable_m6 = 'd0;
  reg             dds_enable_m7 = 'd0;
  reg     [15:0]  dds_init_m_1a = 'd0;
  reg     [15:0]  dds_incr_m_1a = 'd0;
  reg     [15:0]  dds_init_m_1b = 'd0;
  reg     [15:0]  dds_incr_m_1b = 'd0;
  reg     [15:0]  dds_init_m_2a = 'd0;
  reg     [15:0]  dds_incr_m_2a = 'd0;
  reg     [15:0]  dds_init_m_2b = 'd0;
  reg     [15:0]  dds_incr_m_2b = 'd0;
  reg     [ 3:0]  dds_scale_1a = 'd0;
  reg     [ 3:0]  dds_scale_1b = 'd0;
  reg     [ 3:0]  dds_scale_2a = 'd0;
  reg     [ 3:0]  dds_scale_2b = 'd0;
  reg             dds_enable = 'd0;
  reg     [15:0]  dds_incr_1a = 'd0;
  reg     [15:0]  dds_init_1a_0 = 'd0;
  reg     [15:0]  dds_init_1a_1 = 'd0;
  reg     [15:0]  dds_init_1a_2 = 'd0;
  reg     [15:0]  dds_incr_1b = 'd0;
  reg     [15:0]  dds_init_1b_0 = 'd0;
  reg     [15:0]  dds_init_1b_1 = 'd0;
  reg     [15:0]  dds_init_1b_2 = 'd0;
  reg     [15:0]  dds_incr_2a = 'd0;
  reg     [15:0]  dds_init_2a_0 = 'd0;
  reg     [15:0]  dds_init_2a_1 = 'd0;
  reg     [15:0]  dds_init_2a_2 = 'd0;
  reg     [15:0]  dds_incr_2b = 'd0;
  reg     [15:0]  dds_init_2b_0 = 'd0;
  reg     [15:0]  dds_init_2b_1 = 'd0;
  reg     [15:0]  dds_init_2b_2 = 'd0;
  reg             dds_enable_d = 'd0;
  reg     [15:0]  dds_data_in_1a_0 = 'd0;
  reg     [15:0]  dds_data_in_1a_1 = 'd0;
  reg     [15:0]  dds_data_in_1a_2 = 'd0;
  reg     [15:0]  dds_data_in_1b_0 = 'd0;
  reg     [15:0]  dds_data_in_1b_1 = 'd0;
  reg     [15:0]  dds_data_in_1b_2 = 'd0;
  reg     [15:0]  dds_data_in_2a_0 = 'd0;
  reg     [15:0]  dds_data_in_2a_1 = 'd0;
  reg     [15:0]  dds_data_in_2a_2 = 'd0;
  reg     [15:0]  dds_data_in_2b_0 = 'd0;
  reg     [15:0]  dds_data_in_2b_1 = 'd0;
  reg     [15:0]  dds_data_in_2b_2 = 'd0;
  reg     [15:0]  dds_data_out_1a_0 = 'd0;
  reg     [15:0]  dds_data_out_1a_1 = 'd0;
  reg     [15:0]  dds_data_out_1a_2 = 'd0;
  reg     [15:0]  dds_data_out_1b_0 = 'd0;
  reg     [15:0]  dds_data_out_1b_1 = 'd0;
  reg     [15:0]  dds_data_out_1b_2 = 'd0;
  reg     [15:0]  dds_data_out_2a_0 = 'd0;
  reg     [15:0]  dds_data_out_2a_1 = 'd0;
  reg     [15:0]  dds_data_out_2a_2 = 'd0;
  reg     [15:0]  dds_data_out_2b_0 = 'd0;
  reg     [15:0]  dds_data_out_2b_1 = 'd0;
  reg     [15:0]  dds_data_out_2b_2 = 'd0;
  reg     [15:0]  dds_data_out_00 = 'd0;
  reg     [15:0]  dds_data_out_01 = 'd0;
  reg     [15:0]  dds_data_out_02 = 'd0;
  reg     [15:0]  dds_data_out_10 = 'd0;
  reg     [15:0]  dds_data_out_11 = 'd0;
  reg     [15:0]  dds_data_out_12 = 'd0;
  reg     [15:0]  dds_data_00 = 'd0;
  reg     [15:0]  dds_data_01 = 'd0;
  reg     [15:0]  dds_data_02 = 'd0;
  reg     [15:0]  dds_data_10 = 'd0;
  reg     [15:0]  dds_data_11 = 'd0;
  reg     [15:0]  dds_data_12 = 'd0;

  wire    [15:0]  dds_data_out_1a_0_s;
  wire    [15:0]  dds_data_out_1a_1_s;
  wire    [15:0]  dds_data_out_1a_2_s;
  wire    [15:0]  dds_data_out_1b_0_s;
  wire    [15:0]  dds_data_out_1b_1_s;
  wire    [15:0]  dds_data_out_1b_2_s;
  wire    [15:0]  dds_data_out_2a_0_s;
  wire    [15:0]  dds_data_out_2a_1_s;
  wire    [15:0]  dds_data_out_2a_2_s;
  wire    [15:0]  dds_data_out_2b_0_s;
  wire    [15:0]  dds_data_out_2b_1_s;
  wire    [15:0]  dds_data_out_2b_2_s;

  // The DDS outputs are scaled and added together.

  function [15:0] data_scale;
    input [15:0]  data;
    input [ 3:0]  scale;
    reg   [15:0]  data_out;
    begin
      case (scale)
        4'b1111: data_out = {{15{data[15]}}, data[15:15]};
        4'b1110: data_out = {{14{data[15]}}, data[15:14]};
        4'b1101: data_out = {{13{data[15]}}, data[15:13]};
        4'b1100: data_out = {{12{data[15]}}, data[15:12]};
        4'b1011: data_out = {{11{data[15]}}, data[15:11]};
        4'b1010: data_out = {{10{data[15]}}, data[15:10]};
        4'b1001: data_out = {{ 9{data[15]}}, data[15: 9]};
        4'b1000: data_out = {{ 8{data[15]}}, data[15: 8]};
        4'b0111: data_out = {{ 7{data[15]}}, data[15: 7]};
        4'b0110: data_out = {{ 6{data[15]}}, data[15: 6]};
        4'b0101: data_out = {{ 5{data[15]}}, data[15: 5]};
        4'b0100: data_out = {{ 4{data[15]}}, data[15: 4]};
        4'b0011: data_out = {{ 3{data[15]}}, data[15: 3]};
        4'b0010: data_out = {{ 2{data[15]}}, data[15: 2]};
        4'b0001: data_out = {{ 1{data[15]}}, data[15: 1]};
        default: data_out = data;
      endcase
      data_scale = data_out;
    end
  endfunction

  // debug ports

  assign debug_trigger = {7'd0, dds_master_enable};
  assign debug_data[79:79] = dds_master_enable;
  assign debug_data[78:78] = dds_enable_m1;
  assign debug_data[77:77] = dds_enable_m2;
  assign debug_data[76:76] = dds_enable_m3;
  assign debug_data[75:75] = dds_enable_m4;
  assign debug_data[74:74] = dds_enable_m7;
  assign debug_data[73:73] = dds_enable;
  assign debug_data[72:72] = dds_enable_d;
  assign debug_data[71:71] = dds_enable_clr;
  assign debug_data[70:70] = dds_enable_int;
  assign debug_data[69:64] = dds_enable_cnt;
  assign debug_data[63:48] = dds_data_in_2a_2;
  assign debug_data[47:32] = dds_data_in_2a_0;
  assign debug_data[31:16] = dds_data_in_1a_2;
  assign debug_data[15: 0] = dds_data_in_1a_0;

  // The DDS cores need a reset when tones are changed, this is a synchronous clear
  // for the DDS cores. If disabled, the DDS cores are held on rest for about 32
  // clocks. After which processor control takes over.

  always @(posedge dac_div3_clk) begin
    if (dds_master_enable == 1'b0) begin
      dds_enable_cnt <= 6'h20;
    end else if (dds_enable_cnt[5] == 1'b1) begin
      dds_enable_cnt <= dds_enable_cnt + 1'b1;
    end
    dds_enable_clr <= dds_enable_cnt[5];
    dds_enable_int <= ~dds_enable_cnt[5];
  end

  // Transfer processor signals to the dac clock. A very long chain is created for
  // enable. This allows the individual phase counters to stabilize before the
  // actual increment happens.

  always @(posedge dac_div3_clk) begin
    dds_enable_m1 <= dds_enable_int;
    dds_enable_m2 <= dds_enable_m1;
    dds_enable_m3 <= dds_enable_m2;
    dds_enable_m4 <= dds_enable_m3;
    dds_enable_m5 <= dds_enable_m4;
    dds_enable_m6 <= dds_enable_m5;
    dds_enable_m7 <= dds_enable_m6;
    if ((dds_enable_m2 == 1'b1) && (dds_enable_m3 == 1'b0)) begin
      dds_init_m_1a <= up_dds_init_1a;
      dds_incr_m_1a <= up_dds_incr_1a;
      dds_init_m_1b <= up_dds_init_1b;
      dds_incr_m_1b <= up_dds_incr_1b;
      dds_init_m_2a <= up_dds_init_2a;
      dds_incr_m_2a <= up_dds_incr_2a;
      dds_init_m_2b <= up_dds_init_2b;
      dds_incr_m_2b <= up_dds_incr_2b;
    end
    if ((dds_enable_m2 == 1'b1) && (dds_enable_m3 == 1'b0)) begin
      dds_scale_1a <= up_dds_scale_1a;
      dds_scale_1b <= up_dds_scale_1b;
      dds_scale_2a <= up_dds_scale_2a;
      dds_scale_2b <= up_dds_scale_2b;
    end
  end

  // The initial phase values of the DDS cores are updated according to the increment
  // value. Note from the above chain, that by the time enable comes out of that
  // pipe, these values will be stable.

  always @(posedge dac_div3_clk) begin
    dds_enable <= dds_enable_m7;
    dds_incr_1a <= dds_incr_m_1a + {dds_incr_m_1a[14:0], 1'd0};
    dds_init_1a_0 <= dds_init_m_1a;
    dds_init_1a_1 <= dds_init_m_1a + dds_incr_m_1a;
    dds_init_1a_2 <= dds_init_m_1a + {dds_incr_m_1a[14:0], 1'd0};
    dds_incr_1b <= dds_incr_m_1b + {dds_incr_m_1b[14:0], 1'd0};
    dds_init_1b_0 <= dds_init_m_1b;
    dds_init_1b_1 <= dds_init_m_1b + dds_incr_m_1b;
    dds_init_1b_2 <= dds_init_m_1b + {dds_incr_m_1b[14:0], 1'd0};
    dds_incr_2a <= dds_incr_m_2a + {dds_incr_m_2a[14:0], 1'd0};
    dds_init_2a_0 <= dds_init_m_2a;
    dds_init_2a_1 <= dds_init_m_2a + dds_incr_m_2a;
    dds_init_2a_2 <= dds_init_m_2a + {dds_incr_m_2a[14:0], 1'd0};
    dds_incr_2b <= dds_incr_m_2b + {dds_incr_m_2b[14:0], 1'd0};
    dds_init_2b_0 <= dds_init_m_2b;
    dds_init_2b_1 <= dds_init_m_2b + dds_incr_m_2b;
    dds_init_2b_2 <= dds_init_m_2b + {dds_incr_m_2b[14:0], 1'd0};
  end

  // This is the running DDS phase counters

  always @(posedge dac_div3_clk) begin
    dds_enable_d <= dds_enable;
    if (dds_enable_d == 1'b1) begin
      dds_data_in_1a_0 <= dds_data_in_1a_0 + dds_incr_1a;
      dds_data_in_1a_1 <= dds_data_in_1a_1 + dds_incr_1a;
      dds_data_in_1a_2 <= dds_data_in_1a_2 + dds_incr_1a;
      dds_data_in_1b_0 <= dds_data_in_1b_0 + dds_incr_1b;
      dds_data_in_1b_1 <= dds_data_in_1b_1 + dds_incr_1b;
      dds_data_in_1b_2 <= dds_data_in_1b_2 + dds_incr_1b;
      dds_data_in_2a_0 <= dds_data_in_2a_0 + dds_incr_2a;
      dds_data_in_2a_1 <= dds_data_in_2a_1 + dds_incr_2a;
      dds_data_in_2a_2 <= dds_data_in_2a_2 + dds_incr_2a;
      dds_data_in_2b_0 <= dds_data_in_2b_0 + dds_incr_2b;
      dds_data_in_2b_1 <= dds_data_in_2b_1 + dds_incr_2b;
      dds_data_in_2b_2 <= dds_data_in_2b_2 + dds_incr_2b;
    end else if (dds_enable == 1'b1) begin
      dds_data_in_1a_0 <= dds_init_1a_0;
      dds_data_in_1a_1 <= dds_init_1a_1;
      dds_data_in_1a_2 <= dds_init_1a_2;
      dds_data_in_1b_0 <= dds_init_1b_0;
      dds_data_in_1b_1 <= dds_init_1b_1;
      dds_data_in_1b_2 <= dds_init_1b_2;
      dds_data_in_2a_0 <= dds_init_2a_0;
      dds_data_in_2a_1 <= dds_init_2a_1;
      dds_data_in_2a_2 <= dds_init_2a_2;
      dds_data_in_2b_0 <= dds_init_2b_0;
      dds_data_in_2b_1 <= dds_init_2b_1;
      dds_data_in_2b_2 <= dds_init_2b_2;
    end else begin
      dds_data_in_1a_0 <= 16'd0;
      dds_data_in_1a_1 <= 16'd0;
      dds_data_in_1a_2 <= 16'd0;
      dds_data_in_1b_0 <= 16'd0;
      dds_data_in_1b_1 <= 16'd0;
      dds_data_in_1b_2 <= 16'd0;
      dds_data_in_2a_0 <= 16'd0;
      dds_data_in_2a_1 <= 16'd0;
      dds_data_in_2a_2 <= 16'd0;
      dds_data_in_2b_0 <= 16'd0;
      dds_data_in_2b_1 <= 16'd0;
      dds_data_in_2b_2 <= 16'd0;
    end
  end

  // THe DDS outputs are scaled and added together (scaling avoids range overflow).

  always @(posedge dac_div3_clk) begin
    dds_data_out_1a_0 <= data_scale(dds_data_out_1a_0_s, dds_scale_1a);
    dds_data_out_1a_1 <= data_scale(dds_data_out_1a_1_s, dds_scale_1a);
    dds_data_out_1a_2 <= data_scale(dds_data_out_1a_2_s, dds_scale_1a);
    dds_data_out_1b_0 <= data_scale(dds_data_out_1b_0_s, dds_scale_1b);
    dds_data_out_1b_1 <= data_scale(dds_data_out_1b_1_s, dds_scale_1b);
    dds_data_out_1b_2 <= data_scale(dds_data_out_1b_2_s, dds_scale_1b);
    dds_data_out_2a_0 <= data_scale(dds_data_out_2a_0_s, dds_scale_2a);
    dds_data_out_2a_1 <= data_scale(dds_data_out_2a_1_s, dds_scale_2a);
    dds_data_out_2a_2 <= data_scale(dds_data_out_2a_2_s, dds_scale_2a);
    dds_data_out_2b_0 <= data_scale(dds_data_out_2b_0_s, dds_scale_2b);
    dds_data_out_2b_1 <= data_scale(dds_data_out_2b_1_s, dds_scale_2b);
    dds_data_out_2b_2 <= data_scale(dds_data_out_2b_2_s, dds_scale_2b);
    dds_data_out_00 <= dds_data_out_1a_0 + dds_data_out_1b_0;
    dds_data_out_01 <= dds_data_out_1a_1 + dds_data_out_1b_1;
    dds_data_out_02 <= dds_data_out_1a_2 + dds_data_out_1b_2;
    dds_data_out_10 <= dds_data_out_2a_0 + dds_data_out_2b_0;
    dds_data_out_11 <= dds_data_out_2a_1 + dds_data_out_2b_1;
    dds_data_out_12 <= dds_data_out_2a_2 + dds_data_out_2b_2;
    dds_data_00 <= {(dds_format_n ^ dds_data_out_00[15]), dds_data_out_00[14:0]};
    dds_data_01 <= {(dds_format_n ^ dds_data_out_01[15]), dds_data_out_01[14:0]};
    dds_data_02 <= {(dds_format_n ^ dds_data_out_02[15]), dds_data_out_02[14:0]};
    dds_data_10 <= {(dds_format_n ^ dds_data_out_10[15]), dds_data_out_10[14:0]};
    dds_data_11 <= {(dds_format_n ^ dds_data_out_11[15]), dds_data_out_11[14:0]};
    dds_data_12 <= {(dds_format_n ^ dds_data_out_12[15]), dds_data_out_12[14:0]};
  end

  // Xilinx's DDS core, I sample 0

  cf_ddsx_1 i_ddsx_1a_0 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_1a_0),
    .sine (dds_data_out_1a_0_s));

  // Xilinx's DDS core, I sample 1

  cf_ddsx_1 i_ddsx_1a_1 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_1a_1),
    .sine (dds_data_out_1a_1_s));

  // Xilinx's DDS core, I sample 2

  cf_ddsx_1 i_ddsx_1a_2 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_1a_2),
    .sine (dds_data_out_1a_2_s));

  // Xilinx's DDS core, I sample 0

  cf_ddsx_1 i_ddsx_1b_0 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_1b_0),
    .sine (dds_data_out_1b_0_s));

  // Xilinx's DDS core, I sample 1

  cf_ddsx_1 i_ddsx_1b_1 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_1b_1),
    .sine (dds_data_out_1b_1_s));

  // Xilinx's DDS core, I sample 2

  cf_ddsx_1 i_ddsx_1b_2 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_1b_2),
    .sine (dds_data_out_1b_2_s));

  // Xilinx's DDS core, Q sample 0

  cf_ddsx_1 i_ddsx_2a_0 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_2a_0),
    .sine (dds_data_out_2a_0_s));

  // Xilinx's DDS core, Q sample 1

  cf_ddsx_1 i_ddsx_2a_1 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_2a_1),
    .sine (dds_data_out_2a_1_s));

  // Xilinx's DDS core, Q sample 2

  cf_ddsx_1 i_ddsx_2a_2 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_2a_2),
    .sine (dds_data_out_2a_2_s));

  // Xilinx's DDS core, Q sample 0

  cf_ddsx_1 i_ddsx_2b_0 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_2b_0),
    .sine (dds_data_out_2b_0_s));

  // Xilinx's DDS core, Q sample 1

  cf_ddsx_1 i_ddsx_2b_1 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_2b_1),
    .sine (dds_data_out_2b_1_s));

  // Xilinx's DDS core, Q sample 2

  cf_ddsx_1 i_ddsx_2b_2 (
    .clk (dac_div3_clk),
    .sclr (dds_enable_clr),
    .phase_in (dds_data_in_2b_2),
    .sine (dds_data_out_2b_2_s));

endmodule

// ***************************************************************************
// ***************************************************************************

