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
// Receive HDMI, hdmi embedded syncs data in, video dma data out.

module cf_h2v_hdmi (

  // hdmi interface

  hdmi_clk,
  hdmi_data,
  hdmi_hs_count_mismatch,   // indicates receive hs mismatch against programmed 
  hdmi_hs_count_toggle,     // toggle to register received hs count
  hdmi_hs_count,            // received hs count
  hdmi_vs_count_mismatch,   // indicates receive vs mismatch against programmed 
  hdmi_vs_count_toggle,     // toggle to register received vs count
  hdmi_vs_count,            // received vs count
  hdmi_tpm_oos,             // test pattern monitor out of sync
  hdmi_oos,                 // hdmi receive mismatch against programmed
  hdmi_fs_toggle,           // start-of-frame toggle for write address
  hdmi_fs_waddr,            // start-of-frame write address
  hdmi_wr,                  // write interface
  hdmi_waddr,
  hdmi_wdata,
  hdmi_waddr_rel_toggle,    // toggle for released write address
  hdmi_waddr_rel,           // released write address
  hdmi_waddr_g,             // running write address (for ovf/unf)

  // processor interface

  up_enable,
  up_crcb_init,
  up_edge_sel,
  up_hs_count,
  up_vs_count,
  up_csc_bypass,
  up_tpg_enable,

  // debug interface (chipscope)

  debug_data,
  debug_trigger);

  // hdmi interface

  input           hdmi_clk;
  input   [15:0]  hdmi_data;
  output          hdmi_hs_count_mismatch;
  output          hdmi_hs_count_toggle;
  output  [15:0]  hdmi_hs_count;
  output          hdmi_vs_count_mismatch;
  output          hdmi_vs_count_toggle;
  output  [15:0]  hdmi_vs_count;
  output          hdmi_tpm_oos;
  output          hdmi_oos;
  output          hdmi_fs_toggle;
  output  [ 8:0]  hdmi_fs_waddr;
  output          hdmi_wr;
  output  [ 8:0]  hdmi_waddr;
  output  [48:0]  hdmi_wdata;
  output          hdmi_waddr_rel_toggle;
  output  [ 8:0]  hdmi_waddr_rel;
  output  [ 8:0]  hdmi_waddr_g;

  // processor interface

  input           up_enable;
  input           up_crcb_init;
  input           up_edge_sel;
  input   [15:0]  up_hs_count;
  input   [15:0]  up_vs_count;
  input           up_csc_bypass;
  input           up_tpg_enable;

  // debug interface (chipscope)

  output  [61:0]  debug_data;
  output  [ 7:0]  debug_trigger;

  reg             hdmi_waddr_rel_toggle = 'd0;
  reg     [ 8:0]  hdmi_waddr_rel = 'd0;
  reg             hdmi_fs_toggle = 'd0;
  reg     [ 8:0]  hdmi_fs_waddr = 'd0;
  reg             hdmi_wr = 'd0;
  reg             hdmi_wr_d = 'd0;
  reg     [ 9:0]  hdmi_waddr_f = 'd0;
  reg     [ 8:0]  hdmi_waddr_g = 'd0;
  reg     [48:0]  hdmi_wdata = 'd0;
  reg     [23:0]  hdmi_tpm_data = 'd0;
  reg     [ 4:0]  hdmi_tpm_mismatch_count = 'd0;
  reg             hdmi_tpm_oos = 'd0;
  reg             hdmi_fs_422 = 'd0;
  reg             hdmi_de_422 = 'd0;
  reg     [15:0]  hdmi_data_422 = 'd0;
  reg             hdmi_fs_444 = 'd0;
  reg             hdmi_de_444 = 'd0;
  reg     [23:0]  hdmi_data_444 = 'd0;
  reg             hdmi_fs_444_d = 'd0;
  reg             hdmi_de_444_d = 'd0;
  reg     [23:0]  hdmi_data_444_d = 'd0;
  reg             hdmi_oos = 'd0;
  reg             hdmi_sof = 'd0;
  reg             hdmi_hs_de_d = 'd0;
  reg             hdmi_vs_de_d = 'd0;
  reg     [15:0]  hdmi_hs_run_count = 'd0;
  reg     [15:0]  hdmi_vs_run_count = 'd0;
  reg             hdmi_hs_count_mismatch = 'd0;
  reg             hdmi_hs_count_toggle = 'd0;
  reg     [15:0]  hdmi_hs_count = 'd0;
  reg             hdmi_vs_count_mismatch = 'd0;
  reg             hdmi_vs_count_toggle = 'd0;
  reg     [15:0]  hdmi_vs_count = 'd0;
  reg             hdmi_enable = 'd0;
  reg     [15:0]  hdmi_data_d = 'd0;
  reg             hdmi_hs_de_rcv_d = 'd0;
  reg             hdmi_vs_de_rcv_d = 'd0;
  reg     [15:0]  hdmi_data_2d = 'd0;
  reg             hdmi_hs_de_rcv_2d = 'd0;
  reg             hdmi_vs_de_rcv_2d = 'd0;
  reg     [15:0]  hdmi_data_3d = 'd0;
  reg             hdmi_hs_de_rcv_3d = 'd0;
  reg             hdmi_vs_de_rcv_3d = 'd0;
  reg     [15:0]  hdmi_data_4d = 'd0;
  reg             hdmi_hs_de_rcv_4d = 'd0;
  reg             hdmi_vs_de_rcv_4d = 'd0;
  reg     [15:0]  hdmi_data_de = 'd0;
  reg             hdmi_hs_de = 'd0;
  reg             hdmi_vs_de = 'd0;
  reg     [ 1:0]  hdmi_preamble_cnt = 'd0;
  reg             hdmi_hs_de_rcv = 'd0;
  reg             hdmi_vs_de_rcv = 'd0;
  reg     [15:0]  hdmi_data_neg_p = 'd0;
  reg     [15:0]  hdmi_data_pos_p = 'd0;
  reg     [15:0]  hdmi_data_p = 'd0;
  reg     [15:0]  hdmi_data_neg = 'd0;
  reg             hdmi_up_enable_m1 = 'd0;
  reg             hdmi_up_enable_m2 = 'd0;
  reg             hdmi_up_enable_m3 = 'd0;
  reg             hdmi_up_enable = 'd0;
  reg             hdmi_up_crcb_init = 'd0;
  reg             hdmi_up_edge_sel = 'd0;
  reg     [15:0]  hdmi_up_hs_count = 'd0;
  reg     [15:0]  hdmi_up_vs_count = 'd0;
  reg             hdmi_up_csc_bypass = 'd0;
  reg             hdmi_up_tpg_enable = 'd0;

  wire            hdmi_waddr_rel_1_s;
  wire            hdmi_waddr_rel_2_s;
  wire            hdmi_waddr_rel_s;
  wire            hdmi_tpm_mismatch_s;
  wire    [15:0]  hdmi_tpm_data_s;
  wire            hdmi_sof_s;
  wire            hdmi_count_mismatch_s;
  wire            hdmi_oos_s;
  wire            hdmi_fs_444_s;
  wire            hdmi_de_444_s;
  wire    [23:0]  hdmi_data_444_s;
  wire            ss_fs_s;
  wire            ss_de_s;
  wire    [23:0]  ss_data_s;


  // binary to grey coversion

  function [8:0] b2g;
    input [8:0] b;
    reg   [8:0] g;
    begin
      g[8] = b[8];
      g[7] = b[8] ^ b[7];
      g[6] = b[7] ^ b[6];
      g[5] = b[6] ^ b[5];
      g[4] = b[5] ^ b[4];
      g[3] = b[4] ^ b[3];
      g[2] = b[3] ^ b[2];
      g[1] = b[2] ^ b[1];
      g[0] = b[1] ^ b[0];
      b2g = g;
    end
  endfunction

  // debug signals

  assign debug_data[61:61] = hdmi_tpm_oos;
  assign debug_data[60:60] = hdmi_tpm_mismatch_s;
  assign debug_data[59:59] = hdmi_de_422;
  assign debug_data[58:43] = hdmi_data_422;
  assign debug_data[42:42] = hdmi_oos;
  assign debug_data[41:41] = hdmi_sof;
  assign debug_data[40:40] = hdmi_hs_count_mismatch;
  assign debug_data[39:39] = hdmi_vs_count_mismatch;
  assign debug_data[38:38] = hdmi_enable;
  assign debug_data[37:37] = hdmi_vs_de;
  assign debug_data[36:36] = hdmi_hs_de;
  assign debug_data[35:20] = hdmi_data_de;
  assign debug_data[19:18] = hdmi_preamble_cnt;
  assign debug_data[17:17] = hdmi_vs_de_rcv;
  assign debug_data[16:16] = hdmi_hs_de_rcv;
  assign debug_data[15: 0] = hdmi_data_p;

  assign debug_trigger[7] = hdmi_tpm_mismatch_s;
  assign debug_trigger[6] = hdmi_tpm_oos;
  assign debug_trigger[5] = hdmi_enable;
  assign debug_trigger[4] = hdmi_hs_de;
  assign debug_trigger[3] = hdmi_vs_de;
  assign debug_trigger[2] = hdmi_sof;
  assign debug_trigger[1] = hdmi_vs_de_rcv;
  assign debug_trigger[0] = hdmi_hs_de_rcv;

  // pass the write addresses during start of frame and after that, periodically
  // until (and also at) the end of frame.

  assign hdmi_waddr_rel_1_s = hdmi_wr_d & ~hdmi_de_444_d;
  assign hdmi_waddr_rel_2_s = (hdmi_waddr_f[6:0] == 7'h7f) ? hdmi_wr_d : 1'b0;
  assign hdmi_waddr_rel_s = hdmi_waddr_rel_1_s | hdmi_waddr_rel_2_s;

  always @(posedge hdmi_clk) begin
    if (hdmi_waddr_rel_s == 1'b1) begin
      hdmi_waddr_rel_toggle <= ~hdmi_waddr_rel_toggle;
      hdmi_waddr_rel <= hdmi_waddr_f[9:1];
    end
    if (hdmi_fs_444_d == 1'b1) begin
      hdmi_fs_toggle <= ~hdmi_fs_toggle;
      hdmi_fs_waddr <= hdmi_waddr_f[9:1];
    end
  end

  // hdmi data write (last is required for vdma)

  assign hdmi_waddr = hdmi_waddr_f[9:1];

  always @(posedge hdmi_clk) begin
    hdmi_wr <= hdmi_de_444_d;
    hdmi_wr_d <= hdmi_wr;
    if (hdmi_wr == 1'b1) begin
      hdmi_waddr_f <= hdmi_waddr_f + 1'b1;
    end
    hdmi_waddr_g <= b2g(hdmi_waddr_f[9:1]);
    hdmi_wdata[48:48] <= hdmi_wr & ~hdmi_de_444;
    hdmi_wdata[47:24] <= hdmi_data_444_d;
    hdmi_wdata[23: 0] <= hdmi_wdata[47:24];
  end

  // TPM on 422 data (the data must be passed through the cable as it is transmitted
  // by the v2h module. Any csc conversions must be disabled on info frame

  assign hdmi_tpm_mismatch_s = (hdmi_data_422 == hdmi_tpm_data_s) ? 1'b0 : hdmi_de_422;
  assign hdmi_tpm_data_s = {hdmi_tpm_data[3:2], 6'h20, hdmi_tpm_data[1:0], 6'h20};

  always @(posedge hdmi_clk) begin
    if (hdmi_fs_422 == 1'b1) begin
      hdmi_tpm_data <= 'd0;
    end else if (hdmi_de_422 == 1'b1) begin
      hdmi_tpm_data <= hdmi_tpm_data + 1'b1;
    end
    if (hdmi_tpm_mismatch_s == 1'b1) begin
      hdmi_tpm_mismatch_count <= 5'h10;
    end else if (hdmi_tpm_mismatch_count[4] == 1'b1) begin
      hdmi_tpm_mismatch_count <= hdmi_tpm_mismatch_count + 1'b1;
    end
    hdmi_tpm_oos <= hdmi_tpm_mismatch_count[4];
  end

  // fs, enable and data on 422 and 444 domains

  always @(posedge hdmi_clk) begin
    hdmi_fs_422 <= hdmi_sof & hdmi_enable;
    hdmi_de_422 <= hdmi_hs_de & hdmi_vs_de & hdmi_enable;
    hdmi_data_422 <= hdmi_data_de;
    if (hdmi_up_csc_bypass == 1'b1) begin
      hdmi_fs_444 <= hdmi_fs_422;
      hdmi_de_444 <= hdmi_de_422;
    end else begin
      hdmi_fs_444 <= hdmi_fs_444_s;
      hdmi_de_444 <= hdmi_de_444_s;
    end
    if (hdmi_up_tpg_enable == 1'b1) begin
      hdmi_data_444 <= hdmi_tpm_data;
    end else if (hdmi_up_csc_bypass == 1'b1) begin
      hdmi_data_444 <= {8'd0, hdmi_data_422};
    end else begin
      hdmi_data_444 <= hdmi_data_444_s;
    end
    hdmi_fs_444_d <= hdmi_fs_444;
    hdmi_de_444_d <= hdmi_de_444;
    hdmi_data_444_d <= hdmi_data_444;
  end

  // start of frame

  assign hdmi_sof_s = hdmi_vs_de & ~hdmi_vs_de_d;
  assign hdmi_count_mismatch_s = hdmi_hs_count_mismatch | hdmi_vs_count_mismatch;
  assign hdmi_oos_s = ((hdmi_hs_count == hdmi_up_hs_count) &&
    (hdmi_vs_count == hdmi_up_vs_count)) ? hdmi_count_mismatch_s : 1'b1;

  // hdmi side of the interface, horizontal and vertical sync counters.
  // capture active video size and report mismatch

  always @(posedge hdmi_clk) begin
    hdmi_oos <= hdmi_oos_s;
    hdmi_sof <= hdmi_sof_s;
    hdmi_hs_de_d <= hdmi_hs_de;
    hdmi_vs_de_d <= hdmi_vs_de;
    if ((hdmi_hs_de == 1'b1) && (hdmi_hs_de_d == 1'b0)) begin
      hdmi_hs_run_count <= 'd1;
    end else if (hdmi_hs_de == 1'b1) begin
      hdmi_hs_run_count <= hdmi_hs_run_count + 1'b1;
    end
    if ((hdmi_vs_de == 1'b1) && (hdmi_vs_de_d == 1'b0)) begin
      hdmi_vs_run_count <= 'd0;
    end else if ((hdmi_vs_de == 1'b1) && (hdmi_hs_de == 1'b1) && (hdmi_hs_de_d == 1'b0)) begin
      hdmi_vs_run_count <= hdmi_vs_run_count + 1'b1;
    end
    if ((hdmi_hs_de == 1'b0) && (hdmi_hs_de_d == 1'b1)) begin
      hdmi_hs_count_mismatch <= (hdmi_hs_count == hdmi_hs_run_count) ? 1'b0 : 1'b1;
      hdmi_hs_count_toggle <= ~hdmi_hs_count_toggle;
      hdmi_hs_count <= hdmi_hs_run_count;
    end
    if ((hdmi_vs_de == 1'b0) && (hdmi_vs_de_d == 1'b1)) begin
      hdmi_vs_count_mismatch <= (hdmi_vs_count == hdmi_vs_run_count) ? 1'b0 : 1'b1;
      hdmi_vs_count_toggle <= ~hdmi_vs_count_toggle;
      hdmi_vs_count <= hdmi_vs_run_count;
    end
    if (hdmi_sof_s == 1'b1) begin
      hdmi_enable <= hdmi_up_enable & ~hdmi_oos_s;
    end
  end

  // delay to get rid of eav's 4 bytes

  always @(posedge hdmi_clk) begin
    hdmi_data_d <= hdmi_data_p;
    hdmi_hs_de_rcv_d <= hdmi_hs_de_rcv;
    hdmi_vs_de_rcv_d <= hdmi_vs_de_rcv;
    hdmi_data_2d <= hdmi_data_d;
    hdmi_hs_de_rcv_2d <= hdmi_hs_de_rcv_d;
    hdmi_vs_de_rcv_2d <= hdmi_vs_de_rcv_d;
    hdmi_data_3d <= hdmi_data_2d;
    hdmi_hs_de_rcv_3d <= hdmi_hs_de_rcv_2d;
    hdmi_vs_de_rcv_3d <= hdmi_vs_de_rcv_2d;
    hdmi_data_4d <= hdmi_data_3d;
    hdmi_hs_de_rcv_4d <= hdmi_hs_de_rcv_3d;
    hdmi_vs_de_rcv_4d <= hdmi_vs_de_rcv_3d;
    hdmi_data_de <= hdmi_data_4d;
    hdmi_hs_de <= hdmi_hs_de_rcv & hdmi_hs_de_rcv_4d;
    hdmi_vs_de <= hdmi_vs_de_rcv & hdmi_vs_de_rcv_4d;
  end
    
  // check for sav and eav and generate the corresponding enables

  always @(posedge hdmi_clk) begin
    if ((hdmi_data_p == 16'hffff) || (hdmi_data_p == 16'h0000)) begin
      hdmi_preamble_cnt <= hdmi_preamble_cnt + 1'b1;
    end else begin
      hdmi_preamble_cnt <= 'd0;
    end
    if (hdmi_preamble_cnt == 3'b11) begin
      if ((hdmi_data_p == 16'hb6b6) || (hdmi_data_p == 16'h9d9d)) begin
        hdmi_hs_de_rcv <= 1'b0;
      end else if ((hdmi_data_p == 16'habab) || (hdmi_data_p == 16'h8080)) begin
        hdmi_hs_de_rcv <= 1'b1;
      end
      if (hdmi_data_p == 16'hb6b6) begin
        hdmi_vs_de_rcv <= 1'b0;
      end else if (hdmi_data_p == 16'h9d9d) begin
        hdmi_vs_de_rcv <= 1'b1;
      end
    end
  end

  // hdmi input data registers

  always @(posedge hdmi_clk) begin
    hdmi_data_neg_p <= hdmi_data_neg;
    hdmi_data_pos_p <= hdmi_data;
    if (hdmi_up_edge_sel == 1'b1) begin
      hdmi_data_p <= hdmi_data_neg_p;
    end else begin
      hdmi_data_p <= hdmi_data_pos_p;
    end
  end

  always @(negedge hdmi_clk) begin
    hdmi_data_neg <= hdmi_data;
  end

  // microprocessor signals on the hdmi side

  always @(posedge hdmi_clk) begin
    hdmi_up_enable_m1 <= up_enable;
    hdmi_up_enable_m2 <= hdmi_up_enable_m1;
    hdmi_up_enable_m3 <= hdmi_up_enable_m2;
    hdmi_up_enable <= hdmi_up_enable_m3;
    if ((hdmi_up_enable_m3 == 1'b0) && (hdmi_up_enable_m2 == 1'b1)) begin
      hdmi_up_crcb_init <= up_crcb_init;
      hdmi_up_edge_sel <= up_edge_sel;
      hdmi_up_hs_count <= up_hs_count;
      hdmi_up_vs_count <= up_vs_count;
      hdmi_up_csc_bypass <= up_csc_bypass;
      hdmi_up_tpg_enable <= up_tpg_enable;
    end
  end

  // super sampling, 422 to 444

  cf_ss_422to444 i_ss (
    .clk (hdmi_clk),
    .s422_vs (1'b0),
    .s422_hs (hdmi_fs_422),
    .s422_de (hdmi_de_422),
    .s422_data (hdmi_data_422),
    .s444_vs (),
    .s444_hs (ss_fs_s),
    .s444_de (ss_de_s),
    .s444_data (ss_data_s),
    .Cr_Cb_sel_init (hdmi_up_crcb_init));

  // color space conversion, CrYCb to RGB

  cf_csc_CrYCb2RGB i_csc (
    .clk (hdmi_clk),
    .CrYCb_vs (1'b0),
    .CrYCb_hs (ss_fs_s),
    .CrYCb_de (ss_de_s),
    .CrYCb_data (ss_data_s),
    .RGB_vs (),
    .RGB_hs (hdmi_fs_444_s),
    .RGB_de (hdmi_de_444_s),
    .RGB_data (hdmi_data_444_s));

endmodule

// ***************************************************************************
// ***************************************************************************
