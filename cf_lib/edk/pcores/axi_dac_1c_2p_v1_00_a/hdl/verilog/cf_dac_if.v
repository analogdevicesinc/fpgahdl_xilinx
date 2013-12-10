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

module cf_dac_if (

  // dac interface

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_data_out_a_p,
  dac_data_out_a_n,
  dac_data_out_b_p,
  dac_data_out_b_n,

  // internal interface, a low speed dac clock is used by the internal logic
  // sample 0 is transmitted first

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

  // processor signals

  up_dds_enable);

  // dac interface

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output  [13:0]  dac_data_out_a_p;
  output  [13:0]  dac_data_out_a_n;
  output  [13:0]  dac_data_out_b_p;
  output  [13:0]  dac_data_out_b_n;

  // internal interface, a low speed dac clock is used by the internal logic
  // sample 0 is transmitted first

  output          dac_div3_clk;
  input   [13:0]  dds_data_00;
  input   [13:0]  dds_data_01;
  input   [13:0]  dds_data_02;
  input   [13:0]  dds_data_03;
  input   [13:0]  dds_data_04;
  input   [13:0]  dds_data_05;
  input   [13:0]  dds_data_06;
  input   [13:0]  dds_data_07;
  input   [13:0]  dds_data_08;
  input   [13:0]  dds_data_09;
  input   [13:0]  dds_data_10;
  input   [13:0]  dds_data_11;

  // processor signals

  input           up_dds_enable;

  reg     [ 5:0]  dds_data_a[13:0];
  reg     [ 5:0]  dds_data_b[13:0];

  wire            dac_clk_in_s;
  wire            dac_clk_out_s;
  wire  [13:0]    dac_data_out_a_s;
  wire  [13:0]    dac_data_out_b_s;

  wire            serdes_clk_preset_s;
  wire            serdes_clk_rst_s;
  wire            serdes_preset_s;
  wire            serdes_rst_s;

  wire            dac_clk;
  wire            dac_div3_clk_s;

  // The OSERDES modules drive data bit-wise. That is, samples are first need to be
  // bit selected, then passed to the OSERDES. The same for parity.

  always @(posedge dac_div3_clk) begin
    dds_data_a[13] <= {dds_data_10[13], dds_data_08[13], dds_data_06[13],
                       dds_data_04[13], dds_data_02[13], dds_data_00[13]};
    dds_data_a[12] <= {dds_data_10[12], dds_data_08[12], dds_data_06[12],
                       dds_data_04[12], dds_data_02[12], dds_data_00[12]};
    dds_data_a[11] <= {dds_data_10[11], dds_data_08[11], dds_data_06[11],
                       dds_data_04[11], dds_data_02[11], dds_data_00[11]};
    dds_data_a[10] <= {dds_data_10[10], dds_data_08[10], dds_data_06[10],
                       dds_data_04[10], dds_data_02[10], dds_data_00[10]};
    dds_data_a[ 9] <= {dds_data_10[ 9], dds_data_08[ 9], dds_data_06[ 9],
                       dds_data_04[ 9], dds_data_02[ 9], dds_data_00[ 9]};
    dds_data_a[ 8] <= {dds_data_10[ 8], dds_data_08[ 8], dds_data_06[ 8],
                       dds_data_04[ 8], dds_data_02[ 8], dds_data_00[ 8]};
    dds_data_a[ 7] <= {dds_data_10[ 7], dds_data_08[ 7], dds_data_06[ 7],
                       dds_data_04[ 7], dds_data_02[ 7], dds_data_00[ 7]};
    dds_data_a[ 6] <= {dds_data_10[ 6], dds_data_08[ 6], dds_data_06[ 6],
                       dds_data_04[ 6], dds_data_02[ 6], dds_data_00[ 6]};
    dds_data_a[ 5] <= {dds_data_10[ 5], dds_data_08[ 5], dds_data_06[ 5],
                       dds_data_04[ 5], dds_data_02[ 5], dds_data_00[ 5]};
    dds_data_a[ 4] <= {dds_data_10[ 4], dds_data_08[ 4], dds_data_06[ 4],
                       dds_data_04[ 4], dds_data_02[ 4], dds_data_00[ 4]};
    dds_data_a[ 3] <= {dds_data_10[ 3], dds_data_08[ 3], dds_data_06[ 3],
                       dds_data_04[ 3], dds_data_02[ 3], dds_data_00[ 3]};
    dds_data_a[ 2] <= {dds_data_10[ 2], dds_data_08[ 2], dds_data_06[ 2],
                       dds_data_04[ 2], dds_data_02[ 2], dds_data_00[ 2]};
    dds_data_a[ 1] <= {dds_data_10[ 1], dds_data_08[ 1], dds_data_06[ 1],
                       dds_data_04[ 1], dds_data_02[ 1], dds_data_00[ 1]};
    dds_data_a[ 0] <= {dds_data_10[ 0], dds_data_08[ 0], dds_data_06[ 0],
                       dds_data_04[ 0], dds_data_02[ 0], dds_data_00[ 0]};
    dds_data_b[13] <= {dds_data_11[13], dds_data_09[13], dds_data_07[13],
                       dds_data_05[13], dds_data_03[13], dds_data_01[13]};
    dds_data_b[12] <= {dds_data_11[12], dds_data_09[12], dds_data_07[12],
                       dds_data_05[12], dds_data_03[12], dds_data_01[12]};
    dds_data_b[11] <= {dds_data_11[11], dds_data_09[11], dds_data_07[11],
                       dds_data_05[11], dds_data_03[11], dds_data_01[11]};
    dds_data_b[10] <= {dds_data_11[10], dds_data_09[10], dds_data_07[10],
                       dds_data_05[10], dds_data_03[10], dds_data_01[10]};
    dds_data_b[ 9] <= {dds_data_11[ 9], dds_data_09[ 9], dds_data_07[ 9],
                       dds_data_05[ 9], dds_data_03[ 9], dds_data_01[ 9]};
    dds_data_b[ 8] <= {dds_data_11[ 8], dds_data_09[ 8], dds_data_07[ 8],
                       dds_data_05[ 8], dds_data_03[ 8], dds_data_01[ 8]};
    dds_data_b[ 7] <= {dds_data_11[ 7], dds_data_09[ 7], dds_data_07[ 7],
                       dds_data_05[ 7], dds_data_03[ 7], dds_data_01[ 7]};
    dds_data_b[ 6] <= {dds_data_11[ 6], dds_data_09[ 6], dds_data_07[ 6],
                       dds_data_05[ 6], dds_data_03[ 6], dds_data_01[ 6]};
    dds_data_b[ 5] <= {dds_data_11[ 5], dds_data_09[ 5], dds_data_07[ 5],
                       dds_data_05[ 5], dds_data_03[ 5], dds_data_01[ 5]};
    dds_data_b[ 4] <= {dds_data_11[ 4], dds_data_09[ 4], dds_data_07[ 4],
                       dds_data_05[ 4], dds_data_03[ 4], dds_data_01[ 4]};
    dds_data_b[ 3] <= {dds_data_11[ 3], dds_data_09[ 3], dds_data_07[ 3],
                       dds_data_05[ 3], dds_data_03[ 3], dds_data_01[ 3]};
    dds_data_b[ 2] <= {dds_data_11[ 2], dds_data_09[ 2], dds_data_07[ 2],
                       dds_data_05[ 2], dds_data_03[ 2], dds_data_01[ 2]};
    dds_data_b[ 1] <= {dds_data_11[ 1], dds_data_09[ 1], dds_data_07[ 1],
                       dds_data_05[ 1], dds_data_03[ 1], dds_data_01[ 1]};
    dds_data_b[ 0] <= {dds_data_11[ 0], dds_data_09[ 0], dds_data_07[ 0],
                       dds_data_05[ 0], dds_data_03[ 0], dds_data_01[ 0]};
  end

  // The resets for SERDES data/clock are separately controlled.
  // They are held in reset until software enabled.

  assign serdes_clk_preset_s = 1'b0;

  FDPE #(.INIT(1'b1)) i_serdes_clk_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (serdes_clk_preset_s),
    .C (dac_div3_clk),
    .Q (serdes_clk_rst_s));

  assign serdes_preset_s = ~up_dds_enable;

  FDPE #(.INIT(1'b1)) i_serdes_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (serdes_preset_s),
    .C (dac_div3_clk),
    .Q (serdes_rst_s));

  // dac data output serdes(s) & buffers
  // The SERDES is used here to get the lowest clock possible for the internal logic.
  // Since Xilinx SERDES is 3:1 DDR, this clock is DAC-CLK/3. This may seem a bit
  // challenging (being an odd number as divider) to generate samples. It is possible
  // to lower the DAC clock and reduce the OSERDES to be 2:1 or even 1:1. If further
  // reductions are required, it is recommended NOT to use master/slave OSERDES
  // configuration (as this combination is very sensitive to the output and divided
  // clocks). You can lower the clocks at the single OSERDES's divided clock.
  
  genvar l_inst;
  generate
  for (l_inst = 0; l_inst <= 13; l_inst = l_inst + 1) begin: g_dac_data

  OSERDESE1 #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (6),
    .INTERFACE_TYPE ("DEFAULT"),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("MASTER"))
  i_dac_data_out_a_oserdes (
    .D1 (dds_data_a[l_inst][0]),
    .D2 (dds_data_a[l_inst][1]),
    .D3 (dds_data_a[l_inst][2]),
    .D4 (dds_data_a[l_inst][3]),
    .D5 (dds_data_a[l_inst][4]),
    .D6 (dds_data_a[l_inst][5]),
    .T1 (1'b0),
    .T2 (1'b0),
    .T3 (1'b0),
    .T4 (1'b0),
    .SHIFTIN1 (1'b0),
    .SHIFTIN2 (1'b0),
    .SHIFTOUT1 (),
    .SHIFTOUT2 (),
    .OCE (1'b1),
    .CLK (dac_clk),
    .CLKDIV (dac_div3_clk),
    .CLKPERF (1'b0),
    .CLKPERFDELAY (1'b0),
    .WC (1'b0),
    .ODV (1'b0),
    .OQ (dac_data_out_a_s[l_inst]),
    .TQ (),
    .OCBEXTEND (),
    .OFB (),
    .TFB (),
    .TCE (1'b0),
    .RST (serdes_rst_s));

  OBUFDS i_dac_data_out_a_buf (
    .I (dac_data_out_a_s[l_inst]),
    .O (dac_data_out_a_p[l_inst]),
    .OB (dac_data_out_a_n[l_inst]));

  OSERDESE1 #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (6),
    .INTERFACE_TYPE ("DEFAULT"),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("MASTER"))
  i_dac_data_out_b_oserdes (
    .D1 (dds_data_b[l_inst][0]),
    .D2 (dds_data_b[l_inst][1]),
    .D3 (dds_data_b[l_inst][2]),
    .D4 (dds_data_b[l_inst][3]),
    .D5 (dds_data_b[l_inst][4]),
    .D6 (dds_data_b[l_inst][5]),
    .T1 (1'b0),
    .T2 (1'b0),
    .T3 (1'b0),
    .T4 (1'b0),
    .SHIFTIN1 (1'b0),
    .SHIFTIN2 (1'b0),
    .SHIFTOUT1 (),
    .SHIFTOUT2 (),
    .OCE (1'b1),
    .CLK (dac_clk),
    .CLKDIV (dac_div3_clk),
    .CLKPERF (1'b0),
    .CLKPERFDELAY (1'b0),
    .WC (1'b0),
    .ODV (1'b0),
    .OQ (dac_data_out_b_s[l_inst]),
    .TQ (),
    .OCBEXTEND (),
    .OFB (),
    .TFB (),
    .TCE (1'b0),
    .RST (serdes_rst_s));

  OBUFDS i_dac_data_out_b_buf (
    .I (dac_data_out_b_s[l_inst]),
    .O (dac_data_out_b_p[l_inst]),
    .OB (dac_data_out_b_n[l_inst]));

  end
  endgenerate

  // dac clock output serdes & buffer
  
  OSERDESE1 #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (6),
    .INTERFACE_TYPE ("DEFAULT"),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("MASTER"))
  i_dac_clk_out_oserdes (
    .D1 (1'b0),
    .D2 (1'b1),
    .D3 (1'b0),
    .D4 (1'b1),
    .D5 (1'b0),
    .D6 (1'b1),
    .T1 (1'b0),
    .T2 (1'b0),
    .T3 (1'b0),
    .T4 (1'b0),
    .SHIFTIN1 (1'b0),
    .SHIFTIN2 (1'b0),
    .SHIFTOUT1 (),
    .SHIFTOUT2 (),
    .OCE (1'b1),
    .CLK (dac_clk),
    .CLKDIV (dac_div3_clk),
    .CLKPERF (1'b0),
    .CLKPERFDELAY (1'b0),
    .WC (1'b0),
    .ODV (1'b0),
    .OQ (dac_clk_out_s),
    .TQ (),
    .OCBEXTEND (),
    .OFB (),
    .TFB (),
    .TCE (1'b0),
    .RST (serdes_clk_rst_s));

  OBUFDS i_dac_clk_out_obuf (
    .I (dac_clk_out_s),
    .O (dac_clk_out_p),
    .OB (dac_clk_out_n));

  // dac clock input buffers (can't use MMCM or BUFIO due to pin placements).
  // It may be possible to use BUFIO/BUFR on some carriers (where the GCLK and
  // data are on the same banks.

  IBUFGDS i_dac_clk_in_ibuf (
    .I (dac_clk_in_p),
    .IB (dac_clk_in_n),
    .O (dac_clk_in_s));

  BUFG i_dac_clk_in_gbuf (
    .I (dac_clk_in_s),
    .O (dac_clk));

  BUFR #(.BUFR_DIVIDE("3")) i_dac_div3_clk_rbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (dac_clk),
    .O (dac_div3_clk_s));

  BUFG i_dac_div3_clk_gbuf (
    .I (dac_div3_clk_s),
    .O (dac_div3_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
