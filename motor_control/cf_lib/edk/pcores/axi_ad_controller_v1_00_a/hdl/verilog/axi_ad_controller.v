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

module axi_ad_controller
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
    input           pwm_clk_i,     // 40 MHz
    input           ctrl_clk_i,    // 50 MHz
// physical interface
    input           fmc_m1_fault_i,
    output          fmc_m1_en_o,
    output          fmc_m1_in_a_o,
    output          fmc_m1_in_b_o,
    output          fmc_m1_in_c_o,
    output          fmc_m1_en_a_o,
    output          fmc_m1_en_b_o,
    output          fmc_m1_en_c_o,
    output  [1:0]   sensors_o,
    input   [2:0]   position_i,
    input           new_speed_i,
    input   [31:0]  speed_i,
    input   [15:0]  ia_i,
    input   [15:0]  ib_i,
    input           i_ready_i,
// master-slave interface
    output  adc_start_out,
    output  dma_start_out,
    input   adc_start_in,
    input   dma_start_in,
// dma interface

    input   s_axis_s2mm_clk,
    output  s_axis_s2mm_tvalid,
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
    input   [145:0] cntrl_input_i,
    output          adc_mon_valid,
    output  [177:0] adc_mon_data
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
// internal registers

reg             adc_start_out = 'd0;
reg             adc_valid = 'd0;
reg     [31:0]  adc_data = 'd0;
reg     [31:0]  up_rdata = 'd0;
reg             up_ack = 'd0;

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

wire            adc_start_s;
wire            dma_start_s;
wire            adc_enable_s;
wire            adc_status_s;
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
wire            star_delta_s;
wire            oloop_matlab_s;         // 0 - open loop, 1 matlab controlls pwm
wire   [31:0]   pwm_open_s;
wire   [31:0]   pwm_controller_s;
wire   [31:0]   pwm_s;
wire   [31:0]   reference_speed_s;
wire   [31:0]   kp_s;
wire   [31:0]   ki_s;
wire   [31:0]   kd_s;
wire   [31:0]   pid_s;
wire   [2:0]    position_s;             // signal used for open loop start
wire   [2:0]    position_start;         // signal used for open loop start
wire            motor_running_s;        //signals that the motor is running

//DEBUG
reg             derived_clk;
reg     [31:0]  clk_div_cnt;
reg     [17:0]  adc_current_0_dbg;
reg     [17:0]  adc_current_1_dbg;
wire            encoder_a_dbg;
wire            encoder_b_dbg;
wire            encoder_index_dbg;
wire     [1:0]  axi_controller_mode_dbg;
wire     [17:0] axi_command_dbg;
wire     [17:0] axi_velocity_p_gain_dbg;
wire     [17:0] axi_velocity_i_gain_dbg;
wire     [17:0] axi_current_p_gain_dbg;
wire     [17:0] axi_current_i_gain_dbg;
wire     [17:0] axi_open_loop_bias_dbg;
wire     [17:0] axi_open_loop_scalar_dbg;
wire     [17:0] axi_encoder_zero_offset_dbg;

wire            pwm_a_dbg;//0
wire            pwm_b_dbg;//1
wire            pwm_c_dbg;//2
wire            inverter_enable_a_dbg;//3
wire            inverter_enable_b_dbg;//4
wire            inverter_enable_c_dbg;//5
wire            axi_overcurrent_error_dbg;//6
wire            axi_position_valid_dbg;//7
wire            axi_inverter_enable_dbg;//8
wire    [19:0]  axi_phase_voltage_a_dbg;//9-28
wire    [19:0]  axi_phase_voltage_b_dbg;//29-48
wire    [17:0]  axi_phase_current_a_dbg;//49-66
wire    [17:0]  axi_phase_current_b_dbg;//67-84
wire    [17:0]  axi_rotor_position_dbg;//85-102
wire    [17:0]  axi_electrical_position_dbg;//103-120
wire    [17:0]  axi_rotor_velocity_dbg;//121-138
wire    [17:0]  axi_d_current_dbg;//139-156
wire    [17:0]  axi_q_current_dbg;//157-174


wire fmc_m1_in_a_s;
wire fmc_m1_in_b_s;
wire fmc_m1_in_c_s;
wire fmc_m1_en_a_s;
wire fmc_m1_en_b_s;
wire fmc_m1_en_c_s;


