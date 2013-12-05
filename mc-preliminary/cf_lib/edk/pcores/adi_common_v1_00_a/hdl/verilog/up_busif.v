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

module up_busif (

  // bus interface

  up_rstn,
  up_clk,
  upif_sel,
  upif_rwn,
  upif_addr,
  upif_wdata,
  upif_wack,
  upif_rdata,
  upif_rack,

  // block interface

  up_sel,
  up_wr,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,

  // pcore identifier

  pid);

  // parameters

  parameter PCORE_VERSION = 32'h00040061;
  parameter PCORE_ID = 0;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           upif_sel;
  input           upif_rwn;
  input   [31:0]  upif_addr;
  input   [31:0]  upif_wdata;
  output          upif_wack;
  output  [31:0]  upif_rdata;
  output          upif_rack;

  // block interface

  output          up_sel;
  output          up_wr;
  output  [13:0]  up_addr;
  output  [31:0]  up_wdata;
  input   [31:0]  up_rdata;
  input           up_ack;

  // pcore identifier

  output  [31:0]  pid;

  // internal registers

  reg             upif_wack = 'd0;
  reg             upif_rack = 'd0;
  reg     [31:0]  upif_rdata = 'd0;
  reg             up_sel_d = 'd0;
  reg             up_sel = 'd0;
  reg             up_wr = 'd0;
  reg     [13:0]  up_addr = 'd0;
  reg     [31:0]  up_wdata = 'd0;
  reg             up_access = 'd0;
  reg     [ 2:0]  up_access_count = 'd0;
  reg             up_access_ack = 'd0;
  reg     [31:0]  up_access_rdata = 'd0;
  reg     [31:0]  up_scratch = 'd0;
  reg             up_int_ack = 'd0;
  reg     [31:0]  up_int_rdata = 'd0;

  // internal signals

  wire    [31:0]  up_rdata_s;
  wire            up_ack_s;
  wire            up_sel_s;
  wire            up_wr_s;

  // pcore identifier

  assign pid = PCORE_ID;

  // bus interface read and ack registers

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      upif_wack <= 'd0;
      upif_rack <= 'd0;
      upif_rdata <= 'd0;
    end else begin
      upif_wack <= (up_ack_s | up_access_ack) & ~upif_rwn;
      upif_rack <= (up_ack_s | up_access_ack) & upif_rwn;
      upif_rdata <= up_rdata_s | up_access_rdata;
    end
  end

  // usuable format from the bus interface signals

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_sel_d <= 'd0;
      up_sel <= 'd0;
      up_wr <= 'd0;
      up_addr <= 'd0;
      up_wdata <= 'd0;
    end else begin
      up_sel_d <= upif_sel;
      up_sel <= upif_sel & ~up_sel_d;
      up_wr <= ~upif_rwn;
      up_addr <= upif_addr[15:2];
      up_wdata <= upif_wdata;
    end
  end

  // combine up read and ack from all the blocks

  assign up_rdata_s = up_rdata | up_int_rdata;
  assign up_ack_s = up_ack | up_int_ack;

  // 8 clock cycles access time out to release bus

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_access <= 'd0;
      up_access_count <= 'd0;
      up_access_ack <= 'd0;
      up_access_rdata <= 'd0;
    end else begin
      if (up_sel == 1'b1) begin
        up_access <= 1'b1;
      end else if (up_ack_s == 1'b1) begin
        up_access <= 1'b0;
      end
      if (up_access == 1'b1) begin
        up_access_count <= up_access_count + 1'b1;
      end else begin
        up_access_count <= 3'd0;
      end
      if ((up_access_count == 3'h7) && (up_ack_s == 1'b0)) begin
        up_access_ack <= 1'b1;
        up_access_rdata <= {2{16'hdead}};
      end else begin
        up_access_ack <= 1'b0;
        up_access_rdata <= 32'd0;
      end
    end
  end

  // decode block select

  assign up_sel_s = (up_addr[13:4] == 10'd0) ? up_sel : 1'b0;
  assign up_wr_s = up_sel_s & up_wr;

  // write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_scratch <= 'd0;
    end else begin
      if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'h2)) begin
        up_scratch <= up_wdata;
      end
    end
  end

  // read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_int_ack <= 'd0;
      up_int_rdata <= 'd0;
    end else begin
      up_int_ack <= up_sel_s;
      if (up_sel_s == 1'b1) begin
        case (up_addr[3:0])
          4'h0: up_int_rdata <= PCORE_VERSION;
          4'h1: up_int_rdata <= PCORE_ID;
          4'h2: up_int_rdata <= up_scratch;
          default: up_int_rdata <= 32'd0;
        endcase
      end else begin
        up_int_rdata <= 32'd0;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
