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

`timescale 1ns/1ps

module ad_gtv6_channel_1 (

  // reset

  rst,
  pll_rst,

  // receive

  rx_ref_clk,
  rx_p,
  rx_n,
  rx_rst_done,
  rx_pll_locked,
  rx_out_clk,
  rx_usr_clk,
  rx_clk,
  rx_charisk,
  rx_disperr,
  rx_notintable,
  rx_data,
  rx_comma_align_enb,

  // transmit

  tx_ref_clk,
  tx_p,
  tx_n,
  tx_rst_done,
  tx_pll_locked,
  tx_out_clk,
  tx_usr_clk,
  tx_clk,
  tx_charisk,
  tx_data,

  // drp interface

  drp_clk,
  drp_en,
  drp_addr,
  drp_wr,
  drp_wdata,
  drp_rdata,
  drp_ready,

  // monitor signals

  mon_trigger,
  mon_data);

  // reset

  input           rst;
  input           pll_rst;

  // receive

  input           rx_ref_clk;
  input           rx_p;
  input           rx_n;
  output          rx_rst_done;
  output          rx_pll_locked;
  output          rx_out_clk;
  input           rx_usr_clk;
  input           rx_clk;
  output  [ 3:0]  rx_charisk;
  output  [ 3:0]  rx_disperr;
  output  [ 3:0]  rx_notintable;
  output  [31:0]  rx_data;
  input           rx_comma_align_enb;

  // transmit

  input           tx_ref_clk;
  output          tx_p;
  output          tx_n;
  output          tx_rst_done;
  output          tx_pll_locked;
  output          tx_out_clk;
  input           tx_usr_clk;
  input           tx_clk;
  input   [ 3:0]  tx_charisk;
  input   [31:0]  tx_data;

  // drp interface

  input           drp_clk;
  input           drp_en;
  input   [11:0]  drp_addr;
  input           drp_wr;
  input   [15:0]  drp_wdata;
  output  [15:0]  drp_rdata;
  output          drp_ready;

  // monitor signals

  output          mon_trigger;
  output  [49:0]  mon_data;

  // internal signals

  wire            rx_ilas_f_s;
  wire            rx_ilas_q_s;
  wire            rx_ilas_a_s;
  wire            rx_ilas_r_s;
  wire            rx_cgs_k_s;
  wire    [ 3:0]  rx_valid_k_s;
  wire            rx_valid_k_1_s;

  // monitor interface

  assign mon_data[31: 0] = rx_data;
  assign mon_data[35:32] = rx_notintable;
  assign mon_data[39:36] = rx_disperr;
  assign mon_data[43:40] = rx_charisk;
  assign mon_data[44:44] = rx_valid_k_1_s;
  assign mon_data[45:45] = rx_cgs_k_s;
  assign mon_data[46:46] = rx_ilas_r_s;
  assign mon_data[47:47] = rx_ilas_a_s;
  assign mon_data[48:48] = rx_ilas_q_s;
  assign mon_data[49:49] = rx_ilas_f_s;

  assign mon_trigger = rx_valid_k_1_s;

  // ilas frame characters

  assign rx_ilas_f_s = 
    (((rx_data[31:24] == 8'hfc) && (rx_valid_k_s[ 3] == 1'b1)) ||
     ((rx_data[23:16] == 8'hfc) && (rx_valid_k_s[ 2] == 1'b1)) ||
     ((rx_data[15: 8] == 8'hfc) && (rx_valid_k_s[ 1] == 1'b1)) ||
     ((rx_data[ 7: 0] == 8'hfc) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  assign rx_ilas_q_s = 
    (((rx_data[31:24] == 8'h9c) && (rx_valid_k_s[ 3] == 1'b1)) ||
     ((rx_data[23:16] == 8'h9c) && (rx_valid_k_s[ 2] == 1'b1)) ||
     ((rx_data[15: 8] == 8'h9c) && (rx_valid_k_s[ 1] == 1'b1)) ||
     ((rx_data[ 7: 0] == 8'h9c) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  assign rx_ilas_a_s = 
    (((rx_data[31:24] == 8'h7c) && (rx_valid_k_s[ 3] == 1'b1)) ||
     ((rx_data[23:16] == 8'h7c) && (rx_valid_k_s[ 2] == 1'b1)) ||
     ((rx_data[15: 8] == 8'h7c) && (rx_valid_k_s[ 1] == 1'b1)) ||
     ((rx_data[ 7: 0] == 8'h7c) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  assign rx_ilas_r_s = 
    (((rx_data[31:24] == 8'h1c) && (rx_valid_k_s[ 3] == 1'b1)) ||
     ((rx_data[23:16] == 8'h1c) && (rx_valid_k_s[ 2] == 1'b1)) ||
     ((rx_data[15: 8] == 8'h1c) && (rx_valid_k_s[ 1] == 1'b1)) ||
     ((rx_data[ 7: 0] == 8'h1c) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  assign rx_cgs_k_s = 
    (((rx_data[31:24] == 8'hbc) && (rx_valid_k_s[ 3] == 1'b1)) &&
     ((rx_data[23:16] == 8'hbc) && (rx_valid_k_s[ 2] == 1'b1)) &&
     ((rx_data[15: 8] == 8'hbc) && (rx_valid_k_s[ 1] == 1'b1)) &&
     ((rx_data[ 7: 0] == 8'hbc) && (rx_valid_k_s[ 0] == 1'b1))) ? 1'b1 : 1'b0;

  // validate all characters

  assign rx_valid_k_s = rx_charisk & (~rx_disperr) & (~rx_notintable);
  assign rx_valid_k_1_s = (rx_valid_k_s == 4'd0) ? 1'b0 : 1'b1;

  // instantiations

  GTXE1 #(
    .SIM_RECEIVER_DETECT_PASS ("TRUE"),
    .SIM_TX_ELEC_IDLE_LEVEL ("X"),
    .SIM_GTXRESET_SPEEDUP (1),
    .SIM_VERSION ("2.0"),
    .SIM_TXREFCLK_SOURCE (3'b000),
    .SIM_RXREFCLK_SOURCE (3'b000),
    .TX_CLK_SOURCE ("TXPLL"),
    .TX_OVERSAMPLE_MODE ("FALSE"),
    .TXPLL_COM_CFG (24'h21680a),
    .TXPLL_CP_CFG (8'h0D),
    .TXPLL_DIVSEL_FB (2),
    .TXPLL_DIVSEL_OUT (1),
    .TXPLL_DIVSEL_REF (1),
    .TXPLL_DIVSEL45_FB (5),
    .TXPLL_LKDET_CFG (3'b111),
    .TX_CLK25_DIVIDER (10),
    .TXPLL_SATA (2'b00),
    .TX_TDCC_CFG (2'b11),
    .PMA_CAS_CLK_EN ("FALSE"),
    .POWER_SAVE (10'b0000110000),
    .GEN_TXUSRCLK ("FALSE"),
    .TX_DATA_WIDTH (40),
    .TX_USRCLK_CFG (6'h00),
    .TXOUTCLK_CTRL ("TXOUTCLKPMA_DIV2"),
    .TXOUTCLK_DLY (10'b0000000000),
    .TX_PMADATA_OPT (1'b0),
    .PMA_TX_CFG (20'h80082),
    .TX_BUFFER_USE ("TRUE"),
    .TX_BYTECLK_CFG (6'h00),
    .TX_EN_RATE_RESET_BUF ("TRUE"),
    .TX_XCLK_SEL ("TXOUT"),
    .TX_DLYALIGN_CTRINC (4'b0100),
    .TX_DLYALIGN_LPFINC (4'b0110),
    .TX_DLYALIGN_MONSEL (3'b000),
    .TX_DLYALIGN_OVRDSETTING (8'b10000000),
    .GEARBOX_ENDEC (3'b000),
    .TXGEARBOX_USE ("FALSE"),
    .TX_DRIVE_MODE ("DIRECT"),
    .TX_IDLE_ASSERT_DELAY (3'b100),
    .TX_IDLE_DEASSERT_DELAY (3'b010),
    .TXDRIVE_LOOPBACK_HIZ ("FALSE"),
    .TXDRIVE_LOOPBACK_PD ("FALSE"),
    .COM_BURST_VAL (4'b1111),
    .TX_DEEMPH_0 (5'b11010),
    .TX_DEEMPH_1 (5'b10000),
    .TX_MARGIN_FULL_0 (7'b1001110),
    .TX_MARGIN_FULL_1 (7'b1001001),
    .TX_MARGIN_FULL_2 (7'b1000101),
    .TX_MARGIN_FULL_3 (7'b1000010),
    .TX_MARGIN_FULL_4 (7'b1000000),
    .TX_MARGIN_LOW_0 (7'b1000110),
    .TX_MARGIN_LOW_1 (7'b1000100),
    .TX_MARGIN_LOW_2 (7'b1000010),
    .TX_MARGIN_LOW_3 (7'b1000000),
    .TX_MARGIN_LOW_4 (7'b1000000),
    .RX_OVERSAMPLE_MODE ("FALSE"),
    .RXPLL_COM_CFG (24'h21680a),
    .RXPLL_CP_CFG (8'h0D),
    .RXPLL_DIVSEL_FB (2),
    .RXPLL_DIVSEL_OUT (1),
    .RXPLL_DIVSEL_REF (1),
    .RXPLL_DIVSEL45_FB (5),
    .RXPLL_LKDET_CFG (3'b111),
    .RX_CLK25_DIVIDER (10),
    .GEN_RXUSRCLK ("FALSE"),
    .RX_DATA_WIDTH (40),
    .RXRECCLK_CTRL ("RXRECCLKPMA_DIV2"),
    .RXRECCLK_DLY (10'b0000000000),
    .RXUSRCLK_DLY (16'h0000),
    .AC_CAP_DIS ("TRUE"),
    .CDR_PH_ADJ_TIME (5'b10100),
    .OOBDETECT_THRESHOLD (3'b011),
    .PMA_CDR_SCAN (27'h640404C),
    .PMA_RX_CFG (25'h05ce008),
    .RCV_TERM_GND ("FALSE"),
    .RCV_TERM_VTTRX ("FALSE"),
    .RX_EN_IDLE_HOLD_CDR ("FALSE"),
    .RX_EN_IDLE_RESET_FR ("TRUE"),
    .RX_EN_IDLE_RESET_PH ("TRUE"),
    .TX_DETECT_RX_CFG (14'h1832),
    .TERMINATION_CTRL (5'b00000),
    .TERMINATION_OVRD ("FALSE"),
    .CM_TRIM (2'b01),
    .PMA_RXSYNC_CFG (7'h00),
    .PMA_CFG (76'h0040000040000000003),
    .BGTEST_CFG (2'b00),
    .BIAS_CFG (17'h00000),
    .DFE_CAL_TIME (5'b01100),
    .DFE_CFG (8'b00011011),
    .RX_EN_IDLE_HOLD_DFE ("TRUE"),
    .RX_EYE_OFFSET (8'h4C),
    .RX_EYE_SCANMODE (2'b00),
    .RXPRBSERR_LOOPBACK (1'b0),
    .ALIGN_COMMA_WORD (1),
    .COMMA_10B_ENABLE (10'b0001111111),
    .COMMA_DOUBLE ("FALSE"),
    .DEC_MCOMMA_DETECT ("TRUE"),
    .DEC_PCOMMA_DETECT ("TRUE"),
    .DEC_VALID_COMMA_ONLY ("TRUE"),
    .MCOMMA_10B_VALUE (10'b1010000011),
    .MCOMMA_DETECT ("TRUE"),
    .PCOMMA_10B_VALUE (10'b0101111100),
    .PCOMMA_DETECT ("TRUE"),
    .RX_DECODE_SEQ_MATCH ("TRUE"),
    .RX_SLIDE_AUTO_WAIT (5),
    .RX_SLIDE_MODE ("OFF"),
    .SHOW_REALIGN_COMMA ("TRUE"),
    .RX_LOS_INVALID_INCR (1),
    .RX_LOS_THRESHOLD (4),
    .RX_LOSS_OF_SYNC_FSM ("TRUE"),
    .RXGEARBOX_USE ("FALSE"),
    .RX_BUFFER_USE ("TRUE"),
    .RX_EN_IDLE_RESET_BUF ("TRUE"),
    .RX_EN_MODE_RESET_BUF ("TRUE"),
    .RX_EN_RATE_RESET_BUF ("TRUE"),
    .RX_EN_REALIGN_RESET_BUF ("FALSE"),
    .RX_EN_REALIGN_RESET_BUF2 ("FALSE"),
    .RX_FIFO_ADDR_MODE ("FULL"),
    .RX_IDLE_HI_CNT (4'b1000),
    .RX_IDLE_LO_CNT (4'b0000),
    .RX_XCLK_SEL ("RXREC"),
    .RX_DLYALIGN_CTRINC (4'b1110),
    .RX_DLYALIGN_EDGESET (5'b00010),
    .RX_DLYALIGN_LPFINC (4'b1110),
    .RX_DLYALIGN_MONSEL (3'b000),
    .RX_DLYALIGN_OVRDSETTING (8'b10000000),
    .CLK_COR_ADJ_LEN (1),
    .CLK_COR_DET_LEN (1),
    .CLK_COR_INSERT_IDLE_FLAG ("FALSE"),
    .CLK_COR_KEEP_IDLE ("FALSE"),
    .CLK_COR_MAX_LAT (20),
    .CLK_COR_MIN_LAT (18),
    .CLK_COR_PRECEDENCE ("TRUE"),
    .CLK_COR_REPEAT_WAIT (0),
    .CLK_COR_SEQ_1_1 (10'b0100000000),
    .CLK_COR_SEQ_1_2 (10'b0100000000),
    .CLK_COR_SEQ_1_3 (10'b0100000000),
    .CLK_COR_SEQ_1_4 (10'b0100000000),
    .CLK_COR_SEQ_1_ENABLE (4'b1111),
    .CLK_COR_SEQ_2_1 (10'b0100000000),
    .CLK_COR_SEQ_2_2 (10'b0100000000),
    .CLK_COR_SEQ_2_3 (10'b0100000000),
    .CLK_COR_SEQ_2_4 (10'b0100000000),
    .CLK_COR_SEQ_2_ENABLE (4'b1111),
    .CLK_COR_SEQ_2_USE ("FALSE"),
    .CLK_CORRECT_USE ("FALSE"),
    .CHAN_BOND_1_MAX_SKEW (7),
    .CHAN_BOND_2_MAX_SKEW (1),
    .CHAN_BOND_KEEP_ALIGN ("FALSE"),
    .CHAN_BOND_SEQ_1_1 (10'b0101111100),
    .CHAN_BOND_SEQ_1_2 (10'b0000000000),
    .CHAN_BOND_SEQ_1_3 (10'b0000000000),
    .CHAN_BOND_SEQ_1_4 (10'b0000000000),
    .CHAN_BOND_SEQ_1_ENABLE (4'b1111),
    .CHAN_BOND_SEQ_2_1 (10'b0000000000),
    .CHAN_BOND_SEQ_2_2 (10'b0000000000),
    .CHAN_BOND_SEQ_2_3 (10'b0000000000),
    .CHAN_BOND_SEQ_2_4 (10'b0000000000),
    .CHAN_BOND_SEQ_2_CFG (5'b00000),
    .CHAN_BOND_SEQ_2_ENABLE (4'b1111),
    .CHAN_BOND_SEQ_2_USE ("FALSE"),
    .CHAN_BOND_SEQ_LEN (1),
    .PCI_EXPRESS_MODE ("FALSE"),
    .SAS_MAX_COMSAS (52),
    .SAS_MIN_COMSAS (40),
    .SATA_BURST_VAL (3'b100),
    .SATA_IDLE_VAL (3'b100),
    .SATA_MAX_BURST (7),
    .SATA_MAX_INIT (22),
    .SATA_MAX_WAKE (7),
    .SATA_MIN_BURST (4),
    .SATA_MIN_INIT (12),
    .SATA_MIN_WAKE (4),
    .TRANS_TIME_FROM_P2 (12'h03c),
    .TRANS_TIME_NON_P2 (8'h19),
    .TRANS_TIME_RATE (8'hff),
    .TRANS_TIME_TO_P2 (10'h064)) 
  i_gtxe1_channel (
    .LOOPBACK (3'd0),
    .RXPOWERDOWN (2'd0),
    .TXPOWERDOWN (2'd0),
    .RXDATAVALID (),
    .RXGEARBOXSLIP (1'd0),
    .RXHEADER (),
    .RXHEADERVALID (),
    .RXSTARTOFSEQ (),
    .RXCHARISCOMMA (),
    .RXCHARISK (rx_charisk),
    .RXDEC8B10BUSE (1'd1),
    .RXDISPERR (rx_disperr),
    .RXNOTINTABLE (rx_notintable),
    .RXRUNDISP (),
    .USRCODEERR (1'd0),
    .RXCHANBONDSEQ (),
    .RXCHBONDI (4'd0),
    .RXCHBONDLEVEL (3'd0),
    .RXCHBONDMASTER (1'd1),
    .RXCHBONDO (),
    .RXCHBONDSLAVE (1'd0),
    .RXENCHANSYNC (1'd0),
    .RXCLKCORCNT (),
    .RXBYTEISALIGNED (),
    .RXBYTEREALIGN (),
    .RXCOMMADET (),
    .RXCOMMADETUSE (1'd1),
    .RXENMCOMMAALIGN (rx_comma_align_enb),
    .RXENPCOMMAALIGN (rx_comma_align_enb),
    .RXSLIDE (1'd0),
    .PRBSCNTRESET (1'd0),
    .RXENPRBSTST (3'd0),
    .RXPRBSERR (),
    .RXDATA (rx_data),
    .RXRECCLK (rx_out_clk),
    .RXRECCLKPCS (),
    .RXRESET (rst),
    .RXUSRCLK (rx_usr_clk),
    .RXUSRCLK2 (rx_clk),
    .DFECLKDLYADJ (6'd0),
    .DFECLKDLYADJMON (),
    .DFEDLYOVRD (1'd0),
    .DFEEYEDACMON (),
    .DFESENSCAL (),
    .DFETAP1 (5'd0),
    .DFETAP1MONITOR (),
    .DFETAP2 (5'd0),
    .DFETAP2MONITOR (),
    .DFETAP3 (4'd0),
    .DFETAP3MONITOR (),
    .DFETAP4 (4'd0),
    .DFETAP4MONITOR (),
    .DFETAPOVRD (1'd1),
    .GATERXELECIDLE (1'd1),
    .IGNORESIGDET (1'd1),
    .RXCDRRESET (1'd0),
    .RXELECIDLE (),
    .RXEQMIX (10'd0),
    .RXN (rx_n),
    .RXP (rx_p),
    .RXBUFRESET (1'd0),
    .RXBUFSTATUS (),
    .RXCHANISALIGNED (),
    .RXCHANREALIGN (),
    .RXDLYALIGNDISABLE (1'd0),
    .RXDLYALIGNMONENB (1'd0),
    .RXDLYALIGNMONITOR (),
    .RXDLYALIGNOVERRIDE (1'd1),
    .RXDLYALIGNRESET (1'd0),
    .RXDLYALIGNSWPPRECURB (1'd1),
    .RXDLYALIGNUPDSW (1'd0),
    .RXENPMAPHASEALIGN (1'd0),
    .RXPMASETPHASE (1'd0),
    .RXSTATUS (),
    .RXLOSSOFSYNC (),
    .RXENSAMPLEALIGN (1'd0),
    .RXOVERSAMPLEERR (),
    .GREFCLKRX (1'd0),
    .GTXRXRESET (1'd0),
    .MGTREFCLKRX ({1'd0, rx_ref_clk}),
    .NORTHREFCLKRX (2'd0),
    .PERFCLKRX (1'd0),
    .PLLRXRESET (pll_rst),
    .RXPLLLKDET (rx_pll_locked),
    .RXPLLLKDETEN (1'd1),
    .RXPLLPOWERDOWN (1'd0),
    .RXPLLREFSELDY (3'd0),
    .RXRATE (2'd0),
    .RXRATEDONE (),
    .RXRESETDONE (rx_rst_done),
    .SOUTHREFCLKRX (2'd0),
    .PHYSTATUS (),
    .RXVALID (),
    .RXPOLARITY (1'd0),
    .COMINITDET (),
    .COMSASDET (),
    .COMWAKEDET (),
    .DADDR (drp_addr[7:0]),
    .DCLK (drp_clk),
    .DEN (drp_en),
    .DI (drp_wdata),
    .DRDY (drp_ready),
    .DRPDO (drp_rdata),
    .DWE (drp_wr),
    .TXGEARBOXREADY (),
    .TXHEADER (3'd0),
    .TXSEQUENCE (7'd0),
    .TXSTARTSEQ (1'd0),
    .TXBYPASS8B10B (4'd0),
    .TXCHARDISPMODE (4'd0),
    .TXCHARDISPVAL (4'd0),
    .TXCHARISK (tx_charisk),
    .TXENC8B10BUSE (1'd1),
    .TXKERR (),
    .TXRUNDISP (),
    .GTXTEST (13'b1000000000000),
    .MGTREFCLKFAB (),
    .TSTCLK0 (1'd0),
    .TSTCLK1 (1'd0),
    .TSTIN (20'b11111111111111111111),
    .TSTOUT (),
    .TXDATA (tx_data),
    .TXOUTCLK (tx_out_clk),
    .TXOUTCLKPCS (),
    .TXRESET (rst),
    .TXUSRCLK (tx_usr_clk),
    .TXUSRCLK2 (tx_clk),
    .TXBUFDIFFCTRL (3'b100),
    .TXDIFFCTRL (4'b1010),
    .TXINHIBIT (1'd0),
    .TXN (tx_n),
    .TXP (tx_p),
    .TXPOSTEMPHASIS (5'd0),
    .TXPREEMPHASIS (4'd0),
    .TXBUFSTATUS (),
    .TXDLYALIGNDISABLE (1'd1),
    .TXDLYALIGNMONENB (1'd0),
    .TXDLYALIGNMONITOR (),
    .TXDLYALIGNOVERRIDE (1'd0),
    .TXDLYALIGNRESET (1'd0),
    .TXDLYALIGNUPDSW (1'd1),
    .TXENPMAPHASEALIGN (1'd0),
    .TXPMASETPHASE (1'd0),
    .GREFCLKTX (1'd0),
    .GTXTXRESET (1'd0),
    .MGTREFCLKTX ({1'd0, tx_ref_clk}),
    .NORTHREFCLKTX (2'd0),
    .PERFCLKTX (1'd0),
    .PLLTXRESET (pll_rst),
    .SOUTHREFCLKTX (2'd0),
    .TXPLLLKDET (tx_pll_locked),
    .TXPLLLKDETEN (1'd1),
    .TXPLLPOWERDOWN (1'd0),
    .TXPLLREFSELDY (3'd0),
    .TXRATE (2'd0),
    .TXRATEDONE (),
    .TXRESETDONE (tx_rst_done),
    .TXENPRBSTST (3'd0),
    .TXPRBSFORCEERR (1'd0),
    .TXPOLARITY (1'd0),
    .TXDEEMPH (1'd0),
    .TXDETECTRX (1'd0),
    .TXELECIDLE (1'd0),
    .TXMARGIN (3'd0),
    .TXPDOWNASYNCH (1'd0),
    .TXSWING (1'd0),
    .COMFINISH (),
    .TXCOMINIT (1'd0),
    .TXCOMSAS (1'd0),
    .TXCOMWAKE (1'd0));

endmodule

// ***************************************************************************
// ***************************************************************************
 