assign axi_controller_mode_dbg      = cntrl_input_i[1:0];
assign axi_command_dbg              = cntrl_input_i[19:2];
assign axi_velocity_p_gain_dbg      = cntrl_input_i[37:20];
assign axi_velocity_i_gain_dbg      = cntrl_input_i[55:38];
assign axi_current_p_gain_dbg       = cntrl_input_i[73:56];
assign axi_current_i_gain_dbg       = cntrl_input_i[91:74];
assign axi_open_loop_bias_dbg       = cntrl_input_i[109:92];
assign axi_open_loop_scalar_dbg     = cntrl_input_i[127:110];
assign axi_encoder_zero_offset_dbg  = cntrl_input_i[145:128];

assign fmc_m1_in_a_o = oloop_matlab_s ? pwm_a_dbg : fmc_m1_in_a_s;
assign fmc_m1_in_b_o = oloop_matlab_s ? pwm_b_dbg : fmc_m1_in_b_s;
assign fmc_m1_in_c_o = oloop_matlab_s ? pwm_c_dbg : fmc_m1_in_c_s;
assign fmc_m1_en_a_o = oloop_matlab_s ? inverter_enable_a_dbg : fmc_m1_en_a_s;
assign fmc_m1_en_b_o = oloop_matlab_s ? inverter_enable_b_dbg : fmc_m1_en_b_s;
assign fmc_m1_en_c_o = oloop_matlab_s ? inverter_enable_c_dbg : fmc_m1_en_c_s;

encoder_stub encoder_stub_i1
(
    .clk_i(ref_clk),
    .position_i(position_i),
    .encoder_a_o(encoder_a_dbg),
    .encoder_b_o(encoder_b_dbg),
    .encoder_index_o(encoder_index_dbg)
);

