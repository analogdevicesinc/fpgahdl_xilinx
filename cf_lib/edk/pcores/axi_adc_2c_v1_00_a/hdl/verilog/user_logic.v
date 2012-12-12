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

module user_logic (

  pid,

  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_data_or_p,
  adc_data_or_n,

  spi_cs0n,
  spi_cs1n,
  spi_clk,
  spi_sd_o,
  spi_sd_i,

  dma_clk,
  dma_valid,
  dma_data,
  dma_be,
  dma_last,
  dma_ready,

  delay_clk,

  up_status,

  up_adc_capture_int,
  up_adc_capture_ext,

  dma_dbg_data,
  dma_dbg_trigger,

  adc_clk,
  adc_dbg_data,
  adc_dbg_trigger,

  adc_mon_valid,
  adc_mon_data,

  Bus2IP_Clk,
  Bus2IP_Resetn,
  Bus2IP_Data,
  Bus2IP_BE,
  Bus2IP_RdCE,
  Bus2IP_WrCE,
  IP2Bus_Data,
  IP2Bus_RdAck,
  IP2Bus_WrAck,
  IP2Bus_Error);

  parameter C_NUM_REG = 32;
  parameter C_SLV_DWIDTH = 32;
  parameter C_CF_BUFTYPE = 0;
  parameter C_IODELAY_GROUP = "adc_if_delay_group";

  input   [ 7:0]  pid;

  input           adc_clk_in_p;
  input           adc_clk_in_n;
  input   [13:0]  adc_data_in_p;
  input   [13:0]  adc_data_in_n;
  input           adc_data_or_p;
  input           adc_data_or_n;

  output          spi_cs0n;
  output          spi_cs1n;
  output          spi_clk;
  output          spi_sd_o;
  input           spi_sd_i;

  input           dma_clk;
  output          dma_valid;
  output  [63:0]  dma_data;
  output  [ 7:0]  dma_be;
  output          dma_last;
  input           dma_ready;

  input           delay_clk;

  output  [ 7:0]  up_status;

  output          up_adc_capture_int;
  input           up_adc_capture_ext;

  output  [63:0]  dma_dbg_data;
  output  [ 7:0]  dma_dbg_trigger;

  output          adc_clk;
  output  [63:0]  adc_dbg_data;
  output  [ 7:0]  adc_dbg_trigger;

  output          adc_mon_valid;
  output  [31:0]  adc_mon_data;

  input           Bus2IP_Clk;
  input           Bus2IP_Resetn;
  input   [31:0]  Bus2IP_Data;
  input   [ 3:0]  Bus2IP_BE;
  input   [31:0]  Bus2IP_RdCE;
  input   [31:0]  Bus2IP_WrCE;
  output  [31:0]  IP2Bus_Data;
  output          IP2Bus_RdAck;
  output          IP2Bus_WrAck;
  output          IP2Bus_Error;

  reg             up_sel = 'd0;
  reg             up_rwn = 'd0;
  reg     [ 4:0]  up_addr = 'd0;
  reg     [31:0]  up_wdata = 'd0;
  reg             IP2Bus_RdAck = 'd0;
  reg             IP2Bus_WrAck = 'd0;
  reg     [31:0]  IP2Bus_Data = 'd0;
  reg             IP2Bus_Error = 'd0;

  wire    [31:0]  up_rwce_s;
  wire    [31:0]  up_rdata_s;
  wire            up_ack_s;

  assign up_rwce_s = (Bus2IP_RdCE == 0) ? Bus2IP_WrCE : Bus2IP_RdCE;

  always @(negedge Bus2IP_Resetn or posedge Bus2IP_Clk) begin
    if (Bus2IP_Resetn == 0) begin
      up_sel <= 'd0;
      up_rwn <= 'd0;
      up_addr <= 'd0;
      up_wdata <= 'd0;
    end else begin
      up_sel <= (up_rwce_s == 0) ? 1'b0 : 1'b1;
      up_rwn <= (Bus2IP_RdCE == 0) ? 1'b0 : 1'b1;
      case (up_rwce_s)
        32'h80000000: up_addr <= 5'h00;
        32'h40000000: up_addr <= 5'h01;
        32'h20000000: up_addr <= 5'h02;
        32'h10000000: up_addr <= 5'h03;
        32'h08000000: up_addr <= 5'h04;
        32'h04000000: up_addr <= 5'h05;
        32'h02000000: up_addr <= 5'h06;
        32'h01000000: up_addr <= 5'h07;
        32'h00800000: up_addr <= 5'h08;
        32'h00400000: up_addr <= 5'h09;
        32'h00200000: up_addr <= 5'h0a;
        32'h00100000: up_addr <= 5'h0b;
        32'h00080000: up_addr <= 5'h0c;
        32'h00040000: up_addr <= 5'h0d;
        32'h00020000: up_addr <= 5'h0e;
        32'h00010000: up_addr <= 5'h0f;
        32'h00008000: up_addr <= 5'h10;
        32'h00004000: up_addr <= 5'h11;
        32'h00002000: up_addr <= 5'h12;
        32'h00001000: up_addr <= 5'h13;
        32'h00000800: up_addr <= 5'h14;
        32'h00000400: up_addr <= 5'h15;
        32'h00000200: up_addr <= 5'h16;
        32'h00000100: up_addr <= 5'h17;
        32'h00000080: up_addr <= 5'h18;
        32'h00000040: up_addr <= 5'h19;
        32'h00000020: up_addr <= 5'h1a;
        32'h00000010: up_addr <= 5'h1b;
        32'h00000008: up_addr <= 5'h1c;
        32'h00000004: up_addr <= 5'h1d;
        32'h00000002: up_addr <= 5'h1e;
        32'h00000001: up_addr <= 5'h1f;
        default: up_addr <= 5'h1f;
      endcase
      up_wdata <= Bus2IP_Data;
    end
  end

  always @(negedge Bus2IP_Resetn or posedge Bus2IP_Clk) begin
    if (Bus2IP_Resetn == 0) begin
      IP2Bus_RdAck <= 'd0;
      IP2Bus_WrAck <= 'd0;
      IP2Bus_Data <= 'd0;
      IP2Bus_Error <= 'd0;
    end else begin
      IP2Bus_RdAck <= (Bus2IP_RdCE == 0) ? 1'b0 : up_ack_s;
      IP2Bus_WrAck <= (Bus2IP_WrCE == 0) ? 1'b0 : up_ack_s;
      IP2Bus_Data <= up_rdata_s;
      IP2Bus_Error <= 'd0;
    end
  end

  assign spi_cs0n = 1'b1;
  assign spi_cs1n = 1'b1;
  assign spi_clk = 1'b0;
  assign spi_sd_o = 1'b0;

  cf_adc_2c #(.C_CF_BUFTYPE(C_CF_BUFTYPE), .C_IODELAY_GROUP(C_IODELAY_GROUP)) i_adc_2c (
    .pid (pid),
    .adc_clk_in_p (adc_clk_in_p),
    .adc_clk_in_n (adc_clk_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_data_in_n (adc_data_in_n),
    .adc_data_or_p (adc_data_or_p),
    .adc_data_or_n (adc_data_or_n),
    .dma_clk (dma_clk),
    .dma_valid (dma_valid),
    .dma_data (dma_data),
    .dma_be (dma_be),
    .dma_last (dma_last),
    .dma_ready (dma_ready),
    .up_rstn (Bus2IP_Resetn),
    .up_clk (Bus2IP_Clk),
    .up_sel (up_sel),
    .up_rwn (up_rwn),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata_s),
    .up_ack (up_ack_s),
    .up_status (up_status),
    .up_adc_capture_int (up_adc_capture_int),
    .up_adc_capture_ext (up_adc_capture_ext),
    .delay_clk (delay_clk),
    .dma_dbg_data (dma_dbg_data),
    .dma_dbg_trigger (dma_dbg_trigger),
    .adc_clk (adc_clk),
    .adc_dbg_data (adc_dbg_data),
    .adc_dbg_trigger (adc_dbg_trigger),
    .adc_mon_valid (adc_mon_valid),
    .adc_mon_data (adc_mon_data));

endmodule

// ***************************************************************************
// ***************************************************************************
