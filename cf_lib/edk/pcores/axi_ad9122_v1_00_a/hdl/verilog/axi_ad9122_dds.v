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

module axi_ad9122_dds (

  // dac interface

  dac_div_clk,
  dac_rst,
  dac_dds_data_0,
  dac_dds_data_1,
  dac_dds_data_2,
  dac_dds_data_3,

  // processor interface

  dac_dds_enable,
  dac_dds_format,
  dac_dds_pattenb,
  dac_dds_patt_1,
  dac_dds_init_1,
  dac_dds_incr_1,
  dac_dds_scale_1,
  dac_dds_patt_2,
  dac_dds_init_2,
  dac_dds_incr_2,
  dac_dds_scale_2);

  // dac interface

  input           dac_div_clk;
  input           dac_rst;
  output  [15:0]  dac_dds_data_0;
  output  [15:0]  dac_dds_data_1;
  output  [15:0]  dac_dds_data_2;
  output  [15:0]  dac_dds_data_3;

  // processor interface

  input           dac_dds_enable;
  input           dac_dds_format;
  input           dac_dds_pattenb;
  input   [15:0]  dac_dds_patt_1;
  input   [15:0]  dac_dds_init_1;
  input   [15:0]  dac_dds_incr_1;
  input   [ 3:0]  dac_dds_scale_1;
  input   [15:0]  dac_dds_patt_2;
  input   [15:0]  dac_dds_init_2;
  input   [15:0]  dac_dds_incr_2;
  input   [ 3:0]  dac_dds_scale_2;

  // internal registers

  reg     [15:0]  dac_dds_phase_1_0 = 'd0;
  reg     [15:0]  dac_dds_phase_1_1 = 'd0;
  reg     [15:0]  dac_dds_phase_1_2 = 'd0;
  reg     [15:0]  dac_dds_phase_1_3 = 'd0;
  reg     [15:0]  dac_dds_phase_2_0 = 'd0;
  reg     [15:0]  dac_dds_phase_2_1 = 'd0;
  reg     [15:0]  dac_dds_phase_2_2 = 'd0;
  reg     [15:0]  dac_dds_phase_2_3 = 'd0;
  reg     [15:0]  dac_dds_sine_1_0 = 'd0;
  reg     [15:0]  dac_dds_sine_1_1 = 'd0;
  reg     [15:0]  dac_dds_sine_1_2 = 'd0;
  reg     [15:0]  dac_dds_sine_1_3 = 'd0;
  reg     [15:0]  dac_dds_sine_2_0 = 'd0;
  reg     [15:0]  dac_dds_sine_2_1 = 'd0;
  reg     [15:0]  dac_dds_sine_2_2 = 'd0;
  reg     [15:0]  dac_dds_sine_2_3 = 'd0;
  reg     [15:0]  dac_dds_sine_0 = 'd0;
  reg     [15:0]  dac_dds_sine_1 = 'd0;
  reg     [15:0]  dac_dds_sine_2 = 'd0;
  reg     [15:0]  dac_dds_sine_3 = 'd0;
  reg     [15:0]  dac_dds_data_0 = 'd0;
  reg     [15:0]  dac_dds_data_1 = 'd0;
  reg     [15:0]  dac_dds_data_2 = 'd0;
  reg     [15:0]  dac_dds_data_3 = 'd0;

  // internal signals

  wire    [15:0]  dac_dds_data_0_s;
  wire    [15:0]  dac_dds_data_1_s;
  wire    [15:0]  dac_dds_data_2_s;
  wire    [15:0]  dac_dds_data_3_s;
  wire    [15:0]  dac_dds_sine_1_0_s;
  wire    [15:0]  dac_dds_sine_1_1_s;
  wire    [15:0]  dac_dds_sine_1_2_s;
  wire    [15:0]  dac_dds_sine_1_3_s;
  wire    [15:0]  dac_dds_sine_2_0_s;
  wire    [15:0]  dac_dds_sine_2_1_s;
  wire    [15:0]  dac_dds_sine_2_2_s;
  wire    [15:0]  dac_dds_sine_2_3_s;

  // dds output scaling (shift only)

  function [15:0] dac_datascale;
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
      dac_datascale = data_out;
    end
  endfunction

  // dds phase counters

  always @(posedge dac_div_clk) begin
    if (dac_dds_enable == 1'b0) begin
      dac_dds_phase_1_0 <= dac_dds_init_1;
      dac_dds_phase_1_1 <= dac_dds_phase_1_0 + dac_dds_incr_1;
      dac_dds_phase_1_2 <= dac_dds_phase_1_1 + dac_dds_incr_1;
      dac_dds_phase_1_3 <= dac_dds_phase_1_2 + dac_dds_incr_1;
      dac_dds_phase_2_0 <= dac_dds_init_2;
      dac_dds_phase_2_1 <= dac_dds_phase_2_0 + dac_dds_incr_2;
      dac_dds_phase_2_2 <= dac_dds_phase_2_1 + dac_dds_incr_2;
      dac_dds_phase_2_3 <= dac_dds_phase_2_2 + dac_dds_incr_2;
    end else begin
      dac_dds_phase_1_0 <= dac_dds_phase_1_0 + {dac_dds_incr_1[13:0], 2'd0};
      dac_dds_phase_1_1 <= dac_dds_phase_1_1 + {dac_dds_incr_1[13:0], 2'd0};
      dac_dds_phase_1_2 <= dac_dds_phase_1_2 + {dac_dds_incr_1[13:0], 2'd0};
      dac_dds_phase_1_3 <= dac_dds_phase_1_3 + {dac_dds_incr_1[13:0], 2'd0};
      dac_dds_phase_2_0 <= dac_dds_phase_2_0 + {dac_dds_incr_2[13:0], 2'd0};
      dac_dds_phase_2_1 <= dac_dds_phase_2_1 + {dac_dds_incr_2[13:0], 2'd0};
      dac_dds_phase_2_2 <= dac_dds_phase_2_2 + {dac_dds_incr_2[13:0], 2'd0};
      dac_dds_phase_2_3 <= dac_dds_phase_2_3 + {dac_dds_incr_2[13:0], 2'd0};
    end
  end

  // dds outputs are scaled and added (2's complement)

  always @(posedge dac_div_clk) begin
    dac_dds_sine_1_0 <= dac_datascale(dac_dds_sine_1_0_s, dac_dds_scale_1);
    dac_dds_sine_1_1 <= dac_datascale(dac_dds_sine_1_1_s, dac_dds_scale_1);
    dac_dds_sine_1_2 <= dac_datascale(dac_dds_sine_1_2_s, dac_dds_scale_1);
    dac_dds_sine_1_3 <= dac_datascale(dac_dds_sine_1_3_s, dac_dds_scale_1);
    dac_dds_sine_2_0 <= dac_datascale(dac_dds_sine_2_0_s, dac_dds_scale_2);
    dac_dds_sine_2_1 <= dac_datascale(dac_dds_sine_2_1_s, dac_dds_scale_2);
    dac_dds_sine_2_2 <= dac_datascale(dac_dds_sine_2_2_s, dac_dds_scale_2);
    dac_dds_sine_2_3 <= dac_datascale(dac_dds_sine_2_3_s, dac_dds_scale_2);
    dac_dds_sine_0 <= dac_dds_sine_1_0 + dac_dds_sine_2_0;
    dac_dds_sine_1 <= dac_dds_sine_1_1 + dac_dds_sine_2_1;
    dac_dds_sine_2 <= dac_dds_sine_1_2 + dac_dds_sine_2_2;
    dac_dds_sine_3 <= dac_dds_sine_1_3 + dac_dds_sine_2_3;
  end

  assign dac_dds_data_0_s[15:15] = dac_dds_format ^ dac_dds_sine_0[15];
  assign dac_dds_data_0_s[14: 0] = dac_dds_sine_0[14:0];
  assign dac_dds_data_1_s[15:15] = dac_dds_format ^ dac_dds_sine_1[15];
  assign dac_dds_data_1_s[14: 0] = dac_dds_sine_1[14:0];
  assign dac_dds_data_2_s[15:15] = dac_dds_format ^ dac_dds_sine_2[15];
  assign dac_dds_data_2_s[14: 0] = dac_dds_sine_2[14:0];
  assign dac_dds_data_3_s[15:15] = dac_dds_format ^ dac_dds_sine_3[15];
  assign dac_dds_data_3_s[14: 0] = dac_dds_sine_3[14:0];

  // output is either 2's complement or offset binary.

  always @(posedge dac_div_clk) begin
    if (dac_dds_pattenb == 1'b1) begin
      dac_dds_data_0 <= dac_dds_patt_1;
      dac_dds_data_1 <= dac_dds_patt_2;
      dac_dds_data_2 <= dac_dds_patt_1;
      dac_dds_data_3 <= dac_dds_patt_2;
    end else begin
      dac_dds_data_0 <= dac_dds_data_0_s;
      dac_dds_data_1 <= dac_dds_data_1_s;
      dac_dds_data_2 <= dac_dds_data_2_s;
      dac_dds_data_3 <= dac_dds_data_3_s;
    end
  end

  // dds

  ad_dds_1 i_ad_dds_1_1_0 (
    .clk (dac_div_clk),
    .sclr (dac_rst),
    .phase_in (dac_dds_phase_1_0),
    .sine (dac_dds_sine_1_0_s));

  ad_dds_1 i_ad_dds_1_1_1 (
    .clk (dac_div_clk),
    .sclr (dac_rst),
    .phase_in (dac_dds_phase_1_1),
    .sine (dac_dds_sine_1_1_s));

  ad_dds_1 i_ad_dds_1_1_2 (
    .clk (dac_div_clk),
    .sclr (dac_rst),
    .phase_in (dac_dds_phase_1_2),
    .sine (dac_dds_sine_1_2_s));

  ad_dds_1 i_ad_dds_1_1_3 (
    .clk (dac_div_clk),
    .sclr (dac_rst),
    .phase_in (dac_dds_phase_1_3),
    .sine (dac_dds_sine_1_3_s));

  // dds

  ad_dds_1 i_ad_dds_1_2_0 (
    .clk (dac_div_clk),
    .sclr (dac_rst),
    .phase_in (dac_dds_phase_2_0),
    .sine (dac_dds_sine_2_0_s));
  
  ad_dds_1 i_ad_dds_1_2_1 (
    .clk (dac_div_clk),
    .sclr (dac_rst),
    .phase_in (dac_dds_phase_2_1),
    .sine (dac_dds_sine_2_1_s));
  
  ad_dds_1 i_ad_dds_1_2_2 (
    .clk (dac_div_clk),
    .sclr (dac_rst),
    .phase_in (dac_dds_phase_2_2),
    .sine (dac_dds_sine_2_2_s));
  
  ad_dds_1 i_ad_dds_1_2_3 (
    .clk (dac_div_clk),
    .sclr (dac_rst),
    .phase_in (dac_dds_phase_2_3),
    .sine (dac_dds_sine_2_3_s));
  
endmodule

// ***************************************************************************
// ***************************************************************************
