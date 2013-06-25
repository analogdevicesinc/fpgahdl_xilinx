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
// Receive HDMI, hdmi embedded syncs data in, video dma data out.

module cf_h2v_vdma (

  // hdmi interface

  hdmi_clk,
  hdmi_fs_toggle,         // start of frame toggle & write address
  hdmi_fs_waddr,
  hdmi_wr,
  hdmi_waddr,
  hdmi_wdata,
  hdmi_waddr_rel_toggle,  // released write address toggle & data
  hdmi_waddr_rel,
  hdmi_waddr_g,

  // vdma interface

  vdma_clk,
  vdma_fs,
  vdma_fs_ret,
  vdma_valid,
  vdma_be,
  vdma_data,
  vdma_last,
  vdma_ready,
  vdma_ovf,
  vdma_unf,
  vdma_tpm_oos,

  // allow right alignment of data (24bits to 32bits) (default is left)

  up_align_right,

  // debug data (chipscope)

  debug_data,
  debug_trigger);

  // hdmi interface

  input           hdmi_clk;
  input           hdmi_fs_toggle;
  input   [ 8:0]  hdmi_fs_waddr;
  input           hdmi_wr;
  input   [ 8:0]  hdmi_waddr;
  input   [48:0]  hdmi_wdata;
  input           hdmi_waddr_rel_toggle;
  input   [ 8:0]  hdmi_waddr_rel;
  input   [ 8:0]  hdmi_waddr_g;

  // vdma interface

  input           vdma_clk;
  output          vdma_fs;
  input           vdma_fs_ret;
  output          vdma_valid;
  output  [ 7:0]  vdma_be;
  output  [63:0]  vdma_data;
  output          vdma_last;
  input           vdma_ready;
  output          vdma_ovf;
  output          vdma_unf;
  output          vdma_tpm_oos;

  // allow right alignment of data (24bits to 32bits) (default is left)

  input           up_align_right;

  // debug data (chipscope)

  output  [39:0]  debug_data;
  output  [ 7:0]  debug_trigger;

  reg             vdma_align_right_m1 = 'd0;
  reg             vdma_align_right = 'd0;
  reg     [22:0]  vdma_tpm_data = 'd0;
  reg     [ 4:0]  vdma_tpm_mismatch_count = 'd0;
  reg             vdma_tpm_oos = 'd0;
  reg             vdma_fs_toggle_m1 = 'd0;
  reg             vdma_fs_toggle_m2 = 'd0;
  reg             vdma_fs_toggle_m3 = 'd0;
  reg             vdma_fs = 'd0;
  reg     [ 8:0]  vdma_fs_waddr = 'd0;
  reg             vdma_waddr_rel_toggle_m1 = 'd0;
  reg             vdma_waddr_rel_toggle_m2 = 'd0;
  reg             vdma_waddr_rel_toggle_m3 = 'd0;
  reg     [ 8:0]  vdma_waddr_rel = 'd0;
  reg     [ 8:0]  vdma_waddr_g_m1 = 'd0;
  reg     [ 8:0]  vdma_waddr_g_m2 = 'd0;
  reg     [ 8:0]  vdma_waddr = 'd0;
  reg     [ 8:0]  vdma_addr_diff = 'd0;
  reg             vdma_rd_en = 'd0;
  reg     [ 8:0]  vdma_raddr = 'd0;
  reg             vdma_rd = 'd0;
  reg             vdma_rvalid = 'd0;
  reg     [48:0]  vdma_rdata = 'd0;
  reg     [ 1:0]  vdma_wcnt = 'd0;
  reg             vdma_rvalid_0 = 'd0;
  reg     [64:0]  vdma_rdata_0 = 'd0;
  reg             vdma_rvalid_1 = 'd0;
  reg     [64:0]  vdma_rdata_1 = 'd0;
  reg             vdma_rvalid_2 = 'd0;
  reg     [64:0]  vdma_rdata_2 = 'd0;
  reg             vdma_rvalid_3 = 'd0;
  reg     [64:0]  vdma_rdata_3 = 'd0;
  reg     [ 1:0]  vdma_rcnt = 'd0;
  reg             vdma_valid = 'd0;
  reg     [ 7:0]  vdma_be = 'd0;
  reg             vdma_last = 'd0;
  reg     [63:0]  vdma_data = 'd0;
  reg             vdma_almost_full = 'd0;
  reg             vdma_almost_empty = 'd0;
  reg     [ 4:0]  vdma_ovf_count = 'd0;
  reg             vdma_ovf = 'd0;
  reg     [ 4:0]  vdma_unf_count = 'd0;
  reg             vdma_unf = 'd0;

  wire    [63:0]  vdma_tpm_data_s;
  wire            vdma_tpm_mismatch_s;
  wire            vdma_fs_s;
  wire    [ 9:0]  vdma_addr_diff_s;
  wire            vdma_waddr_rel_s;
  wire            vdma_xfer_en_s;
  wire            vdma_rd_s;
  wire    [64:0]  vdma_rdata_align_s;
  wire            vdma_ovf_s;
  wire            vdma_unf_s;
  wire    [48:0]  vdma_rdata_s;

  // grey to binary conversion

  function [8:0] g2b;
    input [8:0] g;
    reg   [8:0] b;
    begin
      b[8] = g[8];
      b[7] = b[8] ^ g[7];
      b[6] = b[7] ^ g[6];
      b[5] = b[6] ^ g[5];
      b[4] = b[5] ^ g[4];
      b[3] = b[4] ^ g[3];
      b[2] = b[3] ^ g[2];
      b[1] = b[2] ^ g[1];
      b[0] = b[1] ^ g[0];
      g2b = b;
    end
  endfunction

  // debug ports

  assign debug_data[39:39] = vdma_tpm_oos;
  assign debug_data[38:38] = vdma_tpm_mismatch_s;
  assign debug_data[37:37] = vdma_ovf_s;
  assign debug_data[36:36] = vdma_unf_s;
  assign debug_data[35:35] = vdma_almost_full;
  assign debug_data[34:34] = vdma_almost_empty;
  assign debug_data[33:33] = vdma_fs;
  assign debug_data[32:32] = vdma_fs_ret;
  assign debug_data[31:31] = vdma_rd_s;
  assign debug_data[30:29] = vdma_wcnt;
  assign debug_data[28:27] = vdma_rcnt;
  assign debug_data[26:26] = vdma_valid;
  assign debug_data[25:25] = vdma_ready;
  assign debug_data[24:24] = vdma_last;
  assign debug_data[23: 0] = vdma_data[23:0];

  assign debug_trigger[7] = vdma_tpm_mismatch_s;
  assign debug_trigger[6] = vdma_ovf_s;
  assign debug_trigger[5] = vdma_unf_s;
  assign debug_trigger[4] = vdma_fs;
  assign debug_trigger[3] = vdma_fs_ret;
  assign debug_trigger[2] = vdma_last;
  assign debug_trigger[1] = vdma_valid;
  assign debug_trigger[0] = vdma_ready;

  // transfer processor signals to vdma domain

  always @(posedge vdma_clk) begin
    vdma_align_right_m1 <= up_align_right;
    vdma_align_right <= vdma_align_right_m1;
  end

  // vdma tpm signals

  assign vdma_tpm_data_s = {8'd0, vdma_tpm_data, 1'b1, 8'd0, vdma_tpm_data, 1'b0};
  assign vdma_tpm_mismatch_s = (vdma_data == vdma_tpm_data_s) ? 1'b0 : (vdma_valid & vdma_ready);

  always @(posedge vdma_clk) begin
    if (vdma_fs_s == 1'b1) begin
      vdma_tpm_data <= 'd0;
    end else if ((vdma_valid == 1'b1) && (vdma_ready == 1'b1)) begin
      vdma_tpm_data <= vdma_tpm_data + 1'b1;
    end
    if (vdma_tpm_mismatch_s == 1'b1) begin
      vdma_tpm_mismatch_count <= 5'h10;
    end else if (vdma_tpm_mismatch_count[4] == 1'b1) begin
      vdma_tpm_mismatch_count <= vdma_tpm_mismatch_count + 1'b1;
    end
    vdma_tpm_oos <= vdma_tpm_mismatch_count[4];
  end

  // hdmi write addresses transferred to vdma domain, start of frame and release pointers

  assign vdma_fs_s = vdma_fs_toggle_m2 ^ vdma_fs_toggle_m3;
  assign vdma_addr_diff_s = {1'b1, vdma_waddr} - vdma_raddr;
  assign vdma_waddr_rel_s = vdma_waddr_rel_toggle_m2 ^ vdma_waddr_rel_toggle_m3;

  always @(posedge vdma_clk) begin
    vdma_fs_toggle_m1 <= hdmi_fs_toggle;
    vdma_fs_toggle_m2 <= vdma_fs_toggle_m1;
    vdma_fs_toggle_m3 <= vdma_fs_toggle_m2;
    vdma_fs <= vdma_fs_s;
    if (vdma_fs_s == 1'b1) begin
      vdma_fs_waddr <= hdmi_fs_waddr;
    end
    vdma_waddr_rel_toggle_m1 <= hdmi_waddr_rel_toggle;
    vdma_waddr_rel_toggle_m2 <= vdma_waddr_rel_toggle_m1;
    vdma_waddr_rel_toggle_m3 <= vdma_waddr_rel_toggle_m2;
    if (vdma_waddr_rel_s == 1'b1) begin
      vdma_waddr_rel <= hdmi_waddr_rel;
    end
    vdma_waddr_g_m1 <= hdmi_waddr_g;
    vdma_waddr_g_m2 <= vdma_waddr_g_m1;
    vdma_waddr <= g2b(vdma_waddr_g_m2);
    vdma_addr_diff <= vdma_addr_diff_s[8:0];
  end

  // vdma read (read is enabled after fs is returned).

  assign vdma_xfer_en_s = vdma_ready | ~vdma_valid;
  assign vdma_rd_s = (vdma_waddr_rel == vdma_raddr) ? 1'b0 : (vdma_ready & vdma_rd_en);

  always @(posedge vdma_clk) begin
    if (vdma_fs_ret == 1'b1) begin
      vdma_rd_en <= 1'b1;
    end else if (vdma_fs_s == 1'b1) begin
      vdma_rd_en <= 1'b0;
    end
    if (vdma_fs_ret == 1'b1) begin
      vdma_raddr <= vdma_fs_waddr;
    end else if (vdma_rd_s == 1'b1) begin
      vdma_raddr <= vdma_raddr + 1'b1;
    end
    vdma_rd <= vdma_rd_s;
    vdma_rvalid <= vdma_rd;
    vdma_rdata <= vdma_rdata_s;
  end

  // linux requires data to be msb-aligned (left) in the receive direction.
  // loop back requires data to be lsb-aligned (right) to match transmit.

  assign vdma_rdata_align_s = (vdma_align_right == 1) ?
    {vdma_rdata[48], 8'd0, vdma_rdata[47:24], 8'd0, vdma_rdata[23:0]} :
    {vdma_rdata[48], vdma_rdata[47:24], 8'd0, vdma_rdata[23:0], 8'd0};

  // vdma required a hard stop on data/valid when ready is deasserted

  always @(posedge vdma_clk) begin
    if (vdma_rvalid == 1'b1) begin
      vdma_wcnt <= vdma_wcnt + 1'b1;
    end
    if ((vdma_wcnt == 2'd0) && (vdma_rvalid == 1'b1)) begin
      vdma_rvalid_0 <= 1'b1;
      vdma_rdata_0 <= vdma_rdata_align_s;
    end else if ((vdma_rcnt == 2'd0) && (vdma_xfer_en_s == 1'b1)) begin
      vdma_rvalid_0 <= 1'b0;
      vdma_rdata_0 <= 65'd0;
    end
    if ((vdma_wcnt == 2'd1) && (vdma_rvalid == 1'b1)) begin
      vdma_rvalid_1 <= 1'b1;
      vdma_rdata_1 <= vdma_rdata_align_s;
    end else if ((vdma_rcnt == 2'd1) && (vdma_xfer_en_s == 1'b1)) begin
      vdma_rvalid_1 <= 1'b0;
      vdma_rdata_1 <= 65'd0;
    end
    if ((vdma_wcnt == 2'd2) && (vdma_rvalid == 1'b1)) begin
      vdma_rvalid_2 <= 1'b1;
      vdma_rdata_2 <= vdma_rdata_align_s;
    end else if ((vdma_rcnt == 2'd2) && (vdma_xfer_en_s == 1'b1)) begin
      vdma_rvalid_2 <= 1'b0;
      vdma_rdata_2 <= 65'd0;
    end
    if ((vdma_wcnt == 2'd3) && (vdma_rvalid == 1'b1)) begin
      vdma_rvalid_3 <= 1'b1;
      vdma_rdata_3 <= vdma_rdata_align_s;
    end else if ((vdma_rcnt == 2'd3) && (vdma_xfer_en_s == 1'b1)) begin
      vdma_rvalid_3 <= 1'b0;
      vdma_rdata_3 <= 65'd0;
    end
    if ((vdma_rcnt != vdma_wcnt) && (vdma_xfer_en_s == 1'b1)) begin
      vdma_rcnt <= vdma_rcnt + 1'b1;
    end
    if ((vdma_valid == 1'b0) || (vdma_ready == 1'b1)) begin
      case (vdma_rcnt)
        2'd3: begin
          vdma_valid <= vdma_rvalid_3;
          vdma_be <= 8'hff;
          vdma_last <= vdma_rdata_3[64] & vdma_rvalid_3;
          vdma_data <= vdma_rdata_3[63:0];
        end
        2'd2: begin
          vdma_valid <= vdma_rvalid_2;
          vdma_be <= 8'hff;
          vdma_last <= vdma_rdata_2[64] & vdma_rvalid_2;
          vdma_data <= vdma_rdata_2[63:0];
        end
        2'd1: begin
          vdma_valid <= vdma_rvalid_1;
          vdma_be <= 8'hff;
          vdma_last <= vdma_rdata_1[64] & vdma_rvalid_1;
          vdma_data <= vdma_rdata_1[63:0];
        end
        default: begin
          vdma_valid <= vdma_rvalid_0;
          vdma_be <= 8'hff;
          vdma_last <= vdma_rdata_0[64] & vdma_rvalid_0;
          vdma_data <= vdma_rdata_0[63:0];
        end
      endcase
    end
  end

  // overflow or underflow status

  assign vdma_ovf_s = (vdma_addr_diff < 3) ? vdma_almost_full : 1'b0;
  assign vdma_unf_s = (vdma_addr_diff > 509) ? vdma_almost_empty : 1'b0;

  always @(posedge vdma_clk) begin
    vdma_almost_full = (vdma_addr_diff > 509) ? 1'b1 : 1'b0;
    vdma_almost_empty = (vdma_addr_diff < 3) ? 1'b1 : 1'b0;
    if (vdma_ovf_s == 1'b1) begin
      vdma_ovf_count <= 5'h10;
    end else if (vdma_ovf_count[4] == 1'b1) begin
      vdma_ovf_count <= vdma_ovf_count + 1'b1;
    end
    vdma_ovf <= vdma_ovf_count[4];
    if (vdma_unf_s == 1'b1) begin
      vdma_unf_count <= 5'h10;
    end else if (vdma_unf_count[4] == 1'b1) begin
      vdma_unf_count <= vdma_unf_count + 1'b1;
    end
    vdma_unf <= vdma_unf_count[4];
  end

  // data memory

  cf_mem #(.DW(49), .AW(9)) i_mem (
    .clka (hdmi_clk),
    .wea (hdmi_wr),
    .addra (hdmi_waddr),
    .dina (hdmi_wdata),
    .clkb (vdma_clk),
    .addrb (vdma_raddr),
    .doutb (vdma_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
