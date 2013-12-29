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

module cf_iqcor (

  // data interface

  clk,
  data_i,
  data_q,
  data_cor_i,
  data_cor_q,

  // processor interface

  up_iqcor_enable,
  up_iqcor_scale_ii,
  up_iqcor_scale_iq,
  up_iqcor_scale_qi,
  up_iqcor_scale_qq,
  up_iqcor_offset_i,
  up_iqcor_offset_q);

  // data interface

  input           clk;
  input   [15:0]  data_i;
  input   [15:0]  data_q;
  output  [15:0]  data_cor_i;
  output  [15:0]  data_cor_q;

  // processor interface

  input           up_iqcor_enable;
  input   [15:0]  up_iqcor_scale_ii;
  input   [15:0]  up_iqcor_scale_iq;
  input   [15:0]  up_iqcor_scale_qi;
  input   [15:0]  up_iqcor_scale_qq;
  input   [15:0]  up_iqcor_offset_i;
  input   [15:0]  up_iqcor_offset_q;

  // internal registers

  reg             iqcor_enable_m1 = 'd0;
  reg             iqcor_enable_m2 = 'd0;
  reg             iqcor_enable_m3 = 'd0;
  reg             iqcor_enable = 'd0;
  reg     [15:0]  iqcor_scale_ii = 'd0;
  reg     [15:0]  iqcor_scale_iq = 'd0;
  reg     [15:0]  iqcor_scale_qi = 'd0;
  reg     [15:0]  iqcor_scale_qq = 'd0;
  reg     [15:0]  iqcor_offset_i = 'd0;
  reg     [15:0]  iqcor_offset_q = 'd0;

  // processor signals in the data clock domain

  always @(posedge clk) begin
    iqcor_enable_m1 <= up_iqcor_enable;
    iqcor_enable_m2 <= iqcor_enable_m1;
    iqcor_enable_m3 <= iqcor_enable_m2;
    iqcor_enable <= iqcor_enable_m3;
    if ((iqcor_enable_m3 == 1'b0) && (iqcor_enable_m2 == 1'b1)) begin
      iqcor_scale_ii <= up_iqcor_scale_ii;
      iqcor_scale_iq <= up_iqcor_scale_iq;
      iqcor_scale_qi <= up_iqcor_scale_qi;
      iqcor_scale_qq <= up_iqcor_scale_qq;
      iqcor_offset_i <= up_iqcor_offset_i;
      iqcor_offset_q <= up_iqcor_offset_q;
    end
  end

  // correction modules - i

  cf_iqcor_1 #(.IQSEL(0)) i_iqcor_1_i (
    .clk (clk),
    .data_i (data_i),
    .data_q (data_q),
    .data_cor (data_cor_i),
    .iqcor_enable (iqcor_enable),
    .iqcor_scale_i (iqcor_scale_ii),
    .iqcor_scale_q (iqcor_scale_iq),
    .iqcor_offset_i (iqcor_offset_i),
    .iqcor_offset_q (iqcor_offset_q));

  // correction modules - q

  cf_iqcor_1 #(.IQSEL(1)) i_iqcor_1_q (
    .clk (clk),
    .data_i (data_i),
    .data_q (data_q),
    .data_cor (data_cor_q),
    .iqcor_enable (iqcor_enable),
    .iqcor_scale_i (iqcor_scale_qi),
    .iqcor_scale_q (iqcor_scale_qq),
    .iqcor_offset_i (iqcor_offset_i),
    .iqcor_offset_q (iqcor_offset_q));

endmodule

// ***************************************************************************
// ***************************************************************************
