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

module cf_gtx_es_if (

  // processor interface

  up_rstn,
  up_clk,
  up_start,
  up_mode,
  up_prescale,
  up_hoffset_min,
  up_hoffset_max,
  up_hoffset_step,
  up_voffset_min,
  up_voffset_max,
  up_voffset_step,

  // drp interface (sel is driven directly by up)

  up_drp_en,
  up_drp_we,
  up_drp_addr,
  up_drp_wdata,
  up_drp_rdata,
  up_drp_ready,

  // write interface

  es_valid,
  es_sos,
  es_eos,
  es_data,
  es_state,

  // debug interface (chipscope)

  es_dbg_data,
  es_dbg_trigger);

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_start;
  input           up_mode;
  input   [ 4:0]  up_prescale;
  input   [11:0]  up_hoffset_min;
  input   [11:0]  up_hoffset_max;
  input   [11:0]  up_hoffset_step;
  input   [ 7:0]  up_voffset_min;
  input   [ 7:0]  up_voffset_max;
  input   [ 7:0]  up_voffset_step;

  // drp interface (sel is driven directly by up)

  output          up_drp_en;
  output          up_drp_we;
  output  [ 8:0]  up_drp_addr;
  output  [15:0]  up_drp_wdata;
  input   [15:0]  up_drp_rdata;
  input           up_drp_ready;

  // write interface

  output          es_valid;
  output          es_sos;
  output          es_eos;
  output  [31:0]  es_data;
  output          es_state;

  // debug interface (chipscope)

  output [227:0]  es_dbg_data;
  output  [ 7:0]  es_dbg_trigger;

  // eye scan state machine parameters

  parameter ESFSM_IDLE                = 'h00;
  parameter ESFSM_INIT                = 'h01;
  parameter ESFSM_CTRLINIT_RD         = 'h02;
  parameter ESFSM_CTRLINIT_RD_RDY     = 'h03;
  parameter ESFSM_CTRLINIT_WR         = 'h04;
  parameter ESFSM_CTRLINIT_WR_RDY     = 'h05;
  parameter ESFSM_SDATA0_WR           = 'h06;
  parameter ESFSM_SDATA0_WR_RDY       = 'h07;
  parameter ESFSM_SDATA1_WR           = 'h08;
  parameter ESFSM_SDATA1_WR_RDY       = 'h09;
  parameter ESFSM_SDATA2_WR           = 'h0a;
  parameter ESFSM_SDATA2_WR_RDY       = 'h0b;
  parameter ESFSM_SDATA3_WR           = 'h0c;
  parameter ESFSM_SDATA3_WR_RDY       = 'h0d;
  parameter ESFSM_SDATA4_WR           = 'h0e;
  parameter ESFSM_SDATA4_WR_RDY       = 'h0f;
  parameter ESFSM_QDATA0_WR           = 'h10;
  parameter ESFSM_QDATA0_WR_RDY       = 'h11;
  parameter ESFSM_QDATA1_WR           = 'h12;
  parameter ESFSM_QDATA1_WR_RDY       = 'h13;
  parameter ESFSM_QDATA2_WR           = 'h14;
  parameter ESFSM_QDATA2_WR_RDY       = 'h15;
  parameter ESFSM_QDATA3_WR           = 'h16;
  parameter ESFSM_QDATA3_WR_RDY       = 'h17;
  parameter ESFSM_QDATA4_WR           = 'h18;
  parameter ESFSM_QDATA4_WR_RDY       = 'h19;
  parameter ESFSM_START               = 'h1a;
  parameter ESFSM_HOFFSET_RD          = 'h1b;
  parameter ESFSM_HOFFSET_RD_RDY      = 'h1c;
  parameter ESFSM_HOFFSET_WR          = 'h1d;
  parameter ESFSM_HOFFSET_WR_RDY      = 'h1e;
  parameter ESFSM_VOFFSET_RD          = 'h1f;
  parameter ESFSM_VOFFSET_RD_RDY      = 'h20;
  parameter ESFSM_VOFFSET_WR          = 'h21;
  parameter ESFSM_VOFFSET_WR_RDY      = 'h22;
  parameter ESFSM_CTRLSTART_RD        = 'h23;
  parameter ESFSM_CTRLSTART_RD_RDY    = 'h24;
  parameter ESFSM_CTRLSTART_WR        = 'h25;
  parameter ESFSM_CTRLSTART_WR_RDY    = 'h26;
  parameter ESFSM_STATUS_RD           = 'h27;
  parameter ESFSM_STATUS_RD_RDY       = 'h28;
  parameter ESFSM_CTRLSTOP_RD         = 'h29;
  parameter ESFSM_CTRLSTOP_RD_RDY     = 'h2a;
  parameter ESFSM_CTRLSTOP_WR         = 'h2b;
  parameter ESFSM_CTRLSTOP_WR_RDY     = 'h2c;
  parameter ESFSM_SCNT_RD             = 'h2d;
  parameter ESFSM_SCNT_RD_RDY         = 'h2e;
  parameter ESFSM_ECNT_RD             = 'h2f;
  parameter ESFSM_ECNT_RD_RDY         = 'h30;
  parameter ESFSM_DATA                = 'h31;

  reg             up_start_d = 'd0;
  reg             up_drp_en = 'd0;
  reg             up_drp_we = 'd0;
  reg     [ 8:0]  up_drp_addr = 'd0;
  reg     [15:0]  up_drp_wdata = 'd0;
  reg             es_state = 'd0;
  reg     [ 4:0]  es_prescale = 'd0;
  reg     [11:0]  es_hoffset = 'd0;
  reg     [ 7:0]  es_voffset = 'd0;
  reg     [15:0]  es_hoffset_rdata = 'd0;
  reg     [15:0]  es_voffset_rdata = 'd0;
  reg     [15:0]  es_ctrl_rdata = 'd0;
  reg     [15:0]  es_scnt_ut1 = 'd0;
  reg     [15:0]  es_scnt_ut0 = 'd0;
  reg     [16:0]  es_scnt = 'd0;
  reg     [15:0]  es_ecnt_ut1 = 'd0;
  reg     [15:0]  es_ecnt_ut0 = 'd0;
  reg     [16:0]  es_ecnt = 'd0;
  reg             es_ut = 'd0;
  reg             es_valid_d = 'd0;
  reg             es_valid_2d = 'd0;
  reg             es_sos_d = 'd0;
  reg             es_eos_d = 'd0;
  reg     [63:0]  es_data_d = 'd0;
  reg             es_valid = 'd0;
  reg             es_sos = 'd0;
  reg             es_eos = 'd0;
  reg     [31:0]  es_data = 'd0;
  reg     [ 5:0]  esfsm = 'd0;
 
  wire            es_start_s;
  wire            es_hsos_s;
  wire            es_sos_s;
  wire            es_heos_s;
  wire            es_eos_s;
  wire    [ 7:0]  es_voffset_2_s;
  wire    [ 7:0]  es_voffset_n_s;
  wire    [ 7:0]  es_voffset_s;
  wire            es_valid_s;
  wire    [63:0]  es_data_s;

  // debug interface

  assign es_dbg_trigger = {up_start, es_eos_s, esfsm};

  assign es_dbg_data[227:227] = up_start;
  assign es_dbg_data[226:226] = up_drp_en;
  assign es_dbg_data[225:225] = up_drp_we;
  assign es_dbg_data[224:216] = up_drp_addr;
  assign es_dbg_data[215:200] = up_drp_wdata;
  assign es_dbg_data[199:184] = up_drp_rdata;
  assign es_dbg_data[183:183] = up_drp_ready;
  assign es_dbg_data[182:182] = es_valid;
  assign es_dbg_data[181:118] = es_data_d;
  assign es_dbg_data[117:113] = es_prescale;
  assign es_dbg_data[112:101] = es_hoffset;
  assign es_dbg_data[100: 93] = es_voffset;
  assign es_dbg_data[ 92: 77] = es_hoffset_rdata;
  assign es_dbg_data[ 76: 61] = es_voffset_rdata;
  assign es_dbg_data[ 60: 45] = es_ctrl_rdata;
  assign es_dbg_data[ 44: 29] = (es_ut == 1) ? es_scnt_ut1 : es_scnt_ut0;
  assign es_dbg_data[ 28: 12] = (es_ut == 1) ? es_ecnt_ut1 : es_ecnt_ut0;
  assign es_dbg_data[ 11: 11] = es_ut;
  assign es_dbg_data[ 10:  5] = esfsm;
  assign es_dbg_data[  4:  4] = es_start_s;
  assign es_dbg_data[  3:  3] = es_hsos_s;
  assign es_dbg_data[  2:  2] = es_sos;
  assign es_dbg_data[  1:  1] = es_heos_s;
  assign es_dbg_data[  0:  0] = es_eos;

  // start eye scan request

  assign es_start_s = up_start & ~up_start_d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_start_d <= 'd0;
    end else begin
      up_start_d <= up_start;
    end
  end

  // drp writes (nothing special about this!)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_drp_en <= 1'b0;
      up_drp_we <= 1'b0;
      up_drp_addr <= 9'h000;
      up_drp_wdata <= 16'h0000;
    end else begin
      case (esfsm)
        ESFSM_CTRLINIT_RD: begin 
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h03d;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_CTRLINIT_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h03d;
          up_drp_wdata <= {es_ctrl_rdata[15:10], 2'b11, es_ctrl_rdata[7:0]};
        end
        ESFSM_SDATA0_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h036;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_SDATA1_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h037;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_SDATA2_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h038;
          up_drp_wdata <= 16'hffff;
        end
        ESFSM_SDATA3_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h039;
          up_drp_wdata <= 16'hffff;
        end
        ESFSM_SDATA4_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h03a;
          up_drp_wdata <= 16'hffff;
        end
        ESFSM_QDATA0_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h031;
          up_drp_wdata <= 16'hffff;
        end
        ESFSM_QDATA1_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h032;
          up_drp_wdata <= 16'hffff;
        end
        ESFSM_QDATA2_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h033;
          up_drp_wdata <= 16'hffff;
        end
        ESFSM_QDATA3_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h034;
          up_drp_wdata <= 16'hffff;
        end
        ESFSM_QDATA4_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h035;
          up_drp_wdata <= 16'hffff;
        end
        ESFSM_HOFFSET_RD: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h03c;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_HOFFSET_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h03c;
          up_drp_wdata <= {es_hoffset_rdata[15:12], es_hoffset};
        end
        ESFSM_VOFFSET_RD: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h03b;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_VOFFSET_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h03b;
          up_drp_wdata <= {es_prescale, es_voffset_rdata[10:9], es_ut, es_voffset_s};
        end
        ESFSM_CTRLSTART_RD: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h03d;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_CTRLSTART_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h03d;
          up_drp_wdata <= {es_ctrl_rdata[15:6], 6'd1};
        end
        ESFSM_STATUS_RD: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h151;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_CTRLSTOP_RD: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h03d;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_CTRLSTOP_WR: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b1;
          up_drp_addr <= 9'h03d;
          up_drp_wdata <= {es_ctrl_rdata[15:6], 6'd0};
        end
        ESFSM_SCNT_RD: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h150;
          up_drp_wdata <= 16'h0000;
        end
        ESFSM_ECNT_RD: begin
          up_drp_en <= 1'b1;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h14f;
          up_drp_wdata <= 16'h0000;
        end
        default: begin
          up_drp_en <= 1'b0;
          up_drp_we <= 1'b0;
          up_drp_addr <= 9'h000;
          up_drp_wdata <= 16'h0000;
        end
      endcase
    end
  end

  // prescale, horizontal and vertical offsets and max limits

  assign es_hsos_s = (es_hoffset == up_hoffset_min) ? es_ut : 1'b0;
  assign es_sos_s = (es_voffset == up_voffset_min) ? es_hsos_s : 1'b0;

  assign es_heos_s = (es_hoffset == up_hoffset_max) ? es_ut : 1'b0;
  assign es_eos_s = (es_voffset == up_voffset_max) ? es_heos_s : 1'b0;

  assign es_voffset_2_s = ~es_voffset + 1'b1;
  assign es_voffset_n_s = {1'b1, es_voffset_2_s[6:0]};
  assign es_voffset_s = (es_voffset[7] == 1'b1) ? es_voffset_n_s : es_voffset;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      es_state <= 'd0;
      es_prescale <= 'd0;
      es_hoffset <= 'd0;
      es_voffset <= 'd0;
    end else begin
      if (es_eos == 1'b1) begin
        es_state <= 1'b0;
      end else if (es_start_s == 1'b1) begin
        es_state <= 1'b1;
      end
      if (esfsm == ESFSM_INIT) begin
        es_prescale <= up_prescale;
        es_hoffset <= up_hoffset_min;
        es_voffset <= up_voffset_min;
      end else if (esfsm == ESFSM_DATA) begin
        es_prescale <= es_prescale;
        if (es_heos_s == 1'b1) begin
          es_hoffset <= up_hoffset_min;
        end else if (es_ut == 1'b1) begin
          es_hoffset <= es_hoffset + up_hoffset_step;
        end
        if (es_heos_s == 1'b1) begin
          es_voffset <= es_voffset + up_voffset_step;
        end
      end
    end
  end

  // store the read-modify-write parameters (gt's are full of mixed up controls)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      es_hoffset_rdata <= 'd0;
      es_voffset_rdata <= 'd0;
      es_ctrl_rdata <= 'd0;
    end else begin
      if ((esfsm == ESFSM_HOFFSET_RD_RDY) && (up_drp_ready == 1'b1)) begin
        es_hoffset_rdata <= up_drp_rdata;
      end
      if ((esfsm == ESFSM_VOFFSET_RD_RDY) && (up_drp_ready == 1'b1)) begin
        es_voffset_rdata <= up_drp_rdata;
      end
      if (((esfsm == ESFSM_CTRLINIT_RD_RDY) || (esfsm == ESFSM_CTRLSTART_RD_RDY) ||
        (esfsm == ESFSM_CTRLSTOP_RD_RDY)) && (up_drp_ready == 1'b1)) begin
        es_ctrl_rdata <= up_drp_rdata;
      end
    end
  end

  // store the sample and error counters
  // in data state- sum the two vertical offsets (ut) and write

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      es_scnt_ut1 <= 'd0;
      es_scnt_ut0 <= 'd0;
      es_scnt <= 'd0;
      es_ecnt_ut1 <= 'd0;
      es_ecnt_ut0 <= 'd0;
      es_ecnt <= 'd0;
      es_ut <= 'd0;
    end else begin
      if ((esfsm == ESFSM_SCNT_RD_RDY) && (up_drp_ready == 1'b1)) begin
        if (es_ut == 1'b1) begin
          es_scnt_ut1 <= up_drp_rdata;
          es_scnt_ut0 <= es_scnt_ut0;
          es_scnt <= es_scnt + up_drp_rdata;
        end else begin
          es_scnt_ut1 <= es_scnt_ut1;
          es_scnt_ut0 <= up_drp_rdata;
          es_scnt <= {1'b0, up_drp_rdata};
        end
      end
      if ((esfsm == ESFSM_ECNT_RD_RDY) && (up_drp_ready == 1'b1)) begin
        if (es_ut == 1'b1) begin
          es_ecnt_ut1 <= up_drp_rdata;
          es_ecnt_ut0 <= es_ecnt_ut0;
          es_ecnt <= es_ecnt + up_drp_rdata;
        end else begin
          es_ecnt_ut1 <= es_ecnt_ut1;
          es_ecnt_ut0 <= up_drp_rdata;
          es_ecnt <= {1'b0, up_drp_rdata};
        end
      end
      if (esfsm == ESFSM_DATA) begin
        es_ut <= ~es_ut;
      end
    end
  end

  // data write the buffer is indexed with the current offsets

  assign es_valid_s = (esfsm == ESFSM_DATA) ? es_ut : 1'b0;
  assign es_data_s = (up_mode == 1'b1) ? {es_scnt_ut1, es_scnt_ut0, es_ecnt_ut1, es_ecnt_ut0} :
    {15'd0, es_scnt, 15'd0, es_ecnt};

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      es_valid_d <= 'd0;
      es_valid_2d <= 'd0;
      es_sos_d <= 'd0;
      es_eos_d <= 'd0;
      es_data_d <= 'd0;
      es_valid <= 'd0;
      es_sos <= 'd0;
      es_eos <= 'd0;
      es_data <= 'd0;
    end else begin
      es_valid_d <= es_valid_s;
      es_valid_2d <= es_valid_d;
      if (es_valid_s == 1'b1) begin
        es_sos_d <= es_sos_s;
        es_eos_d <= es_eos_s;
        es_data_d <= es_data_s;
      end
      es_valid <= es_valid_d | es_valid_2d;
      es_sos <= es_sos_d & es_valid_d;
      es_eos <= es_eos_d & es_valid_2d;
      if (es_valid_d == 1'b1) begin
        es_data <= es_data_d[31:0];
      end else begin
        es_data <= es_data_d[63:32];
      end
    end
  end

  // eye scan state machine- nothing fancy here- we write vertical and horizontal
  // offsets first- followed by prescale and control- wait for done/end state-
  // write to clear run- read stuff - adjust prescale - 

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      esfsm <= ESFSM_IDLE;
    end else begin
      case (esfsm)
        ESFSM_IDLE: begin // idle state wait for software trigger
          if (es_start_s == 1'b1) begin
            esfsm <= ESFSM_INIT;
          end else begin
            esfsm <= ESFSM_IDLE;
          end
        end

        ESFSM_INIT: begin // initialize the parameters
          esfsm <= ESFSM_CTRLINIT_RD;
        end

        ESFSM_CTRLINIT_RD: begin // control read & wait for ready
          esfsm <= ESFSM_CTRLINIT_RD_RDY;
        end
        ESFSM_CTRLINIT_RD_RDY: begin // control read ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_CTRLINIT_WR;
          end else begin
            esfsm <= ESFSM_CTRLINIT_RD_RDY;
          end
        end
        ESFSM_CTRLINIT_WR: begin // control write & wait for ready
          esfsm <= ESFSM_CTRLINIT_WR_RDY;
        end
        ESFSM_CTRLINIT_WR_RDY: begin // control write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_SDATA0_WR;
          end else begin
            esfsm <= ESFSM_CTRLINIT_WR_RDY;
          end
        end

        ESFSM_SDATA0_WR: begin // sdata write & wait for ready
          esfsm <= ESFSM_SDATA0_WR_RDY;
        end
        ESFSM_SDATA0_WR_RDY: begin // sdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_SDATA1_WR;
          end else begin
            esfsm <= ESFSM_SDATA0_WR_RDY;
          end
        end
        ESFSM_SDATA1_WR: begin // sdata write & wait for ready
          esfsm <= ESFSM_SDATA1_WR_RDY;
        end
        ESFSM_SDATA1_WR_RDY: begin // sdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_SDATA2_WR;
          end else begin
            esfsm <= ESFSM_SDATA1_WR_RDY;
          end
        end
        ESFSM_SDATA2_WR: begin // sdata write & wait for ready
          esfsm <= ESFSM_SDATA2_WR_RDY;
        end
        ESFSM_SDATA2_WR_RDY: begin // sdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_SDATA3_WR;
          end else begin
            esfsm <= ESFSM_SDATA2_WR_RDY;
          end
        end
        ESFSM_SDATA3_WR: begin // sdata write & wait for ready
          esfsm <= ESFSM_SDATA3_WR_RDY;
        end
        ESFSM_SDATA3_WR_RDY: begin // sdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_SDATA4_WR;
          end else begin
            esfsm <= ESFSM_SDATA3_WR_RDY;
          end
        end
        ESFSM_SDATA4_WR: begin // sdata write & wait for ready
          esfsm <= ESFSM_SDATA4_WR_RDY;
        end
        ESFSM_SDATA4_WR_RDY: begin // sdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_QDATA0_WR;
          end else begin
            esfsm <= ESFSM_SDATA4_WR_RDY;
          end
        end

        ESFSM_QDATA0_WR: begin // qdata write & wait for ready
          esfsm <= ESFSM_QDATA0_WR_RDY;
        end
        ESFSM_QDATA0_WR_RDY: begin // qdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_QDATA1_WR;
          end else begin
            esfsm <= ESFSM_QDATA0_WR_RDY;
          end
        end
        ESFSM_QDATA1_WR: begin // qdata write & wait for ready
          esfsm <= ESFSM_QDATA1_WR_RDY;
        end
        ESFSM_QDATA1_WR_RDY: begin // qdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_QDATA2_WR;
          end else begin
            esfsm <= ESFSM_QDATA1_WR_RDY;
          end
        end
        ESFSM_QDATA2_WR: begin // qdata write & wait for ready
          esfsm <= ESFSM_QDATA2_WR_RDY;
        end
        ESFSM_QDATA2_WR_RDY: begin // qdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_QDATA3_WR;
          end else begin
            esfsm <= ESFSM_QDATA2_WR_RDY;
          end
        end
        ESFSM_QDATA3_WR: begin // qdata write & wait for ready
          esfsm <= ESFSM_QDATA3_WR_RDY;
        end
        ESFSM_QDATA3_WR_RDY: begin // qdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_QDATA4_WR;
          end else begin
            esfsm <= ESFSM_QDATA3_WR_RDY;
          end
        end
        ESFSM_QDATA4_WR: begin // qdata write & wait for ready
          esfsm <= ESFSM_QDATA4_WR_RDY;
        end
        ESFSM_QDATA4_WR_RDY: begin // qdata write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_START;
          end else begin
            esfsm <= ESFSM_QDATA4_WR_RDY;
          end
        end

        ESFSM_START: begin // place holder state
          esfsm <= ESFSM_HOFFSET_RD;
        end

        ESFSM_HOFFSET_RD: begin // horizontal offset read & wait for ready
          esfsm <= ESFSM_HOFFSET_RD_RDY;
        end
        ESFSM_HOFFSET_RD_RDY: begin // horizontal offset ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_HOFFSET_WR;
          end else begin
            esfsm <= ESFSM_HOFFSET_RD_RDY;
          end
        end
        ESFSM_HOFFSET_WR: begin // horizontal offset write & wait for ready
          esfsm <= ESFSM_HOFFSET_WR_RDY;
        end
        ESFSM_HOFFSET_WR_RDY: begin // horizontal offset ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_VOFFSET_RD;
          end else begin
            esfsm <= ESFSM_HOFFSET_WR_RDY;
          end
        end

        ESFSM_VOFFSET_RD: begin // vertical offset read & wait for ready
          esfsm <= ESFSM_VOFFSET_RD_RDY;
        end
        ESFSM_VOFFSET_RD_RDY: begin // vertical offset ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_VOFFSET_WR;
          end else begin
            esfsm <= ESFSM_VOFFSET_RD_RDY;
          end
        end
        ESFSM_VOFFSET_WR: begin // vertical offset write & wait for ready
          esfsm <= ESFSM_VOFFSET_WR_RDY;
        end
        ESFSM_VOFFSET_WR_RDY: begin // vertical offset ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_CTRLSTART_RD;
          end else begin
            esfsm <= ESFSM_VOFFSET_WR_RDY;
          end
        end

        ESFSM_CTRLSTART_RD: begin // control read & wait for ready
          esfsm <= ESFSM_CTRLSTART_RD_RDY;
        end
        ESFSM_CTRLSTART_RD_RDY: begin // control read ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_CTRLSTART_WR;
          end else begin
            esfsm <= ESFSM_CTRLSTART_RD_RDY;
          end
        end
        ESFSM_CTRLSTART_WR: begin // control write & wait for ready
          esfsm <= ESFSM_CTRLSTART_WR_RDY;
        end
        ESFSM_CTRLSTART_WR_RDY: begin // control write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_STATUS_RD;
          end else begin
            esfsm <= ESFSM_CTRLSTART_WR_RDY;
          end
        end

        ESFSM_STATUS_RD: begin // status read & wait for ready
          esfsm <= ESFSM_STATUS_RD_RDY;
        end
        ESFSM_STATUS_RD_RDY: begin // status read ready
          if (up_drp_ready == 1'b1) begin
            if (up_drp_rdata[3:0] == 4'b0101) begin // end state with done asserted
              esfsm <= ESFSM_CTRLSTOP_RD;
            end else begin
              esfsm <= ESFSM_STATUS_RD;
            end
          end else begin
            esfsm <= ESFSM_STATUS_RD_RDY;
          end
        end

        ESFSM_CTRLSTOP_RD: begin // control read & wait for ready
          esfsm <= ESFSM_CTRLSTOP_RD_RDY;
        end
        ESFSM_CTRLSTOP_RD_RDY: begin // control read ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_CTRLSTOP_WR;
          end else begin
            esfsm <= ESFSM_CTRLSTOP_RD_RDY;
          end
        end
        ESFSM_CTRLSTOP_WR: begin // control write & wait for ready
          esfsm <= ESFSM_CTRLSTOP_WR_RDY;
        end
        ESFSM_CTRLSTOP_WR_RDY: begin // control write ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_SCNT_RD;
          end else begin
            esfsm <= ESFSM_CTRLSTOP_WR_RDY;
          end
        end

        ESFSM_SCNT_RD: begin // read sample count & wait for ready
          esfsm <= ESFSM_SCNT_RD_RDY;
        end
        ESFSM_SCNT_RD_RDY: begin // sample count ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_ECNT_RD;
          end else begin
            esfsm <= ESFSM_SCNT_RD_RDY;
          end
        end

        ESFSM_ECNT_RD: begin // read sample count & wait for ready
          esfsm <= ESFSM_ECNT_RD_RDY;
        end
        ESFSM_ECNT_RD_RDY: begin // sample count ready
          if (up_drp_ready == 1'b1) begin
            esfsm <= ESFSM_DATA;
          end else begin
            esfsm <= ESFSM_ECNT_RD_RDY;
          end
        end

        ESFSM_DATA: begin // data sum & store
          if (es_eos_s == 1'b1) begin
            esfsm <= ESFSM_IDLE;
          end else if (es_ut == 1'b1) begin
            esfsm <= ESFSM_HOFFSET_RD;
          end else begin
            esfsm <= ESFSM_VOFFSET_RD;
          end
        end

        default: begin
          esfsm <= ESFSM_IDLE;
        end
      endcase
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
