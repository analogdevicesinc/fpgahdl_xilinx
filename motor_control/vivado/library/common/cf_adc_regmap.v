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
// PROCESSOR REGISTER MAP:
// ---------------------------------------------------------------------------
// Address
// QW     Byte   Bits     Description
// ---------------------------------------------------------------------------
// 0x00   0x00   [31: 0]  version[31:0]         Parameterized (see top module)
// ---------------------------------------------------------------------------
// DMA Control/Status Registers:
// ---------------------------------------------------------------------------
// 0x01   0x04   [31:31]  capture               Capture start (0->1)
//               [30:30]  capture_stream        Capture stream mode (0x1)
//               [29: 0]  capture_count[29:0]   Capute count (number of quad words - 1)
//
// This register controls the capture of ADC data. A 0 to 1 transistion in the capture bit
// starts the capture. The capture count is the number of quad words minus one. To capture
// 16 quad words (64bit), sw must write 0x0000_0000 followed by 0x8000_000f.
// In stream mode, data is continously passed to the DMA engine- with TLAST asserted
// every capture count quad words. There may be bandwidth limitations.
// ---------------------------------------------------------------------------
// 0x02   0x08   [ 2: 2]  dma_underflow         Underflow (W1C)
//               [ 1: 1]  dma_overflow          Overflow (W1C)
//               [ 0: 0]  dma_status            Idle (0x0) or busy (0x1) (RO)
//
// This register indicates the status of an ADC data capture. Software must clear all the
// bits before starting a data capture.
// ---------------------------------------------------------------------------
// ADC Control/Status Registers:
// ---------------------------------------------------------------------------
// 0x03   0x0c   [ N: 0]  adc_pn_type           PN9 (0x0) or PN23 (0x1)
//
// N = number_of_channels - 1; number of channels can NOT exceed 16.
// ---------------------------------------------------------------------------
// 0x04   0x10   [ M:16]  adc_pnerr             PN Error (W1C)
//               [ N: 1]  adc_pnoos             PN Out Of Sync (W1C)
//
// N = number_of_channels - 1; number of channels can NOT exceed 16.
// M = 16 + (number_of_channels - 1);
// This register indicates the status of ADC data monitoring (regardless of data capture).
// These bits are set whenever a corresponding error is detected. Software must clear
// these bits and read them back to monitor the status.
// ---------------------------------------------------------------------------
// 0x05   0x14   [ N: 0]  adc_or                Over Range (W1C)
//
// N = number_of_channels - 1; number of channels can NOT exceed 16.
// ---------------------------------------------------------------------------
// 0x06   0x18   [17:17]  delay_sel             delay select (0->1)
//               [16:16]  delay_rwn             delay read (0x1) or write(0x0)
//               [13: 8]  delay_addr            delay address[5:0]
//               [ 4: 0]  delay_wdata           delay write data[4:0]
//
// A zero to one transition on delay_sel triggers delay read or write.
// All data signals take up lower range of delay address, with OR and other signals
// at the higher range (implementation specific)
// ---------------------------------------------------------------------------
// 0x07   0x1c   [ 8: 8]  delay_locked          delay locked (RO)
//               [ 4: 0]  delay_rdata           delay read data[4:0] (RO)
//
// The delay locked is independent of the read data (from delayctrl).
// ---------------------------------------------------------------------------
// 0x08   0x20   [ 0: 0]  delay_rst             delay reset 
//
// The delay reset is only applicable to the delayctrl.
// ---------------------------------------------------------------------------
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module cf_adc_regmap (

  // control interface

  up_dma_capture,
  up_dma_capture_stream,
  up_dma_capture_count,
  up_adc_pn_type,
  up_adc_signextn,
  up_delay_sel,
  up_delay_rwn,
  up_delay_addr,
  up_delay_wdata,
  up_delay_rst,

  // status interface

  dma_ovf,
  dma_unf,
  dma_status,
  adc_or,
  adc_pn_oos,
  adc_pn_err,
  delay_ack,
  delay_rdata,
  delay_locked,

  // bus interface

  up_rstn,
  up_clk,
  up_sel,
  up_rwn,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack);

  // top level must set the version and number of channels correctly

  parameter VERSION = 32'h00010061;
  parameter NUM_OF_CHANNELS = 1;
  parameter NC = NUM_OF_CHANNELS - 1;

  // control interface

  output          up_dma_capture;
  output          up_dma_capture_stream;
  output  [29:0]  up_dma_capture_count;
  output  [NC:0]  up_adc_pn_type;
  output  [NC:0]  up_adc_signextn;
  output          up_delay_sel;
  output          up_delay_rwn;
  output  [ 5:0]  up_delay_addr;
  output  [ 4:0]  up_delay_wdata;
  output          up_delay_rst;

  // status interface

  input           dma_ovf;
  input           dma_unf;
  input           dma_status;
  input   [NC:0]  adc_or;
  input   [NC:0]  adc_pn_oos;
  input   [NC:0]  adc_pn_err;
  input           delay_ack;
  input   [ 4:0]  delay_rdata;
  input           delay_locked;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_rwn;
  input   [ 4:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  reg             up_dma_capture = 'd0;
  reg             up_dma_capture_stream = 'd0;
  reg     [29:0]  up_dma_capture_count = 'd0;
  reg             up_dma_unf_hold = 'd0;
  reg             up_dma_ovf_hold = 'd0;
  reg     [NC:0]  up_adc_pn_type = 'd0;
  reg     [NC:0]  up_adc_pn_err_hold = 'd0;
  reg     [NC:0]  up_adc_pn_oos_hold = 'd0;
  reg     [NC:0]  up_adc_or_hold = 'd0;
  reg             up_delay_sel = 'd0;
  reg             up_delay_rwn = 'd0;
  reg     [ 5:0]  up_delay_addr = 'd0;
  reg     [ 4:0]  up_delay_wdata = 'd0;
  reg             up_delay_rst = 'd0;
  reg     [NC:0]  up_adc_signextn = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_sel_d = 'd0;
  reg             up_sel_2d = 'd0;
  reg             up_ack = 'd0;
  reg             up_dma_ovf_m1 = 'd0;
  reg             up_dma_ovf_m2 = 'd0;
  reg             up_dma_ovf = 'd0;
  reg             up_dma_unf_m1 = 'd0;
  reg             up_dma_unf_m2 = 'd0;
  reg             up_dma_unf = 'd0;
  reg             up_dma_status_m1 = 'd0;
  reg             up_dma_status_m2 = 'd0;
  reg             up_dma_status = 'd0;
  reg     [NC:0]  up_adc_or_m1 = 'd0;
  reg     [NC:0]  up_adc_or_m2 = 'd0;
  reg     [NC:0]  up_adc_or = 'd0;
  reg     [NC:0]  up_adc_pn_oos_m1 = 'd0;
  reg     [NC:0]  up_adc_pn_oos_m2 = 'd0;
  reg     [NC:0]  up_adc_pn_oos = 'd0;
  reg     [NC:0]  up_adc_pn_err_m1 = 'd0;
  reg     [NC:0]  up_adc_pn_err_m2 = 'd0;
  reg     [NC:0]  up_adc_pn_err = 'd0;
  reg             up_delay_ack_m1 = 'd0;
  reg             up_delay_ack_m2 = 'd0;
  reg             up_delay_ack_m3 = 'd0;
  reg             up_delay_ack = 'd0;
  reg     [ 4:0]  up_delay_rdata = 'd0;
  reg             up_delay_locked_m1 = 'd0;
  reg             up_delay_locked_m2 = 'd0;
  reg             up_delay_locked = 'd0;

  wire            up_wr_s;
  wire            up_ack_s;

  assign up_wr_s = up_sel & ~up_rwn;
  assign up_ack_s = up_sel_d & ~up_sel_2d;

  // processor write interface 

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dma_capture <= 'd0;
      up_dma_capture_stream <= 'd0;
      up_dma_capture_count <= 'd0;
      up_dma_unf_hold <= 'd0;
      up_dma_ovf_hold <= 'd0;
      up_adc_pn_type <= 'd0;
      up_adc_pn_err_hold <= 'd0;
      up_adc_pn_oos_hold <= 'd0;
      up_adc_or_hold <= 'd0;
      up_delay_sel <= 'd0;
      up_delay_rwn <= 'd0;
      up_delay_addr <= 'd0;
      up_delay_wdata <= 'd0;
      up_delay_rst <= 'd0;
      up_adc_signextn <= 'd0;
    end else begin
      if ((up_addr == 5'h01) && (up_wr_s == 1'b1)) begin
        up_dma_capture <= up_wdata[31];
        up_dma_capture_stream <= up_wdata[30];
        up_dma_capture_count <= up_wdata[29:0];
      end
      if ((up_addr == 5'h02) && (up_wr_s == 1'b1)) begin
        up_dma_unf_hold <= up_dma_unf_hold & ~up_wdata[2];
        up_dma_ovf_hold <= up_dma_ovf_hold & ~up_wdata[1];
      end else begin
        up_dma_unf_hold <= up_dma_unf | up_dma_unf_hold;
        up_dma_ovf_hold <= up_dma_ovf | up_dma_ovf_hold;
      end
      if ((up_addr == 5'h03) && (up_wr_s == 1'b1)) begin
        up_adc_pn_type <= up_wdata[NC:0];
      end
      if ((up_addr == 5'h04) && (up_wr_s == 1'b1)) begin
        up_adc_pn_err_hold <= up_adc_pn_err_hold & ~up_wdata[(NC+16):16];
        up_adc_pn_oos_hold <= up_adc_pn_oos_hold & ~up_wdata[NC:0];
      end else begin
        up_adc_pn_err_hold <= up_adc_pn_err | up_adc_pn_err_hold;
        up_adc_pn_oos_hold <= up_adc_pn_oos | up_adc_pn_oos_hold;
      end
      if ((up_addr == 5'h05) && (up_wr_s == 1'b1)) begin
        up_adc_or_hold <= up_adc_or_hold & ~up_wdata[NC:0];
      end else begin
        up_adc_or_hold <= up_adc_or | up_adc_or_hold;
      end
      if ((up_addr == 5'h06) && (up_wr_s == 1'b1)) begin
        up_delay_sel <= up_wdata[17];
        up_delay_rwn <= up_wdata[16];
        up_delay_addr <= up_wdata[13:8];
        up_delay_wdata <= up_wdata[4:0];
      end
      if ((up_addr == 5'h08) && (up_wr_s == 1'b1)) begin
        up_delay_rst <= up_wdata[0];
      end
      if ((up_addr == 5'h09) && (up_wr_s == 1'b1)) begin
        up_adc_signextn <= up_wdata[NC:0];
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
        5'h00: up_rdata <= VERSION;
        5'h01: up_rdata <= {up_dma_capture, up_dma_capture_stream, up_dma_capture_count};
        5'h02: up_rdata <= {29'd0, up_dma_unf_hold, up_dma_ovf_hold, up_dma_status};
        5'h03: up_rdata <= {16'd0, {(15-NC){1'd0}}, up_adc_pn_type};
        5'h04: up_rdata <= {{(15-NC){1'd0}}, up_adc_pn_err_hold, {(15-NC){1'd0}}, up_adc_pn_oos_hold};
        5'h05: up_rdata <= {16'd0, {(15-NC){1'd0}}, up_adc_or_hold};
        5'h06: up_rdata <= {14'd0, up_delay_sel, up_delay_rwn, 2'd0, up_delay_addr, 3'd0, up_delay_wdata};
        5'h07: up_rdata <= {23'd0, up_delay_locked, 3'd0, up_delay_rdata};
        5'h08: up_rdata <= {31'd0, up_delay_rst};
        5'h09: up_rdata <= {16'd0, {(15-NC){1'd0}}, up_adc_signextn};
        default: up_rdata <= 0;
      endcase
      up_sel_d <= up_sel;
      up_sel_2d <= up_sel_d;
      up_ack <= up_ack_s;
    end
  end

  // transfer dma signals to the processor clock domain

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dma_ovf_m1 <= 'd0;
      up_dma_ovf_m2 <= 'd0;
      up_dma_ovf <= 'd0;
      up_dma_unf_m1 <= 'd0;
      up_dma_unf_m2 <= 'd0;
      up_dma_unf <= 'd0;
      up_dma_status_m1 <= 'd0;
      up_dma_status_m2 <= 'd0;
      up_dma_status <= 'd0;
    end else begin
      up_dma_ovf_m1 <= dma_ovf;
      up_dma_ovf_m2 <= up_dma_ovf_m1;
      up_dma_ovf <= up_dma_ovf_m2;
      up_dma_unf_m1 <= dma_unf;
      up_dma_unf_m2 <= up_dma_unf_m1;
      up_dma_unf <= up_dma_unf_m2;
      up_dma_status_m1 <= dma_status;
      up_dma_status_m2 <= up_dma_status_m1;
      up_dma_status <= up_dma_status_m2;
    end
  end

  // transfer adc signals to the processor clock domain

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_or_m1 <= 'd0;
      up_adc_or_m2 <= 'd0;
      up_adc_or <= 'd0;
      up_adc_pn_oos_m1 <= 'd0;
      up_adc_pn_oos_m2 <= 'd0;
      up_adc_pn_oos <= 'd0;
      up_adc_pn_err_m1 <= 'd0;
      up_adc_pn_err_m2 <= 'd0;
      up_adc_pn_err <= 'd0;
    end else begin
      up_adc_or_m1 <= adc_or;
      up_adc_or_m2 <= up_adc_or_m1;
      up_adc_or <= up_adc_or_m2;
      up_adc_pn_oos_m1 <= adc_pn_oos;
      up_adc_pn_oos_m2 <= up_adc_pn_oos_m1;
      up_adc_pn_oos <= up_adc_pn_oos_m2;
      up_adc_pn_err_m1 <= adc_pn_err;
      up_adc_pn_err_m2 <= up_adc_pn_err_m1;
      up_adc_pn_err <= up_adc_pn_err_m2;
    end
  end

  // transfer delay signals to the processor clock domain

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_delay_ack_m1 <= 'd0;
      up_delay_ack_m2 <= 'd0;
      up_delay_ack_m3 <= 'd0;
      up_delay_ack <= 'd0;
      up_delay_rdata <= 'd0;
      up_delay_locked_m1 <= 'd0;
      up_delay_locked_m2 <= 'd0;
      up_delay_locked <= 'd0;
    end else begin
      up_delay_ack_m1 <= delay_ack;
      up_delay_ack_m2 <= up_delay_ack_m1;
      up_delay_ack_m3 <= up_delay_ack_m2;
      up_delay_ack <= up_delay_ack_m3 ^ up_delay_ack_m2;
      if (up_delay_ack == 1'b1) begin
        up_delay_rdata <= delay_rdata;
      end
      up_delay_locked_m1 <= delay_locked;
      up_delay_locked_m2 <= up_delay_locked_m1;
      up_delay_locked <= up_delay_locked_m2;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
