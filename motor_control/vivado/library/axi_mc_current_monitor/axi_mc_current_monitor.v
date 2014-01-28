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

`timescale 1ns/100ps

module axi_mc_current_monitor
#(

    parameter PCORE_ID = 0,
    parameter PCORE_DEVICE_TYPE = 0,
    parameter PCORE_IODELAY_GROUP = "adc_if_delay_group",
    parameter C_S_AXI_MIN_SIZE = 32'hffff,
    parameter C_BASEADDR = 32'hffffffff,
    parameter C_HIGHADDR = 32'h00000000
)

(

// physical interface

    input   adc_ia_dat_i,
    output  adc_ia_clk_o,
    input   adc_ib_dat_i,
    output  adc_ib_clk_o,
    input   adc_it_dat_i,
    output  adc_it_clk_o,
    input   adc_vbus_dat_i,
    output  adc_vbus_clk_o,

    input   ref_clk,

    output [15:0]   ia_o,
    output [15:0]   ib_o,
    output [15:0]   it_o,
    output          i_ready_o,

  // dma interface

    input           s_axis_s2mm_clk,
    output          s_axis_s2mm_tvalid,
    output  [63:0]  s_axis_s2mm_tdata,
    output  [7:0]   s_axis_s2mm_tkeep,
    output          s_axis_s2mm_tlast,
    input           s_axis_s2mm_tready,

  // axi interface

    input           s_axi_aclk,
    input           s_axi_aresetn,
    input           s_axi_awvalid,
    input   [31:0]  s_axi_awaddr,
    output          s_axi_awready,
    input           s_axi_wvalid,
    input   [31:0]  s_axi_wdata,
    input   [3:0]   s_axi_wstrb,
    output          s_axi_wready,
    output          s_axi_bvalid,
    output  [1:0]   s_axi_bresp,
    input           s_axi_bready,
    input           s_axi_arvalid,
    input   [31:0]  s_axi_araddr,
    output          s_axi_arready,
    output          s_axi_rvalid,
    output  [1:0]   s_axi_rresp,
    output  [31:0]  s_axi_rdata,
    input           s_axi_rready,

  // debug signals

    output          adc_mon_valid,
    output  [31:0]  adc_mon_data
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------

reg             adc_valid       = 'd0;
reg     [63:0]  adc_data        = 'd0;
reg     [47:0]  adc_data_3      = 'd0;
reg     [31:0]  up_rdata        = 'd0;
reg             up_ack          = 'd0;
reg     [1:0]   adc_data_cnt    = 'd0;
reg     [9:0]   adc_clk_cnt     = 'd0;  // used to generate 10 MHz clock for ADCs
reg             adc_clk_reg     = 'd0;  // used to generate 10 MHz clock for ADCs

reg             acq_run_reg     = 'd0;  // register used for synchronizing data acquisition
reg             adc_valid_3     = 'd0;
reg     [47:0]  adc_data_3_1110 = 'd0;
reg     [47:0]  adc_data_3_1101 = 'd0;
reg     [47:0]  adc_data_3_1011 = 'd0;
reg     [47:0]  adc_data_3_0111 = 'd0;
reg     [63:0]  adc_data_1110   = 'd0;
reg     [63:0]  adc_data_1101   = 'd0;
reg     [63:0]  adc_data_1011   = 'd0;
reg     [63:0]  adc_data_0111   = 'd0;

//------------------------------------------------------------------------------
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------

// internal clocks & resets

wire            adc_rst;
wire            dma_clk;
wire            dma_rst;
wire            up_rstn;
wire            up_clk;

// internal signals

wire            dma_valid_s;
wire            dma_last_s;
wire    [63:0]  dma_data_s;
wire            dma_ready_s;
wire            dma_stream_s;
wire    [31:0]  dma_count_s;
wire            dma_ovf_s;
wire            dma_unf_s;
wire            dma_status_s;
wire    [31:0]  dma_bw_s;
wire            up_sel_s;
wire            up_wr_s;
wire    [13:0]  up_addr_s;
wire    [31:0]  up_wdata_s;
wire    [31:0]  up_adc_common_rdata_s;
wire            up_adc_common_ack_s;
wire    [31:0]  up_rdata_0_s ;
wire    [31:0]  up_rdata_1_s ;
wire    [31:0]  up_rdata_2_s ;
wire    [31:0]  up_rdata_3_s ;
wire            up_ack_0_s ;
wire            up_ack_1_s ;
wire            up_ack_2_s ;
wire            up_ack_3_s ;

wire            adc_status_a_s;
wire    [15:0]  adc_data_ia_s ;
wire            data_rd_ready_ia_s;
wire            adc_status_b_s;
wire    [15:0]  adc_data_ib_s;
wire            adc_status_it_s;
wire    [15:0]  adc_data_it_s;
wire    [15:0]  adc_data_it_n_s;
wire            adc_status_vbus_s;
wire    [15:0]  adc_data_vbus_s ;
wire            adc_enable_ia;
wire            adc_enable_ib;
wire            adc_enable_it;
wire            adc_enable_vbus;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// signal name changes

assign up_clk               = s_axi_aclk;
assign up_rstn              = s_axi_aresetn;
assign dma_clk              = s_axis_s2mm_clk;
assign dma_ready_s          = s_axis_s2mm_tready;
assign s_axis_s2mm_tvalid   = dma_valid_s;
assign s_axis_s2mm_tdata    = dma_data_s;
assign s_axis_s2mm_tlast    = dma_last_s;
assign s_axis_s2mm_tkeep    = 8'hff;

// monitor signals

assign adc_mon_valid        = data_rd_ready_ia_s;
assign adc_mon_data[15: 0]  = adc_data[15:0];
assign adc_mon_data[31:16]  = {adc_enable_vbus,adc_enable_it,adc_enable_ib, adc_enable_ia, 12'h0};

// current outputs

assign i_ready_o = data_rd_ready_ia_s;
assign ia_o      = adc_data_ia_s;
assign ib_o      = adc_data_ib_s;
assign it_o      = adc_data_it_s;
assign adc_data_it_n_s = 65535 - adc_data_it_s;

// ADC clock generation

always @(posedge ref_clk)
begin
    if (adc_clk_cnt < 10'd4)
    begin
        adc_clk_cnt <= adc_clk_cnt + 1;
    end
    else
    begin
        adc_clk_cnt <= 10'd0;
        adc_clk_reg <= ~adc_clk_reg;
    end
end

// adc channels - dma interface

always @(posedge ref_clk)
begin
    if(data_rd_ready_ia_s == 1'b1)
    begin
        adc_valid_3             <= adc_data_cnt[0] | adc_data_cnt[1];
        adc_data_3_1110[47:32]  <= adc_data_vbus_s;
        adc_data_3_1110[31:16]  <= adc_data_it_n_s;
        adc_data_3_1110[15:0]   <= adc_data_ib_s;
        adc_data_3_1101[47:32]  <= adc_data_vbus_s;
        adc_data_3_1101[31:16]  <= adc_data_it_n_s;
        adc_data_3_1101[15:0]   <= adc_data_ia_s;
        adc_data_3_1011[47:32]  <= adc_data_vbus_s;
        adc_data_3_1011[31:16]  <= adc_data_ib_s;
        adc_data_3_1011[15:0]   <= adc_data_ia_s;
        adc_data_3_0111[47:32]  <= adc_data_it_n_s;
        adc_data_3_0111[31:16]  <= adc_data_ib_s;
        adc_data_3_0111[15:0]   <= adc_data_ia_s;
        case(adc_data_cnt)
            2'b11:
            begin
                adc_data_1110[63:48]    <= adc_data_vbus_s;
                adc_data_1110[47:32]    <= adc_data_it_n_s;
                adc_data_1110[31:16]    <= adc_data_ib_s;
                adc_data_1110[15:0]     <= adc_data_3_1110[47:32];
                adc_data_1101[63:48]    <= adc_data_vbus_s;
                adc_data_1101[47:32]    <= adc_data_it_n_s;
                adc_data_1101[31:16]    <= adc_data_ia_s;
                adc_data_1101[15:0]     <= adc_data_3_1101[47:32];
                adc_data_1011[63:48]    <= adc_data_vbus_s;
                adc_data_1011[47:32]    <= adc_data_ib_s;
                adc_data_1011[31:16]    <= adc_data_ia_s;
                adc_data_1011[15:0]     <= adc_data_3_1011[47:32];
                adc_data_0111[63:48]    <= adc_data_it_n_s;
                adc_data_0111[47:32]    <= adc_data_ib_s;
                adc_data_0111[31:16]    <= adc_data_ia_s;
                adc_data_0111[15:0]     <= adc_data_3_0111[47:32];
            end
            2'b10:
            begin
                adc_data_1110[63:48]    <= adc_data_it_n_s;
                adc_data_1110[47:32]    <= adc_data_ib_s;
                adc_data_1110[31:16]    <= adc_data_3_1110[47:32];
                adc_data_1110[15:0]     <= adc_data_3_1110[31:16];
                adc_data_1101[63:48]    <= adc_data_it_n_s;
                adc_data_1101[47:32]    <= adc_data_ia_s;
                adc_data_1101[31:16]    <= adc_data_3_1101[47:32];
                adc_data_1101[15:0]     <= adc_data_3_1101[31:16];
                adc_data_1011[63:48]    <= adc_data_ib_s;
                adc_data_1011[47:32]    <= adc_data_ia_s;
                adc_data_1011[31:16]    <= adc_data_3_1011[47:32];
                adc_data_1011[15:0]     <= adc_data_3_1011[31:16];
                adc_data_0111[63:48]    <= adc_data_ib_s;
                adc_data_0111[47:32]    <= adc_data_ia_s;
                adc_data_0111[31:16]    <= adc_data_3_0111[47:32];
                adc_data_0111[15:0]     <= adc_data_3_0111[31:16];
            end
            2'b01:
            begin
                adc_data_1110[63:48]    <= adc_data_ib_s;
                adc_data_1110[47:32]    <= adc_data_3_1110[47:32];
                adc_data_1110[31:16]    <= adc_data_3_1110[31:16];
                adc_data_1110[15:0]     <= adc_data_3_1110[15:0];
                adc_data_1101[63:48]    <= adc_data_ia_s;
                adc_data_1101[47:32]    <= adc_data_3_1101[47:32];
                adc_data_1101[31:16]    <= adc_data_3_1101[31:16];
                adc_data_1101[15:0]     <= adc_data_3_1101[15:0];
                adc_data_1011[63:48]    <= adc_data_ia_s;
                adc_data_1011[47:32]    <= adc_data_3_1011[47:32];
                adc_data_1011[31:16]    <= adc_data_3_1011[31:16];
                adc_data_1011[15:0]     <= adc_data_3_1011[15:0];
                adc_data_0111[63:48]    <= adc_data_ia_s;
                adc_data_0111[47:32]    <= adc_data_3_0111[47:32];
                adc_data_0111[31:16]    <= adc_data_3_0111[31:16];
                adc_data_0111[15:0]     <= adc_data_3_0111[15:0];
            end
            2'b00:
            begin
                adc_data_1110[63:48]    <= 16'hdead;
                adc_data_1110[47:32]    <= 16'hdead;
                adc_data_1110[31:16]    <= 16'hdead;
                adc_data_1110[15:0]     <= 16'hdead;
                adc_data_1101[63:48]    <= 16'hdead;
                adc_data_1101[47:32]    <= 16'hdead;
                adc_data_1101[31:16]    <= 16'hdead;
                adc_data_1101[15:0]     <= 16'hdead;
                adc_data_1011[63:48]    <= 16'hdead;
                adc_data_1011[47:32]    <= 16'hdead;
                adc_data_1011[31:16]    <= 16'hdead;
                adc_data_1011[15:0]     <= 16'hdead;
                adc_data_0111[63:48]    <= 16'hdead;
                adc_data_0111[47:32]    <= 16'hdead;
                adc_data_0111[31:16]    <= 16'hdead;
                adc_data_0111[15:0]     <= 16'hdead;
            end
        endcase
    end
end

always @(posedge ref_clk)
begin
    if (data_rd_ready_ia_s == 1'b1)
    begin
        case ({adc_enable_vbus, adc_enable_it, adc_enable_ib, adc_enable_ia})
            4'b1111:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= 1'b1;
                adc_data[63:48] <= adc_data_vbus_s;
                adc_data[47:32] <= adc_data_it_n_s;
                adc_data[31:16] <= adc_data_ib_s;
                adc_data[15: 0] <= adc_data_ia_s;
            end
            4'b1110:
            begin
                adc_valid       <= adc_valid_3;
                adc_data        <= adc_data_1110;
            end
            4'b1101:
            begin
                adc_valid       <= adc_valid_3;
                adc_data        <= adc_data_1101;
            end
            4'b1100:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[0];
                adc_data[63:48] <= adc_data_vbus_s;
                adc_data[47:32] <= adc_data_it_n_s;
                adc_data[31:16] <= adc_data[63:48];
                adc_data[15: 0] <= adc_data[47:32];
            end
            4'b1011:
            begin
                adc_valid       <= adc_valid_3;
                adc_data        <= adc_data_1011;
            end
            4'b1010:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[0];
                adc_data[63:48] <= adc_data_vbus_s;
                adc_data[47:32] <= adc_data_ib_s;
                adc_data[31:16] <= adc_data[63:48];
                adc_data[15: 0] <= adc_data[47:32];
            end
            4'b1001:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[0];
                adc_data[63:48] <= adc_data_vbus_s;
                adc_data[47:32] <= adc_data_ia_s;
                adc_data[31:16] <= adc_data[63:48];
                adc_data[15: 0] <= adc_data[47:32];
            end
            4'b1000:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[1] & adc_data_cnt[0];
                adc_data[63:48] <= adc_data_vbus_s;
                adc_data[47:32] <= adc_data[63:48];
                adc_data[31:16] <= adc_data[47:32];
                adc_data[15: 0] <= adc_data[31:16];
            end
            4'b0111:
            begin
                adc_valid       <= adc_valid_3;
                adc_data        <= adc_data_0111;
            end
            4'b0110:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[0];
                adc_data[63:48] <= adc_data_it_n_s;
                adc_data[47:32] <= adc_data_ib_s;
                adc_data[31:16] <= adc_data[63:48];
                adc_data[15: 0] <= adc_data[47:32];
            end
            4'b0101:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[0];
                adc_data[63:48] <= adc_data_it_n_s;
                adc_data[47:32] <= adc_data_ia_s;
                adc_data[31:16] <= adc_data[63:48];
                adc_data[15: 0] <= adc_data[47:32];
            end
            4'b0100:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[1] & adc_data_cnt[0];
                adc_data[63:48] <= adc_data_it_n_s;
                adc_data[47:32] <= adc_data[63:48];
                adc_data[31:16] <= adc_data[47:32];
                adc_data[15: 0] <= adc_data[31:16];
            end
            4'b0011:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[0];
                adc_data[63:48] <= adc_data_ib_s;
                adc_data[47:32] <= adc_data_ia_s;
                adc_data[31:16] <= adc_data[63:48];
                adc_data[15: 0] <= adc_data[47:32];
            end
            4'b0010:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[1] & adc_data_cnt[0];
                adc_data[63:48] <= adc_data_ib_s;
                adc_data[47:32] <= adc_data[63:48];
                adc_data[31:16] <= adc_data[47:32];
                adc_data[15: 0] <= adc_data[31:16];
            end
            4'b0001:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= adc_data_cnt[1] & adc_data_cnt[0];
                adc_data[63:48] <= adc_data_ia_s;
                adc_data[47:32] <= adc_data[63:48];
                adc_data[31:16] <= adc_data[47:32];
                adc_data[15: 0] <= adc_data[31:16];
            end
            default:
            begin
                adc_data_3      <= 48'd0;
                adc_valid       <= 1'b1;
                adc_data[63:48] <= 16'hdead;
                adc_data[47:32] <= 16'hdead;
                adc_data[31:16] <= 16'hdead;
                adc_data[15: 0] <= 16'hdead;
            end
        endcase
    end
    else
    begin
        adc_valid       <= 1'b0;
        adc_data        <= adc_data;
    end
end

// the following 2 processe are used for synchronizing the moment 
// data is sent to DMA core so that the first two bytes represent 
// the first channel acquired
always @(posedge ref_clk)
begin
    if (acq_run_reg == 1'b0)
    begin
        adc_data_cnt <= 2'h0;
    end
    else
    begin
        if (data_rd_ready_ia_s == 1'b1 )
        begin
            adc_data_cnt <= adc_data_cnt + 2'b1;
        end
    end
end

always @(posedge ref_clk)
begin
    if (dma_start_s == 1'b1)
    begin
        acq_run_reg <= 1'b1;
    end
    if (dma_last_s == 1'b1)
    begin
        acq_run_reg <= 1'b0;
    end
end


// processor read interface

always @(negedge up_rstn or posedge up_clk)
begin
    if (up_rstn == 0)
    begin
        up_rdata  <= 'd0;
        up_ack    <= 'd0;
    end
    else
    begin
        up_rdata  <= up_adc_common_rdata_s | up_rdata_0_s | up_rdata_1_s | up_rdata_2_s | up_rdata_3_s ;
        up_ack    <= up_adc_common_ack_s | up_ack_0_s | up_ack_1_s | up_ack_2_s | up_ack_3_s ;
    end
end

// adc interfaces

ad7401 ia_if (
    .fpga_clk_i (ref_clk),
    .adc_clk_i(adc_clk_reg),
    .reset_i(adc_rst),
    .adc_status_o(adc_status_a_s),
    .data_o (adc_data_ia_s),
    .data_rd_ready_o (data_rd_ready_ia_s),
    .adc_mdata_i (adc_ia_dat_i),
    .adc_mclkin_o (adc_ia_clk_o)
);

ad7401 ib_if (
    .fpga_clk_i (ref_clk),
    .adc_clk_i(adc_clk_reg),
    .reset_i(adc_rst),
    .adc_status_o(adc_status_b_s),
    .data_o (adc_data_ib_s),
    .data_rd_ready_o (),
    .adc_mdata_i (adc_ib_dat_i),
    .adc_mclkin_o (adc_ib_clk_o)
);
ad7401 it_if (
    .fpga_clk_i (ref_clk),
    .adc_clk_i(adc_clk_reg),
    .reset_i(adc_rst),
    .adc_status_o(adc_status_it_s),
    .data_o (adc_data_it_s),
    .data_rd_ready_o (),
    .adc_mdata_i (adc_it_dat_i),
    .adc_mclkin_o (adc_it_clk_o)
);

ad7401 vbus_if (
    .fpga_clk_i (ref_clk),
    .adc_clk_i(adc_clk_reg),
    .reset_i(adc_rst),
    .adc_status_o(adc_status_vbus_s),
    .data_o (adc_data_vbus_s),
    .data_rd_ready_o (),
    .adc_mdata_i (adc_vbus_dat_i),
    .adc_mclkin_o (adc_vbus_clk_o)
);

up_adc_channel #(.PCORE_ADC_CHID(0)) i_up_adc_channel_ia (
    .adc_clk (ref_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable_ia),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (),
    .adc_dfmt_type (),
    .adc_dfmt_enable (),
    .adc_pn_type (),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pn_err (1'b0),
    .adc_pn_oos (1'b0),
    .adc_or (1'b0),
    .up_adc_pn_err (),
    .up_adc_pn_oos (),
    .up_adc_or (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (16'd1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_0_s),
    .up_ack (up_ack_0_s));

up_adc_channel #(.PCORE_ADC_CHID(1)) i_up_adc_channel_ib (
    .adc_clk (ref_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable_ib),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (),
    .adc_dfmt_type (),
    .adc_dfmt_enable (),
    .adc_pn_type (),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pn_err (1'b0),
    .adc_pn_oos (1'b0),
    .adc_or (1'b0),
    .up_adc_pn_err (),
    .up_adc_pn_oos (),
    .up_adc_or (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (16'd1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_1_s),
    .up_ack (up_ack_1_s));

up_adc_channel #(.PCORE_ADC_CHID(2)) i_up_adc_channel_it (
    .adc_clk (ref_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable_it),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (),
    .adc_dfmt_type (),
    .adc_dfmt_enable (),
    .adc_pn_type (),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pn_err (1'b0),
    .adc_pn_oos (1'b0),
    .adc_or (1'b0),
    .up_adc_pn_err (),
    .up_adc_pn_oos (),
    .up_adc_or (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (16'd1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_2_s),
    .up_ack (up_ack_2_s));

up_adc_channel #(.PCORE_ADC_CHID(3)) i_up_adc_channel_vbus (
    .adc_clk (ref_clk),
    .adc_rst (adc_rst),
    .adc_enable (adc_enable_vbus),
    .adc_iqcor_enb (),
    .adc_dcfilt_enb (),
    .adc_dfmt_se (),
    .adc_dfmt_type (),
    .adc_dfmt_enable (),
    .adc_pn_type (),
    .adc_dcfilt_offset (),
    .adc_dcfilt_coeff (),
    .adc_iqcor_coeff_1 (),
    .adc_iqcor_coeff_2 (),
    .adc_pn_err (1'b0),
    .adc_pn_oos (1'b0),
    .adc_or (1'b0),
    .up_adc_pn_err (),
    .up_adc_pn_oos (),
    .up_adc_or (),
    .up_usr_datatype_be (),
    .up_usr_datatype_signed (),
    .up_usr_datatype_shift (),
    .up_usr_datatype_total_bits (),
    .up_usr_datatype_bits (),
    .up_usr_decimation_m (),
    .up_usr_decimation_n (),
    .adc_usr_datatype_be (1'b0),
    .adc_usr_datatype_signed (1'b1),
    .adc_usr_datatype_shift (8'd0),
    .adc_usr_datatype_total_bits (8'd16),
    .adc_usr_datatype_bits (8'd16),
    .adc_usr_decimation_m (16'd1),
    .adc_usr_decimation_n (16'd1),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_rdata_3_s),
    .up_ack (up_ack_3_s));


// dma transfer
dma_core #(.DATA_WIDTH(64)) i_dma_core (
    .dma_clk (dma_clk),
    .dma_rst (dma_rst),
    .dma_valid (dma_valid_s),
    .dma_last (dma_last_s),
    .dma_data (dma_data_s),
    .dma_ready (dma_ready_s),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
    .dma_status (dma_status_s),
    .dma_bw (dma_bw_s),
    .adc_clk (ref_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid),
    .adc_data (adc_data),
    .dma_start (dma_start_s),
    .dma_stream (dma_stream_s),
    .dma_count (dma_count_s));

// common processor control

up_adc_common i_up_adc_common (
    .adc_clk (ref_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status_a_s | adc_status_b_s | adc_status_it_s | adc_status_vbus_s ),
    .adc_clk_ratio (32'd1),
    .delay_clk (1'b0),
    .delay_rst (),
    .delay_sel (),
    .delay_rwn (),
    .delay_addr (),
    .delay_wdata (),
    .delay_rdata (5'd0),
    .delay_ack_t (1'b0),
    .delay_locked (1'b0),
    .drp_clk (1'd0),
    .drp_rst (),
    .drp_sel (),
    .drp_rwn (),
    .drp_addr (),
    .drp_wdata (),
    .drp_rdata (16'd0),
    .drp_ack_t (1'd0),
    .dma_clk (dma_clk),
    .dma_rst (dma_rst),
    .dma_start (dma_start_s),
    .dma_stream (dma_stream_s),
    .dma_count (dma_count_s),
    .dma_ovf (dma_ovf_s),
    .dma_unf (dma_unf_s),
    .dma_status (dma_status_s),
    .dma_bw (dma_bw_s),
    .up_usr_chanmax (),
    .adc_usr_chanmax (8'd0),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel_s),
    .up_wr (up_wr_s),
    .up_addr (up_addr_s),
    .up_wdata (up_wdata_s),
    .up_rdata (up_adc_common_rdata_s),
    .up_ack (up_adc_common_ack_s)
);

// up bus interface

up_axi #(
    .PCORE_BASEADDR (C_BASEADDR),
    .PCORE_HIGHADDR (C_HIGHADDR))
    i_up_axi (
        .up_rstn (up_rstn),
        .up_clk (up_clk),
        .up_axi_awvalid (s_axi_awvalid),
        .up_axi_awaddr (s_axi_awaddr),
        .up_axi_awready (s_axi_awready),
        .up_axi_wvalid (s_axi_wvalid),
        .up_axi_wdata (s_axi_wdata),
        .up_axi_wstrb (s_axi_wstrb),
        .up_axi_wready (s_axi_wready),
        .up_axi_bvalid (s_axi_bvalid),
        .up_axi_bresp (s_axi_bresp),
        .up_axi_bready (s_axi_bready),
        .up_axi_arvalid (s_axi_arvalid),
        .up_axi_araddr (s_axi_araddr),
        .up_axi_arready (s_axi_arready),
        .up_axi_rvalid (s_axi_rvalid),
        .up_axi_rresp (s_axi_rresp),
        .up_axi_rdata (s_axi_rdata),
        .up_axi_rready (s_axi_rready),
        .up_sel (up_sel_s),
        .up_wr (up_wr_s),
        .up_addr (up_addr_s),
        .up_wdata (up_wdata_s),
        .up_rdata (up_rdata),
        .up_ack (up_ack));

endmodule

// ***************************************************************************
// ***************************************************************************

