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
// dds data to samples conversion

module cf_ddsv_intp (

  dac_div3_clk,
  dds_rd,
  dds_rdata,
  dds_data_00,
  dds_data_01,
  dds_data_02,
  dds_data_10,
  dds_data_11,
  dds_data_12,

  up_intp_enable,
  up_intp_scale_a,
  up_intp_scale_b,

  dac_dbg_data,
  dac_dbg_trigger);

  input           dac_div3_clk;
  output          dds_rd;
  input   [95:0]  dds_rdata;
  output  [15:0]  dds_data_00;
  output  [15:0]  dds_data_01;
  output  [15:0]  dds_data_02;
  output  [15:0]  dds_data_10;
  output  [15:0]  dds_data_11;
  output  [15:0]  dds_data_12;

  input           up_intp_enable;
  input   [15:0]  up_intp_scale_a;
  input   [15:0]  up_intp_scale_b;

  output  [195:0] dac_dbg_data;
  output  [ 7:0]  dac_dbg_trigger;

  reg             dds_intp_enable_m1 = 'd0;
  reg             dds_intp_enable_m2 = 'd0;
  reg             dds_intp_enable_m3 = 'd0;
  reg             dds_intp_enable = 'd0;
  reg     [15:0]  dds_intp_scale_a = 'd0;
  reg     [15:0]  dds_intp_scale_b = 'd0;
  reg     [ 1:0]  dds_rd_cnt = 'd0;
  reg             dds_rd = 'd0;
  reg     [15:0]  dds_rdata_00 = 'd0;
  reg     [15:0]  dds_rdata_01 = 'd0;
  reg     [15:0]  dds_rdata_02 = 'd0;
  reg     [15:0]  dds_rdata_10 = 'd0;
  reg     [15:0]  dds_rdata_11 = 'd0;
  reg     [15:0]  dds_rdata_12 = 'd0;
  reg     [15:0]  dds_data_0 = 'd0;
  reg     [15:0]  dds_data_1 = 'd0;
  reg     [15:0]  dds_data_0_d = 'd0;
  reg     [15:0]  dds_data_1_d = 'd0;
  reg     [15:0]  dds_data_00 = 'd0;
  reg     [15:0]  dds_data_01 = 'd0;
  reg     [15:0]  dds_data_02 = 'd0;
  reg     [15:0]  dds_data_10 = 'd0;
  reg     [15:0]  dds_data_11 = 'd0;
  reg     [15:0]  dds_data_12 = 'd0;

  wire    [15:0]  dds_idata_00_s;
  wire    [15:0]  dds_idata_01_s;
  wire    [15:0]  dds_idata_02_s;
  wire    [15:0]  dds_idata_10_s;
  wire    [15:0]  dds_idata_11_s;
  wire    [15:0]  dds_idata_12_s;

  assign dac_dbg_trigger[7:4] = 'd0;
  assign dac_dbg_trigger[3:3] = dds_intp_enable;
  assign dac_dbg_trigger[2:2] = dds_rd;
  assign dac_dbg_trigger[1:0] = dds_rd_cnt;

  assign dac_dbg_data[195:195] = dds_intp_enable;
  assign dac_dbg_data[194:194] = dds_rd;
  assign dac_dbg_data[193:192] = dds_rd_cnt;
  assign dac_dbg_data[191:176] = dds_data_12;
  assign dac_dbg_data[175:160] = dds_data_11;
  assign dac_dbg_data[159:144] = dds_data_10;
  assign dac_dbg_data[143:128] = dds_data_02;
  assign dac_dbg_data[127:112] = dds_data_01;
  assign dac_dbg_data[111: 96] = dds_data_00;
  assign dac_dbg_data[ 95:  0] = dds_rdata;

  always @(posedge dac_div3_clk) begin
    dds_intp_enable_m1 <= up_intp_enable;
    dds_intp_enable_m2 <= dds_intp_enable_m1;
    dds_intp_enable_m3 <= dds_intp_enable_m2;
    dds_intp_enable <= dds_intp_enable_m3;
    if ((dds_intp_enable_m2 == 1'b1) && (dds_intp_enable_m3 == 1'b0)) begin
      dds_intp_scale_a <= up_intp_scale_a;
      dds_intp_scale_b <= up_intp_scale_b;
    end
  end

  always @(posedge dac_div3_clk) begin
    if (dds_rd_cnt >= 2'b10) begin
      dds_rd_cnt <= 2'b00;
      dds_rd <= 1'b1;
    end else begin
      dds_rd_cnt <= dds_rd_cnt + 1'b1;
      dds_rd <= ~dds_intp_enable;
    end
    if (dds_rd == 1'b1) begin
      dds_rdata_00 <= dds_rdata[95:80];
      dds_rdata_01 <= dds_rdata[63:48];
      dds_rdata_02 <= dds_rdata[31:16];
      dds_rdata_10 <= dds_rdata[79:64];
      dds_rdata_11 <= dds_rdata[47:32];
      dds_rdata_12 <= dds_rdata[15: 0];
    end
    case (dds_rd_cnt)
      2'b01: begin
        dds_data_0 <= dds_rdata_00;
        dds_data_1 <= dds_rdata_10;
      end
      2'b10: begin
        dds_data_0 <= dds_rdata_01;
        dds_data_1 <= dds_rdata_11;
      end
      default: begin
        dds_data_0 <= dds_rdata_02;
        dds_data_1 <= dds_rdata_12;
      end
    endcase
    dds_data_0_d <= dds_data_0;
    dds_data_1_d <= dds_data_1;
    if (dds_intp_enable == 1'b1) begin
      dds_data_00 <= {~dds_idata_00_s[15], dds_idata_00_s[14:0]};
      dds_data_01 <= {~dds_idata_01_s[15], dds_idata_01_s[14:0]};
      dds_data_02 <= {~dds_idata_02_s[15], dds_idata_02_s[14:0]};
      dds_data_10 <= {~dds_idata_10_s[15], dds_idata_10_s[14:0]};
      dds_data_11 <= {~dds_idata_11_s[15], dds_idata_11_s[14:0]};
      dds_data_12 <= {~dds_idata_12_s[15], dds_idata_12_s[14:0]};
    end else begin
      dds_data_00 <= dds_rdata[95:80];
      dds_data_01 <= dds_rdata[63:48];
      dds_data_02 <= dds_rdata[31:16];
      dds_data_10 <= dds_rdata[79:64];
      dds_data_11 <= dds_rdata[47:32];
      dds_data_12 <= dds_rdata[15: 0];
    end
  end

  cf_ddsv_intp_1 i_intp_01 (
    .clk (dac_div3_clk),
    .data_a (dds_data_0_d),
    .data_b (dds_data_0),
    .scale_a (dds_intp_scale_a),
    .scale_b (dds_intp_scale_b),
    .data_s0 (dds_idata_00_s),
    .data_s1 (dds_idata_01_s));

  cf_ddsv_intp_1 i_intp_02 (
    .clk (dac_div3_clk),
    .data_a (dds_data_0_d),
    .data_b (dds_data_0),
    .scale_a (dds_intp_scale_b),
    .scale_b (dds_intp_scale_a),
    .data_s0 (),
    .data_s1 (dds_idata_02_s));

  cf_ddsv_intp_1 i_intp_11 (
    .clk (dac_div3_clk),
    .data_a (dds_data_1_d),
    .data_b (dds_data_1),
    .scale_a (dds_intp_scale_a),
    .scale_b (dds_intp_scale_b),
    .data_s0 (dds_idata_10_s),
    .data_s1 (dds_idata_11_s));

  cf_ddsv_intp_1 i_intp_12 (
    .clk (dac_div3_clk),
    .data_a (dds_data_1_d),
    .data_b (dds_data_1),
    .scale_a (dds_intp_scale_b),
    .scale_b (dds_intp_scale_a),
    .data_s0 (),
    .data_s1 (dds_idata_12_s));

endmodule

// ***************************************************************************
// ***************************************************************************
