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
// all inputs are 2's complement

`timescale 1ps/1ps

module ad_mac_1 (

  // Q0 = S2;
  // Q1 = S0*C0 + S1*C1 + S2*C2 + S3*C3 + S4*C4 + S5*C5;

  clk,
  data_s0,
  data_s1,
  data_s2,
  data_s3,
  data_s4,
  data_s5,

  // outputs

  mac_data_0,
  mac_data_1);

  // parameters

  localparam    MAC_C0 = 16'h024d; //  0.0180
  localparam    MAC_C1 = 16'hf155; // -0.1146
  localparam    MAC_C2 = 16'h4c77; //  0.5974
  localparam    MAC_C3 = 16'h4c77; //  0.5974
  localparam    MAC_C4 = 16'hf155; // -0.1146
  localparam    MAC_C5 = 16'h024d; //  0.0180

  // Q0 = S2;
  // Q1 = S0*C0 + S1*C1 + S2*C2 + S3*C3 + S4*C4 + S5*C5;

  input           clk;
  input   [15:0]  data_s0;
  input   [15:0]  data_s1;
  input   [15:0]  data_s2;
  input   [15:0]  data_s3;
  input   [15:0]  data_s4;
  input   [15:0]  data_s5;

  // outputs

  output  [15:0]  mac_data_0;
  output  [15:0]  mac_data_1;

  // internal registers

  reg     [15:0]  mac_data_0 = 'd0;
  reg     [15:0]  mac_data_1 = 'd0;
  reg     [15:0]  p3_data_0_0 = 'd0;
  reg     [34:0]  p3_data_1_0 = 'd0;
  reg     [15:0]  p2_data_0_0 = 'd0;
  reg     [33:0]  p2_data_1_0 = 'd0;
  reg     [33:0]  p2_data_1_1 = 'd0;
  reg     [15:0]  p1_data_0_0 = 'd0;
  reg     [32:0]  p1_data_1_0 = 'd0;
  reg     [32:0]  p1_data_1_1 = 'd0;
  reg     [32:0]  p1_data_1_2 = 'd0;

  // internal signals

  wire            p3_ovf_s;
  wire    [31:0]  p1_data_0_0_s;
  wire    [31:0]  p1_data_1_0_s;
  wire    [31:0]  p1_data_1_1_s;
  wire    [31:0]  p1_data_1_2_s;
  wire    [31:0]  p1_data_1_3_s;
  wire    [31:0]  p1_data_1_4_s;
  wire    [31:0]  p1_data_1_5_s;

  // output registers

  assign p3_ovf_s = ((p3_data_1_0[34:30] == 5'h00) || (p3_data_1_0[34:30] == 5'h1f)) ? 1'b0 : 1'b1;

  always @(posedge clk) begin
    mac_data_0 <= p3_data_0_0;
    if (p3_ovf_s == 0) begin
      mac_data_1 <= p3_data_1_0[30:15];
    end else if (p3_data_1_0[34] == 1'b1) begin
      mac_data_1 <= 16'h8001;
    end else begin
      mac_data_1 <= 16'h7fff;
    end
  end

  // sum of products (stage-3)

  always @(posedge clk) begin
    p3_data_0_0 <= p2_data_0_0;
    p3_data_1_0 <= {p2_data_1_0[33], p2_data_1_0} + {p2_data_1_1[33], p2_data_1_1};
  end

  // sum of products (stage-2)

  always @(posedge clk) begin
    p2_data_0_0 <= p1_data_0_0;
    p2_data_1_0 <= {p1_data_1_0[32], p1_data_1_0} + {p1_data_1_1[32], p1_data_1_1};
    p2_data_1_1 <= {p1_data_1_2[32], p1_data_1_2};
  end

  // sum of products (stage-1)

  always @(posedge clk) begin
    p1_data_0_0 <= p1_data_0_0_s[15:0];
    p1_data_1_0 <= {p1_data_1_0_s[31], p1_data_1_0_s} + {p1_data_1_1_s[31], p1_data_1_1_s};
    p1_data_1_1 <= {p1_data_1_2_s[31], p1_data_1_2_s} + {p1_data_1_3_s[31], p1_data_1_3_s};
    p1_data_1_2 <= {p1_data_1_4_s[31], p1_data_1_4_s} + {p1_data_1_5_s[31], p1_data_1_5_s};
  end

  // sample -0

  ad_mul_dsp48_1 i_mul_dsp48_1_0_0 (
    .clk (clk),
    .a (data_s2),
    .b (16'h1),
    .p (p1_data_0_0_s));

  // sample -1

  ad_mul_dsp48_1 i_mul_dsp48_1_1_0 (
    .clk (clk),
    .a (data_s0),
    .b (MAC_C0),
    .p (p1_data_1_0_s));

  ad_mul_dsp48_1 i_mul_dsp48_1_1_1 (
    .clk (clk),
    .a (data_s1),
    .b (MAC_C1),
    .p (p1_data_1_1_s));

  ad_mul_dsp48_1 i_mul_dsp48_1_1_2 (
    .clk (clk),
    .a (data_s2),
    .b (MAC_C2),
    .p (p1_data_1_2_s));

  ad_mul_dsp48_1 i_mul_dsp48_1_1_3 (
    .clk (clk),
    .a (data_s3),
    .b (MAC_C3),
    .p (p1_data_1_3_s));

  ad_mul_dsp48_1 i_mul_dsp48_1_1_4 (
    .clk (clk),
    .a (data_s4),
    .b (MAC_C4),
    .p (p1_data_1_4_s));

  ad_mul_dsp48_1 i_mul_dsp48_1_1_5 (
    .clk (clk),
    .a (data_s5),
    .b (MAC_C5),
    .p (p1_data_1_5_s));

endmodule

// ***************************************************************************
// ***************************************************************************
