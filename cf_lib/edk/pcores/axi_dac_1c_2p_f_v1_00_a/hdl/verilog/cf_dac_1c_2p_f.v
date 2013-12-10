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

module cf_dac_1c_2p_f (

  rst,

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_frame_out_p,
  dac_frame_out_n,
  dac_data_out_a_p,
  dac_data_out_a_n,
  dac_data_out_b_p,
  dac_data_out_b_n,

  vdma_clk,
  vdma_valid,
  vdma_data,
  vdma_ready,

  spi_cs0n,
  spi_cs1n,
  spi_clk,
  spi_sd_o,
  spi_sd_i,

  up_rstn,
  up_clk,
  up_sel,
  up_rwn,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,
  up_status,

  debug_clk,
  debug_data,
  debug_trigger,

  delay_clk);

  input           rst;

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output          dac_frame_out_p;
  output          dac_frame_out_n;
  output  [13:0]  dac_data_out_a_p;
  output  [13:0]  dac_data_out_a_n;
  output  [13:0]  dac_data_out_b_p;
  output  [13:0]  dac_data_out_b_n;

  input           vdma_clk;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;

  output          spi_cs0n;
  output          spi_cs1n;
  output          spi_clk;
  output          spi_sd_o;
  input           spi_sd_i;

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_rwn;
  input   [ 4:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;
  output  [ 7:0]  up_status;

  output          debug_clk;
  output  [79:0]  debug_data;
  output  [ 7:0]  debug_trigger;

  input           delay_clk;

  reg             up_dds_parity_type = 'd0;
  reg             up_dds_sel = 'd0;
  reg             up_dds_interpolate = 'd0;
  reg             up_dds_enable = 'd0;
  reg     [15:0]  up_dds_incr = 'd0;
  reg             up_spi_devsel = 'd0;
  reg             up_spi_start = 'd0;
  reg     [31:0]  up_spi_wdata_1 = 'd0;
  reg     [15:0]  up_spi_wdata_0 = 'd0;
  reg     [ 7:0]  up_status = 'd0;
  reg             up_spi_status_d = 'd0;
  reg             up_vdma_ovf_m1 = 'd0;
  reg             up_vdma_ovf_m2 = 'd0;
  reg             up_vdma_ovf = 'd0;
  reg             up_vdma_unf_m1 = 'd0;
  reg             up_vdma_unf_m2 = 'd0;
  reg             up_vdma_unf = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_sel_d = 'd0;
  reg             up_sel_2d = 'd0;
  reg             up_ack = 'd0;

  wire            up_wr_s;
  wire            up_rd_s;
  wire            up_ack_s;
  wire    [ 7:0]  up_spi_rdata_s;
  wire            up_spi_status_s;
  wire            vdma_ovf_s;
  wire            vdma_unf_s;
  wire    [13:0]  dds_data_00_s;
  wire    [13:0]  dds_data_01_s;
  wire    [13:0]  dds_data_02_s;
  wire    [13:0]  dds_data_03_s;
  wire    [13:0]  dds_data_04_s;
  wire    [13:0]  dds_data_05_s;
  wire    [13:0]  dds_data_06_s;
  wire    [13:0]  dds_data_07_s;
  wire    [13:0]  dds_data_08_s;
  wire    [13:0]  dds_data_09_s;
  wire    [13:0]  dds_data_10_s;
  wire    [13:0]  dds_data_11_s;

  assign up_wr_s = up_sel & ~up_rwn;
  assign up_rd_s = up_sel & up_rwn;
  assign up_ack_s = up_sel_d & ~up_sel_2d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dds_parity_type <= 'd0;
      up_dds_sel <= 'd0;
      up_dds_interpolate <= 'd0;
      up_dds_enable <= 'd0;
      up_dds_incr <= 'd0;
      up_spi_devsel <= 'd0;
      up_spi_start <= 'd0;
      up_spi_wdata_1 <= 'd0;
      up_spi_wdata_0 <= 'd0;
      up_status <= 'd0;
      up_spi_status_d <= 'd0;
      up_vdma_ovf_m1 <= 'd0;
      up_vdma_ovf_m2 <= 'd0;
      up_vdma_ovf <= 'd0;
      up_vdma_unf_m1 <= 'd0;
      up_vdma_unf_m2 <= 'd0;
      up_vdma_unf <= 'd0;
    end else begin
      if ((up_addr == 5'h01) && (up_wr_s == 1'b1)) begin
        up_dds_parity_type <= up_wdata[19];
        up_dds_sel <= up_wdata[18];
        up_dds_interpolate <= up_wdata[17];
        up_dds_enable <= up_wdata[16];
        up_dds_incr <= up_wdata[15:0];
      end
      if ((up_addr == 5'h05) && (up_wr_s == 1'b1)) begin
        up_spi_devsel <= up_wdata[1];
      end
      if ((up_spi_status_d == 1'b0) && (up_spi_status_s == 1'b1)) begin
        up_spi_start <= 1'b0;
      end else if ((up_addr == 5'h05) && (up_wr_s == 1'b1)) begin
        up_spi_start <= up_wdata[0];
      end
      if ((up_addr == 5'h06) && (up_wr_s == 1'b1)) begin
        up_spi_wdata_1 <= up_wdata;
      end
      if ((up_addr == 5'h07) && (up_wr_s == 1'b1)) begin
        up_spi_wdata_0 <= up_wdata[15:0];
      end
      up_status <= {4'd0, up_dds_parity_type, up_dds_sel, up_dds_interpolate, up_dds_enable};
      up_spi_status_d <= up_spi_status_s;
      up_vdma_ovf_m1 <= vdma_ovf_s;
      up_vdma_ovf_m2 <= up_vdma_ovf_m1;
      if (up_vdma_ovf_m2 == 1'b1) begin
        up_vdma_ovf <= 1'b1;
      end else if ((up_addr == 5'h09) && (up_wr_s == 1'b1)) begin
        up_vdma_ovf <= up_vdma_ovf & (~up_wdata[1]);
      end
      up_vdma_unf_m1 <= vdma_unf_s;
      up_vdma_unf_m2 <= up_vdma_unf_m1;
      if (up_vdma_unf_m2 == 1'b1) begin
        up_vdma_unf <= 1'b1;
      end else if ((up_addr == 5'h09) && (up_wr_s == 1'b1)) begin
        up_vdma_unf <= up_vdma_unf & (~up_wdata[0]);
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_sel_d <= 'd0;
      up_sel_2d <= 'd0;
      up_ack <= 'd0;
    end else begin
      case (up_addr)
        5'h00: up_rdata <= 32'h00010061;
        5'h01: up_rdata <= {12'd0, up_dds_parity_type, up_dds_sel, up_dds_interpolate,
          up_dds_enable, up_dds_incr};
        5'h05: up_rdata <= {30'd0, up_spi_devsel, up_spi_start};
        5'h06: up_rdata <= up_spi_wdata_1;
        5'h07: up_rdata <= {16'd0, up_spi_wdata_0};
        5'h08: up_rdata <= {23'd0, up_spi_status_s, up_spi_rdata_s};
        5'h09: up_rdata <= {30'd0, up_vdma_ovf, up_vdma_unf};
        default: up_rdata <= 0;
      endcase
      up_sel_d <= up_sel;
      up_sel_2d <= up_sel_d;
      up_ack <= up_ack_s;
    end
  end

  cf_spi i_spi (
    .spi_cs0n (spi_cs0n),
    .spi_cs1n (spi_cs1n),
    .spi_clk (spi_clk),
    .spi_sd_o (spi_sd_o),
    .spi_sd_i (spi_sd_i),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_spi_start (up_spi_start),
    .up_spi_devsel (up_spi_devsel),
    .up_spi_wdata_1 (up_spi_wdata_1),
    .up_spi_wdata_0 (up_spi_wdata_0),
    .up_spi_rdata (up_spi_rdata_s),
    .up_spi_status (up_spi_status_s),
    .debug_trigger (),
    .debug_data ());

  cf_dds_top i_dds_top (
    .vdma_clk (vdma_clk),
    .vdma_valid (vdma_valid),
    .vdma_data (vdma_data),
    .vdma_ready (vdma_ready),
    .vdma_ovf (vdma_ovf_s),
    .vdma_unf (vdma_unf_s),
    .dac_div3_clk (dac_div3_clk),
    .dds_data_00 (dds_data_00_s),
    .dds_data_01 (dds_data_01_s),
    .dds_data_02 (dds_data_02_s),
    .dds_data_03 (dds_data_03_s),
    .dds_data_04 (dds_data_04_s),
    .dds_data_05 (dds_data_05_s),
    .dds_data_06 (dds_data_06_s),
    .dds_data_07 (dds_data_07_s),
    .dds_data_08 (dds_data_08_s),
    .dds_data_09 (dds_data_09_s),
    .dds_data_10 (dds_data_10_s),
    .dds_data_11 (dds_data_11_s),
    .up_dds_sel (up_dds_sel),
    .up_dds_incr (up_dds_incr),
    .up_dds_enable (up_dds_enable),
    .up_dds_interpolate (up_dds_interpolate),
    .debug_clk (debug_clk),
    .debug_data (debug_data),
    .debug_trigger (debug_trigger));

  cf_dac_if i_dac_if (
    .rst (rst),
    .dac_clk_in_p (dac_clk_in_p),
    .dac_clk_in_n (dac_clk_in_n),
    .dac_clk_out_p (dac_clk_out_p),
    .dac_clk_out_n (dac_clk_out_n),
    .dac_frame_out_p (dac_frame_out_p),
    .dac_frame_out_n (dac_frame_out_n),
    .dac_data_out_a_p (dac_data_out_a_p),
    .dac_data_out_a_n (dac_data_out_a_n),
    .dac_data_out_b_p (dac_data_out_b_p),
    .dac_data_out_b_n (dac_data_out_b_n),
    .dac_div3_clk (dac_div3_clk),
    .dds_data_00 (dds_data_00_s),
    .dds_data_01 (dds_data_01_s),
    .dds_data_02 (dds_data_02_s),
    .dds_data_03 (dds_data_03_s),
    .dds_data_04 (dds_data_04_s),
    .dds_data_05 (dds_data_05_s),
    .dds_data_06 (dds_data_06_s),
    .dds_data_07 (dds_data_07_s),
    .dds_data_08 (dds_data_08_s),
    .dds_data_09 (dds_data_09_s),
    .dds_data_10 (dds_data_10_s),
    .dds_data_11 (dds_data_11_s),
    .up_dds_enable (up_dds_enable),
    .up_dds_parity_type (up_dds_parity_type));

endmodule

// ***************************************************************************
// ***************************************************************************
