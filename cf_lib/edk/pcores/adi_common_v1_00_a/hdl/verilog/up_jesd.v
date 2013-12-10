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

module up_jesd (

  // gt interface

  gt_pll_rst,
  gt_rst,

  // receive interface

  rx_clk,
  rx_rst,
  rx_ip_rst,
  rx_sysref,
  rx_ip_sysref,
  rx_sync,
  rx_lanesync_enb,
  rx_descr_enb,
  rx_sysref_enb,
  rx_mfrm_frmcnt,
  rx_frm_bytecnt,
  rx_errrpt_disb,
  rx_testmode,
  rx_bufdelay,
  rx_lanesel,
  rx_pll_locked,
  rx_rst_done,
  rx_sync_in,
  rx_error,
  rx_init_data_0,
  rx_init_data_1,
  rx_init_data_2,
  rx_init_data_3,
  rx_bufcnt,
  rx_test_mfcnt,
  rx_test_ilacnt,
  rx_test_errcnt,
  rx_rate,

  // drp interface

  drp_clk,
  drp_rst,
  drp_sel,
  drp_lanesel,
  drp_wr,
  drp_addr,
  drp_wdata,
  drp_rdata,
  drp_ack_t,

  // es interface

  es_start,
  es_stop,
  es_init,
  es_prescale,
  es_voffset_step,
  es_voffset_max,
  es_voffset_min,
  es_hoffset_max,
  es_hoffset_min,
  es_hoffset_step,
  es_start_addr,
  es_sdata0,
  es_sdata1,
  es_sdata2,
  es_sdata3,
  es_sdata4,
  es_qdata0,
  es_qdata1,
  es_qdata2,
  es_qdata3,
  es_qdata4,
  es_lanesel,
  es_dmaerr,
  es_status,

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

  // gt interface

  output          gt_pll_rst;
  output          gt_rst;

  // receive interface

  input           rx_clk;
  output          rx_rst;
  output          rx_ip_rst;
  output          rx_sysref;
  output          rx_ip_sysref;
  output          rx_sync;
  output          rx_lanesync_enb;
  output          rx_descr_enb;
  output          rx_sysref_enb;
  output  [ 4:0]  rx_mfrm_frmcnt;
  output  [ 7:0]  rx_frm_bytecnt;
  output          rx_errrpt_disb;
  output  [ 1:0]  rx_testmode;
  output  [12:0]  rx_bufdelay;
  output  [ 7:0]  rx_lanesel;
  input           rx_pll_locked;
  input           rx_rst_done;
  input           rx_sync_in;
  input           rx_error;
  input   [31:0]  rx_init_data_0;
  input   [31:0]  rx_init_data_1;
  input   [31:0]  rx_init_data_2;
  input   [31:0]  rx_init_data_3;
  input   [ 7:0]  rx_bufcnt;
  input   [31:0]  rx_test_mfcnt;
  input   [31:0]  rx_test_ilacnt;
  input   [31:0]  rx_test_errcnt;
  input   [ 7:0]  rx_rate;

  // drp interface

  input           drp_clk;
  output          drp_rst;
  output          drp_sel;
  output  [ 7:0]  drp_lanesel;
  output          drp_wr;
  output  [11:0]  drp_addr;
  output  [15:0]  drp_wdata;
  input   [15:0]  drp_rdata;
  input           drp_ack_t;

  // es interface

  output          es_start;
  output          es_stop;
  output          es_init;
  output  [ 4:0]  es_prescale;
  output  [ 7:0]  es_voffset_step;
  output  [ 7:0]  es_voffset_max;
  output  [ 7:0]  es_voffset_min;
  output  [11:0]  es_hoffset_max;
  output  [11:0]  es_hoffset_min;
  output  [11:0]  es_hoffset_step;
  output  [31:0]  es_start_addr;
  output  [15:0]  es_sdata0;
  output  [15:0]  es_sdata1;
  output  [15:0]  es_sdata2;
  output  [15:0]  es_sdata3;
  output  [15:0]  es_sdata4;
  output  [15:0]  es_qdata0;
  output  [15:0]  es_qdata1;
  output  [15:0]  es_qdata2;
  output  [15:0]  es_qdata3;
  output  [15:0]  es_qdata4;
  output  [ 7:0]  es_lanesel;
  input           es_dmaerr;
  input           es_status;

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
  reg             up_drp_resetn = 'd0;
  reg             up_ip_resetn = 'd0;
  reg             up_resetn = 'd0;
  reg             up_gt_resetn = 'd0;
  reg             up_ip_sysref = 'd0;
  reg             up_sysref = 'd0;
  reg             up_sync = 'd0;
  reg             up_rx_lanesync_enb = 'd0;
  reg             up_rx_descr_enb = 'd0;
  reg             up_rx_sysref_enb = 'd0;
  reg     [ 4:0]  up_rx_mfrm_frmcnt = 'd0;
  reg     [ 7:0]  up_rx_frm_bytecnt = 'd0;
  reg             up_rx_errrpt_disb = 'd0;
  reg     [ 1:0]  up_rx_testmode = 'd0;
  reg     [12:0]  up_rx_bufdelay = 'd0;
  reg     [ 7:0]  up_rx_lanesel = 'd0;
  reg             up_drp_sel_t = 'd0;
  reg             up_drp_rwn = 'd0;
  reg     [11:0]  up_drp_addr = 'd0;
  reg     [15:0]  up_drp_wdata = 'd0;
  reg             up_es_init = 'd0;
  reg             up_es_stop = 'd0;
  reg             up_es_start = 'd0;
  reg     [ 4:0]  up_es_prescale = 'd0;
  reg     [ 7:0]  up_es_voffset_step = 'd0;
  reg     [ 7:0]  up_es_voffset_max = 'd0;
  reg     [ 7:0]  up_es_voffset_min = 'd0;
  reg     [11:0]  up_es_hoffset_max = 'd0;
  reg     [11:0]  up_es_hoffset_min = 'd0;
  reg     [11:0]  up_es_hoffset_step = 'd0;
  reg     [31:0]  up_es_start_addr = 'd0;
  reg     [15:0]  up_es_sdata1 = 'd0;
  reg     [15:0]  up_es_sdata0 = 'd0;
  reg     [15:0]  up_es_sdata3 = 'd0;
  reg     [15:0]  up_es_sdata2 = 'd0;
  reg     [15:0]  up_es_sdata4 = 'd0;
  reg     [15:0]  up_es_qdata1 = 'd0;
  reg     [15:0]  up_es_qdata0 = 'd0;
  reg     [15:0]  up_es_qdata3 = 'd0;
  reg     [15:0]  up_es_qdata2 = 'd0;
  reg     [15:0]  up_es_qdata4 = 'd0;
  reg             up_ack = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg     [ 5:0]  up_xfer_cnt = 'd0;
  reg             up_xfer_toggle = 'd0;
  reg             rx_sysref_m1 = 'd0;
  reg             rx_sysref_m2 = 'd0;
  reg             rx_sysref_m3 = 'd0;
  reg             rx_sysref = 'd0;
  reg             rx_up_xfer_toggle_m1 = 'd0;
  reg             rx_up_xfer_toggle_m2 = 'd0;
  reg             rx_up_xfer_toggle_m3 = 'd0;
  reg             rx_ip_sysref_m1 = 'd0;
  reg             rx_ip_sysref_m2 = 'd0;
  reg             rx_ip_sysref_m3 = 'd0;
  reg             rx_ip_sysref = 'd0;
  reg             rx_sync_m1 = 'd0;
  reg             rx_sync_m2 = 'd0;
  reg             rx_sync = 'd0;
  reg             rx_lanesync_enb = 'd0;
  reg             rx_descr_enb = 'd0;
  reg             rx_sysref_enb = 'd0;
  reg     [ 4:0]  rx_mfrm_frmcnt = 'd0;
  reg     [ 7:0]  rx_frm_bytecnt = 'd0;
  reg             rx_errrpt_disb = 'd0;
  reg     [ 1:0]  rx_testmode = 'd0;
  reg     [12:0]  rx_bufdelay = 'd0;
  reg     [ 7:0]  rx_lanesel = 'd0;
  reg     [ 5:0]  rx_xfer_cnt = 'd0;
  reg             rx_xfer_toggle = 'd0;
  reg             rx_status_hold = 'd0;
  reg     [31:0]  rx_init_data_0_hold = 'd0;
  reg     [31:0]  rx_init_data_1_hold = 'd0;
  reg     [31:0]  rx_init_data_2_hold = 'd0;
  reg     [31:0]  rx_init_data_3_hold = 'd0;
  reg     [ 7:0]  rx_bufcnt_hold = 'd0;
  reg     [31:0]  rx_test_mfcnt_hold = 'd0;
  reg     [31:0]  rx_test_ilacnt_hold = 'd0;
  reg     [31:0]  rx_test_errcnt_hold = 'd0;
  reg     [ 7:0]  rx_rate_hold = 'd0;
  reg             up_rx_xfer_toggle_m1 = 'd0;
  reg             up_rx_xfer_toggle_m2 = 'd0;
  reg             up_rx_xfer_toggle_m3 = 'd0;
  reg             up_rx_status = 'd0;
  reg     [31:0]  up_rx_init_data_0 = 'd0;
  reg     [31:0]  up_rx_init_data_1 = 'd0;
  reg     [31:0]  up_rx_init_data_2 = 'd0;
  reg     [31:0]  up_rx_init_data_3 = 'd0;
  reg     [ 7:0]  up_rx_bufcnt = 'd0;
  reg     [31:0]  up_rx_test_mfcnt = 'd0;
  reg     [31:0]  up_rx_test_ilacnt = 'd0;
  reg     [31:0]  up_rx_test_errcnt = 'd0;
  reg     [ 7:0]  up_rx_rate = 'd0;
  reg             drp_sel_t_m1 = 'd0;
  reg             drp_sel_t_m2 = 'd0;
  reg             drp_sel_t_m3 = 'd0;
  reg             drp_sel = 'd0;
  reg     [ 7:0]  drp_lanesel = 'd0;
  reg             drp_wr = 'd0;
  reg     [11:0]  drp_addr = 'd0;
  reg     [15:0]  drp_wdata = 'd0;
  reg             up_drp_ack_t_m1 = 'd0;
  reg             up_drp_ack_t_m2 = 'd0;
  reg             up_drp_ack_t_m3 = 'd0;
  reg             up_drp_sel_t_d = 'd0;
  reg             up_drp_status = 'd0;
  reg     [15:0]  up_drp_rdata = 'd0;
  reg             es_start_m1 = 'd0;
  reg             es_start_m2 = 'd0;
  reg             es_start_m3 = 'd0;
  reg             es_stop_m1 = 'd0;
  reg             es_stop_m2 = 'd0;
  reg             es_stop_m3 = 'd0;
  reg             es_start = 'd0;
  reg             es_stop = 'd0;
  reg             es_init = 'd0;
  reg     [ 4:0]  es_prescale = 'd0;
  reg     [ 7:0]  es_voffset_step = 'd0;
  reg     [ 7:0]  es_voffset_max = 'd0;
  reg     [ 7:0]  es_voffset_min = 'd0;
  reg     [11:0]  es_hoffset_max = 'd0;
  reg     [11:0]  es_hoffset_min = 'd0;
  reg     [11:0]  es_hoffset_step = 'd0;
  reg     [31:0]  es_start_addr = 'd0;
  reg     [15:0]  es_sdata1 = 'd0;
  reg     [15:0]  es_sdata0 = 'd0;
  reg     [15:0]  es_sdata3 = 'd0;
  reg     [15:0]  es_sdata2 = 'd0;
  reg     [15:0]  es_sdata4 = 'd0;
  reg     [15:0]  es_qdata1 = 'd0;
  reg     [15:0]  es_qdata0 = 'd0;
  reg     [15:0]  es_qdata3 = 'd0;
  reg     [15:0]  es_qdata2 = 'd0;
  reg     [15:0]  es_qdata4 = 'd0;
  reg     [ 7:0]  es_lanesel = 'd0;
  reg             up_es_dmaerr_m1 = 'd0;
  reg             up_es_dmaerr_m2 = 'd0;
  reg             up_es_dmaerr = 'd0;
  reg             up_es_status_m1 = 'd0;
  reg             up_es_status = 'd0;

  // internal signals

  wire            up_sel_s;
  wire            up_wr_s;
  wire            up_drp_preset_s;
  wire            up_gt_pll_preset_s;
  wire            up_gt_preset_s;
  wire            up_preset_s;
  wire            up_ip_preset_s;
  wire            rx_up_xfer_toggle_s;
  wire            up_rx_xfer_toggle_s;
  wire            drp_sel_t_s;
  wire            up_drp_ack_t_s;
  wire            up_drp_sel_t_s;

  // decode block select

  assign up_sel_s = (up_addr[13:8] == 6'h00) ? up_sel : 1'b0;
  assign up_wr_s = up_sel_s & up_wr;

  // resets

  assign up_drp_preset_s = ~up_drp_resetn;
  assign up_gt_pll_preset_s = ~up_gt_resetn;
  assign up_gt_preset_s = ~(up_gt_resetn & rx_pll_locked);
  assign up_preset_s = ~(up_resetn & rx_pll_locked & rx_rst_done);
  assign up_ip_preset_s = ~(up_ip_resetn & rx_pll_locked & rx_rst_done);

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_scratch <= 'd0;
      up_drp_resetn <= 'd0;
      up_ip_resetn <= 'd0;
      up_resetn <= 'd0;
      up_gt_resetn <= 'd0;
      up_ip_sysref <= 'd0;
      up_sysref <= 'd0;
      up_sync <= 'd0;
      up_rx_lanesync_enb <= 'd0;
      up_rx_descr_enb <= 'd0;
      up_rx_sysref_enb <= 'd0;
      up_rx_mfrm_frmcnt <= 'd0;
      up_rx_frm_bytecnt <= 'd0;
      up_rx_errrpt_disb <= 'd0;
      up_rx_testmode <= 'd0;
      up_rx_bufdelay <= 'd0;
      up_rx_lanesel <= 'd0;
      up_drp_sel_t <= 'd0;
      up_drp_rwn <= 'd0;
      up_drp_addr <= 'd0;
      up_drp_wdata <= 'd0;
      up_es_init <= 'd0;
      up_es_stop <= 'd0;
      up_es_start <= 'd0;
      up_es_prescale <= 'd0;
      up_es_voffset_step <= 'd0;
      up_es_voffset_max <= 'd0;
      up_es_voffset_min <= 'd0;
      up_es_hoffset_max <= 'd0;
      up_es_hoffset_min <= 'd0;
      up_es_hoffset_step <= 'd0;
      up_es_start_addr <= 'd0;
      up_es_sdata1 <= 'd0;
      up_es_sdata0 <= 'd0;
      up_es_sdata3 <= 'd0;
      up_es_sdata2 <= 'd0;
      up_es_sdata4 <= 'd0;
      up_es_qdata1 <= 'd0;
      up_es_qdata0 <= 'd0;
      up_es_qdata3 <= 'd0;
      up_es_qdata2 <= 'd0;
      up_es_qdata4 <= 'd0;
    end else begin
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h10)) begin
        up_drp_resetn <= up_wdata[3];
        up_ip_resetn <= up_wdata[2];
        up_resetn <= up_wdata[1];
        up_gt_resetn <= up_wdata[0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h11)) begin
        up_ip_sysref <= up_wdata[1];
        up_sysref <= up_wdata[0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h12)) begin
        up_sync <= up_wdata[0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h14)) begin
        up_rx_lanesync_enb <= up_wdata[18];
        up_rx_descr_enb <= up_wdata[17];
        up_rx_sysref_enb <= up_wdata[16];
        up_rx_mfrm_frmcnt <= up_wdata[12:8];
        up_rx_frm_bytecnt <= up_wdata[7:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h15)) begin
        up_rx_errrpt_disb <= up_wdata[20];
        up_rx_testmode <= up_wdata[17:16];
        up_rx_bufdelay <= up_wdata[12:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h17)) begin
        up_rx_lanesel <= up_wdata[7:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h24)) begin
        up_drp_sel_t <= ~up_drp_sel_t;
        up_drp_rwn <= up_wdata[28];
        up_drp_addr <= up_wdata[27:16];
        up_drp_wdata <= up_wdata[15:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h28)) begin
        up_es_init <= up_wdata[2];
        up_es_stop <= up_wdata[1];
        up_es_start <= up_wdata[0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h29)) begin
        up_es_prescale <= up_wdata[4:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h2a)) begin
        up_es_voffset_step <= up_wdata[23:16];
        up_es_voffset_max <= up_wdata[15:8];
        up_es_voffset_min <= up_wdata[7:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h2b)) begin
        up_es_hoffset_max <= up_wdata[27:16];
        up_es_hoffset_min <= up_wdata[11:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h2c)) begin
        up_es_hoffset_step <= up_wdata[11:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h2d)) begin
        up_es_start_addr <= up_wdata;
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h2e)) begin
        up_es_sdata1 <= up_wdata[31:16];
        up_es_sdata0 <= up_wdata[15:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h2f)) begin
        up_es_sdata3 <= up_wdata[31:16];
        up_es_sdata2 <= up_wdata[15:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h30)) begin
        up_es_sdata4 <= up_wdata[15:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h31)) begin
        up_es_qdata1 <= up_wdata[31:16];
        up_es_qdata0 <= up_wdata[15:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h32)) begin
        up_es_qdata3 <= up_wdata[31:16];
        up_es_qdata2 <= up_wdata[15:0];
      end
      if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h33)) begin
        up_es_qdata4 <= up_wdata[15:0];
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
        case (up_addr[7:0])
          8'h00: up_rdata <= PCORE_VERSION;
          8'h01: up_rdata <= PCORE_ID;
          8'h02: up_rdata <= up_scratch;
          8'h10: up_rdata <= {28'd0, up_drp_resetn, up_ip_resetn, up_resetn, up_gt_resetn};
          8'h11: up_rdata <= {30'd0, up_ip_sysref, up_sysref};
          8'h12: up_rdata <= {31'd0, up_sync};
          8'h14: up_rdata <= {13'd0, up_rx_lanesync_enb, up_rx_descr_enb, up_rx_sysref_enb,
                              3'd0, up_rx_mfrm_frmcnt, up_rx_frm_bytecnt};
          8'h15: up_rdata <= {11'd0, up_rx_errrpt_disb, 2'd0, up_rx_testmode, 3'd0, up_rx_bufdelay};
          8'h17: up_rdata <= {24'd0, up_rx_lanesel};
          8'h18: up_rdata <= {31'd0, up_rx_status};
          8'h19: up_rdata <= up_rx_init_data_0;
          8'h1a: up_rdata <= up_rx_init_data_1;
          8'h1b: up_rdata <= up_rx_init_data_2;
          8'h1c: up_rdata <= up_rx_init_data_3;
          8'h1d: up_rdata <= {24'd0, up_rx_bufcnt};
          8'h1e: up_rdata <= up_rx_test_mfcnt;
          8'h1f: up_rdata <= up_rx_test_ilacnt;
          8'h20: up_rdata <= up_rx_test_errcnt;
          8'h24: up_rdata <= {3'd0, up_drp_rwn, up_drp_addr, up_drp_wdata};
          8'h25: up_rdata <= {15'd0, up_drp_status, up_drp_rdata};
          8'h28: up_rdata <= {29'd0, up_es_init, up_es_stop, up_es_start};
          8'h29: up_rdata <= {27'd0, up_es_prescale};
          8'h2a: up_rdata <= {8'd0, up_es_voffset_step, up_es_voffset_max, up_es_voffset_min};
          8'h2b: up_rdata <= {4'd0, up_es_hoffset_max, 4'd0, up_es_hoffset_min};
          8'h2c: up_rdata <= {20'd0, up_es_hoffset_step};
          8'h2d: up_rdata <= up_es_start_addr;
          8'h2e: up_rdata <= {up_es_sdata1, up_es_sdata0};
          8'h2f: up_rdata <= {up_es_sdata3, up_es_sdata2};
          8'h30: up_rdata <= up_es_sdata4;
          8'h31: up_rdata <= {up_es_qdata1, up_es_qdata0};
          8'h32: up_rdata <= {up_es_qdata3, up_es_qdata2};
          8'h33: up_rdata <= up_es_qdata4;
          8'h38: up_rdata <= {30'd0, up_es_dmaerr, up_es_status};
          8'h39: up_rdata <= {24'd0, up_rx_rate};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // common xfer toggle (where no enable or start is available)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_xfer_cnt <= 'd0;
      up_xfer_toggle <= 'd0;
    end else begin
      up_xfer_cnt <= up_xfer_cnt + 1'b1;
      if (up_xfer_cnt == 6'd0) begin
        up_xfer_toggle <= ~up_xfer_toggle;
      end
    end
  end

  // GT CONTROL

  FDPE #(.INIT(1'b1)) i_gt_pll_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (up_gt_pll_preset_s),
    .C (drp_clk),
    .Q (gt_pll_rst));

  FDPE #(.INIT(1'b1)) i_gt_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (up_gt_preset_s),
    .C (drp_clk),
    .Q (gt_rst));

  // RECEIVE CONTROL

  FDPE #(.INIT(1'b1)) i_rx_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (up_preset_s),
    .C (rx_clk),
    .Q (rx_rst));

  FDPE #(.INIT(1'b1)) i_rx_ip_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (up_ip_preset_s),
    .C (rx_clk),
    .Q (rx_ip_rst));

  // rx control transfer

  always @(posedge rx_clk) begin
    if (rx_rst == 1'b1) begin
      rx_sysref_m1 <= 'd0;
      rx_sysref_m2 <= 'd0;
      rx_sysref_m3 <= 'd0;
      rx_sysref <= 'd0;
    end else begin
      rx_sysref_m1 <= up_sysref;
      rx_sysref_m2 <= rx_sysref_m1;
      rx_sysref_m3 <= rx_sysref_m2;
      rx_sysref <= rx_sysref_m2 & ~rx_sysref_m3;
    end
  end

  assign rx_up_xfer_toggle_s = rx_up_xfer_toggle_m3 ^ rx_up_xfer_toggle_m2;

  always @(posedge rx_clk) begin
    if (rx_ip_rst == 1'b1) begin
      rx_up_xfer_toggle_m1 <= 'd0;
      rx_up_xfer_toggle_m2 <= 'd0;
      rx_up_xfer_toggle_m3 <= 'd0;
      rx_ip_sysref_m1 <= 'd0;
      rx_ip_sysref_m2 <= 'd0;
      rx_ip_sysref_m3 <= 'd0;
      rx_ip_sysref <= 'd0;
      rx_sync_m1 <= 'd0;
      rx_sync_m2 <= 'd0;
      rx_sync <= 'd0;
    end else begin
      rx_up_xfer_toggle_m1 <= up_xfer_toggle;
      rx_up_xfer_toggle_m2 <= rx_up_xfer_toggle_m1;
      rx_up_xfer_toggle_m3 <= rx_up_xfer_toggle_m2;
      rx_ip_sysref_m1 <= up_ip_sysref;
      rx_ip_sysref_m2 <= rx_ip_sysref_m1;
      rx_ip_sysref_m3 <= rx_ip_sysref_m2;
      rx_ip_sysref <= rx_ip_sysref_m2 & ~rx_ip_sysref_m3;
      rx_sync_m1 <= up_sync;
      rx_sync_m2 <= rx_sync_m1;
      rx_sync <= rx_sync_m2 & rx_sync_in;
    end
  end

  always @(posedge rx_clk) begin
    if (rx_up_xfer_toggle_s == 1'b1) begin
      rx_lanesync_enb <= up_rx_lanesync_enb;
      rx_descr_enb <= up_rx_descr_enb;
      rx_sysref_enb <= up_rx_sysref_enb;
      rx_mfrm_frmcnt <= up_rx_mfrm_frmcnt;
      rx_frm_bytecnt <= up_rx_frm_bytecnt;
      rx_errrpt_disb <= up_rx_errrpt_disb;
      rx_testmode <= up_rx_testmode;
      rx_bufdelay <= up_rx_bufdelay;
      rx_lanesel <= up_rx_lanesel;
    end
  end

  // rx status transfer

  always @(posedge rx_clk) begin
    rx_xfer_cnt <= rx_xfer_cnt + 1'b1;
    if (rx_xfer_cnt == 6'd0) begin
      rx_xfer_toggle <= ~rx_xfer_toggle;
      rx_status_hold <= rx_sync & ~rx_error;
      rx_init_data_0_hold <= rx_init_data_0;
      rx_init_data_1_hold <= rx_init_data_1;
      rx_init_data_2_hold <= rx_init_data_2;
      rx_init_data_3_hold <= rx_init_data_3;
      rx_bufcnt_hold <= rx_bufcnt;
      rx_test_mfcnt_hold <= rx_test_mfcnt;
      rx_test_ilacnt_hold <= rx_test_ilacnt;
      rx_test_errcnt_hold <= rx_test_errcnt;
      rx_rate_hold <= rx_rate;
    end
  end

  assign up_rx_xfer_toggle_s = up_rx_xfer_toggle_m2 ^ up_rx_xfer_toggle_m3;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rx_xfer_toggle_m1 <= 'd0;
      up_rx_xfer_toggle_m2 <= 'd0;
      up_rx_xfer_toggle_m3 <= 'd0;
      up_rx_status <= 'd0;
      up_rx_init_data_0 <= 'd0;
      up_rx_init_data_1 <= 'd0;
      up_rx_init_data_2 <= 'd0;
      up_rx_init_data_3 <= 'd0;
      up_rx_bufcnt <= 'd0;
      up_rx_test_mfcnt <= 'd0;
      up_rx_test_ilacnt <= 'd0;
      up_rx_test_errcnt <= 'd0;
      up_rx_rate <= 'd0;
    end else begin
      up_rx_xfer_toggle_m1 <= rx_xfer_toggle;
      up_rx_xfer_toggle_m2 <= up_rx_xfer_toggle_m1;
      up_rx_xfer_toggle_m3 <= up_rx_xfer_toggle_m2;
      if (up_rx_xfer_toggle_s == 1'b1) begin
        up_rx_status <= rx_status_hold;
        up_rx_init_data_0 <= rx_init_data_0_hold;
        up_rx_init_data_1 <= rx_init_data_1_hold;
        up_rx_init_data_2 <= rx_init_data_2_hold;
        up_rx_init_data_3 <= rx_init_data_3_hold;
        up_rx_bufcnt <= rx_bufcnt_hold;
        up_rx_test_mfcnt <= rx_test_mfcnt_hold;
        up_rx_test_ilacnt <= rx_test_ilacnt_hold;
        up_rx_test_errcnt <= rx_test_errcnt_hold;
        up_rx_rate <= rx_rate_hold;
      end
    end
  end

  // DRP CONTROL

  FDPE #(.INIT(1'b1)) i_drp_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (up_drp_preset_s),
    .C (drp_clk),
    .Q (drp_rst));

  // drp control transfer

  assign drp_sel_t_s = drp_sel_t_m2 ^ drp_sel_t_m3;

  always @(posedge drp_clk) begin
    if (drp_rst == 1'b1) begin
      drp_sel_t_m1 <= 'd0;
      drp_sel_t_m2 <= 'd0;
      drp_sel_t_m3 <= 'd0;
    end else begin
      drp_sel_t_m1 <= up_drp_sel_t;
      drp_sel_t_m2 <= drp_sel_t_m1;
      drp_sel_t_m3 <= drp_sel_t_m2;
    end
    if (drp_sel_t_s == 1'b1) begin
      drp_sel <= 1'b1;
      drp_lanesel <= up_rx_lanesel;
      drp_wr <= ~up_drp_rwn;
      drp_addr <= up_drp_addr;
      drp_wdata <= up_drp_wdata;
    end else begin
      drp_sel <= 1'b0;
      drp_lanesel <= drp_lanesel;
      drp_wr <= 1'b0;
      drp_addr <= 12'd0;
      drp_wdata <= 16'd0;
    end
  end

  // drp status transfer

  assign up_drp_ack_t_s = up_drp_ack_t_m3 ^ up_drp_ack_t_m2;
  assign up_drp_sel_t_s = up_drp_sel_t ^ up_drp_sel_t_d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_drp_ack_t_m1 <= 'd0;
      up_drp_ack_t_m2 <= 'd0;
      up_drp_ack_t_m3 <= 'd0;
      up_drp_sel_t_d <= 'd0;
      up_drp_status <= 'd0;
      up_drp_rdata <= 'd0;
    end else begin
      up_drp_ack_t_m1 <= drp_ack_t;
      up_drp_ack_t_m2 <= up_drp_ack_t_m1;
      up_drp_ack_t_m3 <= up_drp_ack_t_m2;
      up_drp_sel_t_d <= up_drp_sel_t;
      if (up_drp_ack_t_s == 1'b1) begin
        up_drp_status <= 1'b0;
      end else if (up_drp_sel_t_s == 1'b1) begin
        up_drp_status <= 1'b1;
      end
      if (up_drp_ack_t_s == 1'b1) begin
        up_drp_rdata <= drp_rdata;
      end
    end
  end

  // es control transfer

  always @(posedge drp_clk) begin
    if (drp_rst == 1'b1) begin
      es_start_m1 <= 'd0;
      es_start_m2 <= 'd0;
      es_start_m3 <= 'd0;
      es_stop_m1 <= 'd0;
      es_stop_m2 <= 'd0;
      es_stop_m3 <= 'd0;
    end else begin
      es_start_m1 <= up_es_start;
      es_start_m2 <= es_start_m1;
      es_start_m3 <= es_start_m2;
      es_stop_m1 <= up_es_stop;
      es_stop_m2 <= es_stop_m1;
      es_stop_m3 <= es_stop_m2;
    end
    es_start <= es_start_m2 & ~es_start_m3;
    es_stop <= es_stop_m2 & ~es_stop_m3;
    if ((es_start_m2 == 1'b1) && (es_start_m3 == 1'b0)) begin
      es_init <= up_es_init;
      es_prescale <= up_es_prescale;
      es_voffset_step <= up_es_voffset_step;
      es_voffset_max <= up_es_voffset_max;
      es_voffset_min <= up_es_voffset_min;
      es_hoffset_max <= up_es_hoffset_max;
      es_hoffset_min <= up_es_hoffset_min;
      es_hoffset_step <= up_es_hoffset_step;
      es_start_addr <= up_es_start_addr;
      es_sdata1 <= up_es_sdata1;
      es_sdata0 <= up_es_sdata0;
      es_sdata3 <= up_es_sdata3;
      es_sdata2 <= up_es_sdata2;
      es_sdata4 <= up_es_sdata4;
      es_qdata1 <= up_es_qdata1;
      es_qdata0 <= up_es_qdata0;
      es_qdata3 <= up_es_qdata3;
      es_qdata2 <= up_es_qdata2;
      es_qdata4 <= up_es_qdata4;
      es_lanesel <= up_rx_lanesel;
    end
  end

  // es status transfer

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_es_dmaerr_m1 <= 'd0;
      up_es_dmaerr_m2 <= 'd0;
      up_es_dmaerr <= 'd0;
      up_es_status_m1 <= 'd0;
      up_es_status <= 'd0;
    end else begin
      up_es_dmaerr_m1 <= es_dmaerr;
      up_es_dmaerr_m2 <= up_es_dmaerr_m1;
      if (up_es_dmaerr_m2 == 1'b1) begin
        up_es_dmaerr <= 1'b1;
      end else if ((up_wr_s == 1'b1) && (up_addr[7:0] == 8'h38)) begin
        up_es_dmaerr <= up_es_dmaerr & ~up_wdata[1];
      end
      up_es_status_m1 <= es_status;
      up_es_status <= up_es_status_m1;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
