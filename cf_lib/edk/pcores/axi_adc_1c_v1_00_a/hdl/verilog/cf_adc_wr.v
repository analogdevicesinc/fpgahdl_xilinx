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

  // adc interface (clk, data, over-range)
  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_data_or_p,
  adc_data_or_n,

  // interface outputs
  adc_clk,
  adc_valid,
  adc_data,
  adc_or,
  adc_pn_oos,
  adc_pn_err,

  // processor control signals
  up_pn_type,
  up_dmode,
  up_delay_sel,
  up_delay_rwn,
  up_delay_addr,
  up_delay_wdata,

  // delay control signals
  delay_clk,
  delay_ack,
  delay_rdata,
  delay_locked,

  // adc debug and monitor signals (for chipscope)
  adc_mon_valid,
  adc_mon_data);

  // This parameter controls the buffer type based on the target device.
  parameter C_CF_BUFTYPE = 0;

  // adc interface (clk, data, over-range)
  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [ 7:0]  adc_data_in_p;
  input   [ 7:0]  adc_data_in_n;
  input           adc_data_or_p;
  input           adc_data_or_n;

  // interface outputs
  output          adc_clk;
  output          adc_valid;
  output  [63:0]  adc_data;
  output          adc_or;
  output          adc_pn_oos;
  output          adc_pn_err;

  // processor control signals
  input           up_pn_type;
  input           up_dmode;
  input           up_delay_sel;
  input           up_delay_rwn;
  input   [ 3:0]  up_delay_addr;
  input   [ 4:0]  up_delay_wdata;

  // delay control signals
  input           delay_clk;
  output          delay_ack;
  output  [ 4:0]  delay_rdata;
  output          delay_locked;

  // adc debug and monitor signals (for chipscope)
  output          adc_mon_valid;
  output  [15:0]  adc_mon_data;

  reg     [ 1:0]  adc_count = 'd0;
  reg             adc_valid = 'd0;
  reg     [63:0]  adc_data = 'd0;

  wire    [15:0]  adc_data_if_s;

  assign adc_mon_valid = 1'b1;
  assign adc_mon_data = adc_data_if_s;

  always @(posedge adc_clk) begin
    adc_count <= adc_count + 1'b1;
    adc_valid <= adc_count[0] & adc_count[1];
    adc_data <= {adc_data_if_s, adc_data[63:16]};
  end

  // PN sequence monitor
  cf_pnmon i_pnmon_a (
    .adc_clk (adc_clk),
    .adc_data (adc_data_if_s),
    .adc_pn_oos (adc_pn_oos),
    .adc_pn_err (adc_pn_err),
    .up_pn_type (up_pn_type));

  // ADC data interface
  cf_adc_if #(.C_CF_BUFTYPE (C_CF_BUFTYPE)) i_adc_if (
    .adc_clk_in_p (adc_clk_in_p),
    .adc_clk_in_n (adc_clk_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_data_in_n (adc_data_in_n),
    .adc_data_or_p (adc_data_or_p),
    .adc_data_or_n (adc_data_or_n),
    .adc_clk (adc_clk),
    .adc_data (adc_data_if_s),
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

