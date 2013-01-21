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

module cf_adc_if (

  // adc interface (clk, data, over-range)
  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_data_or_p,
  adc_data_or_n,

  // interface outputs
  adc_clk,
  adc_data_a,
  adc_data_b,
  adc_or,

  // processor control signals
  up_dmode,
  up_delay_sel,
  up_delay_rwn,
  up_delay_addr,
  up_delay_wdata,

  // delay control signals
  delay_clk,
  delay_ack,
  delay_rdata,
  delay_locked);

  // This parameter controls the buffer type based on the target device.
  parameter C_CF_BUFTYPE = 0;
  parameter C_CF_7SERIES = 0;
  parameter C_CF_VIRTEX6 = 1;
  parameter C_IODELAY_GROUP = "adc_if_delay_group";

  // adc interface (clk, data, over-range)
  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [13:0]  adc_data_in_p;
  input   [13:0]  adc_data_in_n;
  input           adc_data_or_p;
  input           adc_data_or_n;

  // interface outputs
  output          adc_clk;
  output  [13:0]  adc_data_a;
  output  [13:0]  adc_data_b;
  output  [ 1:0]  adc_or;

  // processor control signals
  input   [ 1:0]  up_dmode;
  input           up_delay_sel;
  input           up_delay_rwn;
  input   [ 3:0]  up_delay_addr;
  input   [ 4:0]  up_delay_wdata;

  // delay control signals
  input           delay_clk;
  output          delay_ack;
  output  [ 4:0]  delay_rdata;
  output          delay_locked;

  reg     [ 1:0]  adc_dmode_m1 = 'd0;
  reg     [ 1:0]  adc_dmode = 'd0;
  reg     [13:0]  adc_data_p = 'd0;
  reg     [13:0]  adc_data_n = 'd0;
  reg     [13:0]  adc_data_n_d = 'd0;
  reg     [13:0]  adc_dmux_a = 'd0;
  reg     [13:0]  adc_dmux_b = 'd0;
  reg     [13:0]  adc_data_a = 'd0;
  reg     [13:0]  adc_data_b = 'd0;
  reg             adc_or_p = 'd0;
  reg             adc_or_n = 'd0;
  reg     [ 4:0]  adc_or_count_p = 'd0;
  reg     [ 4:0]  adc_or_count_n = 'd0;
  reg     [ 1:0]  adc_or = 'd0;
  reg     [ 7:0]  delay_rst_cnt = 'd0;
  reg             delay_sel_m1 = 'd0;
  reg             delay_sel_m2 = 'd0;
  reg             delay_sel_m3 = 'd0;
  reg             delay_sel = 'd0;
  reg             delay_rwn = 'd0;
  reg     [ 3:0]  delay_addr = 'd0;
  reg     [ 4:0]  delay_wdata = 'd0;
  reg     [14:0]  delay_ld = 'd0;
  reg             delay_sel_d = 'd0;
  reg             delay_sel_2d = 'd0;
  reg             delay_sel_3d = 'd0;
  reg             delay_ack = 'd0;
  reg     [ 4:0]  delay_rdata = 'd0;
  reg             delay_locked = 'd0;

  wire            delay_preset_s;
  wire            delay_rst_s;
  wire    [ 4:0]  delay_rdata_s[14:0];
  wire            delay_locked_s;
  wire    [13:0]  adc_data_ibuf_s;
  wire    [13:0]  adc_data_idelay_s;
  wire    [13:0]  adc_data_p_s;
  wire    [13:0]  adc_data_n_s;
  wire            adc_or_ibuf_s;
  wire            adc_or_idelay_s;
  wire            adc_or_p_s;
  wire            adc_or_n_s;
  wire            adc_clk_ibuf_s;

  genvar          l_inst;

  // The adc data is 14bits ddr, and here it is demuxed to 16bits.
  // The samples may be selected to be either positive first, or negative first.
  // Two data pin modes are supported- data can either be clock edge muxed (rising or falling edges),
  // or within a clock edge, pin muxed (lower 7 bits and upper 7 bits)

  always @(posedge adc_clk) begin
    adc_dmode_m1 <= up_dmode;
    adc_dmode <= adc_dmode_m1;
    adc_data_p <= adc_data_p_s;
    adc_data_n <= adc_data_n_s;
    adc_data_n_d <= adc_data_n;
    adc_dmux_a <= (adc_dmode[0] == 1'b1) ? adc_data_p : adc_data_n_d;
    adc_dmux_b <= (adc_dmode[0] == 1'b1) ? adc_data_n : adc_data_p;
    adc_data_a[13] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[13] : adc_dmux_b[13];
    adc_data_a[12] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[12] : adc_dmux_a[13];
    adc_data_a[11] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[11] : adc_dmux_b[12];
    adc_data_a[10] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[10] : adc_dmux_a[12];
    adc_data_a[ 9] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 9] : adc_dmux_b[11];
    adc_data_a[ 8] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 8] : adc_dmux_a[11];
    adc_data_a[ 7] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 7] : adc_dmux_b[10];
    adc_data_a[ 6] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 6] : adc_dmux_a[10];
    adc_data_a[ 5] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 5] : adc_dmux_b[ 9];
    adc_data_a[ 4] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 4] : adc_dmux_a[ 9];
    adc_data_a[ 3] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 3] : adc_dmux_b[ 8];
    adc_data_a[ 2] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 2] : adc_dmux_a[ 8];
    adc_data_a[ 1] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 1] : adc_dmux_b[ 7];
    adc_data_a[ 0] <= (adc_dmode[1] == 1'b1) ? adc_dmux_a[ 0] : adc_dmux_a[ 7];
    adc_data_b[13] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[13] : adc_dmux_b[ 6];
    adc_data_b[12] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[12] : adc_dmux_a[ 6];
    adc_data_b[11] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[11] : adc_dmux_b[ 5];
    adc_data_b[10] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[10] : adc_dmux_a[ 5];
    adc_data_b[ 9] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 9] : adc_dmux_b[ 4];
    adc_data_b[ 8] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 8] : adc_dmux_a[ 4];
    adc_data_b[ 7] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 7] : adc_dmux_b[ 3];
    adc_data_b[ 6] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 6] : adc_dmux_a[ 3];
    adc_data_b[ 5] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 5] : adc_dmux_b[ 2];
    adc_data_b[ 4] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 4] : adc_dmux_a[ 2];
    adc_data_b[ 3] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 3] : adc_dmux_b[ 1];
    adc_data_b[ 2] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 2] : adc_dmux_a[ 1];
    adc_data_b[ 1] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 1] : adc_dmux_b[ 0];
    adc_data_b[ 0] <= (adc_dmode[1] == 1'b1) ? adc_dmux_b[ 0] : adc_dmux_a[ 0];
    adc_or_p <= adc_or_p_s;
    adc_or_n <= adc_or_n_s;
    if (adc_or_p == 1'b1) begin
      adc_or_count_p <= 5'h10;
    end else if (adc_or_count_p[4] == 1'b1) begin
      adc_or_count_p <= adc_or_count_p + 1'b1;
    end
    if (adc_or_n == 1'b1) begin
      adc_or_count_n <= 5'h10;
    end else if (adc_or_count_n[4] == 1'b1) begin
      adc_or_count_n <= adc_or_count_n + 1'b1;
    end
    adc_or <= {adc_or_count_n[4], adc_or_count_p[4]};
  end

  // The delay control interface, each delay element can be individually
  // addressed, and a delay value can be directly loaded (no INC/DEC stuff)

  always @(posedge delay_clk) begin
    if ((delay_sel == 1'b1) && (delay_rwn == 1'b0) && (delay_addr == 4'hf)) begin
      delay_rst_cnt <= 'd0;
    end else if (delay_rst_cnt[7] == 1'b0) begin
      delay_rst_cnt <= delay_rst_cnt + 1'b1;
    end
    delay_sel_m1 <= up_delay_sel;
    delay_sel_m2 <= delay_sel_m1;
    delay_sel_m3 <= delay_sel_m2;
    delay_sel <= delay_sel_m2 & ~delay_sel_m3;
    if ((delay_sel_m2 == 1'b1) && (delay_sel_m3 == 1'b0)) begin
      delay_rwn <= up_delay_rwn;
      delay_addr <= up_delay_addr;
      delay_wdata <= up_delay_wdata[4:0];
    end
    if ((delay_sel == 1'b1) && (delay_rwn == 1'b0)) begin
      case (delay_addr)
        4'b1110: delay_ld <= 15'h4000;
        4'b1101: delay_ld <= 15'h2000;
        4'b1100: delay_ld <= 15'h1000;
        4'b1011: delay_ld <= 15'h0800;
        4'b1010: delay_ld <= 15'h0400;
        4'b1001: delay_ld <= 15'h0200;
        4'b1000: delay_ld <= 15'h0100;
        4'b0111: delay_ld <= 15'h0080;
        4'b0110: delay_ld <= 15'h0040;
        4'b0101: delay_ld <= 15'h0020;
        4'b0100: delay_ld <= 15'h0010;
        4'b0011: delay_ld <= 15'h0008;
        4'b0010: delay_ld <= 15'h0004;
        4'b0001: delay_ld <= 15'h0002;
        4'b0000: delay_ld <= 15'h0001;
        default: delay_ld <= 15'h0000;
      endcase
    end else begin
      delay_ld <= 15'h0000;
    end
    delay_sel_d <= delay_sel;
    delay_sel_2d <= delay_sel_d;
    delay_sel_3d <= delay_sel_2d;
    if (delay_sel_3d == 1'b1) begin
      delay_ack <= ~delay_ack;
    end
    case (delay_addr)
      4'b1110: delay_rdata <= delay_rdata_s[14];
      4'b1101: delay_rdata <= delay_rdata_s[13];
      4'b1100: delay_rdata <= delay_rdata_s[12];
      4'b1011: delay_rdata <= delay_rdata_s[11];
      4'b1010: delay_rdata <= delay_rdata_s[10];
      4'b1001: delay_rdata <= delay_rdata_s[ 9];
      4'b1000: delay_rdata <= delay_rdata_s[ 8];
      4'b0111: delay_rdata <= delay_rdata_s[ 7];
      4'b0110: delay_rdata <= delay_rdata_s[ 6];
      4'b0101: delay_rdata <= delay_rdata_s[ 5];
      4'b0100: delay_rdata <= delay_rdata_s[ 4];
      4'b0011: delay_rdata <= delay_rdata_s[ 3];
      4'b0010: delay_rdata <= delay_rdata_s[ 2];
      4'b0001: delay_rdata <= delay_rdata_s[ 1];
      4'b0000: delay_rdata <= delay_rdata_s[ 0];
      default: delay_rdata <= 5'd0;
    endcase
    delay_locked <= delay_locked_s;
  end

  // The delay elements need calibration from a delay controller and it needs a
  // reset (it also asserts locked after the controller is up and running).

  assign delay_preset_s = ~delay_rst_cnt[7];

  FDPE #(.INIT(1'b1)) i_delayctrl_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (delay_preset_s),
    .C (delay_clk),
    .Q (delay_rst_s));

  // The data interface, data signals goes through a LVDS input buffer, then
  // a delay element (1/32th of a 200MHz clock) and finally an input DDR demux.

  generate
  for (l_inst = 0; l_inst <= 13; l_inst = l_inst + 1) begin : g_adc_if

  IBUFDS i_data_ibuf (
    .I (adc_data_in_p[l_inst]),
    .IB (adc_data_in_n[l_inst]),
    .O (adc_data_ibuf_s[l_inst]));

  if (C_CF_BUFTYPE == C_CF_VIRTEX6) begin
  (* IODELAY_GROUP = C_IODELAY_GROUP *)
  IODELAYE1 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("I"),
    .HIGH_PERFORMANCE_MODE ("TRUE"),
    .IDELAY_TYPE ("VAR_LOADABLE"),
    .IDELAY_VALUE (0),
    .ODELAY_TYPE ("FIXED"),
    .ODELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .SIGNAL_PATTERN ("DATA"))
  i_data_idelay (
    .T (1'b1),
    .CE (1'b0),
    .INC (1'b0),
    .CLKIN (1'b0),
    .DATAIN (1'b0),
    .ODATAIN (1'b0),
    .CINVCTRL (1'b0),
    .C (delay_clk),
    .IDATAIN (adc_data_ibuf_s[l_inst]),
    .DATAOUT (adc_data_idelay_s[l_inst]),
    .RST (delay_ld[l_inst]),
    .CNTVALUEIN (delay_wdata),
    .CNTVALUEOUT (delay_rdata_s[l_inst]));
  end else begin
  (* IODELAY_GROUP = C_IODELAY_GROUP *)
  IDELAYE2 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("IDATAIN"),
    .HIGH_PERFORMANCE_MODE ("FALSE"),
    .IDELAY_TYPE ("VAR_LOAD"),
    .IDELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .PIPE_SEL ("FALSE"),
    .SIGNAL_PATTERN ("DATA"))
  i_data_idelay (
    .CE (1'b0),
    .INC (1'b0),
    .DATAIN (1'b0),
    .LDPIPEEN (1'b0),
    .CINVCTRL (1'b0),
    .REGRST (1'b0),
    .C (delay_clk),
    .IDATAIN (adc_data_ibuf_s[l_inst]),
    .DATAOUT (adc_data_idelay_s[l_inst]),
    .LD (delay_ld[l_inst]),
    .CNTVALUEIN (delay_wdata),
    .CNTVALUEOUT (delay_rdata_s[l_inst]));
  end

  IDDR #(
    .INIT_Q1 (1'b0),
    .INIT_Q2 (1'b0),
    .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
    .SRTYPE ("ASYNC"))
  i_data_ddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (adc_clk),
    .D (adc_data_idelay_s[l_inst]),
    .Q1 (adc_data_p_s[l_inst]),
    .Q2 (adc_data_n_s[l_inst]));

  end
  endgenerate

  // The over-range interface, it follows a similar path as the data signals.

  IBUFDS i_or_ibuf (
    .I (adc_data_or_p),
    .IB (adc_data_or_n),
    .O (adc_or_ibuf_s));

  generate
  if (C_CF_BUFTYPE == C_CF_VIRTEX6) begin
  (* IODELAY_GROUP = C_IODELAY_GROUP *)
  IODELAYE1 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("I"),
    .HIGH_PERFORMANCE_MODE ("TRUE"),
    .IDELAY_TYPE ("VAR_LOADABLE"),
    .IDELAY_VALUE (0),
    .ODELAY_TYPE ("FIXED"),
    .ODELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .SIGNAL_PATTERN ("DATA"))
  i_or_idelay (
    .T (1'b1),
    .CE (1'b0),
    .INC (1'b0),
    .CLKIN (1'b0),
    .DATAIN (1'b0),
    .ODATAIN (1'b0),
    .CINVCTRL (1'b0),
    .C (delay_clk),
    .IDATAIN (adc_or_ibuf_s),
    .DATAOUT (adc_or_idelay_s),
    .RST (delay_ld[14]),
    .CNTVALUEIN (delay_wdata),
    .CNTVALUEOUT (delay_rdata_s[14]));
  end else begin
  (* IODELAY_GROUP = C_IODELAY_GROUP *)
  IDELAYE2 #(
    .CINVCTRL_SEL ("FALSE"),
    .DELAY_SRC ("IDATAIN"),
    .HIGH_PERFORMANCE_MODE ("FALSE"),
    .IDELAY_TYPE ("VAR_LOAD"),
    .IDELAY_VALUE (0),
    .REFCLK_FREQUENCY (200.0),
    .PIPE_SEL ("FALSE"),
    .SIGNAL_PATTERN ("DATA"))
  i_or_idelay (
    .CE (1'b0),
    .INC (1'b0),
    .DATAIN (1'b0),
    .LDPIPEEN (1'b0),
    .CINVCTRL (1'b0),
    .REGRST (1'b0),
    .C (delay_clk),
    .IDATAIN (adc_or_ibuf_s),
    .DATAOUT (adc_or_idelay_s),
    .LD (delay_ld[14]),
    .CNTVALUEIN (delay_wdata),
    .CNTVALUEOUT (delay_rdata_s[14]));
  end
  endgenerate

  IDDR #(
    .INIT_Q1 (1'b0),
    .INIT_Q2 (1'b0),
    .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
    .SRTYPE ("ASYNC"))
  i_or_ddr (
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (adc_clk),
    .D (adc_or_idelay_s),
    .Q1 (adc_or_p_s),
    .Q2 (adc_or_n_s));

  // The clock path is a simple clock buffer after a LVDS input buffer.
  // It is possible for this logic to be replaced with a OSERDES based data capture.
  // The reason for such a simple interface here is because this reference design
  // is used for various boards (native fmc and/or evaluation boards). The pinouts
  // of the FPGA - ADC interface is probably do not allow a OSERDES placement.

  IBUFGDS i_clk_ibuf (
    .I (adc_clk_in_p),
    .IB (adc_clk_in_n),
    .O (adc_clk_ibuf_s));

  generate
  if (C_CF_BUFTYPE == C_CF_VIRTEX6) begin
  BUFR #(.BUFR_DIVIDE ("BYPASS")) i_clk_gbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (adc_clk_ibuf_s),
    .O (adc_clk));
  end else begin
  BUFG i_clk_gbuf (
    .I (adc_clk_ibuf_s),
    .O (adc_clk));
  end
  endgenerate

  // The delay controller. Refer to Xilinx doc. for details.
  // The GROUP directive controls which delay elements this is associated with.

  (* IODELAY_GROUP = C_IODELAY_GROUP *)
  IDELAYCTRL i_delay_ctrl (
    .RST (delay_rst_s),
    .REFCLK (delay_clk),
    .RDY (delay_locked_s));

endmodule

// ***************************************************************************
// ***************************************************************************

