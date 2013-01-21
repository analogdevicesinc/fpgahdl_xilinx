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
// This is a single sample interpolator.

module cf_ddsv_intp_1 (

  // data_s0 = delayed(data_a);
  // data_s1 = scale_a * data_a + scale_b * data_b;

  clk,
  data_a,
  data_b,
  scale_a,
  scale_b,
  data_s0,
  data_s1);

  // data_s0 = delayed(data_a);
  // data_s1 = scale_a * data_a + scale_b * data_b;

  input           clk;
  input   [15:0]  data_a;
  input   [15:0]  data_b;
  input   [15:0]  scale_a;
  input   [15:0]  scale_b;
  output  [15:0]  data_s0;
  output  [15:0]  data_s1;

  reg     [15:0]  data_a_delay = 'd0;
  reg     [15:0]  data_p = 'd0;
  reg     [15:0]  data_s0 = 'd0;
  reg     [15:0]  data_s1 = 'd0;

  wire    [15:0]  data_a_p_s;
  wire    [15:0]  data_b_p_s;
  wire    [15:0]  data_a_delay_s;

  // output registers (sum of products)

  always @(posedge clk) begin
    data_a_delay <= data_a_delay_s;
    data_p <= data_a_p_s + data_b_p_s;
    data_s0 <= data_a_delay;
    data_s1 <= data_p;
  end

  // product term 1, scale_a * data_a;

  cf_muls #(.DELAY_DATA_WIDTH(16)) i_mul_a (
    .clk (clk),
    .data_a (data_a),
    .data_b (scale_a),
    .data_p (data_a_p_s),
    .ddata_in (data_a),
    .ddata_out (data_a_delay_s));

  // product term 2, scale_b * data_b;

  cf_muls #(.DELAY_DATA_WIDTH(1)) i_mul_b (
    .clk (clk),
    .data_a (data_b),
    .data_b (scale_b),
    .data_p (data_b_p_s),
    .ddata_in (1'b0),
    .ddata_out ());

endmodule

// ***************************************************************************
// ***************************************************************************
