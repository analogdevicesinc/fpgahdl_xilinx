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

module up_fft (

  // fft interface

  clk,
  rst,
  cfg_valid,
  cfg_data,
  win_enable,
  win_incr,
  fft_status,

  // bus interface

  up_rstn,
  up_clk,
  up_sel,
  up_wr,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack);

  // parameters

  parameter   PCORE_VERSION = 32'h00040062;
  parameter   PCORE_ID = 0;

  // fft interface

  input           clk;
  output          rst;
  output          cfg_valid;
  output  [31:0]  cfg_data;
  output          win_enable;
  output  [15:0]  win_incr;
  input   [19:0]  fft_status;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_wr;
  input   [13:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // internal registers

  reg     [31:0]  up_scratch = 'd0;
  reg             up_resetn = 'd0;
  reg             up_cfg_valid_toggle = 'd0;
  reg     [31:0]  up_cfg_data = 'd0;
  reg             up_win_enable = 'd0;
  reg     [15:0]  up_win_incr = 'd0;
  reg             up_ack = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             cfg_valid_toggle_m1 = 'd0;
  reg             cfg_valid_toggle_m2 = 'd0;
  reg             cfg_valid_toggle_m3 = 'd0;
  reg             cfg_valid = 'd0;
  reg     [31:0]  cfg_data = 'd0;
  reg             win_enable_m1 = 'd0;
  reg             win_enable_m2 = 'd0;
  reg             win_enable_m3 = 'd0;
  reg             win_enable = 'd0;
  reg     [15:0]  win_incr = 'd0;
  reg             status = 'd0;
  reg     [ 5:0]  fft_xfer_cnt = 'd0;
  reg             fft_xfer_toggle = 'd0;
  reg     [19:0]  fft_status_hold = 'd0;
  reg     [19:0]  fft_status_acc = 'd0;
  reg             up_status_m1 = 'd0;
  reg             up_status = 'd0;
  reg             up_fft_xfer_toggle_m1 = 'd0;
  reg             up_fft_xfer_toggle_m2 = 'd0;
  reg             up_fft_xfer_toggle_m3 = 'd0;
  reg     [19:0]  up_fft_status = 'd0;

  // internal signals

  wire            up_sel_s;
  wire            up_wr_s;
  wire            up_preset_s;
  wire            cfg_valid_s;
  wire            win_enable_s;
  wire            up_fft_xfer_toggle_s;

  // decode block select

  assign up_sel_s = (up_addr[13:12] == 2'd0) ? up_sel : 1'b0;
  assign up_wr_s = up_sel_s & up_wr;
  assign up_preset_s = ~up_resetn;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_scratch <= 'd0;
      up_resetn <= 'd0;
      up_cfg_valid_toggle <= 'd0;
      up_cfg_data <= 'd0;
      up_win_enable <= 'd0;
      up_win_incr <= 'd0;
    end else begin
      if ((up_wr_s == 1'b1) && (up_addr[11:0] == 12'h002)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wr_s == 1'b1) && (up_addr[11:0] == 12'h010)) begin
        up_resetn <= up_wdata[0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[11:0] == 12'h011)) begin
        up_cfg_valid_toggle <= ~up_cfg_valid_toggle;
        up_cfg_data <= up_wdata;
      end
      if ((up_wr_s == 1'b1) && (up_addr[11:0] == 12'h012)) begin
        up_win_enable <= up_wdata[16];
        up_win_incr <= up_wdata[15:0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_ack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_ack <= up_sel_s;
      if (up_sel_s == 1'b1) begin
        case (up_addr[11:0])
          12'h000: up_rdata <= PCORE_VERSION;
          12'h001: up_rdata <= PCORE_ID;
          12'h002: up_rdata <= up_scratch;
          12'h010: up_rdata <= {31'd0, up_resetn};
          12'h011: up_rdata <= up_cfg_data;
          12'h012: up_rdata <= {15'd0, up_win_enable, up_win_incr};
          12'h017: up_rdata <= {31'd0, up_status};
          12'h018: up_rdata <= {12'd0, up_fft_status};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // FFT CONTROL

  FDPE #(.INIT(1'b1)) i_fft_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (up_preset_s),
    .C (clk),
    .Q (rst));

  // fft control transfer

  assign cfg_valid_s = cfg_valid_toggle_m3 ^ cfg_valid_toggle_m2;

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      cfg_valid_toggle_m1 <= 'd0;
      cfg_valid_toggle_m2 <= 'd0;
      cfg_valid_toggle_m3 <= 'd0;
      cfg_valid <= 'd0;
    end else begin
      cfg_valid_toggle_m1 <= up_cfg_valid_toggle;
      cfg_valid_toggle_m2 <= cfg_valid_toggle_m1;
      cfg_valid_toggle_m3 <= cfg_valid_toggle_m2;
      cfg_valid <= cfg_valid_s;
    end
    if (cfg_valid_s == 1'b1) begin
      cfg_data <= up_cfg_data;
    end
  end

  assign win_enable_s = win_enable_m2 & ~win_enable_m3;

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      win_enable_m1 <= 'd0;
      win_enable_m2 <= 'd0;
      win_enable_m3 <= 'd0;
      win_enable <= 'd0;
    end else begin
      win_enable_m1 <= up_win_enable;
      win_enable_m2 <= win_enable_m1;
      win_enable_m3 <= win_enable_m2;
      win_enable <= win_enable_m3;
    end
    if (win_enable_s == 1'b1) begin
      win_incr <= up_win_incr;
    end
  end

  // FFT STATUS

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      status <= 1'b0;
    end else begin
      status <= 1'b1;
    end
  end

  // fft status transfer

  always @(posedge clk) begin
    fft_xfer_cnt <= fft_xfer_cnt + 1'b1;
    if (fft_xfer_cnt == 6'd0) begin
      fft_xfer_toggle <= ~fft_xfer_toggle;
      fft_status_hold <= fft_status_acc;
    end
    if (fft_xfer_cnt == 6'd0) begin
      fft_status_acc <= fft_status;
    end else begin
      fft_status_acc <= fft_status_acc | fft_status;
    end
  end

  assign up_fft_xfer_toggle_s = up_fft_xfer_toggle_m2 ^ up_fft_xfer_toggle_m3;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_m1 <= 'd0;
      up_status <= 'd0;
      up_fft_xfer_toggle_m1 <= 'd0;
      up_fft_xfer_toggle_m2 <= 'd0;
      up_fft_xfer_toggle_m3 <= 'd0;
      up_fft_status <= 'd0;
    end else begin
      up_status_m1 <= status;
      up_status <= up_status_m1;
      up_fft_xfer_toggle_m1 <= fft_xfer_toggle;
      up_fft_xfer_toggle_m2 <= up_fft_xfer_toggle_m1;
      up_fft_xfer_toggle_m3 <= up_fft_xfer_toggle_m2;
      if (up_fft_xfer_toggle_s == 1'b1) begin
        up_fft_status <= up_fft_status | fft_status_hold;
      end else if ((up_wr_s == 1'b1) && (up_addr[11:0] == 12'h018)) begin
        up_fft_status <= up_fft_status & ~up_wdata[19:0];
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
