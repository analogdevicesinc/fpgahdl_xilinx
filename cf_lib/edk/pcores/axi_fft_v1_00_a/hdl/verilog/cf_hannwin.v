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

module cf_hannwin (

  clk,
  adc_valid,
  adc_data,
  adc_last,
  adc_ready,

  hwin_valid,
  hwin_data,
  hwin_last,
  hwin_ready,

  up_hwin_incr,
  up_hwin_enb);

  input           clk;

  input           adc_valid;
  input   [15:0]  adc_data;
  input           adc_last;
  output          adc_ready;

  output          hwin_valid;
  output  [15:0]  hwin_data;
  output          hwin_last;
  input           hwin_ready;

  input   [15:0]  up_hwin_incr;
  input           up_hwin_enb;

  reg             hwin_enable_m1 = 'd0;
  reg             hwin_enable_m2 = 'd0;
  reg             hwin_enable_m3 = 'd0;
  reg             hwin_enable = 'd0;
  reg     [15:0]  hwin_incr = 'd0;
  reg     [15:0]  hwin_angle = 'd0;
  reg             hwin_valid_s1 = 'd0;
  reg             hwin_last_s1 = 'd0;
  reg             hwin_data_sign_s1 = 'd0;
  reg     [15:0]  hwin_data_s1 = 'd0;
  reg             hwin_cos_sign_s1 = 'd0;
  reg     [15:0]  hwin_cos_data_s1_sub = 'd0;
  reg     [15:0]  hwin_cos_data_s1_add = 'd0;
  reg             hwin_valid_s2 = 'd0;
  reg             hwin_last_s2 = 'd0;
  reg             hwin_data_sign_s2 = 'd0;
  reg     [14:0]  hwin_data_s2 = 'd0;
  reg     [14:0]  hwin_cos_data_s2 = 'd0;
  reg             hwin_valid_s3 = 'd0;
  reg             hwin_last_s3 = 'd0;
  reg     [15:0]  hwin_data_s3 = 'd0;
  reg             mwr = 'd0;
  reg     [16:0]  mwdata = 'd0;
  reg     [ 5:0]  mwaddr = 'd0;
  reg     [ 5:0]  maddrdiff = 'd0;
  reg             adc_ready = 'd0;
  reg     [ 5:0]  mraddr = 'd0;
  reg             mrd = 'd0;
  reg             mrvalid = 'd0;
  reg     [16:0]  mrdata = 'd0;
  reg     [ 1:0]  mwcnt = 'd0;
  reg             mvalid_0 = 'd0;
  reg     [16:0]  mdata_0 = 'd0;
  reg             mvalid_1 = 'd0;
  reg     [16:0]  mdata_1 = 'd0;
  reg             mvalid_2 = 'd0;
  reg     [16:0]  mdata_2 = 'd0;
  reg             mvalid_3 = 'd0;
  reg     [16:0]  mdata_3 = 'd0;
  reg     [ 1:0]  mrcnt = 'd0;
  reg             hwin_valid = 'd0;
  reg     [15:0]  hwin_data = 'd0;
  reg             hwin_last = 'd0;

  wire    [15:0]  hwin_cos_s1_s;
  wire            hwin_valid_s1_s;
  wire            hwin_last_s1_s;
  wire    [15:0]  hwin_data_s1_s;
  wire    [31:0]  hwin_data_s3_s;
  wire            hwin_sign_s3_s;
  wire            hwin_valid_s3_s;
  wire            hwin_last_s3_s;
  wire            mrd_s;
  wire    [ 6:0]  maddrdiff_s;
  wire            mxfer_s;
  wire    [16:0]  mrdata_s;

  always @(posedge clk) begin
    hwin_enable_m1 <= up_hwin_enb;
    hwin_enable_m2 <= hwin_enable_m1;
    hwin_enable_m3 <= hwin_enable_m2;
    hwin_enable <= hwin_enable_m3;
    if ((hwin_enable_m2 == 1'b1) && (hwin_enable_m3 == 1'b0)) begin
      hwin_incr <= up_hwin_incr;
    end
    if (adc_valid == 1'b1) begin
      hwin_angle <= hwin_angle + hwin_incr;
    end else if (hwin_enable == 1'b0) begin
      hwin_angle <= 16'h4000;
    end
  end

  cf_sine #(.DELAY_DATA_WIDTH(18)) i_cos (
    .clk (clk),
    .angle (hwin_angle),
    .sine (hwin_cos_s1_s),
    .ddata_in ({adc_valid, adc_last, adc_data}),
    .ddata_out ({hwin_valid_s1_s, hwin_last_s1_s, hwin_data_s1_s}));

  always @(posedge clk) begin
    hwin_valid_s1 <= hwin_valid_s1_s;
    hwin_last_s1 <= hwin_last_s1_s;
    hwin_data_sign_s1 <= hwin_data_s1_s[15];
    if (hwin_data_s1_s[15] == 1'b1) begin
      hwin_data_s1 <= ~hwin_data_s1_s + 1'b1;
    end else begin
      hwin_data_s1 <= hwin_data_s1_s;
    end
    hwin_cos_sign_s1 <= hwin_cos_s1_s[15];
    hwin_cos_data_s1_sub <= 16'h7fff - hwin_cos_s1_s[14:0];
    hwin_cos_data_s1_add <= 16'h7fff + hwin_cos_s1_s[14:0];
    hwin_valid_s2 <= hwin_valid_s1;
    hwin_last_s2 <= hwin_last_s1;
    hwin_data_sign_s2 <= hwin_data_sign_s1;
    hwin_data_s2 <= hwin_data_s1[14:0];
    if (hwin_cos_sign_s1 == 1'b1) begin
      hwin_cos_data_s2 <= hwin_cos_data_s1_add[15:1];
    end else begin
      hwin_cos_data_s2 <= hwin_cos_data_s1_sub[15:1];
    end
  end

  cf_mul #(.DELAY_DATA_WIDTH(3)) i_mul (
    .clk (clk),
    .data_a ({1'b0, hwin_data_s2}),
    .data_b ({1'b0, hwin_cos_data_s2}),
    .data_p (hwin_data_s3_s),
    .ddata_in ({hwin_data_sign_s2, hwin_valid_s2, hwin_last_s2}),
    .ddata_out ({hwin_sign_s3_s, hwin_valid_s3_s, hwin_last_s3_s}));

  always @(posedge clk) begin
    hwin_valid_s3 <= hwin_valid_s3_s;
    hwin_last_s3 <= hwin_last_s3_s;
    if (hwin_sign_s3_s == 1'b1) begin
      hwin_data_s3 <= ~hwin_data_s3_s[30:15] + 1'b1;
    end else begin
      hwin_data_s3 <= hwin_data_s3_s[30:15];
    end
  end

  always @(posedge clk) begin
    if (hwin_enable == 1'b1) begin
      mwr <= hwin_valid_s3;
      mwdata <= {hwin_last_s3, hwin_data_s3};
    end else begin
      mwr <= adc_valid;
      mwdata <= {adc_last, adc_data};
    end
    if (mwr == 1'b1) begin
      mwaddr <= mwaddr + 1'b1;
    end
  end

  cf_mem #(.AW(6), .DW(17)) i_mem (
    .clka (clk),
    .wea (mwr),
    .addra (mwaddr),
    .dina (mwdata),
    .clkb (clk),
    .addrb (mraddr),
    .doutb (mrdata_s));

  assign mrd_s = (mwaddr == mraddr) ? 1'b0 : hwin_ready;
  assign maddrdiff_s = {1'b1, mwaddr} - mraddr;
  assign mxfer_s = hwin_ready | ~hwin_valid;

  always @(posedge clk) begin
    maddrdiff <= maddrdiff_s[5:0];
    if (maddrdiff >= 32) begin
      adc_ready <= 1'b0;
    end else if (maddrdiff <= 20) begin
      adc_ready <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (mrd_s == 1'b1) begin
      mraddr <= mraddr + 1'b1;
    end
    mrd <= mrd_s;
    mrvalid <= mrd;
    mrdata <= mrdata_s;
  end

  always @(posedge clk) begin
    if (mrvalid == 1'b1) begin
      mwcnt <= mwcnt + 1'b1;
    end
    if ((mwcnt == 2'd0) && (mrvalid == 1'b1)) begin
      mvalid_0 <= 1'b1;
      mdata_0 <= mrdata;
    end else if ((mrcnt == 2'd0) && (mxfer_s == 1'b1)) begin
      mvalid_0 <= 1'b0;
      mdata_0 <= 17'd0;
    end
    if ((mwcnt == 2'd1) && (mrvalid == 1'b1)) begin
      mvalid_1 <= 1'b1;
      mdata_1 <= mrdata;
    end else if ((mrcnt == 2'd1) && (mxfer_s == 1'b1)) begin
      mvalid_1 <= 1'b0;
      mdata_1 <= 17'd0;
    end
    if ((mwcnt == 2'd2) && (mrvalid == 1'b1)) begin
      mvalid_2 <= 1'b1;
      mdata_2 <= mrdata;
    end else if ((mrcnt == 2'd2) && (mxfer_s == 1'b1)) begin
      mvalid_2 <= 1'b0;
      mdata_2 <= 17'd0;
    end
    if ((mwcnt == 2'd3) && (mrvalid == 1'b1)) begin
      mvalid_3 <= 1'b1;
      mdata_3 <= mrdata;
    end else if ((mrcnt == 2'd3) && (mxfer_s == 1'b1)) begin
      mvalid_3 <= 1'b0;
      mdata_3 <= 17'd0;
    end
    if ((mrcnt != mwcnt) && (hwin_ready == 1'b1)) begin
      mrcnt <= mrcnt + 1'b1;
    end
    if ((hwin_valid == 1'b0) || (hwin_ready == 1'b1)) begin
      case (mrcnt)
        2'd3: begin
          hwin_valid <= mvalid_3;
          hwin_data <= mdata_3[15:0];
          hwin_last <= mdata_3[16] & mvalid_3;
        end
        2'd2: begin
          hwin_valid <= mvalid_2;
          hwin_data <= mdata_2[15:0];
          hwin_last <= mdata_2[16] & mvalid_2;
        end
        2'd1: begin
          hwin_valid <= mvalid_1;
          hwin_data <= mdata_1[15:0];
          hwin_last <= mdata_1[16] & mvalid_1;
        end
        default: begin
          hwin_valid <= mvalid_0;
          hwin_data <= mdata_0[15:0];
          hwin_last <= mdata_0[16] & mvalid_0;
        end
      endcase
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
