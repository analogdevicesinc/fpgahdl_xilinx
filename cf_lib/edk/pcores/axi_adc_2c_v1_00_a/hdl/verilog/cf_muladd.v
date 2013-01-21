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
// Scale & Offset Module

`timescale 1ps/1ps

module cf_muladd (

  // data_out = (up_muladd_scale * data_in) + up_muladd_offset;

  adc_clk,
  data_in,
  data_out,

  // processor interface

  up_signext_enable,  // sign extension enable
  up_muladd_enable,   // enable offset & scale
  up_muladd_offbin,   // input is offset binary format
  up_muladd_scale,    // scale factor
  up_muladd_offset);  // offset factor

  // data_out = (up_muladd_scale * data_in) + up_muladd_offset;

  input           adc_clk;
  input   [13:0]  data_in;
  output  [15:0]  data_out;

  // processor interface

  input           up_signext_enable;
  input           up_muladd_enable;
  input           up_muladd_offbin;
  input   [15:0]  up_muladd_scale;
  input   [14:0]  up_muladd_offset;

  reg             muladd_enable_m1 = 'd0;
  reg             muladd_enable_m2 = 'd0;
  reg             muladd_enable_m3 = 'd0;
  reg             muladd_enable = 'd0;
  reg             c_offbin = 'd0;
  reg     [15:0]  c_scale = 'd0;
  reg     [15:0]  c_offset = 'd0;
  reg             signext_enable_m1 = 'd0;
  reg             signext_enable = 'd0;
  reg     [13:0]  data_2s = 'd0;
  reg             sign_a = 'd0;
  reg     [12:0]  data_a = 'd0;
  reg             sign_a_d = 'd0;
  reg     [13:0]  data_a_p = 'd0;
  reg     [13:0]  data_a_n = 'd0;
  reg             p1_ddata = 'd0;
  reg     [28:0]  p1_data_p_0 = 'd0;
  reg     [28:0]  p1_data_p_1 = 'd0;
  reg     [28:0]  p1_data_p_2 = 'd0;
  reg     [28:0]  p1_data_p_3 = 'd0;
  reg     [28:0]  p1_data_p_4 = 'd0;
  reg     [28:0]  p1_data_p_5 = 'd0;
  reg     [28:0]  p1_data_p_6 = 'd0;
  reg     [28:0]  p1_data_p_7 = 'd0;
  reg     [28:0]  p1_data_p_8 = 'd0;
  reg             p2_ddata = 'd0;
  reg     [28:0]  p2_data_p_0 = 'd0;
  reg     [28:0]  p2_data_p_1 = 'd0;
  reg     [28:0]  p2_data_p_2 = 'd0;
  reg     [28:0]  p2_data_p_3 = 'd0;
  reg     [28:0]  p2_data_p_4 = 'd0;
  reg             p3_ddata = 'd0;
  reg     [28:0]  p3_data_p_0 = 'd0;
  reg     [28:0]  p3_data_p_1 = 'd0;
  reg     [28:0]  p3_data_p_2 = 'd0;
  reg             p4_ddata = 'd0;
  reg     [28:0]  p4_data_p_0 = 'd0;
  reg     [28:0]  p4_data_p_1 = 'd0;
  reg             p5_ddata = 'd0;
  reg     [28:0]  p5_data_p = 'd0;
  reg     [15:0]  p6_data_p = 'd0;
  reg     [15:0]  p7_data_p = 'd0;
  reg     [15:0]  data_out = 'd0;

  wire    [12:0]  data_2s_n_s;
  wire    [13:0]  data_a_s;
  wire    [28:0]  p1_data_a_1p_s;
  wire    [28:0]  p1_data_a_1n_s;
  wire    [28:0]  p1_data_a_2p_s;
  wire    [28:0]  p1_data_a_2n_s;
  wire    [15:0]  p6_data_p_s;
  wire    [15:0]  p6_data_n_s;

  // transfer processor signals to the adc clock domain

  always @(posedge adc_clk) begin
    muladd_enable_m1 <= up_muladd_enable;
    muladd_enable_m2 <= muladd_enable_m1;
    muladd_enable_m3 <= muladd_enable_m2;
    muladd_enable <= muladd_enable_m3;
    if ((muladd_enable_m2 == 1'b1) && (muladd_enable_m3 == 1'b0)) begin
      c_offbin <= up_muladd_offbin;
      c_scale <= up_muladd_scale;
      c_offset <= {up_muladd_offset[14], up_muladd_offset[14:0]};
    end
    signext_enable_m1 <= up_signext_enable;
    signext_enable <= signext_enable_m1;
  end

  // if offset binary, get 2's complement, convert to signed

  assign data_2s_n_s = ~data_2s[12:0] + 1'b1;
  assign data_a_s = {1'b0, data_a};

  always @(posedge adc_clk) begin
    if (c_offbin == 1'b1) begin
      data_2s <= data_in + 14'h2000;
    end else begin
      data_2s <= data_in;
    end
    sign_a <= data_2s[13];
    data_a <= (data_2s[13] == 1'b1) ? data_2s_n_s : data_2s[12:0];
    sign_a_d <= sign_a;
    data_a_p <= data_a_s;
    data_a_n <= ~data_a_s + 1'b1;
  end

  // get the partial product inputs

  assign p1_data_a_1p_s = {{15{data_a_p[13]}}, data_a_p};
  assign p1_data_a_1n_s = {{15{data_a_n[13]}}, data_a_n};
  assign p1_data_a_2p_s = {{14{data_a_p[13]}}, data_a_p, 1'b0};
  assign p1_data_a_2n_s = {{14{data_a_n[13]}}, data_a_n, 1'b0};

  // pipe line 1, get the partial products

  always @(posedge adc_clk) begin
    p1_ddata <= sign_a_d;
    case (c_scale[1:0])
      2'b11: p1_data_p_0 <= p1_data_a_1n_s;
      2'b10: p1_data_p_0 <= p1_data_a_2n_s;
      2'b01: p1_data_p_0 <= p1_data_a_1p_s;
      default: p1_data_p_0 <= 29'd0;
    endcase
    case (c_scale[3:1])
      3'b011: p1_data_p_1 <= {p1_data_a_2p_s[26:0], 2'd0};
      3'b100: p1_data_p_1 <= {p1_data_a_2n_s[26:0], 2'd0};
      3'b001: p1_data_p_1 <= {p1_data_a_1p_s[26:0], 2'd0};
      3'b010: p1_data_p_1 <= {p1_data_a_1p_s[26:0], 2'd0};
      3'b101: p1_data_p_1 <= {p1_data_a_1n_s[26:0], 2'd0};
      3'b110: p1_data_p_1 <= {p1_data_a_1n_s[26:0], 2'd0};
      default: p1_data_p_1 <= 29'd0;
    endcase
    case (c_scale[5:3])
      3'b011: p1_data_p_2 <= {p1_data_a_2p_s[24:0], 4'd0};
      3'b100: p1_data_p_2 <= {p1_data_a_2n_s[24:0], 4'd0};
      3'b001: p1_data_p_2 <= {p1_data_a_1p_s[24:0], 4'd0};
      3'b010: p1_data_p_2 <= {p1_data_a_1p_s[24:0], 4'd0};
      3'b101: p1_data_p_2 <= {p1_data_a_1n_s[24:0], 4'd0};
      3'b110: p1_data_p_2 <= {p1_data_a_1n_s[24:0], 4'd0};
      default: p1_data_p_2 <= 29'd0;
    endcase
    case (c_scale[7:5])
      3'b011: p1_data_p_3 <= {p1_data_a_2p_s[22:0], 6'd0};
      3'b100: p1_data_p_3 <= {p1_data_a_2n_s[22:0], 6'd0};
      3'b001: p1_data_p_3 <= {p1_data_a_1p_s[22:0], 6'd0};
      3'b010: p1_data_p_3 <= {p1_data_a_1p_s[22:0], 6'd0};
      3'b101: p1_data_p_3 <= {p1_data_a_1n_s[22:0], 6'd0};
      3'b110: p1_data_p_3 <= {p1_data_a_1n_s[22:0], 6'd0};
      default: p1_data_p_3 <= 29'd0;
    endcase
    case (c_scale[9:7])
      3'b011: p1_data_p_4 <= {p1_data_a_2p_s[20:0], 8'd0};
      3'b100: p1_data_p_4 <= {p1_data_a_2n_s[20:0], 8'd0};
      3'b001: p1_data_p_4 <= {p1_data_a_1p_s[20:0], 8'd0};
      3'b010: p1_data_p_4 <= {p1_data_a_1p_s[20:0], 8'd0};
      3'b101: p1_data_p_4 <= {p1_data_a_1n_s[20:0], 8'd0};
      3'b110: p1_data_p_4 <= {p1_data_a_1n_s[20:0], 8'd0};
      default: p1_data_p_4 <= 29'd0;
    endcase
    case (c_scale[11:9])
      3'b011: p1_data_p_5 <= {p1_data_a_2p_s[18:0], 10'd0};
      3'b100: p1_data_p_5 <= {p1_data_a_2n_s[18:0], 10'd0};
      3'b001: p1_data_p_5 <= {p1_data_a_1p_s[18:0], 10'd0};
      3'b010: p1_data_p_5 <= {p1_data_a_1p_s[18:0], 10'd0};
      3'b101: p1_data_p_5 <= {p1_data_a_1n_s[18:0], 10'd0};
      3'b110: p1_data_p_5 <= {p1_data_a_1n_s[18:0], 10'd0};
      default: p1_data_p_5 <= 29'd0;
    endcase
    case (c_scale[13:11])
      3'b011: p1_data_p_6 <= {p1_data_a_2p_s[16:0], 12'd0};
      3'b100: p1_data_p_6 <= {p1_data_a_2n_s[16:0], 12'd0};
      3'b001: p1_data_p_6 <= {p1_data_a_1p_s[16:0], 12'd0};
      3'b010: p1_data_p_6 <= {p1_data_a_1p_s[16:0], 12'd0};
      3'b101: p1_data_p_6 <= {p1_data_a_1n_s[16:0], 12'd0};
      3'b110: p1_data_p_6 <= {p1_data_a_1n_s[16:0], 12'd0};
      default: p1_data_p_6 <= 29'd0;
    endcase
    case (c_scale[15:13])
      3'b011: p1_data_p_7 <= {p1_data_a_2p_s[14:0], 14'd0};
      3'b100: p1_data_p_7 <= {p1_data_a_2n_s[14:0], 14'd0};
      3'b001: p1_data_p_7 <= {p1_data_a_1p_s[14:0], 14'd0};
      3'b010: p1_data_p_7 <= {p1_data_a_1p_s[14:0], 14'd0};
      3'b101: p1_data_p_7 <= {p1_data_a_1n_s[14:0], 14'd0};
      3'b110: p1_data_p_7 <= {p1_data_a_1n_s[14:0], 14'd0};
      default: p1_data_p_7 <= 29'd0;
    endcase
    case (c_scale[15])
      1'b1: p1_data_p_8 <= {p1_data_a_1p_s[12:0], 16'd0};
      default: p1_data_p_8 <= 29'd0;
    endcase
  end

  // pipe line 2, sum of the partial products (9 -> 5)

  always @(posedge adc_clk) begin
    p2_ddata <= p1_ddata;
    p2_data_p_0 <= p1_data_p_0 + p1_data_p_5;
    p2_data_p_1 <= p1_data_p_1 + p1_data_p_6;
    p2_data_p_2 <= p1_data_p_2 + p1_data_p_7;
    p2_data_p_3 <= p1_data_p_3 + p1_data_p_8;
    p2_data_p_4 <= p1_data_p_4;
  end

  // pipe line 3, sum of the partial products (5 -> 3)

  always @(posedge adc_clk) begin
    p3_ddata <= p2_ddata;
    p3_data_p_0 <= p2_data_p_0 + p2_data_p_3;
    p3_data_p_1 <= p2_data_p_1 + p2_data_p_4;
    p3_data_p_2 <= p2_data_p_2;
  end

  // pipe line 4, sum of the partial products (3 -> 2)

  always @(posedge adc_clk) begin
    p4_ddata <= p3_ddata;
    p4_data_p_0 <= p3_data_p_0 + p3_data_p_2;
    p4_data_p_1 <= p3_data_p_1;
  end

  // pipe line 5, sum of the partial products (2 -> 1)

  always @(posedge adc_clk) begin
    p5_ddata <= p4_ddata;
    p5_data_p <= p4_data_p_0 + p4_data_p_1;
  end

  // pipe line 6, convert back to 2's compl

  assign p6_data_p_s = {2'b00, p5_data_p[28:15]};
  assign p6_data_n_s = ~p6_data_p_s + 1'b1;

  always @(posedge adc_clk) begin
    if (p5_ddata == 1'b1) begin
      p6_data_p <= p6_data_n_s;
    end else begin
      p6_data_p <= p6_data_p_s;
    end
  end

  always @(posedge adc_clk) begin
    p7_data_p <= p6_data_p + c_offset;
  end

  // output registers 

  always @(posedge adc_clk) begin
    if (muladd_enable == 1'b1) begin
      data_out <= p7_data_p;
    end else if (signext_enable == 1'b1) begin
      data_out <= {{2{data_in[13]}}, data_in};
    end else begin
      data_out <= {2'd0, data_in};
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
