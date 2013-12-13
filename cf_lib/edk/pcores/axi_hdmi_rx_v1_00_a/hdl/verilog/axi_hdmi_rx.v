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
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; Loos OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE PoosIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

module axi_hdmi_rx (

  // hdmi interface

  hdmi_clk,
  hdmi_data,

  // vdma interface
  video_clk,
  video_valid,
  video_data,
  video_overflow,
  video_sync,

  // processor interface

  s_axi_aclk,
  s_axi_aresetn,

  s_axi_awvalid,
  s_axi_awaddr,
  s_axi_awready,
  s_axi_wvalid,
  s_axi_wdata,
  s_axi_wstrb,
  s_axi_wready,
  s_axi_bvalid,
  s_axi_bresp,
  s_axi_bready,
  s_axi_arvalid,
  s_axi_araddr,
  s_axi_arready,
  s_axi_rvalid,
  s_axi_rresp,
  s_axi_rdata,
  s_axi_rready,

  // debug interface (chipscope)

  hdmi_dbg_data,
  hdmi_dbg_trigger);

  // parameters

  parameter   C_BASEADDR = 32'hffffffff;
  parameter   C_HIGHADDR = 32'h00000000;
  parameter   PCORE_ID = 1234;
  localparam  PCORE_VERSION = 0;

  // hdmi interface

  input           hdmi_clk;
  input   [15:0]  hdmi_data;

  // vdma interface

  output          video_clk;
  output          video_valid;
  output  [63:0]  video_data;
  input           video_overflow;
  output          video_sync;

  // processor interface

  input           s_axi_aresetn;
  input           s_axi_aclk;
  input           s_axi_awvalid;
  input   [31:0]  s_axi_awaddr;
  output          s_axi_awready;
  input           s_axi_wvalid;
  input   [31:0]  s_axi_wdata;
  input   [ 3:0]  s_axi_wstrb;
  output          s_axi_wready;
  output          s_axi_bvalid;
  output  [ 1:0]  s_axi_bresp;
  input           s_axi_bready;
  input           s_axi_arvalid;
  input   [31:0]  s_axi_araddr;
  output          s_axi_arready;
  output          s_axi_rvalid;
  output  [ 1:0]  s_axi_rresp;
  output  [31:0]  s_axi_rdata;
  input           s_axi_rready;

  wire    [31:0]  up_wdata;
  wire    [13:0]  up_addr;

  // debug interface (chipscope)

  output  [61:0]  hdmi_dbg_data;
  output  [ 7:0]  hdmi_dbg_trigger;

  reg     [31:0]  up_scratch = 'h0;
  reg             up_packed = 'd0;
  reg             up_bgr = 'd0;
  reg             up_tpg_enable = 'd0;
  reg             up_csc_bypass = 'd0;
  reg             up_edge_sel = 'd0;
  reg             up_enable = 'd0;
  reg     [15:0]  up_vs_count = 'd0;
  reg     [15:0]  up_hs_count = 'd0;
  reg     [ 3:0]  up_status = 'd0;
  reg     [31:0]  up_rdata = 'd0;
 
  wire            up_wr_s;
  wire            up_hdmi_hs_mismatch;
  wire            up_hdmi_vs_mismatch;
  wire    [15:0]  up_hdmi_hs;
  wire    [15:0]  up_hdmi_vs;
  wire            hdmi_hs_count_mismatch_s;
  wire            hdmi_hs_count_update;
  wire    [15:0]  hdmi_hs_count_s;
  wire            hdmi_vs_count_mismatch_s;
  wire            hdmi_vs_count_update;
  wire    [15:0]  hdmi_vs_count_s;
  wire            hdmi_tpm_oos_s;
  wire            hdmi_oos_s;
  wire            hdmi_soos_hs_s;
  wire            hdmi_oos_vs_s;
  wire            hdmi_wr_s;
  wire    [64:0]  hdmi_wdata_s;
  wire            up_hdmi_tpm_oos;
  wire            up_hdmi_oos;
  wire            up_hdmi_oos_hs;
  wire            up_hdmi_oos_vs;

  wire            hdmi_up_enable;
  wire            hdmi_up_edge_sel;
  wire    [15:0]  hdmi_up_hs_count;
  wire    [15:0]  hdmi_up_vs_count;
  wire            hdmi_up_csc_bypass;
  wire            hdmi_up_tpg_enable;
  wire            hdmi_up_packed;

  up_axi #(
    .PCORE_BASEADDR (C_BASEADDR),
    .PCORE_HIGHADDR (C_HIGHADDR)
  ) i_up_axi (
    .up_rstn(s_axi_aresetn),
    .up_clk(s_axi_aclk),
    .up_axi_awvalid(s_axi_awvalid),
    .up_axi_awaddr(s_axi_awaddr),
    .up_axi_awready(s_axi_awready),
    .up_axi_wvalid(s_axi_wvalid),
    .up_axi_wdata(s_axi_wdata),
    .up_axi_wstrb(s_axi_wstrb),
    .up_axi_wready(s_axi_wready),
    .up_axi_bvalid(s_axi_bvalid),
    .up_axi_bresp(s_axi_bresp),
    .up_axi_bready(s_axi_bready),
    .up_axi_arvalid(s_axi_arvalid),
    .up_axi_araddr(s_axi_araddr),
    .up_axi_arready(s_axi_arready),
    .up_axi_rvalid(s_axi_rvalid),
    .up_axi_rresp(s_axi_rresp),
    .up_axi_rdata(s_axi_rdata),
    .up_axi_rready(s_axi_rready),
    .up_wr(up_wr_s),
    .up_addr(up_addr),
    .up_wdata(up_wdata),
    .up_rdata(up_rdata),
    .up_ack(1'b1));

 
  wire [3:0] up_hdmi_status = {up_hdmi_oos_vs, up_hdmi_oos_hs, up_hdmi_vs_mismatch, up_hdmi_hs_mismatch};
  reg up_vdma_ovf_hold;
  reg up_hdmi_tpm_oos_hold;
  reg [3:0] up_hdmi_status_hold;

  // processor write interface (see regmap.txt for details)

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 0) begin
      up_packed <= 'd0;
      up_bgr <= 1'b0;
      up_tpg_enable <= 'd0;
      up_csc_bypass <= 'd0;
      up_edge_sel <= 'd0;
      up_enable <= 'd0;
      up_vs_count <= 'd0;
      up_hs_count <= 'd0;
      up_hdmi_status_hold <= 'd0;
      up_status <= 'd0;
    end else begin
	  if (up_wr_s == 1'b1) begin
		  case (up_addr[11:0])
		  12'h002: begin
			up_scratch <= up_wdata;
		  end
		  12'h010: begin
		    up_enable <= up_wdata[0];
		  end
		  12'h011: begin
		    up_bgr <= up_wdata[2];
		    up_packed <= up_wdata[1];
			up_csc_bypass <= up_wdata[0];
		  end
		  12'h012: begin
			up_tpg_enable <= up_wdata[0];
		  end
		  12'h100: begin
			up_vs_count <= up_wdata[31:16];
			up_hs_count <= up_wdata[15:0];
		  end
		  endcase
	  end
      if ((up_addr[11:0] == 12'h018) && (up_wr_s == 1'b1))
        up_vdma_ovf_hold <= (up_vdma_ovf_hold & ~up_wdata[0]) | up_vdma_ovf;
      else
        up_vdma_ovf_hold <= up_vdma_ovf_hold | up_vdma_ovf;
      if ((up_addr[11:0] == 12'h019) && (up_wr_s == 1'b1))
        up_hdmi_tpm_oos_hold <= (up_hdmi_tpm_oos_hold & ~up_wdata[0]) | up_hdmi_tpm_oos;
      else
        up_hdmi_tpm_oos_hold <= up_hdmi_tpm_oos_hold | up_hdmi_tpm_oos;
      if ((up_addr[11:0] == 12'h020) && (up_wr_s == 1'b1))
        up_hdmi_status_hold <= (up_hdmi_status_hold & ~up_wdata[3:0]) | up_hdmi_status;
      else
        up_hdmi_status_hold <= up_hdmi_status_hold | up_hdmi_status;
    end
  end

  // processor read interface

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_rdata <= 'd0;
    end else begin
      case (up_addr[11:0])
        12'h000: up_rdata <= PCORE_VERSION;
        12'h001: up_rdata <= PCORE_ID;
		12'h002: up_rdata <= up_scratch;
		12'h010: up_rdata <= {31'h0, up_enable};
		12'h011: up_rdata <= {29'h0, up_bgr, up_packed, up_csc_bypass};
		12'h012: up_rdata <= {31'h0, up_tpg_enable};
		12'h018: up_rdata <= {30'h0, up_vdma_ovf_hold, 1'b0};
		12'h019: up_rdata <= {30'h0, up_hdmi_tpm_oos_hold, 1'b0};
		12'h020: up_rdata <= {28'h0, up_hdmi_status_hold};
        12'h100: up_rdata <= {up_vs_count, up_hs_count};
        12'h101: up_rdata <= {up_hdmi_vs, up_hdmi_hs};
        default: up_rdata <= 0;
      endcase
    end
  end

  // Whenever a register write happens up_toggle is toggled to notify the HDMI
  // clock domain that it should update its registers. We need to be careful
  // though to not toggle to fast, e.g. if the HDMI clock is running at slower
  // rate than the AXI clock it is poosible that two consecutive writes happen
  // so fast that the toggled signal is not seen in the HDMI domain. Hence we
  // synchronize the toggle signal from the HDMI domain back to the AXI domain.
  // And only if both signals match, the original toggle signal and the one
  // returned from the HDMI domain, we may toggle again.
  reg up_pending;
  wire up_busy;

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_pending <= 1'b0;
    end else begin
      if (up_wr_s == 1'b1) begin
        up_pending <= 1'b1;
      end else if (up_pending & ~up_busy) begin
        up_pending <= 1'b0;
      end
    end
  end

	sync_flag #(
		.DATA_WIDTH(38),
		.IN_HOLD(1),
		.OUT_HOLD(1)
	) up_wr_sync (
		.rstn(s_axi_aresetn),
		.in_clk(s_axi_aclk),
		.in_flag(up_pending & ~up_busy),
		.in_busy(up_busy),
		.out_clk(hdmi_clk),
		.in_data({
			up_hs_count,
			up_vs_count,
			up_enable,
			up_edge_sel,
			up_csc_bypass,
			up_tpg_enable,
			up_packed,
			up_bgr
		}),
		.out_data({
			hdmi_up_hs_count,
			hdmi_up_vs_count,
			hdmi_up_enable,
			hdmi_up_edge_sel,
			hdmi_up_csc_bypass,
			hdmi_up_tpg_enable,
			hdmi_up_packed,
			hdmi_up_bgr
		})
	);

	// Synchronize the detected horizontal resolution to the AXI clock domain.
	// hdmi_hs_count_update will be high for one hdmi_clk cycle whenever the
	// resolution is update.
	sync_flag #(
		.DATA_WIDTH(17),
		.OUT_HOLD(1)
	) hdmi_hs_count_update_sync(
		.rstn(s_axi_aresetn),
		.in_clk(hdmi_clk),
		.in_flag(hdmi_hs_count_update),
		.out_clk(s_axi_aclk),
		.in_data({
			hdmi_hs_count_mismatch_s,
			hdmi_hs_count_s
		}),
		.out_data({
			up_hdmi_hs_mismatch,
			up_hdmi_hs
		})
	);

	// Synchronize the detected vertical resolution to the AXI clock domain.
	// hdmi_vs_count_update will be high for one hdmi_clk cycle whenever the
	// resolution is update.
	sync_flag #(
		.DATA_WIDTH(17),
		.OUT_HOLD(1)
	) hdmi_vs_de_sync(
		.rstn(s_axi_aresetn),
		.in_clk(hdmi_clk),
		.in_flag(hdmi_vs_count_update),
		.out_clk(s_axi_aclk),
		.in_data({
			hdmi_vs_count_mismatch_s,
			hdmi_vs_count_s
		}),
		.out_data({
			up_hdmi_vs_mismatch,
			up_hdmi_vs
		})
	);

	// Synchronize status bits to the AXI clock domain
	sync_bits #(
		.NUM_BITS(2)
	) status_sync (
		.out_resetn(s_axi_aresetn),
		.out_clk(s_axi_aclk),
		.in({
			hdmi_oos_hs_s,
			hdmi_oos_vs_s
		}),
		.out({
			up_hdmi_oos_hs,
			up_hdmi_oos_vs
		})
	);

	sync_flag sync_hdmi_tpm_oos (
		.rstn(s_axi_aresetn),
		.in_clk(hdmi_clk),
		.in_flag(hdmi_tpm_oos_s),
		.out_clk(s_axi_aclk),
		.out_flag(up_hdmi_tpm_oos)
	);

	// It is not unlikely that the ovf condition is asserted for multiple clock
	// cycles. So we need to make sure to not toggle to often, otherwise it might
	// be missed in the target domain.
	wire ovf_busy;
	sync_flag sync_vdma_ovf (
		.rstn(s_axi_aresetn),
		.in_clk(hdmi_clk),
		.in_flag(~ovf_busy & video_overflow),
		.in_busy(ovf_busy),
		.out_clk(s_axi_aclk),
		.out_flag(up_vdma_ovf)
	);

	assign video_clk = hdmi_clk;
	assign video_data = hdmi_wdata_s[63:0];
	assign video_sync = hdmi_wdata_s[64];
	assign video_valid = hdmi_wr_s;

	// hdmi interface

	axi_hdmi_rx_core i_hdmi_rx_core (
		.hdmi_clk(hdmi_clk),
		.hdmi_data(hdmi_data),
		.hdmi_hs_count_mismatch(hdmi_hs_count_mismatch_s),
		.hdmi_hs_count_update(hdmi_hs_count_update),
		.hdmi_hs_count(hdmi_hs_count_s),
		.hdmi_vs_count_mismatch(hdmi_vs_count_mismatch_s),
		.hdmi_vs_count_update(hdmi_vs_count_update),
		.hdmi_vs_count(hdmi_vs_count_s),
		.hdmi_tpm_oos(hdmi_tpm_oos_s),
		.hdmi_oos_hs(hdmi_oos_hs_s),
		.hdmi_oos_vs(hdmi_oos_vs_s),
		.hdmi_wr(hdmi_wr_s),
		.hdmi_wdata(hdmi_wdata_s),
		.hdmi_up_enable(hdmi_up_enable),
		.hdmi_up_edge_sel(hdmi_up_edge_sel),
		.hdmi_up_hs_count(hdmi_up_hs_count),
		.hdmi_up_vs_count(hdmi_up_vs_count),
		.hdmi_up_csc_bypass(hdmi_up_csc_bypass),
		.hdmi_up_tpg_enable(hdmi_up_tpg_enable),
		.hdmi_up_packed(hdmi_up_packed),
		.hdmi_up_bgr(hdmi_up_bgr),
		.debug_data(hdmi_dbg_data),
		.debug_trigger(hdmi_dbg_trigger)
	);

endmodule
