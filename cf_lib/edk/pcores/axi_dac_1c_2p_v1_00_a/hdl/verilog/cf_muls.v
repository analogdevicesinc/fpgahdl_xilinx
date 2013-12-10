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

`timescale 1ps/1ps

module cf_muls (

  // data_p = data_a (signed) * data_b (signed) (fractions only)
  clk,
  data_a,
  data_b,
  data_p,

  // ddata_out is internal pipe-line matched for ddata_in
  ddata_in,
  ddata_out);

  // delayed data bus width
  parameter DELAY_DATA_WIDTH = 16;
  parameter DW = DELAY_DATA_WIDTH - 1;

  input           clk;
  input   [15:0]  data_a;
  input   [15:0]  data_b;
  output  [15:0]  data_p;
  input   [DW:0]  ddata_in;
  output  [DW:0]  ddata_out;

  reg     [DW:0]  p1_ddata = 'd0;
  reg             p1_sign = 'd0;
  reg     [14:0]  p1_data_a = 'd0;
  reg     [14:0]  p1_data_b = 'd0;
  reg     [DW:0]  p2_ddata = 'd0;
  reg             p2_sign = 'd0;
  reg     [29:0]  p2_data_p_0 = 'd0;
  reg     [29:0]  p2_data_p_1 = 'd0;
  reg     [29:0]  p2_data_p_2 = 'd0;
  reg     [29:0]  p2_data_p_3 = 'd0;
  reg     [29:0]  p2_data_p_4 = 'd0;
  reg     [29:0]  p2_data_p_5 = 'd0;
  reg     [29:0]  p2_data_p_6 = 'd0;
  reg     [29:0]  p2_data_p_7 = 'd0;
  reg     [DW:0]  p3_ddata = 'd0;
  reg             p3_sign = 'd0;
  reg     [29:0]  p3_data_p_0 = 'd0;
  reg     [29:0]  p3_data_p_1 = 'd0;
  reg     [29:0]  p3_data_p_2 = 'd0;
  reg     [29:0]  p3_data_p_3 = 'd0;
  reg     [DW:0]  p4_ddata = 'd0;
  reg             p4_sign = 'd0;
  reg     [29:0]  p4_data_p_0 = 'd0;
  reg     [29:0]  p4_data_p_1 = 'd0;
  reg     [DW:0]  p5_ddata = 'd0;
  reg             p5_sign = 'd0;
  reg     [29:0]  p5_data_p = 'd0;
  reg     [DW:0]  ddata_out = 'd0;
  reg     [15:0]  data_p = 'd0;

  wire    [15:0]  p1_data_a_s;
  wire    [15:0]  p1_data_b_s;
  wire    [15:0]  p2_data_a_1p_16_s;
  wire    [15:0]  p2_data_a_1n_16_s;
  wire    [29:0]  p2_data_a_1p_s;
  wire    [29:0]  p2_data_a_1n_s;
  wire    [29:0]  p2_data_a_2p_s;
  wire    [29:0]  p2_data_a_2n_s;
  wire    [15:0]  p6_data_p_0_s;
  wire    [15:0]  p6_data_p_1_s;

  // pipe line stage 1, get the two's complement versions

  assign p1_data_a_s = ~data_a + 1'b1;
  assign p1_data_b_s = ~data_b + 1'b1;

  always @(posedge clk) begin
    p1_ddata <= ddata_in;
    p1_sign <= data_a[15] ^ data_b[15];
    p1_data_a <= (data_a[15] == 1'b1) ? p1_data_a_s[14:0] : data_a[14:0];
    p1_data_b <= (data_b[15] == 1'b1) ? p1_data_b_s[14:0] : data_b[14:0];
  end

  // pipe line stage 2, get the partial products

  assign p2_data_a_1p_16_s = {1'b0, p1_data_a};
  assign p2_data_a_1n_16_s = ~p2_data_a_1p_16_s + 1'b1;

  assign p2_data_a_1p_s = {{14{p2_data_a_1p_16_s[15]}}, p2_data_a_1p_16_s};
  assign p2_data_a_1n_s = {{14{p2_data_a_1n_16_s[15]}}, p2_data_a_1n_16_s};
  assign p2_data_a_2p_s = {{13{p2_data_a_1p_16_s[15]}}, p2_data_a_1p_16_s, 1'b0};
  assign p2_data_a_2n_s = {{13{p2_data_a_1n_16_s[15]}}, p2_data_a_1n_16_s, 1'b0};

  always @(posedge clk) begin
    p2_ddata <= p1_ddata;
    p2_sign <= p1_sign;
    case (p1_data_b[1:0])
      2'b11: p2_data_p_0 <= p2_data_a_1n_s;
      2'b10: p2_data_p_0 <= p2_data_a_2n_s;
      2'b01: p2_data_p_0 <= p2_data_a_1p_s;
      default: p2_data_p_0 <= 30'd0;
    endcase
    case (p1_data_b[3:1])
      3'b011: p2_data_p_1 <= {p2_data_a_2p_s[27:0], 2'd0};
      3'b100: p2_data_p_1 <= {p2_data_a_2n_s[27:0], 2'd0};
      3'b001: p2_data_p_1 <= {p2_data_a_1p_s[27:0], 2'd0};
      3'b010: p2_data_p_1 <= {p2_data_a_1p_s[27:0], 2'd0};
      3'b101: p2_data_p_1 <= {p2_data_a_1n_s[27:0], 2'd0};
      3'b110: p2_data_p_1 <= {p2_data_a_1n_s[27:0], 2'd0};
      default: p2_data_p_1 <= 30'd0;
    endcase
    case (p1_data_b[5:3])
      3'b011: p2_data_p_2 <= {p2_data_a_2p_s[25:0], 4'd0};
      3'b100: p2_data_p_2 <= {p2_data_a_2n_s[25:0], 4'd0};
      3'b001: p2_data_p_2 <= {p2_data_a_1p_s[25:0], 4'd0};
      3'b010: p2_data_p_2 <= {p2_data_a_1p_s[25:0], 4'd0};
      3'b101: p2_data_p_2 <= {p2_data_a_1n_s[25:0], 4'd0};
      3'b110: p2_data_p_2 <= {p2_data_a_1n_s[25:0], 4'd0};
      default: p2_data_p_2 <= 30'd0;
    endcase
    case (p1_data_b[7:5])
      3'b011: p2_data_p_3 <= {p2_data_a_2p_s[23:0], 6'd0};
      3'b100: p2_data_p_3 <= {p2_data_a_2n_s[23:0], 6'd0};
      3'b001: p2_data_p_3 <= {p2_data_a_1p_s[23:0], 6'd0};
      3'b010: p2_data_p_3 <= {p2_data_a_1p_s[23:0], 6'd0};
      3'b101: p2_data_p_3 <= {p2_data_a_1n_s[23:0], 6'd0};
      3'b110: p2_data_p_3 <= {p2_data_a_1n_s[23:0], 6'd0};
      default: p2_data_p_3 <= 30'd0;
    endcase
    case (p1_data_b[9:7])
      3'b011: p2_data_p_4 <= {p2_data_a_2p_s[21:0], 8'd0};
      3'b100: p2_data_p_4 <= {p2_data_a_2n_s[21:0], 8'd0};
      3'b001: p2_data_p_4 <= {p2_data_a_1p_s[21:0], 8'd0};
      3'b010: p2_data_p_4 <= {p2_data_a_1p_s[21:0], 8'd0};
      3'b101: p2_data_p_4 <= {p2_data_a_1n_s[21:0], 8'd0};
      3'b110: p2_data_p_4 <= {p2_data_a_1n_s[21:0], 8'd0};
      default: p2_data_p_4 <= 30'd0;
    endcase
    case (p1_data_b[11:9])
      3'b011: p2_data_p_5 <= {p2_data_a_2p_s[19:0], 10'd0};
      3'b100: p2_data_p_5 <= {p2_data_a_2n_s[19:0], 10'd0};
      3'b001: p2_data_p_5 <= {p2_data_a_1p_s[19:0], 10'd0};
      3'b010: p2_data_p_5 <= {p2_data_a_1p_s[19:0], 10'd0};
      3'b101: p2_data_p_5 <= {p2_data_a_1n_s[19:0], 10'd0};
      3'b110: p2_data_p_5 <= {p2_data_a_1n_s[19:0], 10'd0};
      default: p2_data_p_5 <= 30'd0;
    endcase
    case (p1_data_b[13:11])
      3'b011: p2_data_p_6 <= {p2_data_a_2p_s[17:0], 12'd0};
      3'b100: p2_data_p_6 <= {p2_data_a_2n_s[17:0], 12'd0};
      3'b001: p2_data_p_6 <= {p2_data_a_1p_s[17:0], 12'd0};
      3'b010: p2_data_p_6 <= {p2_data_a_1p_s[17:0], 12'd0};
      3'b101: p2_data_p_6 <= {p2_data_a_1n_s[17:0], 12'd0};
      3'b110: p2_data_p_6 <= {p2_data_a_1n_s[17:0], 12'd0};
      default: p2_data_p_6 <= 30'd0;
    endcase
    case (p1_data_b[14:13])
      2'b11: p2_data_p_7 <= {p2_data_a_2p_s[15:0], 14'd0};
      2'b01: p2_data_p_7 <= {p2_data_a_1p_s[15:0], 14'd0};
      2'b10: p2_data_p_7 <= {p2_data_a_1p_s[15:0], 14'd0};
      default: p2_data_p_7 <= 30'd0;
    endcase
  end

  // pipe line stage 3, get the sum of partial products - 8->4

  always @(posedge clk) begin
    p3_ddata <= p2_ddata;
    p3_sign <= p2_sign;
    p3_data_p_0 <= p2_data_p_0 + p2_data_p_4;
    p3_data_p_1 <= p2_data_p_1 + p2_data_p_5;
    p3_data_p_2 <= p2_data_p_2 + p2_data_p_6;
    p3_data_p_3 <= p2_data_p_3 + p2_data_p_7;
  end

  // pipe line stage 4, get the sum of partial products - 4->2

  always @(posedge clk) begin
    p4_ddata <= p3_ddata;
    p4_sign <= p3_sign;
    p4_data_p_0 <= p3_data_p_0 + p3_data_p_2;
    p4_data_p_1 <= p3_data_p_1 + p3_data_p_3;
  end

  // pipe line stage 5, get the sum of partial products - 2->1

  always @(posedge clk) begin
    p5_ddata <= p4_ddata;
    p5_sign <= p4_sign;
    p5_data_p <= p4_data_p_0 + p4_data_p_1;
  end

  // output registers (data is rounded to 16bits)

  assign p6_data_p_0_s = {1'd0, p5_data_p[29:15]};
  assign p6_data_p_1_s = ~p6_data_p_0_s + 1'b1;

  always @(posedge clk) begin
    ddata_out <= p5_ddata;
    if (p5_sign == 1'b1) begin
      data_p <= p6_data_p_1_s;
    end else begin
      data_p <= p6_data_p_0_s;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
