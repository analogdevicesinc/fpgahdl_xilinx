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

  // vdma read interface

  dac_div3_clk,
  dds_rd,
  dds_rdata,

  // dac data

  dds_data_00,
  dds_data_01,
  dds_data_02,
  dds_data_03,
  dds_data_04,
  dds_data_05,
  dds_data_06,
  dds_data_07,
  dds_data_08,
  dds_data_09,
  dds_data_10,
  dds_data_11,

  // processor signals

  up_intp_enable,
  up_intp_scale_a,
  up_intp_scale_b,

  // debug signals

  dac_dbg_data,
  dac_dbg_trigger);

  // vdma read interface

  input           dac_div3_clk;
  output          dds_rd;
  input   [95:0]  dds_rdata;

  // dac data

  output  [13:0]  dds_data_00;
  output  [13:0]  dds_data_01;
  output  [13:0]  dds_data_02;
  output  [13:0]  dds_data_03;
  output  [13:0]  dds_data_04;
  output  [13:0]  dds_data_05;
  output  [13:0]  dds_data_06;
  output  [13:0]  dds_data_07;
  output  [13:0]  dds_data_08;
  output  [13:0]  dds_data_09;
  output  [13:0]  dds_data_10;
  output  [13:0]  dds_data_11;

  // processor signals

  input           up_intp_enable;
  input   [15:0]  up_intp_scale_a;
  input   [15:0]  up_intp_scale_b;

  // debug signals

  output  [292:0] dac_dbg_data;
  output  [ 7:0]  dac_dbg_trigger;

  reg             dds_intp_enable_m1 = 'd0;
  reg             dds_intp_enable_m2 = 'd0;
  reg             dds_intp_enable_m3 = 'd0;
  reg             dds_intp_enable = 'd0;
  reg     [15:0]  dds_intp_scale_a = 'd0;
  reg     [15:0]  dds_intp_scale_b = 'd0;
  reg     [ 2:0]  dds_rd_cnt = 'd0;
  reg             dds_rd = 'd0;
  reg     [15:0]  dds_rdata_0 = 'd0;
  reg     [15:0]  dds_rdata_1 = 'd0;
  reg     [15:0]  dds_rdata_2 = 'd0;
  reg     [15:0]  dds_rdata_3 = 'd0;
  reg     [15:0]  dds_rdata_4 = 'd0;
  reg     [15:0]  dds_rdata_5 = 'd0;
  reg     [15:0]  dds_data = 'd0;
  reg     [15:0]  dds_data_d = 'd0;
  reg     [13:0]  dds_data_00 = 'd0;
  reg     [13:0]  dds_data_01 = 'd0;
  reg     [13:0]  dds_data_02 = 'd0;
  reg     [13:0]  dds_data_03 = 'd0;
  reg     [13:0]  dds_data_04 = 'd0;
  reg     [13:0]  dds_data_05 = 'd0;
  reg     [13:0]  dds_data_06 = 'd0;
  reg     [13:0]  dds_data_07 = 'd0;
  reg     [13:0]  dds_data_08 = 'd0;
  reg     [13:0]  dds_data_09 = 'd0;
  reg     [13:0]  dds_data_10 = 'd0;
  reg     [13:0]  dds_data_11 = 'd0;

  wire    [15:0]  dds_idata_0_s;
  wire    [15:0]  dds_idata_1_s;
  wire    [15:0]  dds_idata_2_s;

  // debug signals

  assign dac_dbg_trigger[7:5] = 'd0;
  assign dac_dbg_trigger[4:4] = dds_intp_enable;
  assign dac_dbg_trigger[3:3] = dds_rd;
  assign dac_dbg_trigger[2:0] = dds_rd_cnt;

  assign dac_dbg_data[292:292] = dds_intp_enable;
  assign dac_dbg_data[291:291] = dds_rd;
  assign dac_dbg_data[290:288] = dds_rd_cnt;
  assign dac_dbg_data[287:272] = {dds_data_11, 2'd0};
  assign dac_dbg_data[271:256] = {dds_data_10, 2'd0};
  assign dac_dbg_data[255:240] = {dds_data_09, 2'd0};
  assign dac_dbg_data[239:224] = {dds_data_08, 2'd0};
  assign dac_dbg_data[223:208] = {dds_data_07, 2'd0};
  assign dac_dbg_data[207:192] = {dds_data_06, 2'd0};
  assign dac_dbg_data[191:176] = {dds_data_05, 2'd0};
  assign dac_dbg_data[175:160] = {dds_data_04, 2'd0};
  assign dac_dbg_data[159:144] = {dds_data_03, 2'd0};
  assign dac_dbg_data[143:128] = {dds_data_02, 2'd0};
  assign dac_dbg_data[127:112] = {dds_data_01, 2'd0};
  assign dac_dbg_data[111: 96] = {dds_data_00, 2'd0};
  assign dac_dbg_data[ 95:  0] = dds_rdata;

  // transfer processor signals to the dac clock domain

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

  // dds read (read every 6 clock cycles if interpolation is enabled)

  always @(posedge dac_div3_clk) begin
    if (dds_rd_cnt >= 3'b101) begin
      dds_rd_cnt <= 3'b000;
      dds_rd <= 1'b1;
    end else begin
      dds_rd_cnt <= dds_rd_cnt + 1'b1;
      dds_rd <= ~dds_intp_enable;
    end
    if (dds_rd == 1'b1) begin
      dds_rdata_0 <= dds_rdata[95:80];
      dds_rdata_1 <= dds_rdata[79:64];
      dds_rdata_2 <= dds_rdata[63:48];
      dds_rdata_3 <= dds_rdata[47:32];
      dds_rdata_4 <= dds_rdata[31:16];
      dds_rdata_5 <= dds_rdata[15: 0];
    end
  end

  // dds read data and delayed version for interpolation inputs
  // 2 consecutive samples are read, and interpolated to 3.

  always @(posedge dac_div3_clk) begin
    case (dds_rd_cnt)
      3'b001: dds_data <= dds_rdata_0;
      3'b010: dds_data <= dds_rdata_1;
      3'b011: dds_data <= dds_rdata_2;
      3'b100: dds_data <= dds_rdata_3;
      3'b101: dds_data <= dds_rdata_4;
      default: dds_data <= dds_rdata_5;
    endcase
    dds_data_d <= dds_data;
  end

  // interpolation mux select

  always @(posedge dac_div3_clk) begin
    if (dds_intp_enable == 1'b1) begin
      dds_data_00 <= {~dds_idata_0_s[15], dds_idata_0_s[14:2]};
      dds_data_01 <= {~dds_idata_0_s[15], dds_idata_0_s[14:2]};
      dds_data_02 <= {~dds_idata_0_s[15], dds_idata_0_s[14:2]};
      dds_data_03 <= {~dds_idata_0_s[15], dds_idata_0_s[14:2]};
      dds_data_04 <= {~dds_idata_1_s[15], dds_idata_1_s[14:2]};
      dds_data_05 <= {~dds_idata_1_s[15], dds_idata_1_s[14:2]};
      dds_data_06 <= {~dds_idata_1_s[15], dds_idata_1_s[14:2]};
      dds_data_07 <= {~dds_idata_1_s[15], dds_idata_1_s[14:2]};
      dds_data_08 <= {~dds_idata_2_s[15], dds_idata_2_s[14:2]};
      dds_data_09 <= {~dds_idata_2_s[15], dds_idata_2_s[14:2]};
      dds_data_10 <= {~dds_idata_2_s[15], dds_idata_2_s[14:2]};
      dds_data_11 <= {~dds_idata_2_s[15], dds_idata_2_s[14:2]};
    end else begin
      dds_data_00 <= dds_rdata_0[15:2];
      dds_data_01 <= dds_rdata_0[15:2];
      dds_data_02 <= dds_rdata_1[15:2];
      dds_data_03 <= dds_rdata_1[15:2];
      dds_data_04 <= dds_rdata_2[15:2];
      dds_data_05 <= dds_rdata_2[15:2];
      dds_data_06 <= dds_rdata_3[15:2];
      dds_data_07 <= dds_rdata_3[15:2];
      dds_data_08 <= dds_rdata_4[15:2];
      dds_data_09 <= dds_rdata_4[15:2];
      dds_data_10 <= dds_rdata_5[15:2];
      dds_data_11 <= dds_rdata_5[15:2];
    end
  end

  // interpolation works on the following identity:
  // sin(a+b) = sin(a)*cos(b) + cos(a)*sin(b)
  // the serialization above gives sin(n) and sin(4n), we just need to find sin(2n) and
  // sin(3n). If you subsitute the sin(n+d) where d is the increment factor in the
  // above equations, it will end up as sin(2n) = sin(n)*A + sin(4n)*B and
  // sin(3n) = sin(n)*B + sin(4n)*A, where A = sin(2n)/sin(3n) and B = sin(n)/sin(3n)
  // These values are expected to be programmed by software depending on the phase
  // increment required.

  // interpolation 0

  cf_ddsv_intp_1 i_intp_0 (
    .clk (dac_div3_clk),
    .data_a (dds_data_d),
    .data_b (dds_data),
    .scale_a (dds_intp_scale_a),
    .scale_b (dds_intp_scale_b),
    .data_s0 (dds_idata_0_s),
    .data_s1 (dds_idata_1_s));

  // interpolation 1

  cf_ddsv_intp_1 i_intp_1 (
    .clk (dac_div3_clk),
    .data_a (dds_data_d),
    .data_b (dds_data),
    .scale_a (dds_intp_scale_b),
    .scale_b (dds_intp_scale_a),
    .data_s0 (),
    .data_s1 (dds_idata_2_s));

endmodule

// ***************************************************************************
// ***************************************************************************
