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

module cf_gtx_es_wr (

  // synchronous to the processor clock

  up_rstn,
  up_clk,
  up_startaddr,
  up_hsize,
  up_hmin,
  up_hmax,

  // es interface, data is 64bits with valid as the qualifier

  es_valid,
  es_sos,
  es_eos,
  es_data,

  // master interface and status signals

  mb_req,
  mb_ack,
  mb_addr,
  mb_data,
  mb_done,
  mb_error,
  mb_readyn,
  mb_ovf,
  mb_unf,
  mb_state,
  mb_status,

  // master debug data (for chipscope)

  mb_dbg_data,
  mb_dbg_trigger);

  // synchronous to the processor clock

  input           up_rstn;
  input           up_clk;
  input   [31:0]  up_startaddr;
  input   [15:0]  up_hsize;
  input   [15:0]  up_hmin;
  input   [15:0]  up_hmax;

  // es interface, data is 64bits with valid as the qualifier

  input           es_valid;
  input           es_sos;
  input           es_eos;
  input   [31:0]  es_data;

  // master interface and status signals

  output          mb_req;
  input           mb_ack;
  output  [31: 0] mb_addr;
  output  [31: 0] mb_data;
  input           mb_done;
  input           mb_error;
  input           mb_readyn;
  output          mb_ovf;
  output          mb_unf;
  output          mb_state;
  output  [ 1:0]  mb_status;

  // master debug data (for chipscope)

  output  [83:0]  mb_dbg_data;
  output  [ 7:0]  mb_dbg_trigger;

  reg     [ 5:0]  mb_addr_diff = 'd0;
  reg             mb_almost_full = 'd0;
  reg             mb_almost_empty = 'd0;
  reg             mb_ovf = 'd0;
  reg             mb_unf = 'd0;
  reg     [ 5:0]  mb_raddr = 'd0;
  reg             mb_rd = 'd0;
  reg             mb_rvalid = 'd0;
  reg     [31:0]  mb_rdata = 'd0;
  reg             mb_state = 'd0;
  reg     [15:0]  mb_hoffset = 'd0;
  reg     [31:0]  mb_voffset = 'd0;
  reg     [15:0]  mb_hmin = 'd0;
  reg     [15:0]  mb_hmax = 'd0;
  reg     [15:0]  mb_hsize = 'd0;
  reg             mb_req = 'd0;
  reg     [31:0]  mb_addr = 'd0;
  reg     [31:0]  mb_data = 'd0;
  reg     [ 1:0]  mb_status = 'd0;
  reg             mb_wr = 'd0;
  reg     [ 5:0]  mb_waddr = 'd0;
  reg     [31:0]  mb_wdata = 'd0;

  wire    [ 6:0]  mb_addr_diff_s;
  wire    [31:0]  mb_addr_s;
  wire            mb_rd_s;
  wire    [31:0]  mb_rdata_s;

  // debug signals (for chipscope)

  assign mb_dbg_trigger[7] = mb_unf;
  assign mb_dbg_trigger[6] = mb_ovf;
  assign mb_dbg_trigger[5] = mb_state;
  assign mb_dbg_trigger[4] = mb_rvalid;
  assign mb_dbg_trigger[3] = mb_req;
  assign mb_dbg_trigger[2] = mb_ack;
  assign mb_dbg_trigger[1] = mb_done;
  assign mb_dbg_trigger[0] = mb_error;

  assign mb_dbg_data[ 83: 83] = es_valid;
  assign mb_dbg_data[ 82: 82] = es_sos;
  assign mb_dbg_data[ 81: 81] = es_eos;
  assign mb_dbg_data[ 80: 80] = mb_req;
  assign mb_dbg_data[ 79: 79] = mb_ack;
  assign mb_dbg_data[ 78: 78] = mb_done;
  assign mb_dbg_data[ 77: 77] = mb_error;
  assign mb_dbg_data[ 76: 76] = mb_readyn;
  assign mb_dbg_data[ 75: 70] = mb_addr_diff;
  assign mb_dbg_data[ 69: 69] = mb_almost_full;
  assign mb_dbg_data[ 68: 68] = mb_almost_empty;
  assign mb_dbg_data[ 67: 67] = mb_ovf;
  assign mb_dbg_data[ 66: 66] = mb_unf;
  assign mb_dbg_data[ 65: 60] = mb_raddr;
  assign mb_dbg_data[ 59: 59] = mb_rd;
  assign mb_dbg_data[ 58: 58] = mb_rvalid;
  assign mb_dbg_data[ 57: 57] = mb_state;
  assign mb_dbg_data[ 56: 41] = mb_hoffset;
  assign mb_dbg_data[ 40:  9] = mb_voffset;
  assign mb_dbg_data[  8:  7] = mb_status;
  assign mb_dbg_data[  6:  6] = mb_wr;
  assign mb_dbg_data[  5:  0] = mb_waddr;

  // standard book keeping stuff (memory management, overflow or underflow status)

  assign mb_addr_diff_s = {1'b1, mb_waddr} - mb_raddr;
  assign mb_addr_s = mb_voffset + {mb_hoffset, 2'd0};

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      mb_addr_diff <= 'd0;
      mb_almost_full <= 'd0;
      mb_almost_empty <= 'd0;
      mb_ovf <= 'd0;
      mb_unf <= 'd0;
    end else begin
      mb_addr_diff <= mb_addr_diff_s[5:0];
      mb_almost_full <= (mb_addr_diff > 60) ? 1'b1 : 1'b0;
      mb_almost_empty <= (mb_addr_diff < 3) ? 1'b1 : 1'b0;
      mb_ovf <= (mb_addr_diff < 3) ? mb_almost_full : 1'b0;
      mb_unf <= (mb_addr_diff > 60) ? mb_almost_empty : 1'b0;
    end
  end

  // master read and pipe line delays (memory latency)

  assign mb_rd_s = (mb_waddr == mb_raddr) ? 1'b0 : ~mb_state;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      mb_raddr <= 'd0;
      mb_rd <= 'd0;
      mb_rvalid <= 'd0;
      mb_rdata <= 'd0;
    end else begin
      if (mb_rd_s == 1'b1) begin
        mb_raddr <= mb_raddr + 1'b1;
      end
      mb_rd <= mb_rd_s;
      mb_rvalid <= mb_rd;
      mb_rdata <= mb_rdata_s;
    end
  end

  // master command state and address update

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      mb_state <= 'd0;
      mb_hoffset <= 'd0;
      mb_voffset <= 'd0;
      mb_hmin <= 'd0;
      mb_hmax <= 'd0;
      mb_hsize <= 'd0;
    end else begin
      if (mb_done == 1'b1) begin
        mb_state <= 1'b0;
      end else if (mb_rd_s == 1'b1) begin
        mb_state <= 1'b1;
      end
      if (mb_done == 1'b1) begin
        if (mb_hoffset >=  mb_hmax) begin
          mb_hoffset <= mb_hmin;
        end else begin
          mb_hoffset <= mb_hoffset + 1'b1;
        end
      end else if (es_sos == 1'b1) begin
        mb_hoffset <= up_hmin;
      end
      if ((mb_done == 1'b1) && (mb_hoffset >= mb_hmax)) begin
        mb_voffset <= mb_voffset + {mb_hsize, 2'd0};
      end else if (es_sos == 1'b1) begin
        mb_voffset <= up_startaddr;
      end
      if ((es_sos == 1'b1) || (es_eos == 1'b1)) begin
        mb_hmin <= up_hmin;
        mb_hmax <= up_hmax;
        mb_hsize <= up_hsize;
      end
    end
  end

  // master bus write

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      mb_req <= 'd0;
      mb_addr <= 'd0;
      mb_data <= 'd0;
      mb_status <= 'd0;
    end else begin
      if (mb_ack == 1'b1) begin
        mb_req <= 1'b0;
      end else if (mb_rvalid == 1'b1) begin
        mb_req <= 1'b1;
      end
      if (mb_rvalid == 1'b1) begin
        mb_addr <= mb_addr_s;
        mb_data <= mb_rdata;
      end
      if (mb_done == 1'b1) begin
        mb_status <= {mb_error, ~mb_readyn};
      end else if (mb_rvalid == 1'b1) begin
        mb_status <= 2'd0;
      end
    end
  end

  // es data write

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      mb_wr <= 'd0;
      mb_waddr <= 'd0;
      mb_wdata <= 'd0;
    end else begin
      mb_wr <= es_valid;
      if (mb_wr == 1'b1) begin
        mb_waddr <= mb_waddr + 1'b1;
      end
      mb_wdata <= es_data;
    end
  end

  // a small buffer is used to hold the eye scan data

  cf_mem #(.DW(32), .AW(6)) i_mem (
    .clka (up_clk),
    .wea (mb_wr),
    .addra (mb_waddr),
    .dina (mb_wdata),
    .clkb (up_clk),
    .addrb (mb_raddr),
    .doutb (mb_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
