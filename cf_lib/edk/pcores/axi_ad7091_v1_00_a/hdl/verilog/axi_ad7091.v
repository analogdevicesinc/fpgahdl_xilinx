// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
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

`timescale 1ns/1ns //Use a timescale that is best for simulation.

//------------------------------------------------------------------------------
//----------- Module Declaration -----------------------------------------------
//------------------------------------------------------------------------------
module axi_ad7091(/*autoport*/
//output
        // physical
        adc_sclk_o,
        adc_cnv_o,
        adc_cs_n_o,
        // master-slave
        adc_start_o,
        dma_start_o,
        // dma
        s_axis_s2mm_tvalid,
        s_axis_s2mm_tdata,
        s_axis_s2mm_tlast,
        s_axis_s2mm_tkeep,
        // axi
        s_axi_awready,
        s_axi_wready,
        s_axi_bvalid,
        s_axi_arready,
        s_axi_rvalid,
        s_axi_rdata,
        s_axi_bresp,
        s_axi_rresp,
        // monitor/debug
        adc_mon_trig_o,
        adc_mon_data_o,
//input
        // clocks
        ref_clk_i,
        rx_clk_i,
        //physical
        adc_sdo_i,
        // master-slave
        adc_start_i,
        dma_start_i,
        // dma
        s_axis_s2mm_clk,
        s_axis_s2mm_tready,
        // axi
        s_axi_aclk,
        s_axi_aresetn,
        s_axi_awvalid,
        s_axi_awaddr,
        s_axi_wvalid,
        s_axi_wdata,
        s_axi_bready,
        s_axi_arvalid,
        s_axi_araddr,
        s_axi_rready,
        s_axi_wstrb
        );

    // core parameters
    parameter PCORE_ID = 0;
    parameter PCORE_DEVICE_TYPE = 0;
    parameter PCORE_IODELAY_GROUP = "adc_if_delay_group";
    parameter C_S_AXI_MIN_SIZE = 32'hffff;
    parameter C_BASEADDR = 32'hffffffff;
    parameter C_HIGHADDR = 32'h00000000;

    // physical interface
    input           ref_clk_i;
    input           rx_clk_i;
    input           adc_sdo_i;
    output          adc_sclk_o;
    output          adc_cnv_o;
    output          adc_cs_n_o;
    // master-slave interface
    output          adc_start_o;
    output          dma_start_o;
    input           adc_start_i;
    input           dma_start_i;
    // DMA interface
    input           s_axis_s2mm_clk;
    output          s_axis_s2mm_tvalid;
    output  [31:0]  s_axis_s2mm_tdata;
    output  [ 3:0]  s_axis_s2mm_tkeep;
    output          s_axis_s2mm_tlast;
    input           s_axis_s2mm_tready;
    // AXI interface
    input           s_axi_aclk;
    input           s_axi_aresetn;
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
    // debug signals
    output  [7:0]   adc_mon_trig_o;
    output  [31:0]  adc_mon_data_o;

    // register input/outputs
    reg             adc_start_o;

    // internal clock and reset
    wire            dma_clk_s;
    wire            up_rstn_s;
    wire            up_clk_s;
    wire            adc_rst_s;
    wire            adc_clk;

    // internal signals
    wire            data_rd_ready_s;
    wire [15:0]     adc_data_s;
    wire            adc_status_s;
    wire            adc_start_s;
    wire [31:0]     pid_s;
    wire            dma_start_s;
    wire [31:0]     dma_data_s;
    wire            dma_valid_s;
    wire            dma_last_s;
    wire            dma_ovf_s;
    wire            dma_unf_s;
    wire            dma_status_s;
    wire [31:0]     dma_bw_s;
    wire            dma_rst_s;
    wire            dma_ready_s;
    wire            dma_stream_s;
    wire [31:0]     dma_count_s;
    wire [31:0]     up_adc_common_rdata_s;
    wire            up_adc_common_ack_s;
    wire            up_sel_s;
    wire            up_wr_s;
    wire [13:0]     up_addr_s;
    wire [31:0]     up_wdata_s;

    // registers
    reg             adc_valid   = 0;
    reg [31:0]      adc_data    = 32'b0;
    reg [31:0]      up_rdata    = 32'b0;
    reg             up_ack      = 1'b0;

    // signal assignments
    assign dma_clk_s            = s_axis_s2mm_clk;
    assign dma_ready_s          = s_axis_s2mm_tready;
    assign up_clk_s             = s_axi_aclk;
    assign up_rstn_s            = s_axi_aresetn;
    assign s_axis_s2mm_tvalid   = dma_valid_s;
    assign s_axis_s2mm_tdata    = dma_data_s;
    assign s_axis_s2mm_tlast    = dma_last_s;
    assign s_axis_s2mm_tkeep    = 4'hf;
    assign adc_clk              = s_axi_aclk;

    // monitor / debug signals
    assign adc_mon_trig_o = {4'h0, dma_clk_s, dma_start_s, s_axi_aclk, data_rd_ready_s};
    assign adc_mon_data_o[15: 0] = adc_data[15:0];
    assign adc_mon_data_o[31:16] = 16'h0;

    // multiple instances synchronization
    assign pid_s        = 32'd0;
    assign adc_start_s  = (pid_s == 32'd0) ? adc_start_o : adc_start_i;
    assign dma_start_s  = (pid_s == 32'd0) ? dma_start_o : dma_start_i;

    always @(posedge adc_clk) begin
        if (adc_rst_s == 1'b1) begin
            adc_start_o <= 1'b0;
        end else begin
            adc_start_o <= 1'b1;
        end
    end

    // adc channels - dma interface
    always @(posedge adc_clk)
    begin
        adc_valid <= data_rd_ready_s;
        adc_data  <= { 16'h0, adc_data_s };
    end

    // processor read interface
    always @(negedge up_rstn_s or posedge up_clk_s) begin
        if (up_rstn_s == 0) begin
            up_rdata  <= 'd0;
            up_ack    <= 'd0;
        end else begin
            up_rdata  <= up_adc_common_rdata_s;
            up_ack    <= up_adc_common_ack_s;
        end
    end

    // device interface instance
    axi_ad7091_dev_if #(
        .ADC_DATAREADY_WIDTH (1)
                ) axi_ad7091_dev_if_inst(/*autoinst*/
        .data_o(adc_data_s),
        .data_rd_ready_o(data_rd_ready_s),
        .adc_sclk_o(adc_sclk_o),
        .adc_cs_n_o(adc_cs_n_o),
        .adc_convst_n_o(adc_cnv_o),
        .fpga_clk_i(ref_clk_i),
        .adc_clk_i(rx_clk_i),
        .reset_i(adc_rst_s),
        .adc_sdo_i(adc_sdo_i),
        .adc_status_o(adc_status_s)
        );

    // DMA transfer instance
    dma_core #(
        .DATA_WIDTH (32)
               ) dma_core_inst(/*autoinst*/
        .dma_valid(dma_valid_s),
        .dma_last(dma_last_s),
        .dma_data(dma_data_s),
        .dma_ovf(dma_ovf_s),
        .dma_unf(dma_unf_s),
        .dma_status(dma_status_s),
        .dma_bw(dma_bw_s),
        .dma_clk(dma_clk_s),
        .dma_rst(dma_rst_s),
        .dma_ready(dma_ready_s),
        .adc_clk(adc_clk),
        .adc_rst(adc_rst_s),
        .adc_valid(adc_valid),
        .adc_data(adc_data),
        .dma_start(dma_start_s),
        .dma_stream(dma_stream_s),
        .dma_count(dma_count_s));

    // common processor control
    up_adc_common up_adc_common_inst(/*autoinst*/
        .mmcm_rst(),
        .delay_clk(1'b0),
        .delay_ack_t(),
        .delay_locked(),
        .delay_rst(),
        .delay_sel(),
        .delay_rwn(),
        .delay_addr(),
        .delay_wdata(),
        .delay_rdata(5'b0),
        .adc_rst(adc_rst_s),
        .adc_r1_mode(),
        .adc_ddr_edgesel(),
        .adc_pin_mode(),
        .adc_clk(adc_clk),
        .adc_status(adc_status_s),
        .adc_status_pn_err(),
        .adc_status_pn_oos(),
        .adc_status_or(),
        .adc_clk_ratio(32'b1),
        .drp_clk(1'b0),
        .drp_rdata(16'b0),
        .drp_ack_t(1'b0),
        .drp_rst(),
        .drp_sel(),
        .drp_wr(),
        .drp_addr(),
        .drp_wdata(),
        .dma_rst(dma_rst_s),
        .dma_start(dma_start_o),
        .dma_stream(dma_stream_s),
        .dma_count(dma_count_s),
        .dma_clk(dma_clk_s),
        .dma_ovf(dma_ovf_s),
        .dma_unf(dma_unf_s),
        .dma_status(dma_status_s),
        .dma_bw(dma_bw_s),
        .up_rstn(up_rstn_s),
        .up_clk(up_clk_s),
        .up_sel(up_sel_s),
        .up_wr(up_wr_s),
        .up_addr(up_addr_s),
        .up_wdata(up_wdata_s),
        .up_rdata(up_adc_common_rdata_s),
        .up_ack(up_adc_common_ack_s),
        .up_usr_chanmax(),
        .adc_usr_chanmax(8'b0)
    );

    // AXI wrapper instance
    up_axi #(
        .PCORE_BASEADDR (C_BASEADDR),
        .PCORE_HIGHADDR (C_HIGHADDR))
    up_axi_inst(/*autoinst*/
        .up_axi_awready(s_axi_awready),
        .up_axi_wready(s_axi_wready),
        .up_axi_bvalid(s_axi_bvalid),
        .up_axi_arready(s_axi_arready),
        .up_axi_rvalid(s_axi_rvalid),
        .up_axi_rdata(s_axi_rdata),
        .up_sel(up_sel_s),
        .up_wr(up_wr_s),
        .up_addr(up_addr_s),
        .up_wdata(up_wdata_s),
        .up_rstn(up_rstn_s),
        .up_clk(up_clk_s),
        .up_axi_awvalid(s_axi_awvalid),
        .up_axi_awaddr(s_axi_awaddr),
        .up_axi_wvalid(s_axi_wvalid),
        .up_axi_wdata(s_axi_wdata),
        .up_axi_bready(s_axi_bready),
        .up_axi_arvalid(s_axi_arvalid),
        .up_axi_araddr(s_axi_araddr),
        .up_axi_rready(s_axi_rready),
        .up_rdata(up_rdata),
        .up_ack(up_ack),
        .up_axi_wstrb(s_axi_wstrb),
        .up_axi_bresp(s_axi_bresp),
        .up_axi_rresp(s_axi_rresp));

endmodule