always @(posedge ref_clk)
begin
    if (i_ready_i == 1'b1)
    begin
        adc_current_0_dbg   <= {ia_i, 2'h0};
        adc_current_1_dbg   <= {ib_i, 2'h0};
    end
end

//Derive 25 KHz clock
always @(posedge ctrl_clk_i)
begin
    if (up_rstn == 1'b0)
    begin
        clk_div_cnt <= 0;
    end
    else
    begin
        if (clk_div_cnt == 999)
        begin
            clk_div_cnt <= 0;
            derived_clk<= ~derived_clk;
        end
        else
        begin
            clk_div_cnt <= clk_div_cnt + 1;
        end
    end
end


//END DEBUG

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
assign adc_mon_data = {encoder_index_dbg,encoder_b_dbg,encoder_a_dbg,axi_q_current_dbg,axi_d_current_dbg,axi_rotor_velocity_dbg, axi_electrical_position_dbg, axi_rotor_position_dbg,axi_phase_current_b_dbg,axi_phase_current_a_dbg, axi_phase_voltage_b_dbg,axi_phase_voltage_a_dbg,axi_inverter_enable_dbg,axi_position_valid_dbg,axi_overcurrent_error_dbg,inverter_enable_c_dbg, inverter_enable_b_dbg, inverter_enable_a_dbg,pwm_c_dbg, pwm_b_dbg, pwm_a_dbg} ;

// multiple instances synchronization
assign pid_s = 32'd0;
assign adc_start_s = (pid_s == 32'd0) ? adc_start_out : adc_start_in;
assign dma_start_s = (pid_s == 32'd0) ? dma_start_out : dma_start_in;

assign fmc_m1_en_o  = 1'b0;
assign pwm_s        = oloop_matlab_s ? 32'h0: pwm_open_s ;
assign position_s   = sensors_o == 2'b01 ? position_start : position_i;

always @(posedge ref_clk) begin
    if (adc_rst == 1'b1) begin
        adc_start_out <= 1'b0;
    end else begin
        adc_start_out <= 1'b1;
    end
end

// adc channels - dma interface

always @(posedge ref_clk)
begin
    adc_data  <= dma_count_s;
    adc_valid <= pwm_clk_i;
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

oloop_start
(
    .clk_i(ref_clk),
    .rst_i(!up_rstn),
    .enable_i(run_s),
    .position_i(position_i),        // position as read from the BEMF sensors
    .position_o(position_start)     // position that is transmitted forward
);

motor_driver
#( .PWM_BITS(11))
motor_driver_inst
(
    .clk_i(ref_clk),
    .pwm_clk_i(pwm_clk_i),
    .rst_i(!up_rstn) ,
    .run_i(run_s),
    .run_o(motor_running_s),
    .star_delta_i(star_delta_s),
    .position_i(position_s),
    .pwm_duty_i(pwm_s),
    .IN_A_o(fmc_m1_in_a_s),
    .IN_B_o(fmc_m1_in_b_s),
    .IN_C_o(fmc_m1_in_c_s),
    .EN_A_o(fmc_m1_en_a_s),
    .EN_B_o(fmc_m1_en_b_s),
    .EN_C_o(fmc_m1_en_c_s)
);

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
    .star_delta_o(star_delta_s),
    .sensors_o(sensors_o),
    .calibrate_adcs_o(),
    .reference_speed_o(reference_speed_s),
    .oloop_matlab_o(oloop_matlab_s),
    .kp_o(kp_s),
    .ki_o(ki_s),
    .kd_o(kd_s),
    .err_i(err_s),
    .pwm_open_o(pwm_open_s)
);

// matlab controller
/*
motor_control_cw motor_control_cw_i1
(
    .ce(1'b1),
    .clk(clk_dbg_i),
    .rst(!oloop_matlab_s | !motor_running_s),
    .kd(kd_s),
    .ki(ki_s),
    .kp(kp_s),
    .motor_speed(speed_i),
    .new_motor_speed(new_speed_i),
    .ref_speed(reference_speed_s),
    .err(err_s),
    .pwm(pwm_controller_s),
    .speed(speed_rpm_s)
);
*/
controllerPeripheralHdlAdi controllerPeripheralHdlAdi_i1
(
    .clk_in_1_2000(derived_clk),
    .clk_in(ctrl_clk_i),
    .reset_1_2000(!run_s),
    .reset(!run_s),
    .clk_enable(1'b1),
    .clk_enable_2000(1'b1),
    .adc_current_0(adc_current_0_dbg),
    .adc_current_1(adc_current_1_dbg),
    .encoder_a(encoder_a_dbg),
    .encoder_b(encoder_b_dbg),
    .encoder_index(new_speed_i),
    .axi_controller_mode(axi_controller_mode_dbg),
    .axi_command(axi_command_dbg),
    .axi_velocity_p_gain(axi_velocity_p_gain_dbg),
    .axi_velocity_i_gain(axi_velocity_i_gain_dbg),
    .axi_current_p_gain(axi_current_p_gain_dbg),
    .axi_current_i_gain(axi_current_i_gain_dbg),
    .axi_open_loop_bias(axi_open_loop_bias_dbg),
    .axi_open_loop_scalar(axi_open_loop_scalar_dbg),
    .axi_encoder_zero_offset(axi_encoder_zero_offset_dbg),
    .pwm_a(pwm_a_dbg),//1
    .pwm_b(pwm_b_dbg),//1
    .pwm_c(pwm_c_dbg),//1
    .inverter_enable_a(inverter_enable_a_dbg),//1
    .inverter_enable_b(inverter_enable_b_dbg),//1
    .inverter_enable_c(inverter_enable_c_dbg),//1
    .axi_overcurrent_error(axi_overcurrent_error_dbg),//1
    .axi_position_valid(axi_position_valid_dbg),//1
    .axi_inverter_enable(axi_inverter_enable_dbg),//1
    .axi_phase_voltage_a(axi_phase_voltage_a_dbg),//20
    .axi_phase_voltage_b(axi_phase_voltage_b_dbg),//20
    .axi_phase_current_a(axi_phase_current_a_dbg),//18
    .axi_phase_current_b(axi_phase_current_b_dbg),//18
    .axi_rotor_position(axi_rotor_position_dbg),//18
    .axi_electrical_position(axi_electrical_position_dbg),//18
    .axi_rotor_velocity(axi_rotor_velocity_dbg),//18
    .axi_d_current(axi_d_current_dbg),//18
    .axi_q_current(axi_q_current_dbg)//18
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
    .dma_start (dma_start_out),
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

