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

module cf_adc_dma (

  // adc interface, data is 64bits with valid as the qualifier

  adc_clk,
  adc_valid,
  adc_data,

  // dma interface and status signals

  dma_clk,
  dma_valid,
  dma_data,
  dma_be,
  dma_last,
  dma_ready,
  dma_ovf,
  dma_unf,
  dma_status,

  // processor interface

  up_dma_capture,
  up_dma_capture_stream,
  up_dma_capture_count,

  // dma debug data (for chipscope)

  dma_dbg_data,
  dma_dbg_trigger,

  // adc debug data (for chipscope)

  adc_dbg_data,
  adc_dbg_trigger);

  // adc interface, data is 64bits with valid as the qualifier

  input           adc_clk;
  input           adc_valid;
  input   [63:0]  adc_data;

  // dma interface and status signals

  input           dma_clk;
  output          dma_valid;
  output  [63:0]  dma_data;
  output  [ 7:0]  dma_be;
  output          dma_last;
  input           dma_ready;
  output          dma_ovf;
  output          dma_unf;
  output          dma_status;

  // processor interface

  input           up_dma_capture;
  input           up_dma_capture_stream;
  input   [29:0]  up_dma_capture_count;

  // dma debug data (for chipscope)

  output  [63:0]  dma_dbg_data;
  output  [ 7:0]  dma_dbg_trigger;

  // adc debug data (for chipscope)

  output  [63:0]  adc_dbg_data;
  output  [ 7:0]  adc_dbg_trigger;

  reg             dma_fs_toggle_m1 = 'd0;
  reg             dma_fs_toggle_m2 = 'd0;
  reg             dma_fs_toggle_m3 = 'd0;
  reg             dma_fs_toggle = 'd0;
  reg     [ 5:0]  dma_fs_waddr = 'd0;
  reg             dma_rel_toggle_m1 = 'd0;
  reg             dma_rel_toggle_m2 = 'd0;
  reg             dma_rel_toggle_m3 = 'd0;
  reg     [ 5:0]  dma_rel_waddr = 'd0;
  reg     [ 5:0]  dma_waddr_m1 = 'd0;
  reg     [ 5:0]  dma_waddr_m2 = 'd0;
  reg     [ 5:0]  dma_waddr = 'd0;
  reg     [ 5:0]  dma_addr_diff = 'd0;
  reg     [ 5:0]  dma_raddr = 'd0;
  reg             dma_rd = 'd0;
  reg             dma_rvalid = 'd0;
  reg     [64:0]  dma_rdata = 'd0;
  reg     [ 1:0]  dma_wcnt = 'd0;
  reg             dma_rvalid_0 = 'd0;
  reg     [64:0]  dma_rdata_0 = 'd0;
  reg             dma_rvalid_1 = 'd0;
  reg     [64:0]  dma_rdata_1 = 'd0;
  reg             dma_rvalid_2 = 'd0;
  reg     [64:0]  dma_rdata_2 = 'd0;
  reg             dma_rvalid_3 = 'd0;
  reg     [64:0]  dma_rdata_3 = 'd0;
  reg     [ 1:0]  dma_rcnt = 'd0;
  reg             dma_valid = 'd0;
  reg     [ 7:0]  dma_be = 'd0;
  reg             dma_last = 'd0;
  reg     [63:0]  dma_data = 'd0;
  reg             dma_almost_full = 'd0;
  reg             dma_almost_empty = 'd0;
  reg     [ 4:0]  dma_ovf_count = 'd0;
  reg             dma_ovf = 'd0;
  reg     [ 4:0]  dma_unf_count = 'd0;
  reg             dma_unf = 'd0;
  reg             dma_status = 'd0;
  reg             adc_capture_m1 = 'd0;
  reg             adc_capture_m2 = 'd0;
  reg             adc_capture_m3 = 'd0;
  reg             adc_capture_p = 'd0;
  reg             adc_capture_stream = 'd0;
  reg     [30:0]  adc_capture_count = 'd0;
  reg     [30:0]  adc_valid_count = 'd0;
  reg     [ 3:0]  adc_rel_count = 'd0;
  reg             adc_fs_toggle = 'd0;
  reg     [ 5:0]  adc_fs_waddr = 'd0;
  reg             adc_rel_toggle = 'd0;
  reg     [ 5:0]  adc_rel_waddr = 'd0;
  reg             adc_wr = 'd0;
  reg     [ 5:0]  adc_waddr = 'd0;
  reg     [ 5:0]  adc_waddr_g = 'd0;
  reg     [64:0]  adc_wdata = 'd0;

  wire            dma_fs_toggle_s;
  wire            dma_rel_toggle_s;
  wire    [ 6:0]  dma_addr_diff_s;
  wire            dma_xfer_en_s;
  wire            dma_rd_s;
  wire            dma_ovf_s;
  wire            dma_unf_s;
  wire            dma_last_s;
  wire    [64:0]  dma_rdata_s;
  wire            adc_capture_last_s;
  wire            adc_capture_rel_s;
  wire            adc_capture_s;

  // binary to grey conversion

  function [5:0] b2g;
    input [5:0] b;
    reg   [5:0] g;
    begin
      g[5] = b[5];
      g[4] = b[5] ^ b[4];
      g[3] = b[4] ^ b[3];
      g[2] = b[3] ^ b[2];
      g[1] = b[2] ^ b[1];
      g[0] = b[1] ^ b[0];
      b2g = g;
    end
  endfunction

  // grey to binary conversion

  function [5:0] g2b;
    input [5:0] g;
    reg   [5:0] b;
    begin
      b[5] = g[5];
      b[4] = b[5] ^ g[4];
      b[3] = b[4] ^ g[3];
      b[2] = b[3] ^ g[2];
      b[1] = b[2] ^ g[1];
      b[0] = b[1] ^ g[0];
      g2b = b;
    end
  endfunction

  // debug signals (for chipscope)

  assign dma_dbg_trigger[7] = dma_unf;
  assign dma_dbg_trigger[6] = dma_ovf;
  assign dma_dbg_trigger[5] = dma_rel_toggle_s;
  assign dma_dbg_trigger[4] = dma_fs_toggle_s;
  assign dma_dbg_trigger[3] = dma_status;
  assign dma_dbg_trigger[2] = dma_ready;
  assign dma_dbg_trigger[1] = dma_last;
  assign dma_dbg_trigger[0] = dma_valid;

  assign dma_dbg_data[63:61] = 'd0;
  assign dma_dbg_data[60:53] = dma_data[7:0];
  assign dma_dbg_data[52:45] = dma_rdata[7:0];
  assign dma_dbg_data[44:44] = dma_ovf_s;
  assign dma_dbg_data[43:43] = dma_unf_s;
  assign dma_dbg_data[42:42] = dma_almost_empty;
  assign dma_dbg_data[41:41] = dma_almost_full;
  assign dma_dbg_data[40:34] = dma_addr_diff_s;
  assign dma_dbg_data[33:28] = dma_rel_waddr;
  assign dma_dbg_data[27:27] = dma_unf;
  assign dma_dbg_data[26:26] = dma_ovf;
  assign dma_dbg_data[25:24] = dma_wcnt;
  assign dma_dbg_data[23:22] = dma_rcnt;
  assign dma_dbg_data[21:16] = dma_waddr;
  assign dma_dbg_data[15:10] = dma_raddr;
  assign dma_dbg_data[ 9: 9] = dma_rel_toggle_s;
  assign dma_dbg_data[ 8: 8] = dma_fs_toggle_s;
  assign dma_dbg_data[ 7: 7] = dma_xfer_en_s;
  assign dma_dbg_data[ 6: 6] = dma_rvalid;
  assign dma_dbg_data[ 5: 5] = dma_rd;
  assign dma_dbg_data[ 4: 4] = dma_rd_s;
  assign dma_dbg_data[ 3: 3] = dma_status;
  assign dma_dbg_data[ 2: 2] = dma_ready;
  assign dma_dbg_data[ 1: 1] = dma_last;
  assign dma_dbg_data[ 0: 0] = dma_valid;

  assign adc_dbg_trigger[7] = adc_capture_s;
  assign adc_dbg_trigger[6] = adc_wr;
  assign adc_dbg_trigger[5] = adc_fs_toggle;
  assign adc_dbg_trigger[4] = adc_rel_toggle;
  assign adc_dbg_trigger[3] = adc_capture_rel_s;
  assign adc_dbg_trigger[2] = adc_capture_last_s;
  assign adc_dbg_trigger[1] = adc_capture_last_s;
  assign adc_dbg_trigger[0] = adc_capture_last_s;
  
  assign adc_dbg_data[63:63] = adc_capture_rel_s;
  assign adc_dbg_data[62:62] = adc_capture_rel_s;
  assign adc_dbg_data[61:61] = adc_capture_rel_s;
  assign adc_dbg_data[60:60] = adc_capture_last_s;
  assign adc_dbg_data[59:59] = adc_capture_last_s;
  assign adc_dbg_data[58:58] = adc_rel_toggle;
  assign adc_dbg_data[57:57] = adc_rel_toggle;
  assign adc_dbg_data[56:56] = adc_fs_toggle;
  assign adc_dbg_data[55:50] = adc_rel_waddr;
  assign adc_dbg_data[49:44] = adc_waddr;
  assign adc_dbg_data[43:43] = adc_wr;
  assign adc_dbg_data[42:42] = adc_wdata[64];
  assign adc_dbg_data[41: 0] = adc_wdata[41:0];

  // dma clock domain, get write address from adc domain and start capture

  assign dma_fs_toggle_s = dma_fs_toggle_m3 ^ dma_fs_toggle_m2;
  assign dma_rel_toggle_s = dma_rel_toggle_m3 ^ dma_rel_toggle_m2;
  assign dma_addr_diff_s = {1'b1, dma_waddr} - dma_raddr;

  // capture is done in "frames". The maximum size is limited by the processor
  // register width (see regmap.txt for details). The dma side generates a frame
  // start toggle. The adc then releases the write address in regular time
  // intervals or at the end of the frame. The dma side then reads upto the
  // write address "released" by the adc side.

  always @(posedge dma_clk) begin
    dma_fs_toggle_m1 <= adc_fs_toggle;
    dma_fs_toggle_m2 <= dma_fs_toggle_m1;
    dma_fs_toggle_m3 <= dma_fs_toggle_m2;
    dma_fs_toggle <= dma_fs_toggle_s;
    if (dma_fs_toggle_s == 1'b1) begin
      dma_fs_waddr <= adc_fs_waddr;
    end
    dma_rel_toggle_m1 <= adc_rel_toggle;
    dma_rel_toggle_m2 <= dma_rel_toggle_m1;
    dma_rel_toggle_m3 <= dma_rel_toggle_m2;
    if (dma_rel_toggle_s == 1'b1) begin
      dma_rel_waddr <= adc_rel_waddr;
    end
    dma_waddr_m1 <= adc_waddr_g;
    dma_waddr_m2 <= dma_waddr_m1;
    dma_waddr <= g2b(dma_waddr_m2);
    dma_addr_diff <= dma_addr_diff_s[5:0];
  end

  assign dma_xfer_en_s = dma_ready | ~dma_valid;
  assign dma_rd_s = (dma_rel_waddr == dma_raddr) ? 1'b0 : dma_ready;

  // dma read and pipe line delays (memory latency)

  always @(posedge dma_clk) begin
    if (dma_fs_toggle == 1'b1) begin
      dma_raddr <= dma_fs_waddr;
    end else if (dma_rd_s == 1'b1) begin
      dma_raddr <= dma_raddr + 1'b1;
    end
    dma_rd <= dma_rd_s;
    dma_rvalid <= dma_rd;
    dma_rdata <= dma_rdata_s;
  end

  // dma interface requires a hard stop on data/valid when ready is deasserted

  always @(posedge dma_clk) begin
    if (dma_rvalid == 1'b1) begin
      dma_wcnt <= dma_wcnt + 1'b1;
    end
    if ((dma_wcnt == 2'd0) && (dma_rvalid == 1'b1)) begin
      dma_rvalid_0 <= 1'b1;
      dma_rdata_0 <= dma_rdata;
    end else if ((dma_rcnt == 2'd0) && (dma_xfer_en_s == 1'b1)) begin
      dma_rvalid_0 <= 1'b0;
      dma_rdata_0 <= 65'd0;
    end
    if ((dma_wcnt == 2'd1) && (dma_rvalid == 1'b1)) begin
      dma_rvalid_1 <= 1'b1;
      dma_rdata_1 <= dma_rdata;
    end else if ((dma_rcnt == 2'd1) && (dma_xfer_en_s == 1'b1)) begin
      dma_rvalid_1 <= 1'b0;
      dma_rdata_1 <= 65'd0;
    end
    if ((dma_wcnt == 2'd2) && (dma_rvalid == 1'b1)) begin
      dma_rvalid_2 <= 1'b1;
      dma_rdata_2 <= dma_rdata;
    end else if ((dma_rcnt == 2'd2) && (dma_xfer_en_s == 1'b1)) begin
      dma_rvalid_2 <= 1'b0;
      dma_rdata_2 <= 65'd0;
    end
    if ((dma_wcnt == 2'd3) && (dma_rvalid == 1'b1)) begin
      dma_rvalid_3 <= 1'b1;
      dma_rdata_3 <= dma_rdata;
    end else if ((dma_rcnt == 2'd3) && (dma_xfer_en_s == 1'b1)) begin
      dma_rvalid_3 <= 1'b0;
      dma_rdata_3 <= 65'd0;
    end
    if ((dma_rcnt != dma_wcnt) && (dma_ready == 1'b1)) begin
      dma_rcnt <= dma_rcnt + 1'b1;
    end
    if ((dma_valid == 1'b0) || (dma_ready == 1'b1)) begin
      case (dma_rcnt)
        2'd3: begin
          dma_valid <= dma_rvalid_3;
          dma_be <= 8'hff;
          dma_last <= dma_rdata_3[64] & dma_rvalid_3;
          dma_data <= dma_rdata_3[63:0];
        end
        2'd2: begin
          dma_valid <= dma_rvalid_2;
          dma_be <= 8'hff;
          dma_last <= dma_rdata_2[64] & dma_rvalid_2;
          dma_data <= dma_rdata_2[63:0];
        end
        2'd1: begin
          dma_valid <= dma_rvalid_1;
          dma_be <= 8'hff;
          dma_last <= dma_rdata_1[64] & dma_rvalid_1;
          dma_data <= dma_rdata_1[63:0];
        end
        default: begin
          dma_valid <= dma_rvalid_0;
          dma_be <= 8'hff;
          dma_last <= dma_rdata_0[64] & dma_rvalid_0;
          dma_data <= dma_rdata_0[63:0];
        end
      endcase
    end
  end

  // overflow or underflow status

  assign dma_ovf_s = (dma_addr_diff < 3) ? dma_almost_full : 1'b0;
  assign dma_unf_s = (dma_addr_diff > 60) ? dma_almost_empty : 1'b0;

  always @(posedge dma_clk) begin
    dma_almost_full = (dma_addr_diff > 60) ? 1'b1 : 1'b0;
    dma_almost_empty = (dma_addr_diff < 3) ? 1'b1 : 1'b0;
    if (dma_ovf_s == 1'b1) begin
      dma_ovf_count <= 5'h10;
    end else if (dma_ovf_count[4] == 1'b1) begin
      dma_ovf_count <= dma_ovf_count + 1'b1;
    end
    dma_ovf <= dma_ovf_count[4];
    if (dma_unf_s == 1'b1) begin
      dma_unf_count <= 5'h10;
    end else if (dma_unf_count[4] == 1'b1) begin
      dma_unf_count <= dma_unf_count + 1'b1;
    end
    dma_unf <= dma_unf_count[4];
  end

  // dma complete

  assign dma_last_s = dma_valid & dma_ready & dma_last;

  always @(posedge dma_clk) begin
    if (dma_fs_toggle == 1'b1) begin
      dma_status <= 1'b1;
    end else if (dma_last_s == 1'b1) begin
      dma_status <= 1'b0;
    end
  end

  // adc write interface (generates the release addresses)

  assign adc_capture_last_s = (adc_valid_count[29:0] == 'd0) ? adc_valid_count[30] : 1'b0;
  assign adc_capture_rel_s = (adc_rel_count == 4'hf) ? adc_valid : 1'b0;
  assign adc_capture_s = adc_capture_m2 & ~adc_capture_m3;

  always @(posedge adc_clk) begin
    adc_capture_m1 <= up_dma_capture;
    adc_capture_m2 <= adc_capture_m1;
    adc_capture_m3 <= adc_capture_m2;
    adc_capture_p <= adc_capture_s;
    if (adc_capture_s == 1'b1) begin
      adc_capture_stream <= up_dma_capture_stream;
      adc_capture_count <= {1'd1, up_dma_capture_count};
    end
    if ((adc_valid_count[30] == 1'b1) && (adc_valid == 1'b1)) begin
      if ((adc_capture_last_s == 1'b1) && (adc_capture_stream == 1'b1)) begin
        adc_valid_count <= adc_capture_count;
      end else begin
        adc_valid_count <= adc_valid_count - 1'b1;
      end
    end else if (adc_capture_p == 1'b1) begin
      adc_valid_count <= adc_capture_count;
    end
    if (adc_valid == 1'b1) begin
      adc_rel_count <= adc_rel_count + 1'b1;
    end else if (adc_capture_p == 1'b1) begin
      adc_rel_count <= 4'd0;
    end
  end

  // adc data write

  always @(posedge adc_clk) begin
    if (adc_capture_p == 1'b1) begin
      adc_fs_toggle <= ~adc_fs_toggle;
      adc_fs_waddr <= adc_waddr;
    end
    if (adc_capture_rel_s == 1'b1) begin
      adc_rel_toggle <= ~adc_rel_toggle;
      adc_rel_waddr <= adc_waddr;
    end
  end

  always @(posedge adc_clk) begin
    adc_wr <= adc_valid_count[30] & adc_valid;
    if (adc_wr == 1'b1) begin
      adc_waddr <= adc_waddr + 1'b1;
    end
    adc_waddr_g <= b2g(adc_waddr);
    adc_wdata <= {adc_capture_last_s, adc_data};
  end

  // a small buffer is used to hold the captured data for clock domain transfer

  cf_mem #(.DW(65), .AW(6)) i_mem (
    .clka (adc_clk),
    .wea (adc_wr),
    .addra (adc_waddr),
    .dina (adc_wdata),
    .clkb (dma_clk),
    .addrb (dma_raddr),
    .doutb (dma_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
