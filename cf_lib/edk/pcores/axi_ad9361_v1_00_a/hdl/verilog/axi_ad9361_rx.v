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
// ADC channel-need to work on dual mode for pn sequence

`timescale 1ns/100ps

module axi_ad9361_rx (

  // adc interface

  adc_clk,
  adc_valid,
  adc_data_i1,
  adc_data_q1,
  adc_data_i2,
  adc_data_q2,
  adc_status,
  adc_r1_mode,

  // delay interface

  delay_clk,
  delay_rst,
  delay_sel,
  delay_rwn,
  delay_addr,
  delay_wdata,
  delay_rdata,
  delay_ack_t,
  delay_locked,

  // dma interface

  dma_clk,
  dma_valid,
  dma_last,
  dma_data,
  dma_ready,

  // processor interface

  up_rstn,
  up_clk,
  up_sel,
  up_wr,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,

  // monitor signals

  adc_mon_valid,
  adc_mon_data);

  // adc interface

  input           adc_clk;
  input           adc_valid;
  input   [11:0]  adc_data_i1;
  input   [11:0]  adc_data_q1;
  input   [11:0]  adc_data_i2;
  input   [11:0]  adc_data_q2;
  input           adc_status;
  output          adc_r1_mode;

  // delay interface

  input           delay_clk;
  output          delay_rst;
  output          delay_sel;
  output          delay_rwn;
  output  [ 7:0]  delay_addr;
  output  [ 4:0]  delay_wdata;
  input   [ 4:0]  delay_rdata;
  input           delay_ack_t;
  input           delay_locked;

  // dma interface

  input           dma_clk;
  output          dma_valid;
  output          dma_last;
  output  [63:0]  dma_data;
  input           dma_ready;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_wr;
  input   [13:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // monitor signals

  output  [ 1:0]  adc_mon_valid;
  output [116:0]  adc_mon_data;

  // internal registers

  reg             adc_iqcor_valid = 'd0;
  reg     [63:0]  adc_iqcor_data = 'd0;
  reg     [ 1:0]  adc_iqcor_data_cnt = 'd0;
  reg             up_adc_status_pn_err = 'd0;
  reg             up_adc_status_pn_oos = 'd0;
  reg             up_adc_status_or = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_ack = 'd0;

  // internal clocks and resets

  wire            adc_rst;
  wire            dma_rst;

  // internal signals

  wire            adc_status_int_s;
  wire            adc_status_s;
  wire            adc_iqcor_valid_s;
  wire    [15:0]  adc_dcfilter_data_out_0_s;
  wire            adc_pn_oos_out_0_s;
  wire            adc_pn_err_out_0_s;
  wire            adc_iqcor_valid_0_s;
  wire    [15:0]  adc_iqcor_data_0_s;
  wire            adc_enable_0_s;
  wire            up_adc_pn_err_0_s;
  wire            up_adc_pn_oos_0_s;
  wire            up_adc_or_0_s;
  wire    [31:0]  up_rdata_0_s;
  wire            up_ack_0_s;
  wire            adc_iqcor_valid_1_s;
  wire    [15:0]  adc_iqcor_data_1_s;
  wire            adc_enable_1_s;
  wire            up_adc_pn_err_1_s;
  wire            up_adc_pn_oos_1_s;
  wire            up_adc_or_1_s;
  wire    [31:0]  up_rdata_1_s;
  wire            up_ack_1_s;
  wire    [15:0]  adc_dcfilter_data_out_2_s;
  wire            adc_pn_oos_out_2_s;
  wire            adc_pn_err_out_2_s;
  wire            adc_iqcor_valid_2_s;
  wire    [15:0]  adc_iqcor_data_2_s;
  wire            adc_enable_2_s;
  wire            up_adc_pn_err_2_s;
  wire            up_adc_pn_oos_2_s;
  wire            up_adc_or_2_s;
  wire    [31:0]  up_rdata_2_s;
  wire            up_ack_2_s;
  wire            adc_iqcor_valid_3_s;
  wire    [15:0]  adc_iqcor_data_3_s;
  wire            adc_enable_3_s;
  wire            up_adc_pn_err_3_s;
  wire            up_adc_pn_oos_3_s;
  wire            up_adc_or_3_s;
  wire    [31:0]  up_rdata_3_s;
  wire            up_ack_3_s;
  wire            dma_ovf_s;
  wire            dma_unf_s;
  wire            dma_status_s;
  wire    [31:0]  dma_bw_s;
  wire            dma_start_s;
  wire            dma_stream_s;
  wire    [31:0]  dma_count_s;
  wire    [31:0]  up_rdata_s;
  wire            up_ack_s;

  // monitor signals

  assign adc_mon_valid[0] = adc_iqcor_valid_s;
  assign adc_mon_valid[1] = adc_valid;

  assign adc_mon_data[ 15:  0] = adc_iqcor_data_0_s;
  assign adc_mon_data[ 31: 16] = adc_iqcor_data_1_s;
  assign adc_mon_data[ 47: 32] = adc_iqcor_data_2_s;
  assign adc_mon_data[ 63: 48] = adc_iqcor_data_3_s;
  assign adc_mon_data[ 64: 64] = adc_iqcor_valid_0_s;
  assign adc_mon_data[ 65: 65] = adc_iqcor_valid_1_s;
  assign adc_mon_data[ 66: 66] = adc_iqcor_valid_2_s;
  assign adc_mon_data[ 67: 67] = adc_iqcor_valid_3_s;
  assign adc_mon_data[ 79: 68] = adc_data_i1;
  assign adc_mon_data[ 91: 80] = adc_data_q1;
  assign adc_mon_data[103: 92] = adc_data_i2;
  assign adc_mon_data[115:104] = adc_data_q2;
  assign adc_mon_data[116:116] = adc_valid;

  // adc status

  assign adc_status_int_s = ~(adc_iqcor_valid_0_s ^ adc_iqcor_valid_1_s ^
    adc_iqcor_valid_2_s ^ adc_iqcor_valid_3_s);
  assign adc_status_s = adc_status & adc_status_int_s;

  // adc channels - dma interface

  assign adc_iqcor_valid_s = adc_iqcor_valid_0_s & adc_iqcor_valid_1_s &
    adc_iqcor_valid_2_s & adc_iqcor_valid_3_s;

  always @(posedge adc_clk) begin
    if (adc_iqcor_valid_s == 1'b1) begin
      case ({adc_enable_3_s, adc_enable_2_s, adc_enable_1_s, adc_enable_0_s})
        4'b1111: begin
          adc_iqcor_valid <= 1'b1;
          adc_iqcor_data[63:48] <= adc_iqcor_data_3_s;
          adc_iqcor_data[47:32] <= adc_iqcor_data_2_s;
          adc_iqcor_data[31:16] <= adc_iqcor_data_1_s;
          adc_iqcor_data[15: 0] <= adc_iqcor_data_0_s;
        end
        4'b0001: begin
          adc_iqcor_valid <= adc_iqcor_data_cnt[1] & adc_iqcor_data_cnt[0];
          adc_iqcor_data[63:48] <= adc_iqcor_data_0_s;
          adc_iqcor_data[47:32] <= adc_iqcor_data[63:48];
          adc_iqcor_data[31:16] <= adc_iqcor_data[47:32];
          adc_iqcor_data[15: 0] <= adc_iqcor_data[31:16];
        end
        4'b0010: begin
          adc_iqcor_valid <= adc_iqcor_data_cnt[1] & adc_iqcor_data_cnt[0];
          adc_iqcor_data[63:48] <= adc_iqcor_data_1_s;
          adc_iqcor_data[47:32] <= adc_iqcor_data[63:48];
          adc_iqcor_data[31:16] <= adc_iqcor_data[47:32];
          adc_iqcor_data[15: 0] <= adc_iqcor_data[31:16];
        end
        4'b0100: begin
          adc_iqcor_valid <= adc_iqcor_data_cnt[1] & adc_iqcor_data_cnt[0];
          adc_iqcor_data[63:48] <= adc_iqcor_data_2_s;
          adc_iqcor_data[47:32] <= adc_iqcor_data[63:48];
          adc_iqcor_data[31:16] <= adc_iqcor_data[47:32];
          adc_iqcor_data[15: 0] <= adc_iqcor_data[31:16];
        end
        4'b1000: begin
          adc_iqcor_valid <= adc_iqcor_data_cnt[1] & adc_iqcor_data_cnt[0];
          adc_iqcor_data[63:48] <= adc_iqcor_data_3_s;
          adc_iqcor_data[47:32] <= adc_iqcor_data[63:48];
          adc_iqcor_data[31:16] <= adc_iqcor_data[47:32];
          adc_iqcor_data[15: 0] <= adc_iqcor_data[31:16];
        end
        4'b0011: begin
          adc_iqcor_valid <= adc_iqcor_data_cnt[0];
          adc_iqcor_data[63:48] <= adc_iqcor_data_1_s;
          adc_iqcor_data[47:32] <= adc_iqcor_data_0_s;
          adc_iqcor_data[31:16] <= adc_iqcor_data[63:48];
          adc_iqcor_data[15: 0] <= adc_iqcor_data[47:32];
        end
        4'b1100: begin
          adc_iqcor_valid <= adc_iqcor_data_cnt[0];
          adc_iqcor_data[63:48] <= adc_iqcor_data_3_s;
          adc_iqcor_data[47:32] <= adc_iqcor_data_2_s;
          adc_iqcor_data[31:16] <= adc_iqcor_data[63:48];
          adc_iqcor_data[15: 0] <= adc_iqcor_data[47:32];
        end
        default: begin
          adc_iqcor_valid <= 1'b1;
          adc_iqcor_data[63:48] <= 16'hdead;
          adc_iqcor_data[47:32] <= 16'hdead;
          adc_iqcor_data[31:16] <= 16'hdead;
          adc_iqcor_data[15: 0] <= 16'hdead;
        end
      endcase
      adc_iqcor_data_cnt <= adc_iqcor_data_cnt + 1'b1;
    end else begin
      adc_iqcor_valid <= 1'b0;
      adc_iqcor_data <= adc_iqcor_data;
      adc_iqcor_data_cnt <= adc_iqcor_data_cnt;
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_adc_status_pn_err <= 'd0;
      up_adc_status_pn_oos <= 'd0;
      up_adc_status_or <= 'd0;
      up_rdata <= 'd0;
      up_ack <= 'd0;
    end else begin
      up_adc_status_pn_err <= up_adc_pn_err_0_s | up_adc_pn_err_1_s |
        up_adc_pn_err_2_s | up_adc_pn_err_3_s;
      up_adc_status_pn_oos <= up_adc_pn_oos_0_s | up_adc_pn_oos_1_s |
        up_adc_pn_oos_2_s | up_adc_pn_oos_3_s;
      up_adc_status_or <= up_adc_or_0_s | up_adc_or_1_s |
        up_adc_or_2_s | up_adc_or_3_s;
      up_rdata <= up_rdata_s | up_rdata_0_s | up_rdata_1_s |
        up_rdata_2_s | up_rdata_3_s;
      up_ack <= up_ack_s | up_ack_0_s | up_ack_1_s | 
        up_ack_2_s | up_ack_3_s;
    end
  end

  // channel 0 (i)

  axi_ad9361_rx_channel #(.IQSEL(0), .CHID(0)) i_rx_channel_0 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data_i1),
    .adc_data_q (adc_data_q1),
    .adc_or (1'b0),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_0_s),
    .adc_pn_oos_out (adc_pn_oos_out_0_s),
    .adc_pn_err_out (adc_pn_err_out_0_s),
    .adc_dcfilter_data_in (16'd0),
    .adc_pn_oos_in (1'd0),
    .adc_pn_err_in (1'd0),
    .adc_iqcor_valid (adc_iqcor_valid_0_s),
    .adc_iqcor_data (adc_iqcor_data_0_s),
    .adc_enable (adc_enable_0_s),
    .up_adc_pn_err (up_adc_pn_err_0_s),
    .up_adc_pn_oos (up_adc_pn_oos_0_s),
    .up_adc_or (up_adc_or_0_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_0_s),
    .up_ack (up_ack_0_s));

  // channel 1 (q)

  axi_ad9361_rx_channel #(.IQSEL(1), .CHID(1)) i_rx_channel_1 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data_q1),
    .adc_data_q (12'd0),
    .adc_or (1'b0),
    .adc_dcfilter_data_out (),
    .adc_pn_oos_out (),
    .adc_pn_err_out (),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_0_s),
    .adc_pn_oos_in (adc_pn_oos_out_0_s),
    .adc_pn_err_in (adc_pn_err_out_0_s),
    .adc_iqcor_valid (adc_iqcor_valid_1_s),
    .adc_iqcor_data (adc_iqcor_data_1_s),
    .adc_enable (adc_enable_1_s),
    .up_adc_pn_err (up_adc_pn_err_1_s),
    .up_adc_pn_oos (up_adc_pn_oos_1_s),
    .up_adc_or (up_adc_or_1_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_1_s),
    .up_ack (up_ack_1_s));

  // channel 2 (i)

  axi_ad9361_rx_channel #(.IQSEL(0), .CHID(2)) i_rx_channel_2 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data_i2),
    .adc_data_q (adc_data_q2),
    .adc_or (1'b0),
    .adc_dcfilter_data_out (adc_dcfilter_data_out_2_s),
    .adc_pn_oos_out (adc_pn_oos_out_2_s),
    .adc_pn_err_out (adc_pn_err_out_2_s),
    .adc_dcfilter_data_in (16'd0),
    .adc_pn_oos_in (1'd0),
    .adc_pn_err_in (1'd0),
    .adc_iqcor_valid (adc_iqcor_valid_2_s),
    .adc_iqcor_data (adc_iqcor_data_2_s),
    .adc_enable (adc_enable_2_s),
    .up_adc_pn_err (up_adc_pn_err_2_s),
    .up_adc_pn_oos (up_adc_pn_oos_2_s),
    .up_adc_or (up_adc_or_2_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_2_s),
    .up_ack (up_ack_2_s));

  // channel 3 (q)

  axi_ad9361_rx_channel #(.IQSEL(1), .CHID(3)) i_rx_channel_3 (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data_q2),
    .adc_data_q (12'd0),
    .adc_or (1'b0),
    .adc_dcfilter_data_out (),
    .adc_pn_oos_out (),
    .adc_pn_err_out (),
    .adc_dcfilter_data_in (adc_dcfilter_data_out_2_s),
    .adc_pn_oos_in (adc_pn_oos_out_2_s),
    .adc_pn_err_in (adc_pn_err_out_2_s),
    .adc_iqcor_valid (adc_iqcor_valid_3_s),
    .adc_iqcor_data (adc_iqcor_data_3_s),
    .adc_enable (adc_enable_3_s),
    .up_adc_pn_err (up_adc_pn_err_3_s),
    .up_adc_pn_oos (up_adc_pn_oos_3_s),
    .up_adc_or (up_adc_or_3_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_3_s),
    .up_ack (up_ack_3_s));

  // main (dma interface)

  dma_core #(.DATA_WIDTH(64)) i_dma_core (
    .dma_clk (dma_clk),
    .dma_rst (dma_rst),
    .dma_valid (dma_valid),
    .dma_last (dma_last),
    .dma_data (dma_data),
    .dma_ready (dma_ready),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
    .dma_status (dma_status_s),
    .dma_bw (dma_bw_s),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_iqcor_valid),
    .adc_data (adc_iqcor_data),
    .dma_start (dma_start_s),
    .dma_stream (dma_stream_s),
    .dma_count (dma_count_s));

  // common processor control

  up_adc_common i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (adc_r1_mode),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status_s),
    .adc_status_pn_err (up_adc_status_pn_err),
    .adc_status_pn_oos (up_adc_status_pn_oos),
    .adc_status_or (up_adc_status_or),
    .adc_clk_ratio (32'd1),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_sel (delay_sel),
    .delay_rwn (delay_rwn),
    .delay_addr (delay_addr),
    .delay_wdata (delay_wdata),
    .delay_rdata (delay_rdata),
    .delay_ack_t (delay_ack_t),
    .delay_locked (delay_locked),
    .drp_clk (1'd0),
    .drp_rst (),
    .drp_sel (),
    .drp_rwn (),
    .drp_addr (),
    .drp_wdata (),
    .drp_rdata (16'd0),
    .drp_ack_t (1'd0),
    .dma_clk (dma_clk),
    .dma_rst (dma_rst),
    .dma_start (dma_start_s),
    .dma_stream (dma_stream_s),
    .dma_count (dma_count_s),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
    .dma_status (dma_status_s),
    .dma_bw (dma_bw_s),
    .up_usr_chanmax (),
    .adc_usr_chanmax (8'd3),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_wr (up_wr),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_s),
    .up_ack (up_ack_s));

endmodule

// ***************************************************************************
// ***************************************************************************

