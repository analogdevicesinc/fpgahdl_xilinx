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

`timescale 1ns/100ps

module cf_fftfloat (

  clk,

  hwin_valid,
  hwin_data,
  hwin_last,
  hwin_ready,

  fft_valid,
  fft_data,
  fft_last,
  fft_ready,

  fft_mag_valid,
  fft_mag_data,
  fft_mag_last,

  fft_status_toggle,
  fft_status_data,

  up_cfg_valid,
  up_cfg_data);

  parameter C_CF_SIZE_SEL = 0;

  input           clk;

  input           hwin_valid;
  input   [15:0]  hwin_data;
  input           hwin_last;
  output          hwin_ready;

  output          fft_valid;
  output  [63:0]  fft_data;
  output          fft_last;
  input           fft_ready;

  output          fft_mag_valid;
  output  [31:0]  fft_mag_data;
  output          fft_mag_last;

  output          fft_status_toggle;
  output  [19:0]  fft_status_data;

  input           up_cfg_valid;
  input   [31:0]  up_cfg_data;

  reg     [ 4:0]  fft_status_count = 'd0;
  reg     [19:0]  fft_status_acc = 'd0;
  reg             fft_status_toggle = 'd0;
  reg     [19:0]  fft_status_data = 'd0;
  reg             fftx_cfg_valid_m1 = 'd0;
  reg             fftx_cfg_valid_m2 = 'd0;
  reg             fftx_cfg_valid_m3 = 'd0;
  reg             fftx_cfg_valid = 'd0;
  reg     [31:0]  fftx_cfg_data = 'd0;

  wire            fft_valid_s;
  wire    [19:0]  fft_status_s;
  wire            fftx_cfg_ready_s;
  wire    [ 3:0]  fftx_status_s;
  wire    [11:0]  fftp_status_s;
  wire    [ 3:0]  fftr_status_s;
  wire            fix2floatx_valid_s;
  wire    [31:0]  fix2floatx_data_s;
  wire            fix2floatx_last_s;
  wire            fix2floatx_ready_s;
  wire            floatmulx_a_valid_s;
  wire    [31:0]  floatmulx_a_data_s;
  wire            floatmulx_a_last_s;
  wire            floatmulx_a_ready_s;
  wire            floatmulx_b_valid_s;
  wire    [31:0]  floatmulx_b_data_s;
  wire            floatmulx_b_last_s;
  wire            floatmulx_b_ready_s;
  wire            floataddx_valid_s;
  wire    [31:0]  floataddx_data_s;
  wire            floataddx_last_s;
  wire            floataddx_ready_s;
  wire            floatsqrtx_valid_s;
  wire    [31:0]  floatsqrtx_data_s;
  wire            floatsqrtx_last_s;
  wire            floatsqrtx_ready_s;
  
  assign fft_valid_s = fft_valid & fft_ready;
  assign fft_status_s = {fftp_status_s, ~fftr_status_s, fftx_status_s};

  always @(posedge clk) begin
    fft_status_count <= fft_status_count + 1'b1;
    if (fft_status_count == 5'd0) begin
      fft_status_acc <= fft_status_s;
    end else begin
      fft_status_acc <= fft_status_acc | fft_status_s;
    end
    if (fft_status_count == 5'd0) begin
      fft_status_toggle <= ~fft_status_toggle;
      fft_status_data <= fft_status_acc;
    end
  end

  always @(posedge clk) begin
    fftx_cfg_valid_m1 <= up_cfg_valid;
    fftx_cfg_valid_m2 <= fftx_cfg_valid_m1;
    fftx_cfg_valid_m3 <= fftx_cfg_valid_m2;
    if ((fftx_cfg_valid == 1'b1) && (fftx_cfg_ready_s == 1'b1)) begin
      fftx_cfg_valid <= 1'b0;
      fftx_cfg_data <= 'd0;
    end else if ((fftx_cfg_valid_m2 == 1'b1) && (fftx_cfg_valid_m3 == 1'b0)) begin
      fftx_cfg_valid <= 1'b1;
      fftx_cfg_data <= up_cfg_data;
    end
  end

  cf_fix2floatx_1 i_fix2floatx (
    .aclk (clk),
    .s_axis_a_tvalid (hwin_valid),
    .s_axis_a_tdata (hwin_data),
    .s_axis_a_tlast (hwin_last),
    .s_axis_a_tready (hwin_ready),
    .m_axis_result_tvalid (fix2floatx_valid_s),
    .m_axis_result_tdata (fix2floatx_data_s),
    .m_axis_result_tlast (fix2floatx_last_s),
    .m_axis_result_tready (fix2floatx_ready_s));

  generate
  if (C_CF_SIZE_SEL == 1) begin
  cf_fftx_4k_1 i_fftx (
    .aclk (clk),
    .s_axis_data_tvalid (fix2floatx_valid_s),
    .s_axis_data_tdata ({32'd0, fix2floatx_data_s}),
    .s_axis_data_tlast (fix2floatx_last_s),
    .s_axis_data_tready (fix2floatx_ready_s),
    .m_axis_data_tvalid (fft_valid),
    .m_axis_data_tdata (fft_data),
    .m_axis_data_tlast (fft_last),
    .m_axis_data_tready (fft_ready),
    .m_axis_data_tuser (),
    .m_axis_status_tvalid (),
    .m_axis_status_tdata (),
    .m_axis_status_tready (1'b1),
    .s_axis_config_tvalid (fftx_cfg_valid),
    .s_axis_config_tdata (fftx_cfg_data[23:0]),
    .s_axis_config_tready (fftx_cfg_ready_s),
    .event_frame_started (fftx_status_s[0]),
    .event_tlast_unexpected (fftx_status_s[1]),
    .event_tlast_missing (fftx_status_s[2]),
    .event_fft_overflow (fftx_status_s[3]),
    .event_status_channel_halt (),
    .event_data_in_channel_halt (),
    .event_data_out_channel_halt ());
  end else begin
  cf_fftx_1 i_fftx (
    .aclk (clk),
    .s_axis_data_tvalid (fix2floatx_valid_s),
    .s_axis_data_tdata ({32'd0, fix2floatx_data_s}),
    .s_axis_data_tlast (fix2floatx_last_s),
    .s_axis_data_tready (fix2floatx_ready_s),
    .m_axis_data_tvalid (fft_valid),
    .m_axis_data_tdata (fft_data),
    .m_axis_data_tlast (fft_last),
    .m_axis_data_tready (fft_ready),
    .m_axis_data_tuser (),
    .m_axis_status_tvalid (),
    .m_axis_status_tdata (),
    .m_axis_status_tready (1'b1),
    .s_axis_config_tvalid (fftx_cfg_valid),
    .s_axis_config_tdata (fftx_cfg_data),
    .s_axis_config_tready (fftx_cfg_ready_s),
    .event_frame_started (fftx_status_s[0]),
    .event_tlast_unexpected (fftx_status_s[1]),
    .event_tlast_missing (fftx_status_s[2]),
    .event_fft_overflow (fftx_status_s[3]),
    .event_status_channel_halt (),
    .event_data_in_channel_halt (),
    .event_data_out_channel_halt ());
  end
  endgenerate

  cf_floatmulx_1 i_floatmulx_a (
    .aclk (clk),
    .s_axis_a_tvalid (fft_valid_s),
    .s_axis_a_tdata (fft_data[31:0]),
    .s_axis_a_tlast (fft_last),
    .s_axis_a_tready (fftr_status_s[0]),
    .s_axis_b_tvalid (fft_valid_s),
    .s_axis_b_tdata (fft_data[31:0]),
    .s_axis_b_tlast (fft_last),
    .s_axis_b_tready (fftr_status_s[1]),
    .m_axis_result_tvalid (floatmulx_a_valid_s),
    .m_axis_result_tdata (floatmulx_a_data_s),
    .m_axis_result_tlast (floatmulx_a_last_s),
    .m_axis_result_tready (floatmulx_a_ready_s),
    .m_axis_result_tuser (fftp_status_s[2:0]));

  cf_floatmulx_1 i_floatmulx_b (
    .aclk (clk),
    .s_axis_a_tvalid (fft_valid_s),
    .s_axis_a_tdata (fft_data[63:32]),
    .s_axis_a_tlast (fft_last),
    .s_axis_a_tready (fftr_status_s[2]),
    .s_axis_b_tvalid (fft_valid_s),
    .s_axis_b_tdata (fft_data[63:32]),
    .s_axis_b_tlast (fft_last),
    .s_axis_b_tready (fftr_status_s[3]),
    .m_axis_result_tvalid (floatmulx_b_valid_s),
    .m_axis_result_tdata (floatmulx_b_data_s),
    .m_axis_result_tlast (floatmulx_b_last_s),
    .m_axis_result_tready (floatmulx_b_ready_s),
    .m_axis_result_tuser (fftp_status_s[5:3]));

  cf_floataddx_1 i_floataddx (
    .aclk (clk),
    .s_axis_a_tvalid (floatmulx_a_valid_s),
    .s_axis_a_tdata (floatmulx_a_data_s),
    .s_axis_a_tlast (floatmulx_a_last_s),
    .s_axis_a_tready (floatmulx_a_ready_s),
    .s_axis_b_tvalid (floatmulx_b_valid_s),
    .s_axis_b_tdata (floatmulx_b_data_s),
    .s_axis_b_tlast (floatmulx_b_last_s),
    .s_axis_b_tready (floatmulx_b_ready_s),
    .m_axis_result_tvalid (floataddx_valid_s),
    .m_axis_result_tdata (floataddx_data_s),
    .m_axis_result_tlast (floataddx_last_s),
    .m_axis_result_tready (floataddx_ready_s),
    .m_axis_result_tuser (fftp_status_s[8:6]));

  cf_floatsqrtx_1 i_floatsqrtx (
    .aclk (clk),
    .s_axis_a_tvalid (floataddx_valid_s),
    .s_axis_a_tdata (floataddx_data_s),
    .s_axis_a_tlast (floataddx_last_s),
    .s_axis_a_tready (floataddx_ready_s),
    .m_axis_result_tvalid (floatsqrtx_valid_s),
    .m_axis_result_tdata (floatsqrtx_data_s),
    .m_axis_result_tlast (floatsqrtx_last_s),
    .m_axis_result_tready (floatsqrtx_ready_s),
    .m_axis_result_tuser (fftp_status_s[9]));

  cf_float2fixx_1 i_float2fixx (
    .aclk (clk),
    .s_axis_a_tvalid (floatsqrtx_valid_s),
    .s_axis_a_tdata (floatsqrtx_data_s),
    .s_axis_a_tlast (floatsqrtx_last_s),
    .s_axis_a_tready (floatsqrtx_ready_s),
    .m_axis_result_tvalid (fft_mag_valid),
    .m_axis_result_tdata (fft_mag_data),
    .m_axis_result_tlast (fft_mag_last),
    .m_axis_result_tready (1'b1),
    .m_axis_result_tuser (fftp_status_s[11:10]));

endmodule

// ***************************************************************************
// ***************************************************************************
