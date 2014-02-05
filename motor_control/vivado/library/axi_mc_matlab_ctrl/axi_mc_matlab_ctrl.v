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

module axi_mc_matlab_ctrl
#(
    parameter PCORE_ID = 0,
    parameter PCORE_DEVICE_TYPE = 0,
    parameter PCORE_IODELAY_GROUP = "adc_if_delay_group",
    parameter C_S_AXI_MIN_SIZE = 32'hffff,
    parameter C_BASEADDR = 32'hffffffff,
    parameter C_HIGHADDR = 32'h00000000
)

(
    input           ref_clk,       // 100 MHz
// physical interface
    input           fmc_m1_fault_i,
    output          fmc_m1_en_o,
    output          pwm_ah_o,
    output          pwm_al_o,
    output          pwm_bh_o,
    output          pwm_bl_o,
    output          pwm_ch_o,
    output          pwm_cl_o,
    output  [ 7:0]  gpo_o,
// interconnection with other modules
    output  [1:0]   sensors_o,
    input   [2:0]   position_i,
    input           new_speed_i,
    input   [31:0]  speed_i,
    input   [15:0]  ia_i,
    input   [15:0]  ib_i,
    input           i_ready_i,
// dma interface
    input           s_axis_s2mm_clk,
    output          s_axis_s2mm_tvalid,
    output  [31:0]  s_axis_s2mm_tdata,
    output  [3:0]   s_axis_s2mm_tkeep,
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
    output  [323:0] adc_mon_data
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------

// internal registers

reg             adc_valid       = 'd0;
reg     [31:0]  adc_data        = 'd0;
reg     [31:0]  up_rdata        = 'd0;
reg             up_ack          = 'd0;

reg             ctrl_clk_s      = 'h0;    // 50 MHz
reg             derived_clk     = 'h0;
reg             derived_clk_d1  = 'h0;
reg     [31:0]  clk_div_cnt     = 'h0;
reg     [17:0]  adc_current_0_s = 'h0;
reg     [17:0]  adc_current_1_s = 'h0;

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

wire            dma_start_s;
wire            dma_valid_s;
wire            dma_last_s;
wire    [31:0]  dma_data_s;
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
wire    [31:0]  up_control_rdata_s;
wire            up_adc_common_ack_s;
wire            up_control_ack_s;
wire            run_s;
wire   [31:0]   err_s;

wire   [1:0]    controller_mode_s;
wire   [17:0]   command_s;
wire   [17:0]   velocity_p_gain_s;
wire   [17:0]   velocity_i_gain_s;
wire   [17:0]   current_p_gain_s;
wire   [17:0]   current_i_gain_s;
wire   [17:0]   open_loop_bias_s;
wire   [17:0]   open_loop_scalar_s;
wire   [17:0]   encoder_zero_offset_s;

wire            pwm_a_s;
wire            pwm_b_s;
wire            pwm_c_s;
wire            inverter_enable_a_s;
wire            inverter_enable_b_s;
wire            inverter_enable_c_s;
wire            overcurrent_error_s;
wire            position_valid_s;
wire            inverter_enable_s;
wire    [19:0]  phase_voltage_a_s;
wire    [19:0]  phase_voltage_b_s;
wire    [17:0]  phase_current_a_s;
wire    [17:0]  phase_current_b_s;
wire    [17:0]  rotor_position_s;
wire    [17:0]  electrical_position_s;
wire    [17:0]  rotor_velocity_s;
wire    [17:0]  d_current_s;
wire    [17:0]  q_current_s;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// signal name changes

assign up_clk = s_axi_aclk;
assign up_rstn = s_axi_aresetn;
assign dma_clk = s_axis_s2mm_clk;
assign dma_ready_s = s_axis_s2mm_tready;
assign s_axis_s2mm_tvalid = dma_valid_s;
assign s_axis_s2mm_tdata  = dma_data_s;
assign s_axis_s2mm_tlast = dma_last_s;
assign s_axis_s2mm_tkeep = 4'hf;

// monitor signals

assign adc_mon_valid = i_ready_i;
assign adc_mon_data = 'h0 ;

// multiple instances synchronization

assign fmc_m1_en_o  = run_s;

assign pwm_ah_o = inverter_enable_a_s ? pwm_a_s  : 1'b0;
assign pwm_al_o = inverter_enable_a_s ? ~pwm_a_s : 1'b0;
assign pwm_bh_o = inverter_enable_b_s ? pwm_b_s  : 1'b0;
assign pwm_bl_o = inverter_enable_b_s ? ~pwm_b_s : 1'b0;
assign pwm_ch_o = inverter_enable_c_s ? pwm_c_s  : 1'b0;
assign pwm_cl_o = inverter_enable_c_s ? ~pwm_c_s : 1'b0;


always @(posedge ref_clk)
begin
    if (i_ready_i == 1'b1)
    begin
        adc_current_0_s   <= {ia_i, 2'h0};
        adc_current_1_s   <= {ib_i, 2'h0};
    end
end


always @(posedge ref_clk)
begin
    ctrl_clk_s <= ~ctrl_clk_s;
end

//Derive 25 KHz clock
always @(posedge ctrl_clk_s)
begin
    if (up_rstn == 1'b0)
    begin
        clk_div_cnt         <= 0;
    end
    else
    begin
        if (clk_div_cnt == 999)
        begin
            clk_div_cnt <= 0;
            derived_clk <= ~derived_clk;
        end
        else
        begin
            clk_div_cnt <= clk_div_cnt + 1;
        end
    end
end

// adc channels - dma interface

always @(posedge ref_clk)
begin
    adc_data  <= {phase_voltage_b_s[19:4],phase_voltage_a_s[19:4]};
    derived_clk_d1  <= derived_clk;
    adc_valid       <= derived_clk & ~derived_clk_d1;
end

// processor read interface

always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
        up_rdata  <= 'd0;
        up_ack    <= 'd0;
    end else begin
        up_rdata  <= up_control_rdata_s | up_adc_common_rdata_s ;
        up_ack    <= up_control_ack_s | up_adc_common_ack_s;
    end
end

// main (device interface)

control_registers control_reg_inst
(
//bus interface
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_sel(up_sel_s),
    .up_wr(up_wr_s),
    .up_addr(up_addr_s),
    .up_wdata(up_wdata_s),
    .up_rdata(up_control_rdata_s),
    .up_ack(up_control_ack_s),
//control pins
    .run_o(run_s),
    .break_o(),
    .star_delta_o(),
    .sensors_o(sensors_o),
    .controller_mode_reg_o(controller_mode_s),
    .command_reg_o ( command_s),
    .velocity_p_gain_reg_o ( velocity_p_gain_s),
    .velocity_i_gain_reg_o ( velocity_i_gain_s),
    .current_p_gain_reg_o (current_p_gain_s),
    .current_i_gain_reg_o (current_i_gain_s),
    .open_loop_bias_reg_o (open_loop_bias_s),
    .open_loop_scalar_reg_o (open_loop_scalar_s),
    .encoder_zero_offset_reg_o (encoder_zero_offset_s),
    .oloop_matlab_o (),
    .gpo_o(gpo_o),
    .err_i (err_s),
    .pwm_open_o()
);

controllerPeripheralHdlAdi controllerPeripheralHdlAdi_i1
(
    .clk_in_1_2000(derived_clk),
    .clk_in(ctrl_clk_s),
    .reset_1_2000(!run_s),
    .reset(!run_s),
    .clk_enable(1'b1),
    .clk_enable_2000(1'b1),
    .adc_current_0(adc_current_0_s),
    .adc_current_1(adc_current_1_s),
    .encoder_a(position_i[0]),
    .encoder_b(position_i[1]),
    .encoder_index(position_i[2]),
    .axi_controller_mode(controller_mode_s),
    .axi_command(command_s),
    .axi_velocity_p_gain(velocity_p_gain_s),
    .axi_velocity_i_gain(velocity_i_gain_s),
    .axi_current_p_gain(current_p_gain_s),
    .axi_current_i_gain(current_i_gain_s),
    .axi_open_loop_bias(open_loop_bias_s),
    .axi_open_loop_scalar(open_loop_scalar_s),

    .axi_encoder_zero_offset(encoder_zero_offset_s),
    .pwm_a(pwm_a_s),//1
    .pwm_b(pwm_b_s),//1
    .pwm_c(pwm_c_s),//1
    .inverter_enable_a(inverter_enable_a_s),//1
    .inverter_enable_b(inverter_enable_b_s),//1
    .inverter_enable_c(inverter_enable_c_s),//1
    .axi_overcurrent_error(overcurrent_error_s),//1
    .axi_position_valid(position_valid_s),//1
    .axi_inverter_enable(inverter_enable_s),//1
    .axi_phase_voltage_a(phase_voltage_a_s),//20
    .axi_phase_voltage_b(phase_voltage_b_s),//20
    .axi_phase_current_a(phase_current_a_s),//18
    .axi_phase_current_b(phase_current_b_s),//18
    .axi_rotor_position(rotor_position_s),//18
    .axi_electrical_position(electrical_position_s),//18
    .axi_rotor_velocity(rotor_velocity_s),//18
    .axi_d_current(d_current_s),//18
    .axi_q_current(q_current_s)//18
);

// dma transfer 
dma_core #(.DATA_WIDTH(32)) i_dma_core (
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
    .adc_status (1'b1),
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

