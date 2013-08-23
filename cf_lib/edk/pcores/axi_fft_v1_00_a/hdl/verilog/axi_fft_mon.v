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
// A simple chipscope based monitor

`timescale 1ns/100ps

module axi_fft_mon (

  clk,

  // adc interface

  adc_valid,
  adc_data,
  adc_last,
  adc_ready,

  // window interface

  win_valid,
  win_data,
  win_last,
  win_ready,

  // fft magnitude interface

  fft_mag_valid,
  fft_mag_data,
  fft_mag_last,

  // monitor outputs for chipscope

  fft_mon_sync,
  fft_mon_data);

  // parameter to control the memory size

  parameter   PCORE_FFT_MON_ADDR_WIDTH = 0;
  localparam  AW = PCORE_FFT_MON_ADDR_WIDTH - 1;

  input           clk;

  // adc interface

  input           adc_valid;
  input   [15:0]  adc_data;
  input           adc_last;
  input           adc_ready;

  // window interface

  input           win_valid;
  input   [15:0]  win_data;
  input           win_last;
  input           win_ready;

  // fft magnitude interface

  input           fft_mag_valid;
  input   [31:0]  fft_mag_data;
  input           fft_mag_last;

  // monitor outputs for chipscope

  output          fft_mon_sync;
  output  [63:0]  fft_mon_data;

  // internal registers

  reg             adc_clrn = 'd0;
  reg             adc_wr = 'd0;
  reg     [AW:0]  adc_waddr = 'd0;
  reg     [15:0]  adc_wdata = 'd0;
  reg             win_clrn = 'd0;
  reg             win_wr = 'd0;
  reg     [AW:0]  win_waddr = 'd0;
  reg     [15:0]  win_wdata = 'd0;
  reg             fft_mag_clrn = 'd0;
  reg             fft_mag_wr = 'd0;
  reg     [AW:0]  fft_mag_waddr = 'd0;
  reg     [31:0]  fft_mag_wdata = 'd0;
  reg     [AW:0]  fft_mon_raddr = 'd0;
  reg             fft_mon_sync = 'd0;
  reg     [63:0]  fft_mon_data = 'd0;

  // internal signals

  wire    [63:0]  fft_mon_rdata_s;

  // samples

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
    if (win_last == 1'b1) begin
      win_clrn <= 1'b0;
    end else if ((win_valid == 1'b1) && (win_ready == 1'b1)) begin
      win_clrn <= 1'b1;
    end
    win_wr <= win_valid & win_ready;
    if (win_wr == 1'b1) begin
      win_waddr <= win_waddr + 1'b1;
    end else if (win_clrn == 1'b0) begin
      win_waddr <= 'd0;
    end
    win_wdata <= win_data;
  end

  // FFT data. once again, clear is used to reset the write address

  always @(posedge clk) begin
    if (fft_mag_last == 1'b1) begin
      fft_mag_clrn <= 1'b0;
    end else if (fft_mag_valid == 1'b1) begin
      fft_mag_clrn <= 1'b1;
    end
    fft_mag_wr <= fft_mag_valid;
    if (fft_mag_wr == 1'b1) begin
      fft_mag_waddr <= fft_mag_waddr + 1'b1;
    end else if (fft_mag_clrn == 1'b0) begin
      fft_mag_waddr <= 'd0;
    end
    fft_mag_wdata <= fft_mag_data;
  end

  // monitor read interface, the resets of write addresses above guarantees that
  // sync is always at address 0 (0x1 here to make it trigger out of reset)

  always @(posedge clk) begin
    fft_mon_raddr <= fft_mon_raddr + 1'b1;
    fft_mon_sync <= (fft_mon_raddr == 'd1) ? 1'b1 : 1'b0;
    fft_mon_data <= fft_mon_rdata_s;
  end

  // samples

  mem #(.ADDR_WIDTH(PCORE_FFT_MON_ADDR_WIDTH), .DATA_WIDTH(16)) i_mem_adc (
    .clka (clk),
    .wea (adc_wr),
    .addra (adc_waddr),
    .dina (adc_wdata),
    .clkb (clk),
    .addrb (fft_mon_raddr),
    .doutb (fft_mon_rdata_s[15:0]));

  // window

  mem #(.ADDR_WIDTH(PCORE_FFT_MON_ADDR_WIDTH), .DATA_WIDTH(16)) i_mem_win (
    .clka (clk),
    .wea (win_wr),
    .addra (win_waddr),
    .dina (win_wdata),
    .clkb (clk),
    .addrb (fft_mon_raddr),
    .doutb (fft_mon_rdata_s[31:16]));

  // fft mag.

  mem #(.ADDR_WIDTH(PCORE_FFT_MON_ADDR_WIDTH), .DATA_WIDTH(32)) i_mem_fft_mag (
    .clka (clk),
    .wea (fft_mag_wr),
    .addra (fft_mag_waddr),
    .dina (fft_mag_wdata),
    .clkb (clk),
    .addrb (fft_mon_raddr),
    .doutb (fft_mon_rdata_s[63:32]));

endmodule

// ***************************************************************************
// ***************************************************************************
