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
// This is the LVDS/DDR interface, note that overrange is independent of data path,
// software will not be able to relate overrange to a specific sample!
// Alternative is to concatenate sample value and or status for data.

`timescale 1ns/100ps

module axi_ad9434_if (

  // adc interface (clk, data, over-range)

  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_or_in_p,
  adc_or_in_n,

  // interface outputs

  adc_clk,
  adc_rst,
  adc_data,
  adc_or,
  adc_status,

  // delay control signals

  delay_clk,
  delay_rst,
  delay_sel,
  delay_rwn,
  delay_addr,
  delay_wdata,
  delay_rdata,
  delay_ack_t,
  delay_locked);

  // This parameter controls the buffer type based on the target device.

  parameter   PCORE_DEVICE_TYPE = 0;
  parameter   PCORE_IODELAY_GROUP = "adc_if_delay_group";
  localparam  PCORE_DEVICE_7SERIES = 0;
  localparam  PCORE_DEVICE_VIRTEX6 = 1;

  // adc interface (clk, data, over-range)

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [11:0]  adc_data_in_p;
  input   [11:0]  adc_data_in_n;
  input           adc_or_in_p;
  input           adc_or_in_n;

  // interface outputs

  output          adc_clk;
  input           adc_rst;
  output  [47:0]  adc_data;
  output          adc_or;
  output          adc_status;

  // delay control signals

  input           delay_clk;
  input           delay_rst;
  input           delay_sel;
  input           delay_rwn;
  input   [ 7:0]  delay_addr;
  input   [ 4:0]  delay_wdata;
  output  [ 4:0]  delay_rdata;
  output          delay_ack_t;
  output          delay_locked;

  // internal registers

  reg     [47:0]  adc_data = 'd0;
  reg             adc_or = 'd0;
  reg             adc_status = 'd0;

  // internal clocks and resets

  wire            adc_clk_in;

  // internal signals

  wire    [11:0]  adc_data_ibuf_s;
  wire    [ 3:0]  adc_data_serdes_s[11:0];
  wire            adc_or_ibuf_s;
  wire    [ 3:0]  adc_or_serdes_s;
  wire            adc_clk_ibuf_s;

  // delay elements are not used

  assign delay_ack_t = 1'b0;
  assign delay_rdata = 5'd0;
  assign delay_locked = 1'b0;

  // de-multiplex the adc data

  always @(posedge adc_clk) begin
    adc_data <= {adc_data_serdes_s[11][3], adc_data_serdes_s[10][3],
                 adc_data_serdes_s[ 9][3], adc_data_serdes_s[ 8][3],
                 adc_data_serdes_s[ 7][3], adc_data_serdes_s[ 6][3],
                 adc_data_serdes_s[ 5][3], adc_data_serdes_s[ 4][3],
                 adc_data_serdes_s[ 3][3], adc_data_serdes_s[ 2][3],
                 adc_data_serdes_s[ 1][3], adc_data_serdes_s[ 0][3],
                 adc_data_serdes_s[11][2], adc_data_serdes_s[10][2],
                 adc_data_serdes_s[ 9][2], adc_data_serdes_s[ 8][2],
                 adc_data_serdes_s[ 7][2], adc_data_serdes_s[ 6][2],
                 adc_data_serdes_s[ 5][2], adc_data_serdes_s[ 4][2],
                 adc_data_serdes_s[ 3][2], adc_data_serdes_s[ 2][2],
                 adc_data_serdes_s[ 1][2], adc_data_serdes_s[ 0][2],
                 adc_data_serdes_s[11][1], adc_data_serdes_s[10][1],
                 adc_data_serdes_s[ 9][1], adc_data_serdes_s[ 8][1],
                 adc_data_serdes_s[ 7][1], adc_data_serdes_s[ 6][1],
                 adc_data_serdes_s[ 5][1], adc_data_serdes_s[ 4][1],
                 adc_data_serdes_s[ 3][1], adc_data_serdes_s[ 2][1],
                 adc_data_serdes_s[ 1][1], adc_data_serdes_s[ 0][1],
                 adc_data_serdes_s[11][0], adc_data_serdes_s[10][0],
                 adc_data_serdes_s[ 9][0], adc_data_serdes_s[ 8][0],
                 adc_data_serdes_s[ 7][0], adc_data_serdes_s[ 6][0],
                 adc_data_serdes_s[ 5][0], adc_data_serdes_s[ 4][0],
                 adc_data_serdes_s[ 3][0], adc_data_serdes_s[ 2][0],
                 adc_data_serdes_s[ 1][0], adc_data_serdes_s[ 0][0]};
    if (adc_or_serdes_s == 4'd0) begin
      adc_or <= 1'b0;
    end else begin
      adc_or <= 1'b1;
    end
    adc_status <= 1'b1;
  end

  // data path - input-buffer - input-serdes (4:1)

  genvar l_inst;
  generate
  for (l_inst = 0; l_inst <= 11; l_inst = l_inst + 1) begin : g_adc_if

  IBUFDS i_data_ibuf (
    .I (adc_data_in_p[l_inst]),
    .IB (adc_data_in_n[l_inst]),
    .O (adc_data_ibuf_s[l_inst]));

  ISERDESE1 #(
    .DATA_RATE ("SDR"),
    .DATA_WIDTH (4),
    .INTERFACE_TYPE ("NETWORKING"), 
    .DYN_CLKDIV_INV_EN ("FALSE"),
    .DYN_CLK_INV_EN ("FALSE"),
    .NUM_CE (2),
    .OFB_USED ("FALSE"),
    .IOBDELAY ("NONE"),
    .SERDES_MODE ("MASTER"))
  i_data_serdes (
    .Q1 (adc_data_serdes_s[l_inst][3]),
    .Q2 (adc_data_serdes_s[l_inst][2]),
    .Q3 (adc_data_serdes_s[l_inst][1]),
    .Q4 (adc_data_serdes_s[l_inst][0]),
    .Q5 (),
    .Q6 (),
    .SHIFTOUT1 (),
    .SHIFTOUT2 (),
    .BITSLIP (1'b0),
    .CE1 (1'b1),
    .CE2 (1'b1),
    .CLK (adc_clk_in),
    .CLKB (~adc_clk_in),
    .CLKDIV (adc_clk),
    .D (adc_data_ibuf_s[l_inst]),
    .DDLY (1'b0),
    .RST (adc_rst),
    .SHIFTIN1 (1'b0),
    .SHIFTIN2 (1'b0),
    .DYNCLKDIVSEL (1'b0),
    .DYNCLKSEL (1'b0),
    .OFB (1'b0),
    .OCLK (1'b0),
    .O ());

  end
  endgenerate

  // over-range - input-buffer - input-serdes (4:1)

  IBUFDS i_or_ibuf (
    .I (adc_or_in_p),
    .IB (adc_or_in_n),
    .O (adc_or_ibuf_s));

  ISERDESE1 #(
    .DATA_RATE ("SDR"),
    .DATA_WIDTH (4),
    .INTERFACE_TYPE ("NETWORKING"), 
    .DYN_CLKDIV_INV_EN ("FALSE"),
    .DYN_CLK_INV_EN ("FALSE"),
    .NUM_CE (2),
    .OFB_USED ("FALSE"),
    .IOBDELAY ("NONE"),
    .SERDES_MODE ("MASTER"))
  i_or_serdes (
    .Q1 (adc_or_serdes_s[3]),
    .Q2 (adc_or_serdes_s[2]),
    .Q3 (adc_or_serdes_s[1]),
    .Q4 (adc_or_serdes_s[0]),
    .Q5 (),
    .Q6 (),
    .SHIFTOUT1 (),
    .SHIFTOUT2 (),
    .BITSLIP (1'b0),
    .CE1 (1'b1),
    .CE2 (1'b1),
    .CLK (adc_clk_in),
    .CLKB (~adc_clk_in),
    .CLKDIV (adc_clk),
    .D (adc_or_ibuf_s),
    .DDLY (1'b0),
    .RST (adc_rst),
    .SHIFTIN1 (1'b0),
    .SHIFTIN2 (1'b0),
    .DYNCLKDIVSEL (1'b0),
    .DYNCLKSEL (1'b0),
    .OFB (1'b0),
    .OCLK (1'b0),
    .O ());

  // clock - input-buffer ---> bufio & bufr combination (4:1)

  IBUFGDS i_clk_ibuf (
    .I (adc_clk_in_p),
    .IB (adc_clk_in_n),
    .O (adc_clk_ibuf_s));

  BUFIO i_clk_hs_buf (
    .I (adc_clk_ibuf_s),
    .O (adc_clk_in));

  BUFR #(.BUFR_DIVIDE("4")) i_clk_buf (
    .CLR(1'b0),
    .CE(1'b1),
    .I (adc_clk_ibuf_s),
    .O (adc_clk));

endmodule

// ***************************************************************************
// ***************************************************************************

