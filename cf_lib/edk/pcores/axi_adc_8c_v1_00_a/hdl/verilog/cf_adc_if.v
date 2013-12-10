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
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module cf_adc_if (

  // adc interface

  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_frame_p,
  adc_frame_n,

  // data and status signals

  adc_clk,
  adc_valid,
  adc_data,
  adc_err,
  adc_pn_oos,
  adc_pn_err,

  // processor signals

  up_serdes_preset,
  up_pn_type,

  // monitor signals

  adc_mon_valid,
  adc_mon_data);

  // adc interface

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [ 7:0]  adc_data_in_p;
  input   [ 7:0]  adc_data_in_n;
  input           adc_frame_p;
  input           adc_frame_n;

  // data and status signals

  output          adc_clk;
  output          adc_valid;
  output  [63:0]  adc_data;
  output          adc_err;
  output  [ 7:0]  adc_pn_oos;
  output  [ 7:0]  adc_pn_err;

  // processor signals

  input           up_serdes_preset;
  input   [ 7:0]  up_pn_type;

  // monitor signals

  output          adc_mon_valid;
  output [143:0]  adc_mon_data;

  reg             adc_valid = 'd0;
  reg             adc_datasel = 'd0;
  reg     [ 5:0]  adc_frame_serdes = 'd0;
  reg     [ 5:0]  adc_frame_serdes_d = 'd0;
  reg     [11:0]  adc_frame = 'd0;
  reg     [ 3:0]  adc_bitsel = 'd0;
  reg     [63:0]  adc_data = 'd0;
  reg     [ 4:0]  adc_err_count = 'd0;
  reg             adc_err = 'd0;

  wire            adc_err_s;
  wire    [11:0]  adc_frame_s;
  wire    [11:0]  adc_data_s[7:0];
  wire            adc_rst_s;
  wire            adc_frame_ibuf_s;
  wire    [ 5:0]  adc_frame_serdes_s;
  wire            adc_clk_in_ibuf_s;
  wire            adc_clk_in;

  genvar          l_inst;

  // monitor signals

  assign adc_mon_valid = adc_datasel;

  assign adc_mon_data[143:128] = {4'd0, adc_frame};
  assign adc_mon_data[127:112] = {4'd0, adc_data_s[7]};
  assign adc_mon_data[111: 96] = {4'd0, adc_data_s[6]};
  assign adc_mon_data[ 95: 80] = {4'd0, adc_data_s[5]};
  assign adc_mon_data[ 79: 64] = {4'd0, adc_data_s[4]};
  assign adc_mon_data[ 63: 48] = {4'd0, adc_data_s[3]};
  assign adc_mon_data[ 47: 32] = {4'd0, adc_data_s[2]};
  assign adc_mon_data[ 31: 16] = {4'd0, adc_data_s[1]};
  assign adc_mon_data[ 15:  0] = {4'd0, adc_data_s[0]};

  // the frame signal is used to align the inidivual adc channels- a bit select
  // shifts the bits within the serial to parallel data so that the channels
  // are aligned to the frame signal-  an error is generated if the recovered
  // frame shifts around a captured position-

  assign adc_err_s = (adc_frame == adc_frame_s) ? ~adc_datasel : adc_datasel;
  assign adc_frame_s = {adc_frame_serdes_d, adc_frame_serdes};

  always @(posedge adc_clk) begin
    adc_valid <= 1'b1;
    adc_datasel <= ~adc_datasel;
    adc_frame_serdes <= adc_frame_serdes_s;
    adc_frame_serdes_d <= adc_frame_serdes;
    if (adc_datasel == 1'b1) begin
      adc_frame <= adc_frame_s;
    end
    case (adc_frame)
      12'b111111000000: adc_bitsel <= 4'h0;
      12'b011111100000: adc_bitsel <= 4'h1;
      12'b001111110000: adc_bitsel <= 4'h2;
      12'b000111111000: adc_bitsel <= 4'h3;
      12'b000011111100: adc_bitsel <= 4'h4;
      12'b000001111110: adc_bitsel <= 4'h5;
      12'b000000111111: adc_bitsel <= 4'h6;
      12'b100000011111: adc_bitsel <= 4'h7;
      12'b110000001111: adc_bitsel <= 4'h8;
      12'b111000000111: adc_bitsel <= 4'h9;
      12'b111100000011: adc_bitsel <= 4'ha;
      12'b111110000001: adc_bitsel <= 4'hb;
      default: adc_bitsel <= 4'hf;
    endcase
    if (adc_datasel == 1'b1) begin
      adc_data[63:48] <= {4'd0, adc_data_s[7]};
      adc_data[47:32] <= {4'd0, adc_data_s[6]};
      adc_data[31:16] <= {4'd0, adc_data_s[5]};
      adc_data[15: 0] <= {4'd0, adc_data_s[4]};
    end else begin
      adc_data[63:48] <= {4'd0, adc_data_s[3]};
      adc_data[47:32] <= {4'd0, adc_data_s[2]};
      adc_data[31:16] <= {4'd0, adc_data_s[1]};
      adc_data[15: 0] <= {4'd0, adc_data_s[0]};
    end
    if (adc_err_s == 1'b1) begin
      adc_err_count <= 5'h10;
    end else if (adc_err_count[4] == 1'b1) begin
      adc_err_count <= adc_err_count + 1'b1;
    end
    adc_err <= adc_err_count[4];
  end

  // the individual adc channel interface- the individual bit alignments
  // are controlled by the common frame signal-

  generate
  for (l_inst = 0; l_inst <= 7; l_inst = l_inst + 1) begin : g_adc_if
  cf_adc_if_1 i_adc_if_1 (
    .adc_data_in_p (adc_data_in_p[l_inst]),
    .adc_data_in_n (adc_data_in_n[l_inst]),
    .adc_clk_in (adc_clk_in),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst_s),
    .adc_datasel (adc_datasel),
    .adc_bitsel (adc_bitsel),
    .adc_pn_oos (adc_pn_oos[l_inst]),
    .adc_pn_err (adc_pn_err[l_inst]),
    .adc_data (adc_data_s[l_inst]),
    .up_pn_type (up_pn_type[l_inst]));
  end
  endgenerate

  // the serdes needs a reset- this is used for the high speed to low speed data
  // transition - the serial to parallel bit counter resets

  FDPE #(.INIT(1'b1)) i_serdes_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (up_serdes_preset),
    .C (adc_clk),
    .Q (adc_rst_s));

  // frame input buffer and iserdes

  IBUFDS i_frame_ibuf (
    .I (adc_frame_p),
    .IB (adc_frame_n),
    .O (adc_frame_ibuf_s));

  ISERDESE1 # (
    .DATA_RATE ("DDR"),
    .DATA_WIDTH (6),
    .INTERFACE_TYPE ("NETWORKING"), 
    .DYN_CLKDIV_INV_EN ("FALSE"),
    .DYN_CLK_INV_EN ("FALSE"),
    .NUM_CE (2),
    .OFB_USED ("FALSE"),
    .IOBDELAY ("NONE"),
    .SERDES_MODE ("MASTER"))
  i_frame_serdes (
    .Q1 (adc_frame_serdes_s[0]),
    .Q2 (adc_frame_serdes_s[1]),
    .Q3 (adc_frame_serdes_s[2]),
    .Q4 (adc_frame_serdes_s[3]),
    .Q5 (adc_frame_serdes_s[4]),
    .Q6 (adc_frame_serdes_s[5]),
    .SHIFTOUT1 (),
    .SHIFTOUT2 (),
    .BITSLIP (1'b0),
    .CE1 (1'b1),
    .CE2 (1'b1),
    .CLK (adc_clk_in),
    .CLKB (~adc_clk_in),
    .CLKDIV (adc_clk),
    .D (adc_frame_ibuf_s),
    .DDLY (1'b0),
    .RST (adc_rst_s),
    .SHIFTIN1 (1'b0),
    .SHIFTIN2 (1'b0),
    .DYNCLKDIVSEL (1'b0),
    .DYNCLKSEL (1'b0),
    .OFB (1'b0),
    .OCLK (1'b0),
    .O ());

  // raw and divided clock bufio/bufr pair-

  IBUFGDS i_clk_ibuf (
    .I (adc_clk_in_p),
    .IB (adc_clk_in_n),
    .O (adc_clk_in_ibuf_s));

  BUFIO i_clk_gbuf (
    .I (adc_clk_in_ibuf_s),
    .O (adc_clk_in));

  BUFR #( .BUFR_DIVIDE ("3")) i_clk_rbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (adc_clk_in_ibuf_s),
    .O (adc_clk));

endmodule

// ***************************************************************************
// ***************************************************************************

