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
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module cf_adc_wr (

  // adc interface (clk, data, over-range)
  adc_clk_in_p,
  adc_clk_in_n,
  adc_data_in_p,
  adc_data_in_n,
  adc_data_or_p,
  adc_data_or_n,

  // interface outputs
  adc_clk,
  adc_valid,
  adc_data,
  adc_or,
  adc_pn_oos,
  adc_pn_err,

  // processor control signals
  up_signext_enable,  // sign extension enable
  up_muladd_enable,   // offset & scale enable
  up_muladd_offbin,   // offset & scale in offset binary mode
  up_muladd_scale_a,  // scale factor for I
  up_muladd_offset_a, // offset factor for I
  up_muladd_scale_b,  // scale factor for I
  up_muladd_offset_b, // offset factor for I
  up_pn_type,         // PN9 (0x0) or PN23 (0x1)
  up_dmode,           // data capture modes (see adc_if)
  up_ch_sel,          // channel select
  up_usr_sel,         // user controls
  up_delay_sel,       // delay controls
  up_delay_rwn,
  up_delay_addr,
  up_delay_wdata,
  up_decimation_m,    // processor decimation controls
  up_decimation_n,
  up_data_type,

  usr_decimation_m,   // user decimation controls
  usr_decimation_n,
  usr_data_type,
  usr_max_channels,

  // delay control signals
  delay_clk,
  delay_ack,
  delay_rdata,
  delay_locked,

  // adc debug and monitor signals (for chipscope)
  debug_data,
  debug_trigger,
  adc_mon_valid,
  adc_mon_data);

  // This parameter controls the buffer type based on the target device.
  parameter C_CF_BUFTYPE = 0;
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
  output          adc_valid;
  output  [63:0]  adc_data;
  output  [ 1:0]  adc_or;
  output  [ 1:0]  adc_pn_oos;
  output  [ 1:0]  adc_pn_err;

  // processor control signals
  input           up_signext_enable;
  input           up_muladd_enable;
  input           up_muladd_offbin;
  input   [15:0]  up_muladd_scale_a;
  input   [14:0]  up_muladd_offset_a;
  input   [15:0]  up_muladd_scale_b;
  input   [14:0]  up_muladd_offset_b;
  input   [ 1:0]  up_pn_type;
  input   [ 1:0]  up_dmode;
  input   [ 1:0]  up_ch_sel;
  input   [ 3:0]  up_usr_sel;
  input           up_delay_sel;
  input           up_delay_rwn;
  input   [ 3:0]  up_delay_addr;
  input   [ 4:0]  up_delay_wdata;
  input   [15:0]  up_decimation_m;
  input   [15:0]  up_decimation_n;
  input           up_data_type;

  output  [15:0]  usr_decimation_m;
  output  [15:0]  usr_decimation_n;
  output          usr_data_type;
  output  [ 3:0]  usr_max_channels;

  // delay control signals
  input           delay_clk;
  output          delay_ack;
  output  [ 4:0]  delay_rdata;
  output          delay_locked;

  // adc debug and monitor signals (for chipscope)
  output  [63:0]  debug_data;
  output  [ 7:0]  debug_trigger;
  output          adc_mon_valid;
  output  [31:0]  adc_mon_data;

  reg     [ 3:0]  usr_max_channels = 'd0; // usr maximum number of channels (nodes or tap points)
  reg     [15:0]  usr_decimation_m = 'd0; // user decimation M
  reg     [15:0]  usr_decimation_n = 'd0; // user decimation N
  reg             usr_data_type = 'd0; // user data type complex (0), real (1)
  reg             usr_data_valid = 'd0; // user logic data valid
  reg     [63:0]  usr_data = 'd0; // user logic data
  reg     [ 3:0]  adc_usr_sel_m1 = 'd0;
  reg     [ 3:0]  adc_usr_sel = 'd0;
  reg     [ 1:0]  adc_ch_sel_m1 = 'd0;
  reg     [ 1:0]  adc_ch_sel = 'd0;
  reg     [ 1:0]  adc_cnt = 'd0;
  reg             adc_valid = 'd0;
  reg     [63:0]  adc_data = 'd0;

  wire    [15:0]  adc_data_a_s;         // offset & scaled data 
  wire    [15:0]  adc_data_b_s;         // offset & scaled data
  wire    [13:0]  adc_data_a_if_s;      // raw adc data
  wire    [13:0]  adc_data_b_if_s;      // raw adc data

  // Users may add a custom logic here (or a separate module), the data inputs for the
  // user logic may be raw or offset-&-scaled data (see wire definitions above).
  // The user must correctly specify the following parameters so that the drivers
  // would know the decimation factor and the output data type (I/Q).
  // The driver must also enable the up_usr_sel to select user logic output.
  // THIS IS NOT A COMPLETE SOLUTION and individual needs may vary.
  // Also note that the data bitwidths may require padding or truncation to match the
  // external DMA bus width. This design as it is, uses 64bits.
  // A 4bit user logic select (max 16) is provided for tap points within the user logic.
  // Modify the following mux accordingly. If a tap point is not used, please drive
  // the decimation factors '0'. The example code below uses 2 tap points

  // Also note that there are processor based decimation and type controls-
  // If you are planning to put a programmable decimation filter, you may use these
  // signals (up_*) to control the decimation and data type. In this case, do
  // make sure to route the up_* signals to the usr_* - this allows software
  // writes to be read back. If software can not read back, it will default to a
  // read only mode (programmability is disabled).

  always @(posedge adc_clk) begin
    usr_max_channels <= 4'd1; // channel selects from 0 to 1.
    case (adc_usr_sel)
      4'b0000: begin // tap point 1. (let's say output of pulse shaping filter)
        usr_decimation_m <= 16'd1; // user logic decimation numerator
        usr_decimation_n <= 16'd1; // user logic decimation denominator
        usr_data_type <= 1'b0; // user logic output type (0 - complex, 1- real)
        usr_data_valid <= 1'd1; // user data valid (replace with user logic)
        usr_data <= {4{16'hf00d}}; // user data (replace with user logic)
      end
      4'b0001: begin // tap point 2. (let's say output of symbol timing recovery)
        usr_decimation_m <= 16'd1; // user logic decimation numerator
        usr_decimation_n <= 16'd1; // user logic decimation denominator
        usr_data_type <= 1'b0; // user logic output type (0 - complex, 1- real)
        usr_data_valid <= 1'd1; // user data valid (replace with user logic)
        usr_data <= {4{16'hcafe}}; // user data (replace with user logic)
      end
      default: begin // unused tap points
        usr_decimation_m <= up_decimation_m; // user logic decimation numerator
        usr_decimation_n <= up_decimation_n; // user logic decimation denominator
        usr_data_type <= up_data_type; // user logic output type (0 - complex, 1- real)
        usr_data_valid <= 1'd1; // user data valid (replace with user logic)
        usr_data <= {4{16'hdead}}; // user data (replace with user logic)
      end
    endcase
  end

  assign adc_mon_valid = 1'b1;
  assign adc_mon_data = {adc_data_b_s, adc_data_a_s};

  // the adc channel select let you pick a particular channel -

  always @(posedge adc_clk) begin
    adc_usr_sel_m1 <= up_usr_sel;
    adc_usr_sel <= adc_usr_sel_m1;
    adc_ch_sel_m1 <= up_ch_sel;
    adc_ch_sel <= adc_ch_sel_m1;
    adc_cnt <= adc_cnt + 1'b1;
    case (adc_ch_sel)
      2'b11: begin // both I and Q
        adc_valid <= adc_cnt[0];
        adc_data <= {adc_data_a_s, adc_data_b_s, adc_data[63:32]};
      end
      2'b10: begin // Q only
        adc_valid <= adc_cnt[1] & adc_cnt[0];
        adc_data <= {adc_data_b_s, adc_data[63:16]};
      end
      2'b01: begin // I only
        adc_valid <= adc_cnt[1] & adc_cnt[0];
        adc_data <= {adc_data_a_s, adc_data[63:16]};
      end
      default: begin  // user data
        adc_valid <= usr_data_valid;
        adc_data <= usr_data;
      end
    endcase
  end

  // PN sequence monitor
  cf_pnmon i_pnmon_a (
    .adc_clk (adc_clk),
    .adc_data (adc_data_a_if_s),
    .adc_pn_oos (adc_pn_oos[0]),
    .adc_pn_err (adc_pn_err[0]),
    .up_pn_type (up_pn_type[0]));

  // Offset & scale
  cf_muladd i_muladd_a (
    .adc_clk (adc_clk),
    .data_in (adc_data_a_if_s),
    .data_out (adc_data_a_s),
    .up_signext_enable (up_signext_enable),
    .up_muladd_enable (up_muladd_enable),
    .up_muladd_offbin (up_muladd_offbin),
    .up_muladd_scale (up_muladd_scale_a),
    .up_muladd_offset (up_muladd_offset_a));

  // PN sequence monitor
  cf_pnmon i_pnmon_b (
    .adc_clk (adc_clk),
    .adc_data (adc_data_b_if_s),
    .adc_pn_oos (adc_pn_oos[1]),
    .adc_pn_err (adc_pn_err[1]),
    .up_pn_type (up_pn_type[1]));

  // Offset & scale
  cf_muladd i_muladd_b (
    .adc_clk (adc_clk),
    .data_in (adc_data_b_if_s),
    .data_out (adc_data_b_s),
    .up_signext_enable (up_signext_enable),
    .up_muladd_enable (up_muladd_enable),
    .up_muladd_offbin (up_muladd_offbin),
    .up_muladd_scale (up_muladd_scale_b),
    .up_muladd_offset (up_muladd_offset_b));

  // ADC data interface
  cf_adc_if #(.C_CF_BUFTYPE (C_CF_BUFTYPE), .C_IODELAY_GROUP(C_IODELAY_GROUP)) i_adc_if (
    .adc_clk_in_p (adc_clk_in_p),
    .adc_clk_in_n (adc_clk_in_n),
    .adc_data_in_p (adc_data_in_p),
    .adc_data_in_n (adc_data_in_n),
    .adc_data_or_p (adc_data_or_p),
    .adc_data_or_n (adc_data_or_n),
    .adc_clk (adc_clk),
    .adc_data_a (adc_data_a_if_s),
    .adc_data_b (adc_data_b_if_s),
    .adc_or (adc_or),
    .up_dmode (up_dmode),
    .up_delay_sel (up_delay_sel),
    .up_delay_rwn (up_delay_rwn),
    .up_delay_addr (up_delay_addr),
    .up_delay_wdata (up_delay_wdata),
    .delay_clk (delay_clk),
    .delay_ack (delay_ack),
    .delay_rdata (delay_rdata),
    .delay_locked (delay_locked));

endmodule

// ***************************************************************************
// ***************************************************************************

