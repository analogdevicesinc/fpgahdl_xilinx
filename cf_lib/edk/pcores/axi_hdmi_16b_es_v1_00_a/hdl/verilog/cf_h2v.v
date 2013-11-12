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

module cf_h2v (

  // hdmi interface

  hdmi_clk,
  hdmi_data,

  // vdma interface

  vdma_clk,
  vdma_fs,
  vdma_fs_ret,
  vdma_valid,
  vdma_be,
  vdma_data,
  vdma_last,
  vdma_ready,

  // processor interface

  up_rstn,
  up_clk,
  up_sel,
  up_rwn,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,
  up_status,

  // debug interface (chipscope)

  vdma_dbg_data,
  vdma_dbg_trigger,
  hdmi_dbg_data,
  hdmi_dbg_trigger);

  // hdmi interface

  input           hdmi_clk;
  input   [15:0]  hdmi_data;

  // vdma interface

  input           vdma_clk;
  output          vdma_fs;
  input           vdma_fs_ret;
  output          vdma_valid;
  output  [ 7:0]  vdma_be;
  output  [63:0]  vdma_data;
  output          vdma_last;
  input           vdma_ready;

  // processor interface

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_rwn;
  input   [ 4:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;
  output  [ 3:0]  up_status;

  // debug interface (chipscope)

  output  [39:0]  vdma_dbg_data;
  output  [ 7:0]  vdma_dbg_trigger;
  output  [61:0]  hdmi_dbg_data;
  output  [ 7:0]  hdmi_dbg_trigger;

  reg             up_crcb_init = 'd0;
  reg             up_align_right = 'd0;
  reg             up_tpg_enable = 'd0;
  reg             up_csc_bypass = 'd0;
  reg             up_edge_sel = 'd0;
  reg             up_enable = 'd0;
  reg     [15:0]  up_vs_count = 'd0;
  reg     [15:0]  up_hs_count = 'd0;
  reg             up_hdmi_hs_mismatch_hold = 'd0;
  reg             up_hdmi_vs_mismatch_hold = 'd0;
  reg             up_hdmi_oos_hold = 'd0;
  reg             up_hdmi_tpm_oos_hold = 'd0;
  reg             up_vdma_ovf_hold = 'd0;
  reg             up_vdma_unf_hold = 'd0;
  reg             up_vdma_tpm_oos_hold = 'd0;
  reg     [ 3:0]  up_status = 'd0;
  reg     [31:0]  up_rdata = 'd0;
  reg             up_sel_d = 'd0;
  reg             up_sel_2d = 'd0;
  reg             up_ack = 'd0;
  reg             up_hdmi_hs_toggle_m1 = 'd0;
  reg             up_hdmi_hs_toggle_m2 = 'd0;
  reg             up_hdmi_hs_toggle_m3 = 'd0;
  reg             up_hdmi_hs_mismatch = 'd0;
  reg     [15:0]  up_hdmi_hs = 'd0;
  reg             up_hdmi_vs_toggle_m1 = 'd0;
  reg             up_hdmi_vs_toggle_m2 = 'd0;
  reg             up_hdmi_vs_toggle_m3 = 'd0;
  reg             up_hdmi_vs_mismatch = 'd0;
  reg     [15:0]  up_hdmi_vs = 'd0;
  reg             up_hdmi_tpm_oos_m1 = 'd0;
  reg             up_hdmi_tpm_oos = 'd0;
  reg             up_hdmi_oos_m1 = 'd0;
  reg             up_hdmi_oos = 'd0;
  reg             up_vdma_ovf_m1 = 'd0;
  reg             up_vdma_ovf = 'd0;
  reg             up_vdma_unf_m1 = 'd0;
  reg             up_vdma_unf = 'd0;
  reg             up_vdma_tpm_oos_m1 = 'd0;
  reg             up_vdma_tpm_oos = 'd0;

  wire            up_wr_s;
  wire            up_ack_s;
  wire            up_hdmi_hs_toggle_s;
  wire            up_hdmi_vs_toggle_s;
  wire            hdmi_hs_count_mismatch_s;
  wire            hdmi_hs_count_toggle_s;
  wire    [15:0]  hdmi_hs_count_s;
  wire            hdmi_vs_count_mismatch_s;
  wire            hdmi_vs_count_toggle_s;
  wire    [15:0]  hdmi_vs_count_s;
  wire            hdmi_tpm_oos_s;
  wire            hdmi_oos_s;
  wire            hdmi_fs_toggle_s;
  wire    [ 8:0]  hdmi_fs_waddr_s;
  wire            hdmi_wr_s;
  wire    [ 8:0]  hdmi_waddr_s;
  wire    [48:0]  hdmi_wdata_s;
  wire            hdmi_waddr_rel_toggle_s;
  wire    [ 8:0]  hdmi_waddr_rel_s;
  wire    [ 8:0]  hdmi_waddr_g_s;
  wire            vdma_ovf_s;
  wire            vdma_unf_s;
  wire            vdma_tpm_oos_s;

  // processor write interface (see regmap.txt for details)

  assign up_wr_s = up_sel & ~up_rwn;
  assign up_ack_s = up_sel_d & ~up_sel_2d;

  // Whenever a register write happens up_toggle is toggled to notify the HDMI
  // clock domain that it should update its registers. We need to be careful
  // though to not toggle to fast, e.g. if the HDMI clock is running at slower
  // rate than the AXI clock it is possible that two consecutive writes happen
  // so fast that the toggled signal is not seen in the HDMI domain. Hence we
  // synchronize the toggle signal from the HDMI domain back to the AXI domain.
  // And only if both signals match, the original toggle signal and the one
  // returned from the HDMI domain, we may toggle again.
  reg [1:0] up_toggle_ret;
  reg up_pending;
  reg up_toggle;
  wire hdmi_up_toggle_ret;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_toggle <= 'b0;
      up_toggle_ret <= 'b0;
    end else begin
      up_toggle_ret[0] <= hdmi_up_toggle_ret;
      up_toggle_ret[1] <= up_toggle_ret[0];
      if (up_wr_s == 1'b1) begin
		  up_pending <= 1'b1;
		end else if (up_pending == 1'b1 && up_toggle_ret[1] == up_toggle) begin
		  up_toggle <= ~up_toggle;
		  up_pending <= 1'b0;
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_crcb_init <= 'd0;
      up_align_right <= 'd0;
      up_tpg_enable <= 'd0;
      up_csc_bypass <= 'd0;
      up_edge_sel <= 'd0;
      up_enable <= 'd0;
      up_vs_count <= 'd0;
      up_hs_count <= 'd0;
      up_hdmi_hs_mismatch_hold <= 'd0;
      up_hdmi_vs_mismatch_hold <= 'd0;
      up_hdmi_oos_hold <= 'd0;
      up_hdmi_tpm_oos_hold <= 'd0;
      up_vdma_ovf_hold <= 'd0;
      up_vdma_unf_hold <= 'd0;
      up_vdma_tpm_oos_hold <= 'd0;
      up_status <= 'd0;
    end else begin
      if ((up_addr == 5'h1) && (up_wr_s == 1'b1)) begin
        up_crcb_init <= up_wdata[5];
        up_align_right <= up_wdata[4];
        up_tpg_enable <= up_wdata[3];
        up_csc_bypass <= up_wdata[2];
        up_edge_sel <= up_wdata[1];
        up_enable <= up_wdata[0];
      end
      if ((up_addr == 5'h2) && (up_wr_s == 1'b1)) begin
        up_vs_count <= up_wdata[31:16];
        up_hs_count <= up_wdata[15:0];
      end
      if (up_hdmi_hs_mismatch == 1'b1) begin
        up_hdmi_hs_mismatch_hold <= 1'b1;
      end else if ((up_addr == 5'h3) && (up_wr_s == 1'b1)) begin
        up_hdmi_hs_mismatch_hold <= up_hdmi_hs_mismatch_hold & ~up_wdata[6];
      end
      if (up_hdmi_vs_mismatch == 1'b1) begin
        up_hdmi_vs_mismatch_hold <= 1'b1;
      end else if ((up_addr == 5'h3) && (up_wr_s == 1'b1)) begin
        up_hdmi_vs_mismatch_hold <= up_hdmi_vs_mismatch_hold & ~up_wdata[5];
      end
      if (up_hdmi_oos == 1'b1) begin
        up_hdmi_oos_hold <= 1'b1;
      end else if ((up_addr == 5'h3) && (up_wr_s == 1'b1)) begin
        up_hdmi_oos_hold <= up_hdmi_oos_hold & ~up_wdata[4];
      end
      if (up_hdmi_tpm_oos == 1'b1) begin
        up_hdmi_tpm_oos_hold <= 1'b1;
      end else if ((up_addr == 5'h3) && (up_wr_s == 1'b1)) begin
        up_hdmi_tpm_oos_hold <= up_hdmi_tpm_oos_hold & ~up_wdata[3];
      end
      if (up_vdma_ovf == 1'b1) begin
        up_vdma_ovf_hold <= 1'b1;
      end else if ((up_addr == 5'h3) && (up_wr_s == 1'b1)) begin
        up_vdma_ovf_hold <= up_vdma_ovf_hold & ~up_wdata[2];
      end
      if (up_vdma_unf == 1'b1) begin
        up_vdma_unf_hold <= 1'b1;
      end else if ((up_addr == 5'h3) && (up_wr_s == 1'b1)) begin
        up_vdma_unf_hold <= up_vdma_unf_hold & ~up_wdata[1];
      end
      if (up_vdma_tpm_oos == 1'b1) begin
        up_vdma_tpm_oos_hold <= 1'b1;
      end else if ((up_addr == 5'h3) && (up_wr_s == 1'b1)) begin
        up_vdma_tpm_oos_hold <= up_vdma_tpm_oos_hold & ~up_wdata[0];
      end
      up_status <= {up_enable, (up_hdmi_hs_mismatch_hold | up_hdmi_vs_mismatch_hold | up_hdmi_oos_hold),
        (up_hdmi_tpm_oos_hold | up_vdma_tpm_oos_hold), (up_vdma_ovf_hold | up_vdma_unf_hold)};
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rdata <= 'd0;
      up_sel_d <= 'd0;
      up_sel_2d <= 'd0;
      up_ack <= 'd0;
    end else begin
      case (up_addr)
        5'h0: up_rdata <= 32'h00010061;
        5'h1: up_rdata <= {26'd0, up_crcb_init, up_align_right, up_tpg_enable,
                            up_csc_bypass, up_edge_sel, up_enable};
        5'h2: up_rdata <= {up_vs_count, up_hs_count};
        5'h3: up_rdata <= {25'd0, up_hdmi_hs_mismatch_hold, up_hdmi_vs_mismatch_hold,
                            up_hdmi_oos_hold, up_hdmi_tpm_oos_hold, up_vdma_ovf_hold,
                            up_vdma_unf_hold, up_vdma_tpm_oos_hold};
        5'h4: up_rdata <= {up_hdmi_vs, up_hdmi_hs};
        default: up_rdata <= 0;
      endcase
      up_sel_d <= up_sel;
      up_sel_2d <= up_sel_d;
      up_ack <= up_ack_s;
    end
  end

  // the hdmi data signals are transferred to the processor side using toggles
  // others are simply double registered

  assign up_hdmi_hs_toggle_s = up_hdmi_hs_toggle_m3 ^ up_hdmi_hs_toggle_m2;
  assign up_hdmi_vs_toggle_s = up_hdmi_vs_toggle_m3 ^ up_hdmi_vs_toggle_m2;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_hdmi_hs_toggle_m1 <= 'd0;
      up_hdmi_hs_toggle_m2 <= 'd0;
      up_hdmi_hs_toggle_m3 <= 'd0;
      up_hdmi_hs_mismatch <= 'd0;
      up_hdmi_hs <= 'd0;
      up_hdmi_vs_toggle_m1 <= 'd0;
      up_hdmi_vs_toggle_m2 <= 'd0;
      up_hdmi_vs_toggle_m3 <= 'd0;
      up_hdmi_vs_mismatch <= 'd0;
      up_hdmi_vs <= 'd0;
      up_hdmi_tpm_oos_m1 <= 'd0;
      up_hdmi_tpm_oos <= 'd0;
      up_hdmi_oos_m1 <= 'd0;
      up_hdmi_oos <= 'd0;
      up_vdma_ovf_m1 <= 'd0;
      up_vdma_ovf <= 'd0;
      up_vdma_unf_m1 <= 'd0;
      up_vdma_unf <= 'd0;
      up_vdma_tpm_oos_m1 <= 'd0;
      up_vdma_tpm_oos <= 'd0;
    end else begin
      up_hdmi_hs_toggle_m1 <= hdmi_hs_count_toggle_s;
      up_hdmi_hs_toggle_m2 <= up_hdmi_hs_toggle_m1;
      up_hdmi_hs_toggle_m3 <= up_hdmi_hs_toggle_m2;
      if (up_hdmi_hs_toggle_s == 1'b1) begin
        up_hdmi_hs_mismatch <= hdmi_hs_count_mismatch_s;
        up_hdmi_hs <= hdmi_hs_count_s;
      end
      up_hdmi_vs_toggle_m1 <= hdmi_vs_count_toggle_s;
      up_hdmi_vs_toggle_m2 <= up_hdmi_vs_toggle_m1;
      up_hdmi_vs_toggle_m3 <= up_hdmi_vs_toggle_m2;
      if (up_hdmi_vs_toggle_s == 1'b1) begin
        up_hdmi_vs_mismatch <= hdmi_vs_count_mismatch_s;
        up_hdmi_vs <= hdmi_vs_count_s;
      end
      up_hdmi_tpm_oos_m1 <= hdmi_tpm_oos_s;
      up_hdmi_tpm_oos <= up_hdmi_tpm_oos_m1;
      up_hdmi_oos_m1 <= hdmi_oos_s;
      up_hdmi_oos <= up_hdmi_oos_m1;
      up_vdma_ovf_m1 <= vdma_ovf_s;
      up_vdma_ovf <= up_vdma_ovf_m1;
      up_vdma_unf_m1 <= vdma_unf_s;
      up_vdma_unf <= up_vdma_unf_m1;
      up_vdma_tpm_oos_m1 <= vdma_tpm_oos_s;
      up_vdma_tpm_oos <= up_vdma_tpm_oos_m1;
    end
  end

  // hdmi interface

  cf_h2v_hdmi i_hdmi (
    .hdmi_clk (hdmi_clk),
    .hdmi_data (hdmi_data),
    .hdmi_hs_count_mismatch (hdmi_hs_count_mismatch_s),
    .hdmi_hs_count_toggle (hdmi_hs_count_toggle_s),
    .hdmi_hs_count (hdmi_hs_count_s),
    .hdmi_vs_count_mismatch (hdmi_vs_count_mismatch_s),
    .hdmi_vs_count_toggle (hdmi_vs_count_toggle_s),
    .hdmi_vs_count (hdmi_vs_count_s),
    .hdmi_tpm_oos (hdmi_tpm_oos_s),
    .hdmi_oos (hdmi_oos_s),
    .hdmi_fs_toggle (hdmi_fs_toggle_s),
    .hdmi_fs_waddr (hdmi_fs_waddr_s),
    .hdmi_wr (hdmi_wr_s),
    .hdmi_waddr (hdmi_waddr_s),
    .hdmi_wdata (hdmi_wdata_s),
    .hdmi_waddr_rel_toggle (hdmi_waddr_rel_toggle_s),
    .hdmi_waddr_rel (hdmi_waddr_rel_s),
    .hdmi_waddr_g (hdmi_waddr_g_s),
    .up_toggle (up_toggle),
    .hdmi_up_toggle_ret (hdmi_up_toggle_ret),
    .up_enable (up_enable),
    .up_crcb_init (up_crcb_init),
    .up_edge_sel (up_edge_sel),
    .up_hs_count (up_hs_count),
    .up_vs_count (up_vs_count),
    .up_csc_bypass (up_csc_bypass),
    .up_tpg_enable (up_tpg_enable),
    .debug_data (hdmi_dbg_data),
    .debug_trigger (hdmi_dbg_trigger));

  // vdma interface

  cf_h2v_vdma i_vdma (
    .hdmi_clk (hdmi_clk),
    .hdmi_fs_toggle (hdmi_fs_toggle_s),
    .hdmi_fs_waddr (hdmi_fs_waddr_s),
    .hdmi_wr (hdmi_wr_s),
    .hdmi_waddr (hdmi_waddr_s),
    .hdmi_wdata (hdmi_wdata_s),
    .hdmi_waddr_rel_toggle (hdmi_waddr_rel_toggle_s),
    .hdmi_waddr_rel (hdmi_waddr_rel_s),
    .hdmi_waddr_g (hdmi_waddr_g_s),
    .vdma_clk (vdma_clk),
    .vdma_fs (vdma_fs),
    .vdma_fs_ret (vdma_fs_ret),
    .vdma_valid (vdma_valid),
    .vdma_be (vdma_be),
    .vdma_data (vdma_data),
    .vdma_last (vdma_last),
    .vdma_ready (vdma_ready),
    .vdma_ovf (vdma_ovf_s),
    .vdma_unf (vdma_unf_s),
    .vdma_tpm_oos (vdma_tpm_oos_s),
    .up_align_right (up_align_right),
    .debug_data (vdma_dbg_data),
    .debug_trigger (vdma_dbg_trigger));

endmodule

// ***************************************************************************
// ***************************************************************************