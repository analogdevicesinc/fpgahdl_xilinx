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

module axi_fft_win (

  clk,

  // adc data input

  adc_valid,
  adc_data,
  adc_last,
  adc_ready,

  // windowed output

  win_valid,
  win_data,
  win_last,
  win_ready,

  // window phase increment

  win_incr,
  win_enable);

  input           clk;

  // adc data input

  input           adc_valid;
  input   [15:0]  adc_data;
  input           adc_last;
  output          adc_ready;

  // windowed output

  output          win_valid;
  output  [15:0]  win_data;
  output          win_last;
  input           win_ready;

  // window phase increment

  input   [15:0]  win_incr;
  input           win_enable;

  // internal registers

  reg     [15:0]  win_angle = 'd0;
  reg             win_valid_s1 = 'd0;
  reg             win_last_s1 = 'd0;
  reg             win_data_sign_s1 = 'd0;
  reg     [15:0]  win_data_s1 = 'd0;
  reg             win_cos_sign_s1 = 'd0;
  reg     [15:0]  win_cos_data_s1_sub = 'd0;
  reg     [15:0]  win_cos_data_s1_add = 'd0;
  reg             win_valid_s2 = 'd0;
  reg             win_last_s2 = 'd0;
  reg             win_data_sign_s2 = 'd0;
  reg     [14:0]  win_data_s2 = 'd0;
  reg     [14:0]  win_cos_data_s2 = 'd0;
  reg             win_valid_s3 = 'd0;
  reg             win_last_s3 = 'd0;
  reg     [15:0]  win_data_s3 = 'd0;
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
  reg             win_valid = 'd0;
  reg     [15:0]  win_data = 'd0;
  reg             win_last = 'd0;

  // internal signals

  wire    [15:0]  win_cos_s1_s;
  wire            win_valid_s1_s;
  wire            win_last_s1_s;
  wire    [15:0]  win_data_s1_s;
  wire    [31:0]  win_data_s3_s;
  wire            win_sign_s3_s;
  wire            win_valid_s3_s;
  wire            win_last_s3_s;
  wire            mrd_s;
  wire    [ 6:0]  maddrdiff_s;
  wire            mxfer_s;
  wire    [16:0]  mrdata_s;

  // the window is generated from a sine function, to get the cos you need to add 90deg == (pi)/4

  always @(posedge clk) begin
    if (adc_valid == 1'b1) begin
      win_angle <= win_angle + win_incr;
    end else if (win_enable == 1'b0) begin
      win_angle <= 16'h4000;
    end
  end

  // the sine function actually generates cosine (because of the pi/4 addition above)

  ad_sine #(.DELAY_DATA_WIDTH(18)) i_cos (
    .clk (clk),
    .angle (win_angle),
    .sine (win_cos_s1_s),
    .ddata_in ({adc_valid, adc_last, adc_data}),
    .ddata_out ({win_valid_s1_s, win_last_s1_s, win_data_s1_s}));

  // get 0.5*(1 - cos(a)), the output is +ve (because mag(cos(a)) is less than 1.

  always @(posedge clk) begin
    win_valid_s1 <= win_valid_s1_s;
    win_last_s1 <= win_last_s1_s;
    win_data_sign_s1 <= win_data_s1_s[15];
    if (win_data_s1_s[15] == 1'b1) begin
      win_data_s1 <= ~win_data_s1_s + 1'b1;
    end else begin
      win_data_s1 <= win_data_s1_s;
    end
    win_cos_sign_s1 <= win_cos_s1_s[15];
    win_cos_data_s1_sub <= 16'h7fff - win_cos_s1_s[14:0];
    win_cos_data_s1_add <= 16'h7fff + win_cos_s1_s[14:0];
    win_valid_s2 <= win_valid_s1;
    win_last_s2 <= win_last_s1;
    win_data_sign_s2 <= win_data_sign_s1;
    win_data_s2 <= win_data_s1[14:0];
    if (win_cos_sign_s1 == 1'b1) begin
      win_cos_data_s2 <= win_cos_data_s1_add[15:1];
    end else begin
      win_cos_data_s2 <= win_cos_data_s1_sub[15:1];
    end
  end

  // apply the window function

  mul_u16 #(.DELAY_DATA_WIDTH(3)) i_mul (
    .clk (clk),
    .data_a ({1'b0, win_data_s2}),
    .data_b ({1'b0, win_cos_data_s2}),
    .data_p (win_data_s3_s),
    .ddata_in ({win_data_sign_s2, win_valid_s2, win_last_s2}),
    .ddata_out ({win_sign_s3_s, win_valid_s3_s, win_last_s3_s}));

  // get the 2's compl and pass the data to memory 

  always @(posedge clk) begin
    win_valid_s3 <= win_valid_s3_s;
    win_last_s3 <= win_last_s3_s;
    if (win_sign_s3_s == 1'b1) begin
      win_data_s3 <= ~win_data_s3_s[30:15] + 1'b1;
    end else begin
      win_data_s3 <= win_data_s3_s[30:15];
    end
  end

  // the memory is used to account for the "back pressure" from the fft module

  always @(posedge clk) begin
    if (win_enable == 1'b1) begin
      mwr <= win_valid_s3;
      mwdata <= {win_last_s3, win_data_s3};
    end else begin
      mwr <= adc_valid;
      mwdata <= {adc_last, adc_data};
    end
    if (mwr == 1'b1) begin
      mwaddr <= mwaddr + 1'b1;
    end
  end

  mem #(.ADDR_WIDTH(6), .DATA_WIDTH(17)) i_mem (
    .clka (clk),
    .wea (mwr),
    .addra (mwaddr),
    .dina (mwdata),
    .clkb (clk),
    .addrb (mraddr),
    .doutb (mrdata_s));

  // read from meory and pass it to the FFT module

  assign mrd_s = (mwaddr == mraddr) ? 1'b0 : win_ready;
  assign maddrdiff_s = {1'b1, mwaddr} - mraddr;
  assign mxfer_s = win_ready | ~win_valid;

  always @(posedge clk) begin
    maddrdiff <= maddrdiff_s[5:0];
    if (maddrdiff >= 32) begin
      adc_ready <= 1'b0;
    end else if (maddrdiff <= 20) begin
      adc_ready <= 1'b1;
    end
  end

  // read and address update

  always @(posedge clk) begin
    if (mrd_s == 1'b1) begin
      mraddr <= mraddr + 1'b1;
    end
    mrd <= mrd_s;
    mrvalid <= mrd;
    mrdata <= mrdata_s;
  end

  // hold data during sudden death (ready de-asserted!)

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
    if ((mrcnt != mwcnt) && (win_ready == 1'b1)) begin
      mrcnt <= mrcnt + 1'b1;
    end
    if ((win_valid == 1'b0) || (win_ready == 1'b1)) begin
      case (mrcnt)
        2'd3: begin
          win_valid <= mvalid_3;
          win_data <= mdata_3[15:0];
          win_last <= mdata_3[16] & mvalid_3;
        end
        2'd2: begin
          win_valid <= mvalid_2;
          win_data <= mdata_2[15:0];
          win_last <= mdata_2[16] & mvalid_2;
        end
        2'd1: begin
          win_valid <= mvalid_1;
          win_data <= mdata_1[15:0];
          win_last <= mdata_1[16] & mvalid_1;
        end
        default: begin
          win_valid <= mvalid_0;
          win_data <= mdata_0[15:0];
          win_last <= mdata_0[16] & mvalid_0;
        end
      endcase
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
