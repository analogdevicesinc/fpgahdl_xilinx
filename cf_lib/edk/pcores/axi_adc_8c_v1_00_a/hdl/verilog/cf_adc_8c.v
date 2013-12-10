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

module cf_adc_8c (

  // adc interface

  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_frame_p,
  adc_frame_n,

  // dma interface

  dma_clk,
  dma_valid,
  dma_data,
  dma_be,
  dma_last,
  dma_ready,

  // processor interface

  up_rstn,
  up_clk,
  up_sel,
  up_rwn,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,

  // delay clock (200MHz)

  delay_clk,

  // debug interface

  dma_dbg_data,
  dma_dbg_trigger,

  // debug interface

  adc_dbg_data,
  adc_dbg_trigger,

  // monitor signals

  adc_clk,
  adc_mon_valid,
  adc_mon_data);

  // adc interface

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [ 7:0]  adc_data_in_p;
  input   [ 7:0]  adc_data_in_n;
  input           adc_frame_p;
  input           adc_frame_n;

  // dma interface

  input           dma_clk;
  output          dma_valid;
  output  [63:0]  dma_data;
  output  [ 7:0]  dma_be;
  output          dma_last;
  input           dma_ready;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_rwn;
  input   [ 4:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // delay clock (200MHz)

  input           delay_clk;

  // debug interface

  output  [63:0]  dma_dbg_data;
  output  [ 7:0]  dma_dbg_trigger;

  // debug interface

  output  [63:0]  adc_dbg_data;
  output  [ 7:0]  adc_dbg_trigger;

  // monitor signals

  output          adc_clk;
  output          adc_mon_valid;
  output [143:0]  adc_mon_data;

  reg             up_capture = 'd0;
  reg     [15:0]  up_capture_count = 'd0;
  reg             up_dma_unf_hold = 'd0;
  reg             up_dma_ovf_hold = 'd0;
  reg             up_dma_status = 'd0;
  reg     [ 7:0]  up_adc_pn_oos_hold = 'd0;
  reg     [ 7:0]  up_adc_pn_err_hold = 'd0;
  reg             up_adc_err_hold = 'd0;
  reg     [ 7:0]  up_pn_type = 'd0;
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
  reg             up_dma_complete_m1 = 'd0;
  reg             up_dma_complete_m2 = 'd0;
  reg             up_dma_complete_m3 = 'd0;
  reg             up_dma_complete = 'd0;
  reg             up_serdes_preset = 'd0;
  reg             up_adc_err_m1 = 'd0;
  reg             up_adc_err_m2 = 'd0;
  reg             up_adc_err = 'd0;
  reg     [ 7:0]  up_adc_pn_oos_m1 = 'd0;
  reg     [ 7:0]  up_adc_pn_oos_m2 = 'd0;
  reg     [ 7:0]  up_adc_pn_oos = 'd0;
  reg     [ 7:0]  up_adc_pn_err_m1 = 'd0;
  reg     [ 7:0]  up_adc_pn_err_m2 = 'd0;
  reg     [ 7:0]  up_adc_pn_err = 'd0;

  wire            up_wr_s;
  wire            up_ack_s;
  wire            dma_ovf_s;
  wire            dma_unf_s;
  wire            dma_complete_s;
  wire            adc_valid_s;
  wire    [63:0]  adc_data_s;
  wire            adc_err_s;
  wire    [ 7:0]  adc_pn_oos_s;
  wire    [ 7:0]  adc_pn_err_s;

  // processor control signals

  assign up_wr_s = up_sel & ~up_rwn;
  assign up_ack_s = up_sel_d & ~up_sel_2d;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_capture <= 'd0;
      up_capture_count <= 'd0;
      up_dma_unf_hold <= 'd0;
      up_dma_ovf_hold <= 'd0;
      up_dma_status <= 'd0;
      up_adc_pn_oos_hold <= 'd0;
      up_adc_pn_err_hold <= 'd0;
      up_adc_err_hold <= 'd0;
      up_pn_type <= 'd0;
    end else begin
      if ((up_addr == 5'h03) && (up_wr_s == 1'b1)) begin
        up_capture <= up_wdata[16];
        up_capture_count <= up_wdata[15:0];
      end
      if (up_dma_unf == 1'b1) begin
        up_dma_unf_hold <= 1'b1;
      end else if ((up_addr == 5'h04) && (up_wr_s == 1'b1)) begin
        up_dma_unf_hold <= up_dma_unf_hold & ~up_wdata[2];
      end
      if (up_dma_ovf == 1'b1) begin
        up_dma_ovf_hold <= 1'b1;
      end else if ((up_addr == 5'h04) && (up_wr_s == 1'b1)) begin
        up_dma_ovf_hold <= up_dma_ovf_hold & ~up_wdata[2];
      end
      if (up_dma_complete == 1'b1) begin
        up_dma_status <= 1'b0;
      end else if ((up_addr == 5'h03) && (up_wr_s == 1'b1) && (up_dma_status == 1'b0)) begin
        up_dma_status <= up_wdata[16];
      end
      if ((up_addr == 5'h05) && (up_wr_s == 1'b1)) begin
        up_adc_pn_oos_hold <= up_adc_pn_oos_hold & ~up_wdata[7:0];
      end else begin
        up_adc_pn_oos_hold <= up_adc_pn_oos_hold | up_adc_pn_oos;
      end
      if ((up_addr == 5'h05) && (up_wr_s == 1'b1)) begin
        up_adc_pn_err_hold <= up_adc_pn_err_hold & ~up_wdata[15:8];
      end else begin
        up_adc_pn_err_hold <= up_adc_pn_err_hold | up_adc_pn_err;
      end
      if (up_adc_err == 1'b1) begin
        up_adc_err_hold <= 1'b1;
      end else if ((up_addr == 5'h05) && (up_wr_s == 1'b1)) begin
        up_adc_err_hold <= up_adc_err_hold & ~up_wdata[0];
      end
      if ((up_addr == 5'h09) && (up_wr_s == 1'b1)) begin
        up_pn_type <= up_wdata[7:0];
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
        5'h00: up_rdata <= 32'h00010062;
        5'h03: up_rdata <= {15'd0, up_capture, up_capture_count};
        5'h04: up_rdata <= {29'd0, up_dma_unf_hold, up_dma_ovf_hold, up_dma_status};
        5'h05: up_rdata <= {15'd0, up_adc_err_hold, up_adc_pn_err_hold, up_adc_pn_oos_hold};
        5'h09: up_rdata <= {24'd0, up_pn_type};
        default: up_rdata <= 0;
      endcase
      up_sel_d <= up_sel;
      up_sel_2d <= up_sel_d;
      up_ack <= up_ack_s;
    end
  end

  // transfer status signals to processor clock domain

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dma_ovf_m1 <= 'd0;
      up_dma_ovf_m2 <= 'd0;
      up_dma_ovf <= 'd0;
      up_dma_unf_m1 <= 'd0;
      up_dma_unf_m2 <= 'd0;
      up_dma_unf <= 'd0;
      up_dma_complete_m1 <= 'd0;
      up_dma_complete_m2 <= 'd0;
      up_dma_complete_m3 <= 'd0;
      up_dma_complete <= 'd0;
    end else begin
      up_dma_ovf_m1 <= dma_ovf_s;
      up_dma_ovf_m2 <= up_dma_ovf_m1;
      up_dma_ovf <= up_dma_ovf_m2;
      up_dma_unf_m1 <= dma_unf_s;
      up_dma_unf_m2 <= up_dma_unf_m1;
      up_dma_unf <= up_dma_unf_m2;
      up_dma_complete_m1 <= dma_complete_s;
      up_dma_complete_m2 <= up_dma_complete_m1;
      up_dma_complete_m3 <= up_dma_complete_m2;
      up_dma_complete <= up_dma_complete_m3 ^ up_dma_complete_m2;
    end
  end

  // transfer status signals to processor clock domain

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_serdes_preset <= 'd1;
      up_adc_err_m1 <= 'd0;
      up_adc_err_m2 <= 'd0;
      up_adc_err <= 'd0;
      up_adc_pn_oos_m1 <= 'd0;
      up_adc_pn_oos_m2 <= 'd0;
      up_adc_pn_oos <= 'd0;
      up_adc_pn_err_m1 <= 'd0;
      up_adc_pn_err_m2 <= 'd0;
      up_adc_pn_err <= 'd0;
    end else begin
      up_serdes_preset <= 'd0;
      up_adc_err_m1 <= adc_err_s;
      up_adc_err_m2 <= up_adc_err_m1;
      up_adc_err <= up_adc_err_m2;
      up_adc_pn_oos_m1 <= adc_pn_oos_s;
      up_adc_pn_oos_m2 <= up_adc_pn_oos_m1;
      up_adc_pn_oos <= up_adc_pn_oos_m2;
      up_adc_pn_err_m1 <= adc_pn_err_s;
      up_adc_pn_err_m2 <= up_adc_pn_err_m1;
      up_adc_pn_err <= up_adc_pn_err_m2;
    end
  end

  // dma write interface

  cf_dma_wr i_dma_wr (
    .adc_clk (adc_clk),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_master_capture (up_capture),
    .dma_clk (dma_clk),
    .dma_valid (dma_valid),
    .dma_data (dma_data),
    .dma_be (dma_be),
    .dma_last (dma_last),
    .dma_ready (dma_ready),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
    .dma_complete (dma_complete_s),
    .up_capture_count (up_capture_count),
    .dma_dbg_data (dma_dbg_data),
    .dma_dbg_trigger (dma_dbg_trigger),
    .adc_dbg_data (adc_dbg_data),
    .adc_dbg_trigger (adc_dbg_trigger));

  // adc capture interface

  cf_adc_if i_adc_if (
    .adc_clk_in_p (adc_clk_in_p),
    .adc_clk_in_n (adc_clk_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_data_in_n (adc_data_in_n),
    .adc_frame_p (adc_frame_p),
    .adc_frame_n (adc_frame_n),
    .adc_clk (adc_clk),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s),
    .adc_err (adc_err_s),
    .adc_pn_oos (adc_pn_oos_s),
    .adc_pn_err (adc_pn_err_s),
    .up_serdes_preset (up_serdes_preset),
    .up_pn_type (up_pn_type),
    .adc_mon_valid (adc_mon_valid),
    .adc_mon_data (adc_mon_data));

endmodule

// ***************************************************************************
// ***************************************************************************
