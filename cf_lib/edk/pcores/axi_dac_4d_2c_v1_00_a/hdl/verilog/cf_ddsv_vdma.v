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
// dds data to samples conversion

module cf_ddsv_vdma (

  // vdma interface

  vdma_clk,
  vdma_fs,
  vdma_valid,
  vdma_data,
  vdma_ready,
  vdma_ovf,
  vdma_unf,

  // dac side (interpolator default) interface

  dac_div3_clk,
  dds_master_enable,
  dds_rd,
  dds_rdata,

  // frame count (for vdma fs)

  up_vdma_fscnt,

  // debug data (chipscope)

  vdma_dbg_data,
  vdma_dbg_trigger,

  // debug data (chipscope)

  dac_dbg_data,
  dac_dbg_trigger);

  // vdma interface

  input           vdma_clk;
  output          vdma_fs;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;
  output          vdma_ovf;
  output          vdma_unf;

  // dac side (interpolator default) interface

  input           dac_div3_clk;
  input           dds_master_enable;
  input           dds_rd;
  output  [95:0]  dds_rdata;

  // frame count (for vdma fs)

  input   [15:0]  up_vdma_fscnt;

  // debug data (chipscope)

  output  [198:0] vdma_dbg_data;
  output  [ 7:0]  vdma_dbg_trigger;

  // debug data (chipscope)

  output  [107:0] dac_dbg_data;
  output  [ 7:0]  dac_dbg_trigger;

  reg             dds_start_m1 = 'd0;
  reg             dds_start = 'd0;
  reg     [ 7:0]  dds_raddr = 'd0;
  reg     [ 7:0]  dds_raddr_g = 'd0;
  reg     [95:0]  dds_rdata = 'd0;
  reg             vdma_master_enable_m1 = 'd0;
  reg             vdma_master_enable = 'd0;
  reg             vdma_master_enable_d = 'd0;
  reg     [15:0]  vdma_fscnt = 'd0;
  reg     [15:0]  vdma_rdcnt = 'd0;
  reg             vdma_fs = 'd0;
  reg             vdma_start = 'd0;
  reg     [ 1:0]  vdma_dcnt = 'd0;
  reg     [63:0]  vdma_data_d = 'd0;
  reg             vdma_wr = 'd0;
  reg     [ 7:0]  vdma_waddr = 'd0;
  reg     [95:0]  vdma_wdata = 'd0;
  reg     [ 7:0]  vdma_raddr_g_m1 = 'd0;
  reg     [ 7:0]  vdma_raddr_g_m2 = 'd0;
  reg     [ 7:0]  vdma_raddr = 'd0;
  reg     [ 7:0]  vdma_addr_diff = 'd0;
  reg             vdma_ready = 'd0;
  reg             vdma_almost_full = 'd0;
  reg             vdma_almost_empty = 'd0;
  reg     [ 4:0]  vdma_ovf_count = 'd0;
  reg             vdma_ovf = 'd0;
  reg     [ 4:0]  vdma_unf_count = 'd0;
  reg             vdma_unf = 'd0;

  wire            vdma_we_s;
  wire    [ 8:0]  vdma_addr_diff_s;
  wire            vdma_ovf_s;
  wire            vdma_unf_s;
  wire    [95:0]  dds_rdata_s;

  // binary to grey coversion

  function [7:0] b2g;
    input [7:0] b;
    reg   [7:0] g;
    begin
      g[7] = b[7];
      g[6] = b[7] ^ b[6];
      g[5] = b[6] ^ b[5];
      g[4] = b[5] ^ b[4];
      g[3] = b[4] ^ b[3];
      g[2] = b[3] ^ b[2];
      g[1] = b[2] ^ b[1];
      g[0] = b[1] ^ b[0];
      b2g = g;
    end
  endfunction

  // grey to binary conversion

  function [7:0] g2b;
    input [7:0] g;
    reg   [7:0] b;
    begin
      b[7] = g[7];
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

  // debug signals

  assign vdma_dbg_trigger[7:7] = vdma_valid;
  assign vdma_dbg_trigger[6:6] = vdma_ready;
  assign vdma_dbg_trigger[5:5] = vdma_master_enable;
  assign vdma_dbg_trigger[4:4] = vdma_start;
  assign vdma_dbg_trigger[3:3] = vdma_wr;
  assign vdma_dbg_trigger[2:2] = vdma_fs;
  assign vdma_dbg_trigger[1:1] = vdma_ovf_s;
  assign vdma_dbg_trigger[0:0] = vdma_unf_s;

  assign vdma_dbg_data[198:198] = vdma_valid;
  assign vdma_dbg_data[197:197] = vdma_ready;
  assign vdma_dbg_data[196:196] = vdma_ovf;
  assign vdma_dbg_data[195:195] = vdma_unf;
  assign vdma_dbg_data[194:194] = vdma_fs;
  assign vdma_dbg_data[193:193] = vdma_master_enable;
  assign vdma_dbg_data[192:192] = vdma_start;
  assign vdma_dbg_data[191:191] = vdma_wr;
  assign vdma_dbg_data[190:190] = vdma_almost_full;
  assign vdma_dbg_data[189:189] = vdma_almost_empty;
  assign vdma_dbg_data[188:188] = vdma_we_s;
  assign vdma_dbg_data[187:187] = vdma_ovf_s;
  assign vdma_dbg_data[186:186] = vdma_unf_s;
  assign vdma_dbg_data[185:184] = vdma_dcnt;
  assign vdma_dbg_data[183:176] = vdma_waddr;
  assign vdma_dbg_data[175:168] = vdma_raddr;
  assign vdma_dbg_data[167:160] = vdma_addr_diff;
  assign vdma_dbg_data[159: 96] = vdma_data;
  assign vdma_dbg_data[ 95: 80] = vdma_rdcnt;
  assign vdma_dbg_data[ 79: 64] = vdma_fscnt;
  assign vdma_dbg_data[ 63:  0] = vdma_wdata[63:0];

  assign dac_dbg_trigger[7:4] = 'd0;
  assign dac_dbg_trigger[3:3] = dds_master_enable;
  assign dac_dbg_trigger[2:2] = dds_rd;
  assign dac_dbg_trigger[1:1] = dds_start_m1;
  assign dac_dbg_trigger[0:0] = dds_start;

  assign dac_dbg_data[107:107] = dds_master_enable;
  assign dac_dbg_data[106:106] = dds_rd;
  assign dac_dbg_data[105:105] = dds_start_m1;
  assign dac_dbg_data[104:104] = dds_start;
  assign dac_dbg_data[103: 96] = dds_raddr;
  assign dac_dbg_data[ 95:  0] = dds_rdata;

  // dds read and data output (nothing special)

  always @(posedge dac_div3_clk) begin
    dds_start_m1 <= vdma_start;
    dds_start <= dds_start_m1;
    if (dds_start == 1'b0) begin
      dds_raddr <= 8'h80;
    end else if (dds_rd == 1'b1) begin
      dds_raddr <= dds_raddr + 1'b1;
    end
    dds_raddr_g <= b2g(dds_raddr);
    dds_rdata <= dds_rdata_s;
  end

  // a free running counter is used to generate frame sync for vdma- it is up to the software
  // to set it's value. the only thing is that it should be greater than the frame size.

  always @(posedge vdma_clk) begin
    vdma_master_enable_m1 <= dds_master_enable;
    vdma_master_enable <= vdma_master_enable_m1;
    vdma_master_enable_d <= vdma_master_enable;
    if ((vdma_master_enable == 1'b1) && (vdma_master_enable_d == 1'b0)) begin
      vdma_fscnt <= up_vdma_fscnt;
    end
    if (((vdma_master_enable == 1'b1) && (vdma_master_enable_d == 1'b0)) ||
      (vdma_rdcnt >= vdma_fscnt)) begin
      vdma_rdcnt <= 16'd0;
    end else if (vdma_we_s == 1'b1) begin
      vdma_rdcnt <= vdma_rdcnt + 1'b1;
    end
    if (((vdma_master_enable == 1'b1) && (vdma_master_enable_d == 1'b0)) ||
      ((vdma_rdcnt >= vdma_fscnt) && (vdma_master_enable_d == 1'b1))) begin
      vdma_fs <= 1'b1;
    end else begin
      vdma_fs <= 1'b0;
    end
  end

  // vdma write, the incoming data is 4 samples (64bits), in order to interface seamlessly to the
  // OSERDES 3:1 ratio, the dac is set to read 3 (or 6) samples. So data is written to the
  // memory as 6 samples (96bits).

  assign vdma_we_s = vdma_valid & vdma_ready;

  always @(posedge vdma_clk) begin
    if (vdma_master_enable == 1'b0) begin
      vdma_start <= 1'b0;
      vdma_dcnt <= 2'd0;
      vdma_data_d <= 64'd0;
      vdma_wr <= 1'b0;
      vdma_waddr <= 8'd0;
      vdma_wdata <= 96'd0;
    end else if (vdma_we_s == 1'b1) begin
      vdma_start <= 1'b1;
      if (vdma_dcnt >= 2'd2) begin
        vdma_dcnt <= 2'd0;
      end else begin
        vdma_dcnt <= vdma_dcnt + 1'b1;
      end
      vdma_data_d <= vdma_data;
      vdma_wr <= vdma_dcnt[0] | vdma_dcnt[1];
      if (vdma_wr == 1'b1) begin
        vdma_waddr <= vdma_waddr + 1'b1;
      end
      if (vdma_dcnt == 2'd1) begin
        vdma_wdata[95:80] <= vdma_data_d[15: 0];
        vdma_wdata[79:64] <= vdma_data_d[31:16];
        vdma_wdata[63:48] <= vdma_data_d[47:32];
        vdma_wdata[47:32] <= vdma_data_d[63:48];
        vdma_wdata[31:16] <= vdma_data[15: 0];
        vdma_wdata[15: 0] <= vdma_data[31:16];
      end else begin
        vdma_wdata[95:80] <= vdma_data_d[47:32];
        vdma_wdata[79:64] <= vdma_data_d[63:48];
        vdma_wdata[63:48] <= vdma_data[15: 0];
        vdma_wdata[47:32] <= vdma_data[31:16];
        vdma_wdata[31:16] <= vdma_data[47:32];
        vdma_wdata[15: 0] <= vdma_data[63:48];
      end
    end
  end

  // overflow or underflow status

  assign vdma_addr_diff_s = {1'b1, vdma_waddr} - vdma_raddr;
  assign vdma_ovf_s = (vdma_addr_diff < 3) ? vdma_almost_full : 1'b0;
  assign vdma_unf_s = (vdma_addr_diff > 250) ? vdma_almost_empty : 1'b0;

  always @(posedge vdma_clk) begin
    vdma_raddr_g_m1 <= dds_raddr_g;
    vdma_raddr_g_m2 <= vdma_raddr_g_m1;
    vdma_raddr <= g2b(vdma_raddr_g_m2);
    vdma_addr_diff <= vdma_addr_diff_s[7:0];
    if (vdma_addr_diff >= 250) begin
      vdma_ready <= ~vdma_master_enable;
    end else if (vdma_addr_diff <= 200) begin
      vdma_ready <= 1'b1;
    end
    vdma_almost_full = (vdma_addr_diff > 250) ? 1'b1 : 1'b0;
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

  // memory

  cf_mem #(.DW(96), .AW(8)) i_mem (
    .clka (vdma_clk),
    .wea (vdma_wr),
    .addra (vdma_waddr),
    .dina (vdma_wdata),
    .clkb (dac_div3_clk),
    .addrb (dds_raddr),
    .doutb (dds_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
