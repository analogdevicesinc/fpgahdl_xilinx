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
// This is the dac physical interface (drives samples from the low speed clock to the
// DAC clock domain.

`timescale 1ns/100ps

module cf_dac_if (

  // The clock is controlled separately from the data. This ensures that the data (samples)
  // changes are hitless (clock is always present).  The DACs usually use DCI (this clock) at
  // the write side of a FIFO. This would keep the FIFOs running while data is being changed.

  up_dds_clk_enable,

  // DAC interface

  dac_clk_in_p,
  dac_clk_in_n,
  dac_clk_out_p,
  dac_clk_out_n,
  dac_frame_out_p,
  dac_frame_out_n,
  dac_data_out_p,
  dac_data_out_n,

  // internal interface, a low speed dac clock is used by the internal logic

  dac_div3_clk,
  dds_master_enable,

  // I frame/data (sample 0 is transmitted first)

  dds_frame_0,
  dds_data_00,
  dds_data_01,
  dds_data_02,

  // Q frame/data (sample 0 is transmitted first)

  dds_frame_1,
  dds_data_10,
  dds_data_11,
  dds_data_12,

  // the following interface is provided for any user logic that requires dac-clk,
  // and do not wish to run the interface at higher speeds. You must set the
  // C_CF_BUFTYPE parameter to 'h1X to enable ODDR interface instead of an OSERDES.
  // You may use either dac_clk or dac_div3_clk in this case.

  dac_clk,
  usr_frame,
  usr_data_I,
  usr_data_Q,

  // delay controls

  delay_clk,
  delay_enable,
  delay_incdecn,
  delay_locked);

  // This parameter controls the buffer type based on the target device.

  parameter C_CF_BUFTYPE = 0;
  parameter C_CF_7SERIES = 0;
  parameter C_CF_VIRTEX6 = 1;
  parameter MMCM_CLKIN1_PERIOD  = 1.667;
  parameter MMCM_DIVCLK_DIVIDE  = 6;
  parameter MMCM_CLKFBOUT_MULT_F = 12.000;
  parameter MMCM_CLKOUT0_DIVIDE_F = 2.000;
  parameter MMCM_CLKOUT1_DIVIDE = 6;

  parameter C_DEVICE_SEL = C_CF_BUFTYPE & 'hf;
  parameter C_ODDR_SEL = (C_CF_BUFTYPE >> 4) & 'hf;

  // The clock is controlled separately from the data. This ensures that the data (samples)
  // changes are hitless (clock is always present).  The DACs usually use DCI (this clock) at
  // the write side of a FIFO. This would keep the FIFOs running while data is being changed.

  input           up_dds_clk_enable;

  // DAC interface

  input           dac_clk_in_p;
  input           dac_clk_in_n;
  output          dac_clk_out_p;
  output          dac_clk_out_n;
  output          dac_frame_out_p;
  output          dac_frame_out_n;
  output  [15:0]  dac_data_out_p;
  output  [15:0]  dac_data_out_n;

  // internal interface, a low speed dac clock is used by the internal logic

  output          dac_div3_clk;
  input           dds_master_enable;

  // I frame/data (sample 0 is transmitted first)

  input   [ 2:0]  dds_frame_0;
  input   [15:0]  dds_data_00;
  input   [15:0]  dds_data_01;
  input   [15:0]  dds_data_02;

  // Q frame/data (sample 0 is transmitted first)

  input   [ 2:0]  dds_frame_1;
  input   [15:0]  dds_data_10;
  input   [15:0]  dds_data_11;
  input   [15:0]  dds_data_12;

  // the following interface is provided for any user logic that requires dac-clk,
  // and do not wish to run the interface at higher speeds. You must set the
  // C_CF_BUFTYPE parameter to 'h1X to enable ODDR interface instead of an OSERDES.
  // You may use either dac_clk or dac_div3_clk in this case.

  output          dac_clk;
  input           usr_frame;
  input   [15:0]  usr_data_I;
  input   [15:0]  usr_data_Q;

  // delay controls

  input           delay_clk;
  input           delay_enable;
  input           delay_incdecn;
  output          delay_locked;

  reg     [ 5:0]  dds_data[15:0];
  reg     [ 5:0]  dds_frame = 'd0;

  wire            dac_clk_in_s;
  wire            dac_clk_out_s;
  wire            dac_frame_out_s;
  wire    [15:0]  dac_data_out_s;

  wire            serdes_preset_s;
  wire            serdes_rst_s;
  wire            serdes_clk_preset_s;
  wire            serdes_clk_rst_s;
  wire            dac_clk;
  wire            dac_mmcm_fb_clk_s;
  wire            dac_mmcm_clk_s;
  wire            dac_mmcm_div3_clk_s;
  wire            dac_mmcm_locked_s;
  wire            dac_fb_clk_s;

  assign delay_locked = 'd0;

  // The OSERDES modules drive data bit-wise. That is, samples are first need to be
  // bit selected, then passed to the OSERDES. The same for frame.

  always @(posedge dac_div3_clk) begin
    dds_data[15] <= {dds_data_12[15], dds_data_02[15], dds_data_11[15],
                    dds_data_01[15], dds_data_10[15], dds_data_00[15]};
    dds_data[14] <= {dds_data_12[14], dds_data_02[14], dds_data_11[14],
                    dds_data_01[14], dds_data_10[14], dds_data_00[14]};
    dds_data[13] <= {dds_data_12[13], dds_data_02[13], dds_data_11[13],
                    dds_data_01[13], dds_data_10[13], dds_data_00[13]};
    dds_data[12] <= {dds_data_12[12], dds_data_02[12], dds_data_11[12],
                    dds_data_01[12], dds_data_10[12], dds_data_00[12]};
    dds_data[11] <= {dds_data_12[11], dds_data_02[11], dds_data_11[11],
                    dds_data_01[11], dds_data_10[11], dds_data_00[11]};
    dds_data[10] <= {dds_data_12[10], dds_data_02[10], dds_data_11[10],
                    dds_data_01[10], dds_data_10[10], dds_data_00[10]};
    dds_data[ 9] <= {dds_data_12[ 9], dds_data_02[ 9], dds_data_11[ 9],
                    dds_data_01[ 9], dds_data_10[ 9], dds_data_00[ 9]};
    dds_data[ 8] <= {dds_data_12[ 8], dds_data_02[ 8], dds_data_11[ 8],
                    dds_data_01[ 8], dds_data_10[ 8], dds_data_00[ 8]};
    dds_data[ 7] <= {dds_data_12[ 7], dds_data_02[ 7], dds_data_11[ 7],
                    dds_data_01[ 7], dds_data_10[ 7], dds_data_00[ 7]};
    dds_data[ 6] <= {dds_data_12[ 6], dds_data_02[ 6], dds_data_11[ 6],
                    dds_data_01[ 6], dds_data_10[ 6], dds_data_00[ 6]};
    dds_data[ 5] <= {dds_data_12[ 5], dds_data_02[ 5], dds_data_11[ 5],
                    dds_data_01[ 5], dds_data_10[ 5], dds_data_00[ 5]};
    dds_data[ 4] <= {dds_data_12[ 4], dds_data_02[ 4], dds_data_11[ 4],
                    dds_data_01[ 4], dds_data_10[ 4], dds_data_00[ 4]};
    dds_data[ 3] <= {dds_data_12[ 3], dds_data_02[ 3], dds_data_11[ 3],
                    dds_data_01[ 3], dds_data_10[ 3], dds_data_00[ 3]};
    dds_data[ 2] <= {dds_data_12[ 2], dds_data_02[ 2], dds_data_11[ 2],
                    dds_data_01[ 2], dds_data_10[ 2], dds_data_00[ 2]};
    dds_data[ 1] <= {dds_data_12[ 1], dds_data_02[ 1], dds_data_11[ 1],
                    dds_data_01[ 1], dds_data_10[ 1], dds_data_00[ 1]};
    dds_data[ 0] <= {dds_data_12[ 0], dds_data_02[ 0], dds_data_11[ 0],
                    dds_data_01[ 0], dds_data_10[ 0], dds_data_00[ 0]};
    dds_frame <= {dds_frame_1[2], dds_frame_0[2], dds_frame_1[1],
      dds_frame_0[1], dds_frame_1[0], dds_frame_0[0]};
  end

  // The resets for SERDES data/clock are separately controlled.
  // They are held in reset until MMCM is locked and software enabled.

  assign serdes_preset_s = ~dac_mmcm_locked_s | ~dds_master_enable;

  FDPE #(.INIT(1'b1)) i_serdes_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (serdes_preset_s),
    .C (dac_div3_clk),
    .Q (serdes_rst_s));

  assign serdes_clk_preset_s = ~dac_mmcm_locked_s | ~up_dds_clk_enable;

  FDPE #(.INIT(1'b1)) i_serdes_clk_rst_reg (
    .CE (1'b1),
    .D (1'b0),
    .PRE (serdes_clk_preset_s),
    .C (dac_div3_clk),
    .Q (serdes_clk_rst_s));

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
  for (l_inst = 0; l_inst <= 15; l_inst = l_inst + 1) begin: g_dac_data

  if (C_ODDR_SEL == 1) begin
  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_dac_data_out_oddr (
    .S (1'b0),
    .CE (1'b1),
    .R (serdes_rst_s),
    .C (dac_clk),
    .D1 (usr_data_I[l_inst]),
    .D2 (usr_data_Q[l_inst]),
    .Q (dac_data_out_s[l_inst]));
  end else begin
  OSERDESE1 #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (6),
    .INTERFACE_TYPE ("DEFAULT"),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("MASTER"))
  i_dac_data_out_oserdes (
    .D1 (dds_data[l_inst][0]),
    .D2 (dds_data[l_inst][1]),
    .D3 (dds_data[l_inst][2]),
    .D4 (dds_data[l_inst][3]),
    .D5 (dds_data[l_inst][4]),
    .D6 (dds_data[l_inst][5]),
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
    .OQ (dac_data_out_s[l_inst]),
    .TQ (),
    .OCBEXTEND (),
    .OFB (),
    .TFB (),
    .TCE (1'b0),
    .RST (serdes_rst_s));
  end

  OBUFDS #(
    .IOSTANDARD ("LVDS_25"))
  i_dac_data_out_buf (
    .I (dac_data_out_s[l_inst]),
    .O (dac_data_out_p[l_inst]),
    .OB (dac_data_out_n[l_inst]));

  end
  endgenerate

  // dac frame output serdes & buffer
  
  generate
  if (C_ODDR_SEL == 1) begin
  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_dac_frame_out_oddr (
    .S (1'b0),
    .CE (1'b1),
    .R (serdes_clk_rst_s),
    .C (dac_clk),
    .D1 (usr_frame),
    .D2 (usr_frame),
    .Q (dac_frame_out_s));
  end else begin
  OSERDESE1 #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (6),
    .INTERFACE_TYPE ("DEFAULT"),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("MASTER"))
  i_dac_frame_out_oserdes (
    .D1 (dds_frame[0]),
    .D2 (dds_frame[1]),
    .D3 (dds_frame[2]),
    .D4 (dds_frame[3]),
    .D5 (dds_frame[4]),
    .D6 (dds_frame[5]),
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
    .OQ (dac_frame_out_s),
    .TQ (),
    .OCBEXTEND (),
    .OFB (),
    .TFB (),
    .TCE (1'b0),
    .RST (serdes_clk_rst_s));
  end
  endgenerate

  OBUFDS #(
    .IOSTANDARD ("LVDS_25"))
  i_dac_frame_out_obuf (
    .I (dac_frame_out_s),
    .O (dac_frame_out_p),
    .OB (dac_frame_out_n));

  // dac clock output serdes & buffer
  
  generate
  if (C_ODDR_SEL == 1) begin
  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_dac_clk_out_oddr (
    .S (1'b0),
    .CE (1'b1),
    .R (serdes_clk_rst_s),
    .C (dac_clk),
    .D1 (1'b1),
    .D2 (1'b0),
    .Q (dac_clk_out_s));
  end else begin
  OSERDESE1 #(
    .DATA_RATE_OQ ("DDR"),
    .DATA_RATE_TQ ("SDR"),
    .DATA_WIDTH (6),
    .INTERFACE_TYPE ("DEFAULT"),
    .TRISTATE_WIDTH (1),
    .SERDES_MODE ("MASTER"))
  i_dac_clk_out_oserdes (
    .D1 (1'b1),
    .D2 (1'b0),
    .D3 (1'b1),
    .D4 (1'b0),
    .D5 (1'b1),
    .D6 (1'b0),
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
  end
  endgenerate

  OBUFDS #(
    .IOSTANDARD ("LVDS_25"))
  i_dac_clk_out_obuf (
    .I (dac_clk_out_s),
    .O (dac_clk_out_p),
    .OB (dac_clk_out_n));

  // dac clock input buffers, an MMCM is used here, note that some DACs are sensitive
  // to it's input clocks and may not have input FIFOs to absorb clock jitters. You
  // can NOT use this clocking method on such DACs.

  IBUFGDS i_dac_clk_in_ibuf (
    .I (dac_clk_in_p),
    .IB (dac_clk_in_n),
    .O (dac_clk_in_s));

  generate
  if (C_DEVICE_SEL == C_CF_VIRTEX6) begin
  MMCM_ADV #(
    .BANDWIDTH ("OPTIMIZED"),
    .CLKOUT4_CASCADE ("FALSE"),
    .CLOCK_HOLD ("FALSE"),
    .COMPENSATION ("ZHOLD"),
    .STARTUP_WAIT ("FALSE"),
    .DIVCLK_DIVIDE (MMCM_DIVCLK_DIVIDE),
    .CLKFBOUT_MULT_F (MMCM_CLKFBOUT_MULT_F),
    .CLKFBOUT_PHASE (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT0_PHASE (0.000),
    .CLKOUT0_DUTY_CYCLE (0.500),
    .CLKOUT0_USE_FINE_PS ("FALSE"),
    .CLKOUT1_DIVIDE (MMCM_CLKOUT1_DIVIDE),
    .CLKOUT1_PHASE (0.000),
    .CLKOUT1_DUTY_CYCLE (0.500),
    .CLKOUT1_USE_FINE_PS ("FALSE"),
    .CLKIN1_PERIOD (MMCM_CLKIN1_PERIOD),
    .REF_JITTER1 (0.010))
  i_dac_clk_mmcm (
    .CLKFBOUT (dac_mmcm_fb_clk_s),
    .CLKFBOUTB (),
    .CLKOUT0 (dac_mmcm_clk_s),
    .CLKOUT0B (),
    .CLKOUT1 (dac_mmcm_div3_clk_s),
    .CLKOUT1B (),
    .CLKOUT2 (),
    .CLKOUT2B (),
    .CLKOUT3 (),
    .CLKOUT3B (),
    .CLKOUT4 (),
    .CLKOUT5 (),
    .CLKOUT6 (),
    .CLKFBIN (dac_fb_clk_s),
    .CLKIN1 (dac_clk_in_s),
    .CLKIN2 (1'b0),
    .CLKINSEL (1'b1),
    .DADDR (7'h0),
    .DCLK (1'b0),
    .DEN (1'b0),
    .DI (16'h0),
    .DO (),
    .DRDY (),
    .DWE (1'b0),
    .PSCLK (1'b0),
    .PSEN (1'b0),
    .PSINCDEC (1'b0),
    .PSDONE (),
    .LOCKED (dac_mmcm_locked_s),
    .CLKINSTOPPED (),
    .CLKFBSTOPPED (),
    .PWRDWN (1'b0),
    .RST (1'b0));
  end else begin
  MMCME2_ADV #(
    .BANDWIDTH ("OPTIMIZED"),
    .CLKOUT4_CASCADE ("FALSE"),
    .COMPENSATION ("ZHOLD"),
    .STARTUP_WAIT ("FALSE"),
    .DIVCLK_DIVIDE (MMCM_DIVCLK_DIVIDE),
    .CLKFBOUT_MULT_F (MMCM_CLKFBOUT_MULT_F),
    .CLKFBOUT_PHASE (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT0_PHASE (0.000),
    .CLKOUT0_DUTY_CYCLE (0.500),
    .CLKOUT0_USE_FINE_PS ("FALSE"),
    .CLKOUT1_DIVIDE (MMCM_CLKOUT1_DIVIDE),
    .CLKOUT1_PHASE (0.000),
    .CLKOUT1_DUTY_CYCLE (0.500),
    .CLKOUT1_USE_FINE_PS ("FALSE"),
    .CLKIN1_PERIOD (MMCM_CLKIN1_PERIOD),
    .REF_JITTER1 (0.010))
  i_dac_clk_mmcm (
    .CLKFBOUT (dac_mmcm_fb_clk_s),
    .CLKFBOUTB (),
    .CLKOUT0 (dac_mmcm_clk_s),
    .CLKOUT0B (),
    .CLKOUT1 (dac_mmcm_div3_clk_s),
    .CLKOUT1B (),
    .CLKOUT2 (),
    .CLKOUT2B (),
    .CLKOUT3 (),
    .CLKOUT3B (),
    .CLKOUT4 (),
    .CLKOUT5 (),
    .CLKOUT6 (),
    .CLKFBIN (dac_fb_clk_s),
    .CLKIN1 (dac_clk_in_s),
    .CLKIN2 (1'b0),
    .CLKINSEL (1'b1),
    .DADDR (7'h0),
    .DCLK (1'b0),
    .DEN (1'b0),
    .DI (16'h0),
    .DO (),
    .DRDY (),
    .DWE (1'b0),
    .PSCLK (1'b0),
    .PSEN (1'b0),
    .PSINCDEC (1'b0),
    .PSDONE (),
    .LOCKED (dac_mmcm_locked_s),
    .CLKINSTOPPED (),
    .CLKFBSTOPPED (),
    .PWRDWN (1'b0),
    .RST (1'b0));
  end
  endgenerate

  BUFG i_dac_clk_fb_bufg (
    .I (dac_mmcm_fb_clk_s),
    .O (dac_fb_clk_s));

  generate
  if (C_ODDR_SEL == 1) begin
  BUFG i_dac_clk_bufg (
    .I (dac_mmcm_clk_s),
    .O (dac_clk));
  assign dac_div3_clk = dac_clk;
  end else begin
  BUFG i_dac_clk_bufg (
    .I (dac_mmcm_clk_s),
    .O (dac_clk));
  BUFG i_dac_div3_clk_bufg (
    .I (dac_mmcm_div3_clk_s),
    .O (dac_div3_clk));
  end
  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
