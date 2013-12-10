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

module ad_intp2_16 (

  clk,
  data,

  // outputs

  intp2_00,
  intp2_01,
  intp2_02,
  intp2_03,
  intp2_04,
  intp2_05,
  intp2_06,
  intp2_07,
  intp2_08,
  intp2_09,
  intp2_10,
  intp2_11,
  intp2_12,
  intp2_13,
  intp2_14,
  intp2_15);

  input           clk;
  input   [15:0]  data;
  
  // outputs

  output  [15:0]  intp2_00;
  output  [15:0]  intp2_01;
  output  [15:0]  intp2_02;
  output  [15:0]  intp2_03;
  output  [15:0]  intp2_04;
  output  [15:0]  intp2_05;
  output  [15:0]  intp2_06;
  output  [15:0]  intp2_07;
  output  [15:0]  intp2_08;
  output  [15:0]  intp2_09;
  output  [15:0]  intp2_10;
  output  [15:0]  intp2_11;
  output  [15:0]  intp2_12;
  output  [15:0]  intp2_13;
  output  [15:0]  intp2_14;
  output  [15:0]  intp2_15;

  // internal registers

  reg     [15:0]  data_s00 = 'd0;
  reg     [15:0]  data_s01 = 'd0;
  reg     [15:0]  data_s02 = 'd0;
  reg     [15:0]  data_s03 = 'd0;
  reg     [15:0]  data_s04 = 'd0;
  reg     [15:0]  data_s05 = 'd0;
  reg     [15:0]  data_s06 = 'd0;
  reg     [15:0]  data_s07 = 'd0;
  reg     [15:0]  data_s08 = 'd0;
  reg     [15:0]  data_s09 = 'd0;
  reg     [15:0]  data_s10 = 'd0;
  reg     [15:0]  data_s11 = 'd0;
  reg     [15:0]  data_s12 = 'd0;
  reg     [15:0]  data_s13 = 'd0;
  reg     [15:0]  data_s14 = 'd0;
  reg     [15:0]  data_s15 = 'd0;
  reg     [15:0]  data_s16 = 'd0;
  reg     [15:0]  data_s17 = 'd0;

  // internal signals

  wire    [15:0]  intp2_0_s;
  wire    [15:0]  intp2_1_s;
  wire    [15:0]  intp2_2_s;
  wire    [15:0]  intp2_3_s;
  wire    [15:0]  intp2_4_s;
  wire    [15:0]  intp2_5_s;
  wire    [15:0]  intp2_6_s;
  wire    [15:0]  intp2_7_s;

  // delay registers

  always @(posedge clk) begin
    data_s00 <= data_s08;
    data_s01 <= data_s09;
    data_s02 <= data_s10;
    data_s03 <= data_s11;
    data_s04 <= data_s12;
    data_s05 <= data_s13;
    data_s06 <= data_s14;
    data_s07 <= data_s15;
    data_s08 <= data_s16;
    data_s09 <= data_s17;
    data_s10 <= intp2_0_s;
    data_s11 <= intp2_1_s;
    data_s12 <= intp2_2_s;
    data_s13 <= intp2_3_s;
    data_s14 <= intp2_4_s;
    data_s15 <= intp2_5_s;
    data_s16 <= intp2_6_s;
    data_s17 <= intp2_7_s;
  end

  // interpolators (stage-2)

  ad_mac_1 i_mac_1_0 (
    .clk (clk),
    .data_s0 (data_s00),
    .data_s1 (data_s01),
    .data_s2 (data_s02),
    .data_s3 (data_s03),
    .data_s4 (data_s04),
    .data_s5 (data_s05),
    .mac_data_0 (intp2_00),
    .mac_data_1 (intp2_01));

  // interpolators (stage-2)

  ad_mac_1 i_mac_1_1 (
    .clk (clk),
    .data_s0 (data_s01),
    .data_s1 (data_s02),
    .data_s2 (data_s03),
    .data_s3 (data_s04),
    .data_s4 (data_s05),
    .data_s5 (data_s06),
    .mac_data_0 (intp2_02),
    .mac_data_1 (intp2_03));

  // interpolators (stage-2)

  ad_mac_1 i_mac_1_2 (
    .clk (clk),
    .data_s0 (data_s02),
    .data_s1 (data_s03),
    .data_s2 (data_s04),
    .data_s3 (data_s05),
    .data_s4 (data_s06),
    .data_s5 (data_s07),
    .mac_data_0 (intp2_04),
    .mac_data_1 (intp2_05));

  // interpolators (stage-2)

  ad_mac_1 i_mac_1_3 (
    .clk (clk),
    .data_s0 (data_s03),
    .data_s1 (data_s04),
    .data_s2 (data_s05),
    .data_s3 (data_s06),
    .data_s4 (data_s07),
    .data_s5 (data_s08),
    .mac_data_0 (intp2_06),
    .mac_data_1 (intp2_07));

  // interpolators (stage-2)

  ad_mac_1 i_mac_1_4 (
    .clk (clk),
    .data_s0 (data_s04),
    .data_s1 (data_s05),
    .data_s2 (data_s06),
    .data_s3 (data_s07),
    .data_s4 (data_s08),
    .data_s5 (data_s09),
    .mac_data_0 (intp2_08),
    .mac_data_1 (intp2_09));

  // interpolators (stage-2)

  ad_mac_1 i_mac_1_5 (
    .clk (clk),
    .data_s0 (data_s05),
    .data_s1 (data_s06),
    .data_s2 (data_s07),
    .data_s3 (data_s08),
    .data_s4 (data_s09),
    .data_s5 (data_s10),
    .mac_data_0 (intp2_10),
    .mac_data_1 (intp2_11));

  // interpolators (stage-2)

  ad_mac_1 i_mac_1_6 (
    .clk (clk),
    .data_s0 (data_s06),
    .data_s1 (data_s07),
    .data_s2 (data_s08),
    .data_s3 (data_s09),
    .data_s4 (data_s10),
    .data_s5 (data_s11),
    .mac_data_0 (intp2_12),
    .mac_data_1 (intp2_13));

  // interpolators (stage-2)

  ad_mac_1 i_mac_1_7 (
    .clk (clk),
    .data_s0 (data_s07),
    .data_s1 (data_s08),
    .data_s2 (data_s09),
    .data_s3 (data_s10),
    .data_s4 (data_s11),
    .data_s5 (data_s12),
    .mac_data_0 (intp2_14),
    .mac_data_1 (intp2_15));

  // interpolators (stage-1)

  ad_intp2_8 i_intp2_8 (
    .clk (clk),
    .data (data),
    .intp2_0 (intp2_0_s),
    .intp2_1 (intp2_1_s),
    .intp2_2 (intp2_2_s),
    .intp2_3 (intp2_3_s),
    .intp2_4 (intp2_4_s),
    .intp2_5 (intp2_5_s),
    .intp2_6 (intp2_6_s),
    .intp2_7 (intp2_7_s));

endmodule

// ***************************************************************************
// ***************************************************************************
