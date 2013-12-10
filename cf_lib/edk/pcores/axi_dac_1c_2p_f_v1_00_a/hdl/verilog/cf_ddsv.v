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

module cf_ddsv (

  vdma_clk,
  vdma_valid,
  vdma_data,
  vdma_ready,
  vdma_ovf,
  vdma_unf,

  dac_div3_clk,
  dds_data_00,
  dds_data_01,
  dds_data_02,
  dds_data_03,
  dds_data_04,
  dds_data_05,
  dds_data_06,
  dds_data_07,
  dds_data_08,
  dds_data_09,
  dds_data_10,
  dds_data_11,

  up_dds_enable,
  up_dds_interpolate,

  debug_clk,
  debug_data,
  debug_trigger);

  input           vdma_clk;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;
  output          vdma_ovf;
  output          vdma_unf;

  input           dac_div3_clk;
  output  [13:0]  dds_data_00;
  output  [13:0]  dds_data_01;
  output  [13:0]  dds_data_02;
  output  [13:0]  dds_data_03;
  output  [13:0]  dds_data_04;
  output  [13:0]  dds_data_05;
  output  [13:0]  dds_data_06;
  output  [13:0]  dds_data_07;
  output  [13:0]  dds_data_08;
  output  [13:0]  dds_data_09;
  output  [13:0]  dds_data_10;
  output  [13:0]  dds_data_11;

  input           up_dds_enable;
  input           up_dds_interpolate;

  output          debug_clk;
  output  [79:0]  debug_data;
  output  [ 7:0]  debug_trigger;

  reg             dds_enable_m1 = 'd0;
  reg             dds_enable = 'd0;
  reg             dds_interpolate_m1 = 'd0;
  reg             dds_interpolate = 'd0;
  reg     [ 9:0]  dds_rdcnt = 'd0;
  reg     [ 7:0]  dds_raddr = 'd0;
  reg     [ 7:0]  dds_raddr_g = 'd0;
  reg     [ 1:0]  dds_rdcnt2 = 'd0;
  reg     [ 1:0]  dds_rdcnt2_d = 'd0;
  reg     [ 1:0]  dds_dcnt = 'd0;
  reg     [95:0]  dds_rdata_0 = 'd0;
  reg     [95:0]  dds_rdata_1 = 'd0;
  reg     [15:0]  dds_isample_0 = 'd0;
  reg     [15:0]  dds_isample_1 = 'd0;
  reg     [15:0]  dds_isample_2 = 'd0;
  reg     [15:0]  dds_isample_3 = 'd0;
  reg     [15:0]  dds_isample_0_d = 'd0;
  reg     [15:0]  dds_isample_1_d = 'd0;
  reg     [15:0]  dds_isample_2_d = 'd0;
  reg     [17:0]  dds_isample_0d_d = 'd0;
  reg     [17:0]  dds_isample_1d_d = 'd0;
  reg     [17:0]  dds_isample_2d_d = 'd0;
  reg     [13:0]  dds_data_00 = 'd0;
  reg     [13:0]  dds_data_01 = 'd0;
  reg     [13:0]  dds_data_02 = 'd0;
  reg     [13:0]  dds_data_03 = 'd0;
  reg     [13:0]  dds_data_04 = 'd0;
  reg     [13:0]  dds_data_05 = 'd0;
  reg     [13:0]  dds_data_06 = 'd0;
  reg     [13:0]  dds_data_07 = 'd0;
  reg     [13:0]  dds_data_08 = 'd0;
  reg     [13:0]  dds_data_09 = 'd0;
  reg     [13:0]  dds_data_10 = 'd0;
  reg     [13:0]  dds_data_11 = 'd0;
  reg     [ 1:0]  vdma_dcnt = 'd0;
  reg     [63:0]  vdma_data_2_d = 'd0;
  reg     [63:0]  vdma_data_1_d = 'd0;
  reg     [63:0]  vdma_data_0_d = 'd0;
  reg             vdma_wr = 'd0;
  reg     [ 7:0]  vdma_waddr = 'd0;
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

  wire    [95:0]  vdma_wdata_0_s;
  wire    [95:0]  vdma_wdata_1_s;
  wire    [ 8:0]  vdma_addr_diff_s;
  wire            vdma_ovf_s;
  wire            vdma_unf_s;
  wire    [ 17:0] dds_isample_0n_s;
  wire    [ 17:0] dds_isample_1n_s;
  wire    [ 17:0] dds_isample_2n_s;
  wire    [ 17:0] dds_isample_3n_s;
  wire    [ 17:0] dds_isample_0i_s;
  wire    [ 17:0] dds_isample_1i_s;
  wire    [ 17:0] dds_isample_2i_s;
  wire    [ 17:0] dds_isample_3i_s;
  wire    [ 17:0] dds_isample_0d_s;
  wire    [ 17:0] dds_isample_1d_s;
  wire    [ 17:0] dds_isample_2d_s;
  wire    [ 17:0] dds_isample_00_s;
  wire    [ 17:0] dds_isample_01_s;
  wire    [ 17:0] dds_isample_02_s;
  wire    [ 17:0] dds_isample_03_s;
  wire    [ 17:0] dds_isample_10_s;
  wire    [ 17:0] dds_isample_11_s;
  wire    [ 17:0] dds_isample_12_s;
  wire    [ 17:0] dds_isample_13_s;
  wire    [ 17:0] dds_isample_20_s;
  wire    [ 17:0] dds_isample_21_s;
  wire    [ 17:0] dds_isample_22_s;
  wire    [ 17:0] dds_isample_23_s;
  wire    [95:0]  dds_rdata_0_s;
  wire    [95:0]  dds_rdata_1_s;

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

  // up signals

  always @(posedge dac_div3_clk) begin
    dds_enable_m1 <= up_dds_enable;
    dds_enable <= dds_enable_m1;
    dds_interpolate_m1 <= up_dds_interpolate;
    dds_interpolate <= dds_interpolate_m1;
  end

  // dac samples generation

  always @(posedge dac_div3_clk) begin
    if (dds_enable == 1'b1) begin
      dds_rdcnt <= dds_rdcnt + 1'b1;
    end
    dds_raddr <= (dds_interpolate == 1'b1) ? dds_rdcnt[9:2] : dds_rdcnt[7:0];
    dds_raddr_g <= b2g(dds_raddr);
    dds_rdcnt2 <= dds_rdcnt[1:0];
    dds_rdcnt2_d <= dds_rdcnt2;
    dds_dcnt <= dds_rdcnt2_d;
    dds_rdata_0 <= dds_rdata_0_s;
    dds_rdata_1 <= dds_rdata_1_s;
  end

  // get interpolate input samples

  always @(posedge dac_div3_clk) begin
    case (dds_dcnt)
      2'b11: begin
        dds_isample_0 <= dds_isample_3;
        dds_isample_1 <= dds_rdata_1[63:48];
        dds_isample_2 <= dds_rdata_1[79:64];
        dds_isample_3 <= dds_rdata_1[95:80];
      end
      2'b10: begin
        dds_isample_0 <= dds_isample_3;
        dds_isample_1 <= dds_rdata_1[15: 0];
        dds_isample_2 <= dds_rdata_1[31:16];
        dds_isample_3 <= dds_rdata_1[47:32];
      end
      2'b01: begin
        dds_isample_0 <= dds_isample_3;
        dds_isample_1 <= dds_rdata_0[63:48];
        dds_isample_2 <= dds_rdata_0[79:64];
        dds_isample_3 <= dds_rdata_0[95:80];
      end
      default: begin
        dds_isample_0 <= dds_isample_3;
        dds_isample_1 <= dds_rdata_0[15: 0];
        dds_isample_2 <= dds_rdata_0[31:16];
        dds_isample_3 <= dds_rdata_0[47:32];
      end
    endcase
  end

  // interpolate deltas

  assign dds_isample_0n_s = {2'd0, dds_isample_0};
  assign dds_isample_1n_s = {2'd0, dds_isample_1};
  assign dds_isample_2n_s = {2'd0, dds_isample_2};
  assign dds_isample_3n_s = {2'd0, dds_isample_3};
  assign dds_isample_0i_s = ~dds_isample_0n_s;
  assign dds_isample_1i_s = ~dds_isample_1n_s;
  assign dds_isample_2i_s = ~dds_isample_2n_s;
  assign dds_isample_3i_s = ~dds_isample_3n_s;
  assign dds_isample_0d_s = dds_isample_1n_s + dds_isample_0i_s + 1'b1;
  assign dds_isample_1d_s = dds_isample_2n_s + dds_isample_1i_s + 1'b1;
  assign dds_isample_2d_s = dds_isample_3n_s + dds_isample_2i_s + 1'b1;

  always @(posedge dac_div3_clk) begin
    dds_isample_0_d <= dds_isample_0;
    dds_isample_1_d <= dds_isample_1;
    dds_isample_2_d <= dds_isample_2;
    dds_isample_0d_d = dds_isample_0d_s;
    dds_isample_1d_d = dds_isample_1d_s;
    dds_isample_2d_d = dds_isample_2d_s;
  end

  // interpolate samples

  assign dds_isample_00_s = {dds_isample_0_d, 2'd0};
  assign dds_isample_01_s = {dds_isample_0_d, 2'd0} + dds_isample_0d_d;
  assign dds_isample_02_s = {dds_isample_0_d, 2'd0} + {dds_isample_0d_d[16:0], 1'd0};
  assign dds_isample_03_s = {dds_isample_0_d, 2'd0} + {dds_isample_0d_d[16:0], 1'd0} +
    dds_isample_0d_d;

  assign dds_isample_10_s = {dds_isample_1_d, 2'd0};
  assign dds_isample_11_s = {dds_isample_1_d, 2'd0} + dds_isample_1d_d;
  assign dds_isample_12_s = {dds_isample_1_d, 2'd0} + {dds_isample_1d_d[16:0], 1'd0};
  assign dds_isample_13_s = {dds_isample_1_d, 2'd0} + {dds_isample_1d_d[16:0], 1'd0} +
    dds_isample_1d_d;

  assign dds_isample_20_s = {dds_isample_2_d, 2'd0};
  assign dds_isample_21_s = {dds_isample_2_d, 2'd0} + dds_isample_2d_d;
  assign dds_isample_22_s = {dds_isample_2_d, 2'd0} + {dds_isample_2d_d[16:0], 1'd0};
  assign dds_isample_23_s = {dds_isample_2_d, 2'd0} + {dds_isample_2d_d[16:0], 1'd0} +
    dds_isample_2d_d;

  always @(posedge dac_div3_clk) begin
    if (dds_interpolate == 1'b1) begin
      dds_data_00 <= dds_isample_00_s[17:4];
      dds_data_01 <= dds_isample_01_s[17:4];
      dds_data_02 <= dds_isample_02_s[17:4];
      dds_data_03 <= dds_isample_03_s[17:4];
      dds_data_04 <= dds_isample_10_s[17:4];
      dds_data_05 <= dds_isample_11_s[17:4];
      dds_data_06 <= dds_isample_12_s[17:4];
      dds_data_07 <= dds_isample_13_s[17:4];
      dds_data_08 <= dds_isample_20_s[17:4];
      dds_data_09 <= dds_isample_21_s[17:4];
      dds_data_10 <= dds_isample_22_s[17:4];
      dds_data_11 <= dds_isample_23_s[17:4];
    end else begin
      dds_data_00 <= dds_rdata_0[15: 2];
      dds_data_01 <= dds_rdata_0[31:18];
      dds_data_02 <= dds_rdata_0[47:34];
      dds_data_03 <= dds_rdata_0[63:50];
      dds_data_04 <= dds_rdata_0[79:66];
      dds_data_05 <= dds_rdata_0[95:82];
      dds_data_06 <= dds_rdata_1[15: 2];
      dds_data_07 <= dds_rdata_1[31:18];
      dds_data_08 <= dds_rdata_1[47:34];
      dds_data_09 <= dds_rdata_1[63:50];
      dds_data_10 <= dds_rdata_1[79:66];
      dds_data_11 <= dds_rdata_1[95:82];
    end
  end

  // debug information

  assign debug_clk = dac_div3_clk;

  assign debug_trigger[7:4] = 'd0;
  assign debug_trigger[3:3] = dds_enable;
  assign debug_trigger[2:2] = dds_interpolate;
  assign debug_trigger[1:0] = dds_dcnt;

  assign debug_data[79:68] = dds_isample_3[11:0];
  assign debug_data[67:56] = dds_isample_2[11:0];
  assign debug_data[55:44] = dds_isample_1[11:0];
  assign debug_data[43:32] = dds_isample_0[11:0];
  assign debug_data[31:31] = dds_enable;
  assign debug_data[30:30] = dds_interpolate;
  assign debug_data[29:28] = dds_dcnt;
  assign debug_data[27:14] = dds_data_05;
  assign debug_data[13: 0] = dds_data_01;

  // vdma write - 3 vdma clocks makes 2 samples

  assign vdma_wdata_0_s = {vdma_data_1_d[31:0], vdma_data_0_d};
  assign vdma_wdata_1_s = {vdma_data_2_d, vdma_data_1_d[63:32]};

  always @(posedge vdma_clk) begin
    if ((vdma_valid == 1'b1) && (vdma_ready == 1'b1)) begin
      if (vdma_dcnt >= 'd2) begin
        vdma_dcnt <= 'd0;
      end else begin
        vdma_dcnt <= vdma_dcnt + 1'b1;
      end
      vdma_data_2_d <= vdma_data;
      vdma_data_1_d <= vdma_data_2_d;
      vdma_data_0_d <= vdma_data_1_d;
    end
    vdma_wr <= (vdma_dcnt == 'd2) ? (vdma_valid & vdma_ready) : 1'b0;
    if (vdma_wr == 1'b1) begin
      vdma_waddr <= vdma_waddr + 1'b1;
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
      vdma_ready <= 1'b0;
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

  cf_mem i_mem_0 (
    .clka (vdma_clk),
    .wea (vdma_wr),
    .addra (vdma_waddr),
    .dina (vdma_wdata_0_s),
    .clkb (dac_div3_clk),
    .addrb (dds_raddr),
    .doutb (dds_rdata_0_s));

  defparam i_mem_0.DW = 96;
  defparam i_mem_0.AW =  8;

  cf_mem i_mem_1 (
    .clka (vdma_clk),
    .wea (vdma_wr),
    .addra (vdma_waddr),
    .dina (vdma_wdata_1_s),
    .clkb (dac_div3_clk),
    .addrb (dds_raddr),
    .doutb (dds_rdata_1_s));

  defparam i_mem_1.DW = 96;
  defparam i_mem_1.AW =  8;

endmodule

// ***************************************************************************
// ***************************************************************************
