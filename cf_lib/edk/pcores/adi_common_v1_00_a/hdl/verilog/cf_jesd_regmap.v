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

`timescale 1ns/100ps

module cf_jesd_regmap (

  // control interface

  up_lanesync_enb,
  up_scr_enb,
  up_sysref_enb,
  up_err_disb,
  up_frmcnt,
  up_bytecnt,
  up_bufdelay,
  up_test_mode,
  up_gtx_rstn,
  up_jesd_rstn,
  up_es_mode,
  up_es_start,
  up_prescale,
  up_voffset_step,
  up_voffset_max,
  up_voffset_min,
  up_hoffset_max,
  up_hoffset_min,
  up_hoffset_step,
  up_startaddr,
  up_hsize,
  up_hmax,
  up_hmin,

  // eye scan ports

  es_drp_en,
  es_drp_we,
  es_drp_addr,
  es_drp_wdata,
  es_drp_rdata,
  es_drp_ready,
  es_state,

  // master bus interface

  mb_ovf,
  mb_unf,
  mb_status,
  mb_state,

  // drp ports

  up_drp_en,
  up_drp_we,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,

  // jesd ports

  jesd_status,
  jesd_bufcnt,
  jesd_init_data0,
  jesd_init_data1,
  jesd_init_data2,
  jesd_init_data3,
  jesd_test_mfcnt,
  jesd_test_ilacnt,
  jesd_test_errcnt,

  // bus interface

  up_rstn,
  up_clk,
  up_sel,
  up_rwn,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack);

  parameter VERSION = 32'h00010061;
  parameter NUM_OF_LANES = 4;
  parameter NC = NUM_OF_LANES - 1;
  parameter NB = (NUM_OF_LANES* 8) - 1;
  parameter NW = (NUM_OF_LANES*16) - 1;
  parameter ND = (NUM_OF_LANES*32) - 1;

  // control interface

  output          up_lanesync_enb;
  output          up_scr_enb;
  output          up_sysref_enb;
  output          up_err_disb;
  output  [ 4:0]  up_frmcnt;
  output  [ 7:0]  up_bytecnt;
  output  [12:0]  up_bufdelay;
  output  [ 1:0]  up_test_mode;
  output          up_gtx_rstn;
  output          up_jesd_rstn;
  output          up_es_mode;
  output          up_es_start;
  output  [ 4:0]  up_prescale;
  output  [ 7:0]  up_voffset_step;
  output  [ 7:0]  up_voffset_max;
  output  [ 7:0]  up_voffset_min;
  output  [11:0]  up_hoffset_max;
  output  [11:0]  up_hoffset_min;
  output  [11:0]  up_hoffset_step;
  output  [31:0]  up_startaddr;
  output  [15:0]  up_hsize;
  output  [15:0]  up_hmax;
  output  [15:0]  up_hmin;

  // eye scan ports

  input           es_drp_en;
  input           es_drp_we;
  input   [ 8:0]  es_drp_addr;
  input   [15:0]  es_drp_wdata;
  output  [15:0]  es_drp_rdata;
  output          es_drp_ready;
  input           es_state;

  // master bus interface

  input           mb_ovf;
  input           mb_unf;
  input   [ 1:0]  mb_status;
  input           mb_state;

  // drp ports

  output  [NC:0]  up_drp_en;
  output          up_drp_we;
  output  [ 8:0]  up_drp_addr;
  output  [15:0]  up_drp_wdata;
  input   [NW:0]  up_drp_rdata;
  input   [NC:0]  up_drp_ready;

  // jesd ports

  input           jesd_status;
  input   [NB:0]  jesd_bufcnt;
  input   [ND:0]  jesd_init_data0;
  input   [ND:0]  jesd_init_data1;
  input   [ND:0]  jesd_init_data2;
  input   [ND:0]  jesd_init_data3;
  input   [ND:0]  jesd_test_mfcnt;
  input   [ND:0]  jesd_test_ilacnt;
  input   [ND:0]  jesd_test_errcnt;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_rwn;
  input   [ 4:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;

  // internal registers

  reg             up_lanesync_enb = 'd0;
  reg             up_scr_enb = 'd0;
  reg             up_sysref_enb = 'd0;
  reg             up_err_disb = 'd0;
  reg     [ 4:0]  up_frmcnt = 'd0;
  reg     [ 7:0]  up_bytecnt = 'd0;
  reg     [12:0]  up_bufdelay = 'd0;
  reg     [ 1:0]  up_test_mode = 'd0;
  reg             up_gtx_rstn = 'd0;
  reg             up_jesd_rstn = 'd0;
  reg     [ 7:0]  up_lanesel = 'd0;
  reg             up_es_mode = 'd0;
  reg             up_es_start = 'd0;
  reg     [ 4:0]  up_prescale = 'd0;
  reg     [ 7:0]  up_voffset_step = 'd0;
  reg     [ 7:0]  up_voffset_max = 'd0;
  reg     [ 7:0]  up_voffset_min = 'd0;
  reg     [11:0]  up_hoffset_max = 'd0;
  reg     [11:0]  up_hoffset_min = 'd0;
  reg     [11:0]  up_hoffset_step = 'd0;
  reg     [31:0]  up_startaddr = 'd0;
  reg     [15:0]  up_hsize = 'd0;
  reg     [15:0]  up_hmax = 'd0;
  reg     [15:0]  up_hmin = 'd0;
  reg             up_mb_ovf_hold = 'd0;
  reg             up_mb_unf_hold = 'd0;
  reg     [ 1:0]  up_mb_status_hold = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_sel_d = 'd0;
  reg             up_sel_2d = 'd0;
  reg             up_ack = 'd0;
  reg     [NC:0]  up_drp_en = 'd0;
  reg             up_drp_we = 'd0;
  reg     [ 8:0]  up_drp_addr = 'd0;
  reg     [15:0]  up_drp_wdata = 'd0;
  reg     [15:0]  es_drp_rdata = 'd0;
  reg             es_drp_ready = 'd0;
  reg             up_jesd_status_m1 = 'd0;
  reg             up_jesd_status = 'd0;
  reg     [ 7:0]  up_jesd_bufcnt = 'd0;
  reg     [31:0]  up_jesd_init_data0 = 'd0;
  reg     [31:0]  up_jesd_init_data1 = 'd0;
  reg     [31:0]  up_jesd_init_data2 = 'd0;
  reg     [31:0]  up_jesd_init_data3 = 'd0;
  reg     [31:0]  up_jesd_test_mfcnt = 'd0;
  reg     [31:0]  up_jesd_test_ilacnt = 'd0;
  reg     [31:0]  up_jesd_test_errcnt = 'd0;

  // internal signals

  wire            up_wr_s;
  wire            up_ack_s;
  wire    [NC:0]  up_drp_en_s;
  wire    [15:0]  up_drp_rdata_s[0:NC];
  wire    [ 7:0]  jesd_bufcnt_s[0:NC];
  wire    [31:0]  jesd_init_data0_s[0:NC];
  wire    [31:0]  jesd_init_data1_s[0:NC];
  wire    [31:0]  jesd_init_data2_s[0:NC];
  wire    [31:0]  jesd_init_data3_s[0:NC];
  wire    [31:0]  jesd_test_mfcnt_s[0:NC];
  wire    [31:0]  jesd_test_ilacnt_s[0:NC];
  wire    [31:0]  jesd_test_errcnt_s[0:NC];

  genvar n;

  // processor control signals

  assign up_wr_s = up_sel & ~up_rwn;
  assign up_ack_s = up_sel_d & ~up_sel_2d;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_lanesync_enb <= 'd0;
      up_scr_enb <= 'd0;
      up_sysref_enb <= 'd0;
      up_err_disb <= 'd0;
      up_frmcnt <= 'd0;
      up_bytecnt <= 'd0;
      up_bufdelay <= 'd0;
      up_test_mode <= 'd0;
      up_gtx_rstn <= 'd0;
      up_jesd_rstn <= 'd0;
      up_lanesel <= 'd0;
      up_es_mode <= 'd0;
      up_es_start <= 'd0;
      up_prescale <= 'd0;
      up_voffset_step <= 'd0;
      up_voffset_max <= 'd0;
      up_voffset_min <= 'd0;
      up_hoffset_max <= 'd0;
      up_hoffset_min <= 'd0;
      up_hoffset_step <= 'd0;
      up_startaddr <= 'd0;
      up_hsize <= 'd0;
      up_hmin <= 'd0;
      up_hmax <= 'd0;
      up_mb_ovf_hold <= 'd0;
      up_mb_unf_hold <= 'd0;
      up_mb_status_hold <= 'd0;
    end else begin
      if ((up_addr == 5'h01) && (up_wr_s == 1'b1)) begin
        up_lanesync_enb <= up_wdata[3];
        up_scr_enb <= up_wdata[2];
        up_sysref_enb <= up_wdata[1];
        up_err_disb <= up_wdata[0];
      end
      if ((up_addr == 5'h03) && (up_wr_s == 1'b1)) begin
        up_frmcnt <= up_wdata[12:8];
        up_bytecnt <= up_wdata[7:0];
      end
      if ((up_addr == 5'h04) && (up_wr_s == 1'b1)) begin
        up_bufdelay <= up_wdata[12:0];
      end
      if ((up_addr == 5'h05) && (up_wr_s == 1'b1)) begin
        up_gtx_rstn <= up_wdata[5];
        up_jesd_rstn <= up_wdata[4];
        up_test_mode <= 2'd0;
        up_lanesel <= {4'd0, up_wdata[3:0]};
      end
      if ((up_addr == 5'h10) && (up_wr_s == 1'b1)) begin
        up_es_mode <= up_wdata[1];
        up_es_start <= up_wdata[0];
      end
      if ((up_addr == 5'h11) && (up_wr_s == 1'b1)) begin
        up_prescale <= up_wdata[4:0];
      end
      if ((up_addr == 5'h12) && (up_wr_s == 1'b1)) begin
        up_voffset_step <= up_wdata[23:16];
        up_voffset_max <= up_wdata[15:8];
        up_voffset_min <= up_wdata[7:0];
      end
      if ((up_addr == 5'h13) && (up_wr_s == 1'b1)) begin
        up_hoffset_max <= up_wdata[27:16];
        up_hoffset_min <= up_wdata[11:0];
      end
      if ((up_addr == 5'h14) && (up_wr_s == 1'b1)) begin
        up_hoffset_step <= up_wdata[11:0];
      end
      if ((up_addr == 5'h15) && (up_wr_s == 1'b1)) begin
        up_startaddr <= up_wdata;
      end
      if ((up_addr == 5'h16) && (up_wr_s == 1'b1)) begin
        up_hsize <= up_wdata[15:0];
      end
      if ((up_addr == 5'h17) && (up_wr_s == 1'b1)) begin
        up_hmax <= up_wdata[31:16];
        up_hmin <= up_wdata[15:0];
      end
      if ((up_addr == 5'h18) && (up_wr_s == 1'b1)) begin
        up_mb_ovf_hold <= up_mb_ovf_hold & ~up_wdata[5];
        up_mb_unf_hold <= up_mb_unf_hold & ~up_wdata[4];
        up_mb_status_hold[1] <= up_mb_status_hold[1] & ~up_wdata[3];
        up_mb_status_hold[0] <= up_mb_status_hold[0] & ~up_wdata[2];
      end else begin
        up_mb_ovf_hold <= up_mb_ovf_hold | mb_ovf;
        up_mb_unf_hold <= up_mb_unf_hold | mb_unf;
        up_mb_status_hold[1] <= up_mb_status_hold[1] | mb_status[1];
        up_mb_status_hold[0] <= up_mb_status_hold[0] | mb_status[0];
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
        5'h01: up_rdata <= {28'd0, up_lanesync_enb, up_scr_enb, up_sysref_enb, up_err_disb};
        5'h02: up_rdata <= {31'd0, up_jesd_status};
        5'h03: up_rdata <= {19'd0, up_frmcnt, up_bytecnt};
        5'h04: up_rdata <= {19'd0, up_bufdelay};
        5'h05: up_rdata <= {26'd0, up_gtx_rstn, up_jesd_rstn, up_lanesel[3:0]};
        5'h06: up_rdata <= up_jesd_bufcnt;
        5'h07: up_rdata <= up_jesd_init_data0;
        5'h08: up_rdata <= up_jesd_init_data1;
        5'h09: up_rdata <= up_jesd_init_data2;
        5'h0a: up_rdata <= up_jesd_init_data3;
        5'h0b: up_rdata <= up_jesd_test_mfcnt;
        5'h0c: up_rdata <= up_jesd_test_ilacnt;
        5'h0d: up_rdata <= up_jesd_test_errcnt;
        5'h10: up_rdata <= {30'd0, up_es_mode, up_es_start};
        5'h11: up_rdata <= {27'd0, up_prescale};
        5'h12: up_rdata <= {8'd0, up_voffset_step, up_voffset_max, up_voffset_min};
        5'h13: up_rdata <= {4'd0, up_hoffset_max, 4'd0, up_hoffset_min};
        5'h14: up_rdata <= {20'd0, up_hoffset_step};
        5'h15: up_rdata <= up_startaddr;
        5'h16: up_rdata <= {16'd0, up_hsize};
        5'h17: up_rdata <= {up_hmax, up_hmin};
        5'h18: up_rdata <= {26'd0, up_mb_ovf_hold, up_mb_unf_hold, up_mb_status_hold,
                            mb_state, es_state};
        default: up_rdata <= 0;
      endcase
      up_sel_d <= up_sel;
      up_sel_2d <= up_sel_d;
      up_ack <= up_ack_s;
    end
  end

  // drp mux based on lane select

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_drp_en <= 'd0;
      up_drp_we <= 'd0;
      up_drp_addr <= 'd0;
      up_drp_wdata <= 'd0;
      es_drp_rdata <= 'd0;
      es_drp_ready <= 'd0;
    end else begin
      up_drp_en <= up_drp_en_s;
      up_drp_we <= es_drp_we;
      up_drp_addr <= es_drp_addr;
      up_drp_wdata <= es_drp_wdata;
      es_drp_rdata <= up_drp_rdata_s[up_lanesel];
      es_drp_ready <= up_drp_ready[up_lanesel];
    end
  end

  // multiplexed gtx status/control signals per lane

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_jesd_status_m1 <= 'd0;
      up_jesd_status <= 'd0;
      up_jesd_bufcnt <= 'd0;
      up_jesd_init_data0 <= 'd0;
      up_jesd_init_data1 <= 'd0;
      up_jesd_init_data2 <= 'd0;
      up_jesd_init_data3 <= 'd0;
      up_jesd_test_mfcnt <= 'd0;
      up_jesd_test_ilacnt <= 'd0;
      up_jesd_test_errcnt <= 'd0;
    end else begin
      up_jesd_status_m1 <= jesd_status;
      up_jesd_status <= up_jesd_status_m1;
      up_jesd_bufcnt <= jesd_bufcnt_s[up_lanesel];
      up_jesd_init_data0 <= jesd_init_data0_s[up_lanesel];
      up_jesd_init_data1 <= jesd_init_data1_s[up_lanesel];
      up_jesd_init_data2 <= jesd_init_data2_s[up_lanesel];
      up_jesd_init_data3 <= jesd_init_data3_s[up_lanesel];
      up_jesd_test_mfcnt <= jesd_test_mfcnt_s[up_lanesel];
      up_jesd_test_ilacnt <= jesd_test_ilacnt_s[up_lanesel];
      up_jesd_test_errcnt <= jesd_test_errcnt_s[up_lanesel];
    end
  end

  // convert 1d signals to 2d signals per lane

  generate
  for (n = 0; n < NUM_OF_LANES; n = n + 1) begin : g_lanes
    assign up_drp_en_s[n] = (up_lanesel == n) ? es_drp_en : 1'b0;
    assign up_drp_rdata_s[n] = up_drp_rdata[((n*16)+15):(n*16)];
    assign jesd_bufcnt_s[n] = jesd_bufcnt[((n*8)+7):(n*8)];
    assign jesd_init_data0_s[n] = jesd_init_data0[((n*32)+31):(n*32)];
    assign jesd_init_data1_s[n] = jesd_init_data1[((n*32)+31):(n*32)];
    assign jesd_init_data2_s[n] = jesd_init_data2[((n*32)+31):(n*32)];
    assign jesd_init_data3_s[n] = jesd_init_data3[((n*32)+31):(n*32)];
    assign jesd_test_mfcnt_s[n] = jesd_test_mfcnt[((n*32)+31):(n*32)];
    assign jesd_test_ilacnt_s[n] = jesd_test_ilacnt[((n*32)+31):(n*32)];
    assign jesd_test_errcnt_s[n] = jesd_test_errcnt[((n*32)+31):(n*32)];
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
