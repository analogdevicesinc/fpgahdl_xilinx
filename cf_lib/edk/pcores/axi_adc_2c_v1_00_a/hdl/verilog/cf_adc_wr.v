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

module cf_adc_wr (

  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_data_or_p,
  adc_data_or_n,

  adc_clk,
  adc_valid,
  adc_data,
  adc_or,
  adc_pn_oos,
  adc_pn_err,

  up_signext_enable,
  up_muladd_enable,
  up_muladd_offbin,
  up_muladd_scale_a,
  up_muladd_offset_a,
  up_muladd_scale_b,
  up_muladd_offset_b,
  up_pn_type,
  up_dmode,
  up_ch_sel,
  up_delay_sel,
  up_delay_rwn,
  up_delay_addr,
  up_delay_wdata,

  delay_clk,
  delay_ack,
  delay_rdata,
  delay_locked,

  debug_data,
  debug_trigger,

  adc_mon_valid,
  adc_mon_data);

  parameter C_CF_BUFTYPE = 0;
  parameter C_IODELAY_GROUP = "adc_if_delay_group";

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [13:0]  adc_data_in_p;
  input   [13:0]  adc_data_in_n;
  input           adc_data_or_p;
  input           adc_data_or_n;

  output          adc_clk;
  output          adc_valid;
  output  [63:0]  adc_data;
  output  [ 1:0]  adc_or;
  output  [ 1:0]  adc_pn_oos;
  output  [ 1:0]  adc_pn_err;

  input           up_signext_enable;
  input           up_muladd_enable;
  input           up_muladd_offbin;
  input   [15:0]  up_muladd_scale_a;
  input   [14:0]  up_muladd_offset_a;
  input   [15:0]  up_muladd_scale_b;
  input   [14:0]  up_muladd_offset_b;
  input   [ 1:0]  up_pn_type;
  input   [ 1:0]  up_dmode;
  input   [ 1:0]  up_ch_sel;
  input           up_delay_sel;
  input           up_delay_rwn;
  input   [ 3:0]  up_delay_addr;
  input   [ 4:0]  up_delay_wdata;

  input           delay_clk;
  output          delay_ack;
  output  [ 4:0]  delay_rdata;
  output          delay_locked;

  output  [63:0]  debug_data;
  output  [ 7:0]  debug_trigger;

  output          adc_mon_valid;
  output  [31:0]  adc_mon_data;

  reg     [ 1:0]  adc_ch_sel_m1 = 'd0;
  reg     [ 1:0]  adc_ch_sel = 'd0;
  reg     [ 1:0]  adc_cnt = 'd0;
  reg             adc_valid = 'd0;
  reg     [63:0]  adc_data = 'd0;

  wire    [15:0]  adc_data_a_s;
  wire    [15:0]  adc_data_b_s;
  wire    [13:0]  adc_data_a_if_s;
  wire    [13:0]  adc_data_b_if_s;

  assign adc_mon_valid = 1'b1;
  assign adc_mon_data = {adc_data_b_s, adc_data_a_s};

  always @(posedge adc_clk) begin
    adc_ch_sel_m1 <= up_ch_sel;
    adc_ch_sel <= adc_ch_sel_m1;
    adc_cnt <= adc_cnt + 1'b1;
    case (adc_ch_sel)
      2'b11: begin
        adc_valid <= adc_cnt[0];
        adc_data <= {adc_data_a_s, adc_data_b_s, adc_data[63:32]};
      end
      2'b10: begin
        adc_valid <= adc_cnt[1] & adc_cnt[0];
        adc_data <= {adc_data_b_s, adc_data[63:16]};
      end
      2'b01: begin
        adc_valid <= adc_cnt[1] & adc_cnt[0];
        adc_data <= {adc_data_a_s, adc_data[63:16]};
      end
      default: begin
        adc_valid <= adc_cnt[0];
        adc_data <= 64'd0;
      end
    endcase
  end

  cf_pnmon i_pnmon_a (
    .adc_clk (adc_clk),
    .adc_data (adc_data_a_if_s),
    .adc_pn_oos (adc_pn_oos[0]),
    .adc_pn_err (adc_pn_err[0]),
    .up_pn_type (up_pn_type[0]));

  cf_muladd i_muladd_a (
    .adc_clk (adc_clk),
    .data_in (adc_data_a_if_s),
    .data_out (adc_data_a_s),
    .up_signext_enable (up_signext_enable),
    .up_muladd_enable (up_muladd_enable),
    .up_muladd_offbin (up_muladd_offbin),
    .up_muladd_scale (up_muladd_scale_a),
    .up_muladd_offset (up_muladd_offset_a));

  cf_pnmon i_pnmon_b (
    .adc_clk (adc_clk),
    .adc_data (adc_data_b_if_s),
    .adc_pn_oos (adc_pn_oos[1]),
    .adc_pn_err (adc_pn_err[1]),
    .up_pn_type (up_pn_type[1]));

  cf_muladd i_muladd_b (
    .adc_clk (adc_clk),
    .data_in (adc_data_b_if_s),
    .data_out (adc_data_b_s),
    .up_signext_enable (up_signext_enable),
    .up_muladd_enable (up_muladd_enable),
    .up_muladd_offbin (up_muladd_offbin),
    .up_muladd_scale (up_muladd_scale_b),
    .up_muladd_offset (up_muladd_offset_b));

  cf_adc_if #(.C_CF_BUFTYPE (C_CF_BUFTYPE), .C_IODELAY_GROUP(C_IODELAY_GROUP)) i_adc_if (
    .adc_clk_in_p (adc_clk_in_p),
    .adc_clk_in_n (adc_clk_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_data_in_n (adc_data_in_n),
    .adc_data_or_p (adc_data_or_p),
    .adc_data_or_n (adc_data_or_n),
    .adc_clk (adc_clk),
    .adc_data_a (adc_data_a_if_s),
    .adc_data_b (adc_data_b_if_s),
    .adc_or (adc_or),
    .up_dmode (up_dmode),
    .up_delay_sel (up_delay_sel),
    .up_delay_rwn (up_delay_rwn),
    .up_delay_addr (up_delay_addr),
    .up_delay_wdata (up_delay_wdata),
    .delay_clk (delay_clk),
    .delay_ack (delay_ack),
    .delay_rdata (delay_rdata),
    .delay_locked (delay_locked));

endmodule

// ***************************************************************************
// ***************************************************************************

