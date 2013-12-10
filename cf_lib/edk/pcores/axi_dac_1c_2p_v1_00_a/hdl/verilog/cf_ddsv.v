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

  // vdma interface

  vdma_clk,
  vdma_valid,
  vdma_data,
  vdma_ready,
  vdma_ovf,
  vdma_unf,

  // dac interface

  dac_div3_clk,
  dds_enable,
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

  up_intp_enable,
  up_intp_scale_a,
  up_intp_scale_b,

  // debug signals (dma)

  vdma_dbg_data,
  vdma_dbg_trigger,

  // debug signals (dac)

  dac_dbg_data,
  dac_dbg_trigger);

  // vdma interface

  input           vdma_clk;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;
  output          vdma_ovf;
  output          vdma_unf;

  // dac interface

  input           dac_div3_clk;
  input           dds_enable;
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

  // processor signals

  input           up_intp_enable;
  input   [15:0]  up_intp_scale_a;
  input   [15:0]  up_intp_scale_b;

  // debug signals (dma)

  output  [198:0] vdma_dbg_data;
  output  [ 7:0]  vdma_dbg_trigger;

  // debug signals (dac)

  output  [292:0] dac_dbg_data;
  output  [ 7:0]  dac_dbg_trigger;

  wire            dds_rd_s;
  wire    [95:0]  dds_rdata_s;

  // interpolator

  cf_ddsv_intp i_ddsv_intp (
    .dac_div3_clk (dac_div3_clk),
    .dds_rd (dds_rd_s),
    .dds_rdata (dds_rdata_s),
    .dds_data_00 (dds_data_00),
    .dds_data_01 (dds_data_01),
    .dds_data_02 (dds_data_02),
    .dds_data_03 (dds_data_03),
    .dds_data_04 (dds_data_04),
    .dds_data_05 (dds_data_05),
    .dds_data_06 (dds_data_06),
    .dds_data_07 (dds_data_07),
    .dds_data_08 (dds_data_08),
    .dds_data_09 (dds_data_09),
    .dds_data_10 (dds_data_10),
    .dds_data_11 (dds_data_11),
    .up_intp_enable (up_intp_enable),
    .up_intp_scale_a (up_intp_scale_a),
    .up_intp_scale_b (up_intp_scale_b),
    .dac_dbg_data (dac_dbg_data),
    .dac_dbg_trigger (dac_dbg_trigger));

  // vdma read interface

  cf_ddsv_vdma i_ddsv_vdma (
    .vdma_clk (vdma_clk),
    .vdma_valid (vdma_valid),
    .vdma_data (vdma_data),
    .vdma_ready (vdma_ready),
    .vdma_ovf (vdma_ovf),
    .vdma_unf (vdma_unf),
    .dac_div3_clk (dac_div3_clk),
    .dds_enable (dds_enable),
    .dds_rd (dds_rd_s),
    .dds_rdata (dds_rdata_s),
    .vdma_dbg_data (vdma_dbg_data),
    .vdma_dbg_trigger (vdma_dbg_trigger),
    .dac_dbg_data (),
    .dac_dbg_trigger ());

endmodule

// ***************************************************************************
// ***************************************************************************
