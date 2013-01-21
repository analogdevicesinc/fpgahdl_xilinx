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
// This module computes FFT based on Xilinx's IP core. This is NOT a streaming
// interface, back pressure is allowed (ready can be deasserted). It is likely
// that it is used as an off-line module (DMA data from a storage).

`timescale 1ns/100ps

module cf_fft (

  clk,

  // adc interface (usually from a DMA engine)

  adc_valid,
  adc_data,
  adc_last,
  adc_ready,

  // fft output (usually to a DMA engine)

  fft_valid,
  fft_data,
  fft_last,
  fft_ready,

  // processor interface

  up_rstn,
  up_clk,
  up_sel,
  up_rwn,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,

  // monitor outputs for chipscope

  mon_sync,
  mon_data);

  // This parameter allows size select for FFT. The maximum supported sample
  // length is 64k. If it doesn't fit on a device, you can lower the size.
  // You will still have to generate the IP core to use here.

  parameter C_CF_SIZE_SEL = 0;

  input           clk;

  // adc interface (usually from a DMA engine)

  input           adc_valid;
  input   [15:0]  adc_data;
  input           adc_last;
  output          adc_ready;

  // fft output (usually to a DMA engine)

  output          fft_valid;
  output  [63:0]  fft_data;
  output          fft_last;
  input           fft_ready;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_rwn;
  input   [ 4:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // monitor outputs for chipscope

  output          mon_sync;
  output  [63:0]  mon_data;

  reg             up_cfg_valid = 'd0;
  reg     [31:0]  up_cfg_data = 'd0;
  reg             up_hwin_enb = 'd0;
  reg     [15:0]  up_hwin_incr = 'd0;
  reg     [19:0]  up_status_hold = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_sel_d = 'd0;
  reg             up_sel_2d = 'd0;
  reg             up_ack = 'd0;
  reg             up_status_toggle_m1 = 'd0;
  reg             up_status_toggle_m2 = 'd0;
  reg             up_status_toggle_m3 = 'd0;
  reg     [19:0]  up_status = 'd0;
  reg             adc_clrn = 'd0;
  reg             adc_wr = 'd0;
  reg     [ 9:0]  adc_waddr = 'd0;
  reg     [15:0]  adc_wdata = 'd0;
  reg             hwin_clrn = 'd0;
  reg             hwin_wr = 'd0;
  reg     [ 9:0]  hwin_waddr = 'd0;
  reg     [15:0]  hwin_wdata = 'd0;
  reg             fft_mag_clrn = 'd0;
  reg             fft_mag_wr = 'd0;
  reg     [ 9:0]  fft_mag_waddr = 'd0;
  reg     [31:0]  fft_mag_wdata = 'd0;
  reg             mrsync = 'd0;
  reg     [ 9:0]  mraddr = 'd0;
  reg     [63:0]  mrdata = 'd0;

  wire            up_wr_s;
  wire            up_ack_s;
  wire            up_status_toggle_s;
  wire            hwin_valid_s;
  wire    [15:0]  hwin_data_s;
  wire            hwin_last_s;
  wire            hwin_ready_s;
  wire            fft_mag_valid_s;
  wire    [31:0]  fft_mag_data_s;
  wire            fft_mag_last_s;
  wire            fft_status_toggle_s;
  wire    [19:0]  fft_status_data_s;
  wire    [63:0]  mrdata_s;

  assign mon_sync = mrsync;
  assign mon_data = mrdata;

  // processor write interface (see regmap.txt)

  assign up_wr_s = up_sel & ~up_rwn;
  assign up_ack_s = up_sel_d & ~up_sel_2d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_cfg_valid <= 'd0;
      up_cfg_data <= 'd0;
      up_hwin_enb <= 'd0;
      up_hwin_incr <= 'd0;
      up_status_hold <= 'd0;
    end else begin
      up_cfg_valid <= (up_addr == 5'h01) ? up_wr_s : 1'b0;
      if ((up_addr == 5'h01) && (up_wr_s == 1'b1)) begin
        up_cfg_data <= up_wdata;
      end
      if ((up_addr == 5'h02) && (up_wr_s == 1'b1)) begin
        up_hwin_enb <= up_wdata[16];
        up_hwin_incr <= up_wdata[15:0];
      end
      if ((up_addr == 5'h03) && (up_wr_s == 1'b1)) begin
        up_status_hold <= up_status_hold & ~up_wdata[19:0];
      end else begin
        up_status_hold <= up_status_hold | up_status;
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_sel_d <= 'd0;
      up_sel_2d <= 'd0;
      up_ack <= 'd0;
    end else begin
      case (up_addr)
        5'h00: up_rdata <= 32'h00010061;
        5'h01: up_rdata <= up_cfg_data;
        5'h02: up_rdata <= {15'd0, up_hwin_enb, up_hwin_incr};
        5'h03: up_rdata <= {12'd0, up_status_hold};
        default: up_rdata <= 0;
      endcase
      up_sel_d <= up_sel;
      up_sel_2d <= up_sel_d;
      up_ack <= up_ack_s;
    end
  end

  // transfer status signals to the processor side

  assign up_status_toggle_s = up_status_toggle_m3 ^ up_status_toggle_m2;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_toggle_m1 <= 'd0;
      up_status_toggle_m2 <= 'd0;
      up_status_toggle_m3 <= 'd0;
      up_status <= 'd0;
    end else begin
      up_status_toggle_m1 <= fft_status_toggle_s;
      up_status_toggle_m2 <= up_status_toggle_m1;
      up_status_toggle_m3 <= up_status_toggle_m2;
      if (up_status_toggle_s == 1'b1) begin
        up_status <= fft_status_data_s;
      end
    end
  end

  // adc write interface, the clear is used to reset the write address so that
  // each FFT starts at the same position.

  always @(posedge clk) begin
    if (adc_last == 1'b1) begin
      adc_clrn <= 1'b0;
    end else if ((adc_valid == 1'b1) && (adc_ready == 1'b1)) begin
      adc_clrn <= 1'b1;
    end
    adc_wr <= adc_valid & adc_ready;
    if (adc_wr == 1'b1) begin
      adc_waddr <= adc_waddr + 1'b1;
    end else if (adc_clrn == 1'b0) begin
      adc_waddr <= 'd0;
    end
    adc_wdata <= adc_data;
  end

  // windowing controls. again, clear is used to reset the write address

  always @(posedge clk) begin
    if (hwin_last_s == 1'b1) begin
      hwin_clrn <= 1'b0;
    end else if ((hwin_valid_s == 1'b1) && (hwin_ready_s == 1'b1)) begin
      hwin_clrn <= 1'b1;
    end
    hwin_wr <= hwin_valid_s & hwin_ready_s;
    if (hwin_wr == 1'b1) begin
      hwin_waddr <= hwin_waddr + 1'b1;
    end else if (hwin_clrn == 1'b0) begin
      hwin_waddr <= 'd0;
    end
    hwin_wdata <= hwin_data_s;
  end

  // FFT data. once again, clear is used to reset the write address

  always @(posedge clk) begin
    if (fft_mag_last_s == 1'b1) begin
      fft_mag_clrn <= 1'b0;
    end else if (fft_mag_valid_s == 1'b1) begin
      fft_mag_clrn <= 1'b1;
    end
    fft_mag_wr <= fft_mag_valid_s;
    if (fft_mag_wr == 1'b1) begin
      fft_mag_waddr <= fft_mag_waddr + 1'b1;
    end else if (fft_mag_clrn == 1'b0) begin
      fft_mag_waddr <= 'd0;
    end
    fft_mag_wdata <= fft_mag_data_s;
  end

  // monitor read interface, the resets of write addresses above guarantees that
  // sync is always at address 0 (0x1 here to make it trigger out of reset)

  always @(posedge clk) begin
    mrsync <= (mraddr == 10'd1) ? 1'b1 : 1'b0;
    mraddr <= mraddr + 1'b1;
    mrdata <= mrdata_s;
  end

  // windowing

  cf_hannwin i_hannwin (
    .clk (clk),
    .adc_valid (adc_valid),
    .adc_data (adc_data),
    .adc_last (adc_last),
    .adc_ready (adc_ready),
    .hwin_valid (hwin_valid_s),
    .hwin_data (hwin_data_s),
    .hwin_last (hwin_last_s),
    .hwin_ready (hwin_ready_s),
    .up_hwin_incr (up_hwin_incr),
    .up_hwin_enb (up_hwin_enb));

  // floating point fft

  cf_fftfloat #(.C_CF_SIZE_SEL(C_CF_SIZE_SEL)) i_fftfloat (
    .clk (clk),
    .hwin_valid (hwin_valid_s),
    .hwin_data (hwin_data_s),
    .hwin_last (hwin_last_s),
    .hwin_ready (hwin_ready_s),
    .fft_valid (fft_valid),
    .fft_data (fft_data),
    .fft_last (fft_last),
    .fft_ready (fft_ready),
    .fft_mag_valid (fft_mag_valid_s),
    .fft_mag_data (fft_mag_data_s),
    .fft_mag_last (fft_mag_last_s),
    .fft_status_toggle (fft_status_toggle_s),
    .fft_status_data (fft_status_data_s),
    .up_cfg_valid (up_cfg_valid),
    .up_cfg_data (up_cfg_data));

  // memory for samples

  cf_mem #(.AW(10), .DW(16)) i_mem_adc (
    .clka (clk),
    .wea (adc_wr),
    .addra (adc_waddr),
    .dina (adc_wdata),
    .clkb (clk),
    .addrb (mraddr),
    .doutb (mrdata_s[15:0]));

  // memory for window

  cf_mem #(.AW(10), .DW(16)) i_mem_hwin (
    .clka (clk),
    .wea (hwin_wr),
    .addra (hwin_waddr),
    .dina (hwin_wdata),
    .clkb (clk),
    .addrb (mraddr),
    .doutb (mrdata_s[31:16]));

  // memory for fft

  cf_mem #(.AW(10), .DW(32)) i_mem_fft_mag (
    .clka (clk),
    .wea (fft_mag_wr),
    .addra (fft_mag_waddr),
    .dina (fft_mag_wdata),
    .clkb (clk),
    .addrb (mraddr),
    .doutb (mrdata_s[63:32]));

endmodule

// ***************************************************************************
// ***************************************************************************
