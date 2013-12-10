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

module cf_spi (

  spi_cs0n,
  spi_cs1n,
  spi_clk,
  spi_sd_en,
  spi_sd_o,
  spi_sd_i,

  up_rstn,
  up_clk,
  up_spi_start,
  up_spi_devsel,
  up_spi_wdata,
  up_spi_rdata,
  up_spi_status,

  debug_data,
  debug_trigger);

  output          spi_cs0n;
  output          spi_cs1n;
  output          spi_clk;
  output          spi_sd_en;
  output          spi_sd_o;
  input           spi_sd_i;

  input           up_rstn;
  input           up_clk;
  input           up_spi_start;
  input           up_spi_devsel;
  input   [23:0]  up_spi_wdata;
  output  [ 7:0]  up_spi_rdata;
  output          up_spi_status;

  output  [63:0]  debug_data;
  output  [ 7:0]  debug_trigger;

  reg             spi_cs0n;
  reg             spi_cs1n;
  reg             spi_clk;
  reg             spi_sd_en;
  reg             spi_sd_o;
  reg             spi_count_5_d;
  reg     [ 2:0]  spi_clk_count;
  reg     [ 5:0]  spi_count;
  reg             spi_rwn;
  reg     [23:0]  spi_data_out;
  reg     [ 7:0]  spi_data_in;
  reg             up_spi_start_d;
  reg             up_spi_status;
  reg     [ 7:0]  up_spi_rdata;

  wire            spi_cs_en_s;

  assign debug_trigger[7] = spi_cs0n;
  assign debug_trigger[6] = spi_cs1n;
  assign debug_trigger[5] = spi_sd_en;
  assign debug_trigger[4] = spi_count[5];
  assign debug_trigger[3] = up_spi_devsel;
  assign debug_trigger[2] = up_spi_start;
  assign debug_trigger[1] = up_spi_start_d;
  assign debug_trigger[0] = up_spi_status;

  assign debug_data[63:62] = 'd0;
  assign debug_data[61:61] = spi_cs_en_s;
  assign debug_data[60:60] = up_spi_start_d;
  assign debug_data[59:52] = up_spi_rdata;
  assign debug_data[51:44] = spi_data_in;
  assign debug_data[43:20] = spi_data_out;
  assign debug_data[19:19] = spi_rwn;
  assign debug_data[18:18] = spi_count_5_d;
  assign debug_data[17:12] = spi_count;
  assign debug_data[11: 9] = spi_clk_count;
  assign debug_data[ 8: 8] = up_spi_status;
  assign debug_data[ 7: 7] = up_spi_devsel;
  assign debug_data[ 6: 6] = up_spi_start;
  assign debug_data[ 5: 5] = spi_sd_i;
  assign debug_data[ 4: 4] = spi_sd_o;
  assign debug_data[ 3: 3] = spi_sd_en;
  assign debug_data[ 2: 2] = spi_clk;
  assign debug_data[ 1: 1] = spi_cs1n;
  assign debug_data[ 0: 0] = spi_cs0n;

  assign spi_cs_en_s = spi_count_5_d | spi_count[5];

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      spi_cs0n <= 'd1;
      spi_cs1n <= 'd1;
      spi_clk <= 'd0;
      spi_sd_en <= 'd0;
      spi_sd_o <= 'd0;
      spi_count_5_d <= 'd0;
      spi_clk_count <= 'd0;
      spi_count <= 'd0;
      spi_rwn <= 'd0;
      spi_data_out <= 'd0;
      spi_data_in <= 'd0;
      up_spi_start_d <= 'd0;
      up_spi_status <= 'd0;
      up_spi_rdata <= 'd0;
    end else begin
      spi_cs0n <= up_spi_devsel | (~spi_cs_en_s);
      spi_cs1n <= (~up_spi_devsel) | (~spi_cs_en_s);
      spi_clk <= spi_clk_count[2] & spi_count[5];
      spi_sd_en <= (spi_count[5:3] == 3'b111) ? spi_rwn : 1'b0;
      spi_sd_o <= spi_data_out[23];
      if (spi_clk_count == 3'b100) begin
        spi_count_5_d <= spi_count[5];
      end
      spi_clk_count <= spi_clk_count + 1'b1;
      if (spi_count[5] == 1'b1) begin
        if (spi_clk_count == 3'b111) begin
          spi_count <= spi_count + 1'b1;
        end
        spi_rwn <= spi_rwn;
        if (spi_clk_count == 3'b111) begin
          spi_data_out <= {spi_data_out[22:0], 1'b0};
        end
        if ((spi_clk_count == 3'b100) && (spi_rwn == 1'b1) && (spi_count[5:3] == 3'b111)) begin
          spi_data_in <= {spi_data_in[6:0], spi_sd_i};
        end
      end else if ((spi_clk_count == 3'b111) && (up_spi_start == 1'b1) &&
        (up_spi_start_d == 1'b0)) begin
        spi_count <= 6'h28;
        spi_rwn <= up_spi_wdata[23];
        spi_data_out <= up_spi_wdata;
        spi_data_in <= 8'd0;
      end
      if (spi_clk_count == 3'b111) begin
        up_spi_start_d <= up_spi_start;
      end
      up_spi_status <= ~(spi_count[5] | (up_spi_start & ~up_spi_start_d));
      up_spi_rdata <= spi_data_in;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
