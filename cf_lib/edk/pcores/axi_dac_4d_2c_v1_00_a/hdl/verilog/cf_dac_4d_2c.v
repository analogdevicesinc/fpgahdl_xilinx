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

module cf_dac_4d_2c (

  rst,
  pid,

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_frame_out_p,
  dac_frame_out_n,
  dac_data_out_p,
  dac_data_out_n,

  vdma_clk,
  vdma_valid,
  vdma_data,
  vdma_ready,

  up_rstn,
  up_clk,
  up_sel,
  up_rwn,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,
  up_status,

  up_dds_enable_int,
  up_dds_frame_int,
  up_dds_enable_ext,
  up_dds_frame_ext,

  vdma_dbg_data,
  vdma_dbg_trigger,

  dac_div3_clk,
  dac_dbg_data,
  dac_dbg_trigger,

  delay_clk);

  parameter C_CF_BUFTYPE = 0;

  input           rst;
  input   [ 7:0]  pid;

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output          dac_frame_out_p;
  output          dac_frame_out_n;
  output  [15:0]  dac_data_out_p;
  output  [15:0]  dac_data_out_n;

  input           vdma_clk;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_rwn;
  input   [ 4:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;
  output  [ 7:0]  up_status;

  output          up_dds_enable_int;
  output          up_dds_frame_int;
  input           up_dds_enable_ext;
  input           up_dds_frame_ext;

  output  [198:0] vdma_dbg_data;
  output  [ 7:0]  vdma_dbg_trigger;

  output          dac_div3_clk;
  output  [195:0] dac_dbg_data;
  output  [ 7:0]  dac_dbg_trigger;

  input           delay_clk;

  reg             up_dds_psel = 'd0;
  reg             up_intp_enable = 'd0;
  reg             up_dds_sel = 'd0;
  reg             up_dds_enable_int = 'd0;
  reg             up_dds_clk_enable = 'd0;
  reg     [15:0]  up_dds_init_1a = 'd0;
  reg     [15:0]  up_dds_incr_1a = 'd0;
  reg     [15:0]  up_dds_init_1b = 'd0;
  reg     [15:0]  up_dds_incr_1b = 'd0;
  reg     [15:0]  up_dds_init_2a = 'd0;
  reg     [15:0]  up_dds_incr_2a = 'd0;
  reg     [15:0]  up_dds_init_2b = 'd0;
  reg     [15:0]  up_dds_incr_2b = 'd0;
  reg     [15:0]  up_intp_scale_b = 'd0;
  reg     [15:0]  up_intp_scale_a = 'd0;
  reg             up_status_enable = 'd0;
  reg     [ 3:0]  up_dds_scale_2b = 'd0;
  reg     [ 3:0]  up_dds_scale_2a = 'd0;
  reg     [ 3:0]  up_dds_scale_1b = 'd0;
  reg     [ 3:0]  up_dds_scale_1a = 'd0;
  reg             up_dds_frame_int = 'd0;
  reg     [15:0]  up_dds_data_2b = 'd0;
  reg     [15:0]  up_dds_data_2a = 'd0;
  reg     [15:0]  up_dds_data_1b = 'd0;
  reg     [15:0]  up_dds_data_1a = 'd0;
  reg     [ 7:0]  up_status = 'd0;
  reg             up_dds_master_enable_n = 'd0;
  reg             up_dds_master_frame = 'd0;
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
  wire            up_ack_s;
  wire            vdma_ovf_s;
  wire            vdma_unf_s;
  wire            dds_master_enable_s;
  wire            dds_master_frame_s;
  wire    [ 2:0]  dds_frame_0_s;
  wire    [15:0]  dds_data_00_s;
  wire    [15:0]  dds_data_01_s;
  wire    [15:0]  dds_data_02_s;
  wire    [ 2:0]  dds_frame_1_s;
  wire    [15:0]  dds_data_10_s;
  wire    [15:0]  dds_data_11_s;
  wire    [15:0]  dds_data_12_s;

  assign up_wr_s = up_sel & ~up_rwn;
  assign up_ack_s = up_sel_d & ~up_sel_2d;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_dds_psel <= 'd0;
      up_intp_enable <= 'd0;
      up_dds_sel <= 'd0;
      up_dds_enable_int <= 'd0;
      up_dds_clk_enable <= 'd0;
      up_dds_init_1a <= 'd0;
      up_dds_incr_1a <= 'd0;
      up_dds_init_1b <= 'd0;
      up_dds_incr_1b <= 'd0;
      up_dds_init_2a <= 'd0;
      up_dds_incr_2a <= 'd0;
      up_dds_init_2b <= 'd0;
      up_dds_incr_2b <= 'd0;
      up_intp_scale_b <= 'd0;
      up_intp_scale_a <= 'd0;
      up_status_enable <= 'd0;
      up_dds_scale_2b <= 'd0;
      up_dds_scale_2a <= 'd0;
      up_dds_scale_1b <= 'd0;
      up_dds_scale_1a <= 'd0;
      up_dds_frame_int <= 'd0;
      up_dds_data_2b <= 'd0;
      up_dds_data_2a <= 'd0;
      up_dds_data_1b <= 'd0;
      up_dds_data_1a <= 'd0;
      up_status <= 'd0;
      up_dds_master_enable_n <= 'd1;
      up_dds_master_frame <= 'd0;
      up_vdma_ovf_m1 <= 'd0;
      up_vdma_ovf_m2 <= 'd0;
      up_vdma_ovf <= 'd0;
      up_vdma_unf_m1 <= 'd0;
      up_vdma_unf_m2 <= 'd0;
      up_vdma_unf <= 'd0;
    end else begin
      if ((up_addr == 5'h01) && (up_wr_s == 1'b1)) begin
        up_dds_psel <= up_wdata[4];
        up_intp_enable <= up_wdata[3];
        up_dds_sel <= up_wdata[2];
        up_dds_enable_int <= up_wdata[1];
        up_dds_clk_enable <= up_wdata[0];
      end
      if ((up_addr == 5'h02) && (up_wr_s == 1'b1)) begin
        up_dds_init_1a <= up_wdata[31:16];
        up_dds_incr_1a <= up_wdata[15:0];
      end
      if ((up_addr == 5'h03) && (up_wr_s == 1'b1)) begin
        up_dds_init_1b <= up_wdata[31:16];
        up_dds_incr_1b <= up_wdata[15:0];
      end
      if ((up_addr == 5'h04) && (up_wr_s == 1'b1)) begin
        up_dds_init_2a <= up_wdata[31:16];
        up_dds_incr_2a <= up_wdata[15:0];
      end
      if ((up_addr == 5'h05) && (up_wr_s == 1'b1)) begin
        up_dds_init_2b <= up_wdata[31:16];
        up_dds_incr_2b <= up_wdata[15:0];
      end
      if ((up_addr == 5'h06) && (up_wr_s == 1'b1)) begin
        up_intp_scale_b <= up_wdata[31:16];
        up_intp_scale_a <= up_wdata[15:0];
      end
      if ((up_addr == 5'h07) && (up_wr_s == 1'b1)) begin
        up_status_enable <= up_wdata[0];
      end
      if ((up_addr == 5'h08) && (up_wr_s == 1'b1)) begin
        up_dds_scale_2b <= up_wdata[15:12];
        up_dds_scale_2a <= up_wdata[11: 8];
        up_dds_scale_1b <= up_wdata[ 7: 4];
        up_dds_scale_1a <= up_wdata[ 3: 0];
      end
      if ((up_addr == 5'h09) && (up_wr_s == 1'b1)) begin
        up_dds_frame_int <= up_wdata[0];
      end
      if ((up_addr == 5'h11) && (up_wr_s == 1'b1)) begin
        up_dds_data_2b <= up_wdata[31:16];
        up_dds_data_2a <= up_wdata[15:0];
      end
      if ((up_addr == 5'h10) && (up_wr_s == 1'b1)) begin
        up_dds_data_1b <= up_wdata[31:16];
        up_dds_data_1a <= up_wdata[15:0];
      end
      if (up_status_enable == 1'b1) begin
        up_status <= {pid[0], ~up_dds_master_enable_n, up_dds_master_frame, up_dds_frame_int,
          up_intp_enable, up_dds_sel, up_dds_enable_int, up_dds_clk_enable};
      end else begin
        up_status <= 'd0;
      end
      if (pid == 0) begin
        up_dds_master_enable_n <= ~up_dds_enable_int;
        up_dds_master_frame <= up_dds_frame_int;
      end else begin
        up_dds_master_enable_n <= ~up_dds_enable_ext;
        up_dds_master_frame <= up_dds_frame_ext;
      end
      up_vdma_ovf_m1 <= vdma_ovf_s;
      up_vdma_ovf_m2 <= up_vdma_ovf_m1;
      if (up_vdma_ovf_m2 == 1'b1) begin
        up_vdma_ovf <= 1'b1;
      end else if ((up_addr == 5'h0a) && (up_wr_s == 1'b1)) begin
        up_vdma_ovf <= up_vdma_ovf & (~up_wdata[1]);
      end
      up_vdma_unf_m1 <= vdma_unf_s;
      up_vdma_unf_m2 <= up_vdma_unf_m1;
      if (up_vdma_unf_m2 == 1'b1) begin
        up_vdma_unf <= 1'b1;
      end else if ((up_addr == 5'h0a) && (up_wr_s == 1'b1)) begin
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
        5'h01: up_rdata <= {27'd0, up_dds_psel, up_intp_enable, up_dds_sel,
                            up_dds_enable_int, up_dds_clk_enable};
        5'h02: up_rdata <= {up_dds_init_1a, up_dds_incr_1a};
        5'h03: up_rdata <= {up_dds_init_1b, up_dds_incr_1b};
        5'h04: up_rdata <= {up_dds_init_2a, up_dds_incr_2a};
        5'h05: up_rdata <= {up_dds_init_2b, up_dds_incr_2b};
        5'h06: up_rdata <= {up_intp_scale_b, up_intp_scale_a};
        5'h07: up_rdata <= {31'd0, up_status_enable};
        5'h08: up_rdata <= {16'd0, up_dds_scale_2b, up_dds_scale_2a,
                            up_dds_scale_1b, up_dds_scale_1a};
        5'h09: up_rdata <= {31'd0, up_dds_frame_int};
        5'h0a: up_rdata <= {30'd0, up_vdma_ovf, up_vdma_unf};
        5'h10: up_rdata <= {up_dds_data_1b, up_dds_data_1a};
        5'h11: up_rdata <= {up_dds_data_2b, up_dds_data_2a};
        5'h12: up_rdata <= {24'd0, pid};
        default: up_rdata <= 0;
      endcase
      up_sel_d <= up_sel;
      up_sel_2d <= up_sel_d;
      up_ack <= up_ack_s;
    end
  end

  FDCE #(.INIT(1'b0)) i_m_enable (
    .CE (1'b1),
    .D (1'b1),
    .CLR (up_dds_master_enable_n),
    .C (dac_div3_clk),
    .Q (dds_master_enable_s));

  FDPE #(.INIT(1'b0)) i_m_frame (
    .CE (1'b1),
    .D (1'b0),
    .PRE (up_dds_master_frame),
    .C (dac_div3_clk),
    .Q (dds_master_frame_s));

  cf_dds_top i_dds_top (
    .vdma_clk (vdma_clk),
    .vdma_valid (vdma_valid),
    .vdma_data (vdma_data),
    .vdma_ready (vdma_ready),
    .vdma_ovf (vdma_ovf_s),
    .vdma_unf (vdma_unf_s),
    .dac_div3_clk (dac_div3_clk),
    .dds_master_enable (dds_master_enable_s),
    .dds_master_frame (dds_master_frame_s),
    .dds_frame_0 (dds_frame_0_s),
    .dds_data_00 (dds_data_00_s),
    .dds_data_01 (dds_data_01_s),
    .dds_data_02 (dds_data_02_s),
    .dds_frame_1 (dds_frame_1_s),
    .dds_data_10 (dds_data_10_s),
    .dds_data_11 (dds_data_11_s),
    .dds_data_12 (dds_data_12_s),
    .up_dds_psel (up_dds_psel),
    .up_dds_sel (up_dds_sel),
    .up_dds_init_1a (up_dds_init_1a),
    .up_dds_incr_1a (up_dds_incr_1a),
    .up_dds_scale_1a (up_dds_scale_1a),
    .up_dds_init_1b (up_dds_init_1b),
    .up_dds_incr_1b (up_dds_incr_1b),
    .up_dds_scale_1b (up_dds_scale_1b),
    .up_dds_init_2a (up_dds_init_2a),
    .up_dds_incr_2a (up_dds_incr_2a),
    .up_dds_scale_2a (up_dds_scale_2a),
    .up_dds_init_2b (up_dds_init_2b),
    .up_dds_incr_2b (up_dds_incr_2b),
    .up_dds_scale_2b (up_dds_scale_2b),
    .up_dds_data_1a (up_dds_data_1a),
    .up_dds_data_1b (up_dds_data_1b),
    .up_dds_data_2a (up_dds_data_2a),
    .up_dds_data_2b (up_dds_data_2b),
    .up_intp_enable (up_intp_enable),
    .up_intp_scale_a (up_intp_scale_a),
    .up_intp_scale_b (up_intp_scale_b),
    .vdma_dbg_data (vdma_dbg_data),
    .vdma_dbg_trigger (vdma_dbg_trigger),
    .dac_dbg_data (dac_dbg_data),
    .dac_dbg_trigger (dac_dbg_trigger));

  cf_dac_if #(.C_CF_BUFTYPE(C_CF_BUFTYPE)) i_dac_if (
    .rst (rst),
    .up_dds_clk_enable (up_dds_clk_enable),
    .dac_clk_in_p (dac_clk_in_p),
    .dac_clk_in_n (dac_clk_in_n),
    .dac_clk_out_p (dac_clk_out_p),
    .dac_clk_out_n (dac_clk_out_n),
    .dac_frame_out_p (dac_frame_out_p),
    .dac_frame_out_n (dac_frame_out_n),
    .dac_data_out_p (dac_data_out_p),
    .dac_data_out_n (dac_data_out_n),
    .dac_div3_clk (dac_div3_clk),
    .dds_master_enable (up_dds_clk_enable),
    .dds_frame_0 (dds_frame_0_s),
    .dds_data_00 (dds_data_00_s),
    .dds_data_01 (dds_data_01_s),
    .dds_data_02 (dds_data_02_s),
    .dds_frame_1 (dds_frame_1_s),
    .dds_data_10 (dds_data_10_s),
    .dds_data_11 (dds_data_11_s),
    .dds_data_12 (dds_data_12_s),
    .delay_clk (delay_clk),
    .delay_enable (1'b0),
    .delay_incdecn (1'b0),
    .delay_locked ());

endmodule

// ***************************************************************************
// ***************************************************************************
