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

module control_registers
(
//bus interface
    input              up_rstn,
    input              up_clk,
    input              up_sel,
    input              up_wr,
    input      [13:0]  up_addr,
    input      [31:0]  up_wdata,
    output reg [31:0]  up_rdata,
    output reg         up_ack,
//control
    input  [31:0]  err_i,
    output [31:0]  pwm_open_o,
    output         run_o,
    output         break_o,
    output         star_delta_o,
    output [1:0]   sensors_o,
    output [10:0]  gpo_o,
    output         oloop_matlab_o,
    output         calibrate_adcs_o,
    output [1:0]   controller_mode_reg_o,
    output [17:0]  command_reg_o,
    output [17:0]  velocity_p_gain_reg_o,
    output [17:0]  velocity_i_gain_reg_o,
    output [17:0]  current_p_gain_reg_o,
    output [17:0]  current_i_gain_reg_o,
    output [17:0]  open_loop_bias_reg_o,
    output [17:0]  open_loop_scalar_reg_o,
    output [17:0]  encoder_zero_offset_reg_o
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
//internal registers
reg [31:0] control_r;
reg [31:0] command_r;
reg [31:0] velocity_p_gain_r;
reg [31:0] velocity_i_gain_r;
reg [31:0] current_p_gain_r;
reg [31:0] current_i_gain_r;
reg [31:0] open_loop_bias_r;
reg [31:0] open_loop_scalar_r;
reg [31:0] encoder_zero_offset_r;
reg [31:0] pwm_open_r;
reg [31:0] pwm_break_r;
reg [31:0] status_r;

//------------------------------------------------------------------------------
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------
//internal signals
wire        up_sel_s;
wire        up_wr_s;
wire [31:0] err_r;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------
//decode block select
assign up_sel_s = (up_addr[13:4] == 10'h00) ? up_sel : 1'b0;
assign up_wr_s = up_sel_s & up_wr;

assign run_o                    = control_r[0];     // Run the motor
assign break_o                  = control_r[2];     // Activate the Break circuit
assign star_delta_o             = control_r[4];     // Select between star [0] or delta [1] controller
assign sensors_o                = control_r[9:8];   // Select between Hall[00] and BEMF[01] sensors 
assign controller_mode_reg_o    = control_r[17:16]; // 0 Error, 1 StandBy, 2 Velocity Control, 3 Open Loop Velocity Control
assign gpo_o                    = control_r[30:20]; // GPO pin control


assign pwm_open_o               = pwm_open_r;       // PWM value, for open loop control

assign command_reg_o                = command_r [17:0];
assign velocity_p_gain_reg_o        = velocity_p_gain_r[17:0];
assign velocity_i_gain_reg_o        = velocity_i_gain_r[17:0];
assign current_p_gain_reg_o         = current_p_gain_r[17:0];
assign current_i_gain_reg_o         = current_i_gain_r[17:0];
assign open_loop_bias_reg_o         = open_loop_bias_r[17:0];
assign open_loop_scalar_reg_o       = open_loop_scalar_r[17:0];
assign encoder_zero_offset_reg_o    = encoder_zero_offset_r[17:0];


assign err_r            = err_i;            // Register indicating the error between the set speed and actual speed
assign oloop_matlab_o   = control_r [12];   // Select between open loop control [0] and matlab control [1]

// processor write interface

always @(negedge up_rstn or posedge up_clk)
begin
   if (up_rstn == 0) 
   begin
       encoder_zero_offset_r    <= 'h0;
       control_r                <= 'h2;
       command_r                <= 'h1111;
       velocity_p_gain_r        <= 'h1;
       velocity_i_gain_r        <= 'h1;
       current_p_gain_r         <= 'h1;
       current_i_gain_r         <= 'h1;
       open_loop_bias_r         <= 'h1;
       open_loop_scalar_r       <= 'h1000;
       pwm_open_r               <= 'h5ff;
       pwm_break_r              <= 'd0;
       status_r                 <= 'd0;
   end
   else
   begin
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'h3))
       begin
           encoder_zero_offset_r    <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'h4))
       begin
           control_r                <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'h5))
       begin
           command_r              <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'h6))
       begin
           velocity_p_gain_r        <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'h7))
       begin
           velocity_i_gain_r        <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'h8))
       begin
           current_p_gain_r         <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'h9))
       begin
           current_i_gain_r         <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'ha))
       begin
           open_loop_bias_r         <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'hb))
       begin
           open_loop_scalar_r       <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'hc))
       begin
           pwm_open_r          <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'hd))
       begin
           pwm_break_r         <= up_wdata;
       end
       if ((up_wr_s == 1'b1) && (up_addr[3:0] == 4'he))
       begin
           status_r            <= up_wdata;
       end
   end
end


// processor read interface
//
always @(negedge up_rstn or posedge up_clk) 
begin
    if (up_rstn == 0) begin
        up_ack <= 'd0;
        up_rdata <= 'd0;
    end
    else
    begin
        up_ack <= up_sel_s;
        if (up_sel_s == 1'b1) begin
            case (up_addr[3:0])
                4'h3: up_rdata <= encoder_zero_offset_r;
                4'h4: up_rdata <= control_r;
                4'h5: up_rdata <= command_r;
                4'h6: up_rdata <= velocity_p_gain_r;
                4'h7: up_rdata <= velocity_i_gain_r;
                4'h8: up_rdata <= current_p_gain_r;
                4'h9: up_rdata <= current_i_gain_r;
                4'ha: up_rdata <= open_loop_bias_r;
                4'hb: up_rdata <= open_loop_scalar_r;
                4'hc: up_rdata <= pwm_open_r;
                4'hd: up_rdata <= pwm_break_r;
                4'he: up_rdata <= status_r;
                4'hf: up_rdata <= err_r;
                default: up_rdata <= 0;
            endcase
        end 
        else 
        begin
            up_rdata <= 32'd0;
        end
    end
end

endmodule
