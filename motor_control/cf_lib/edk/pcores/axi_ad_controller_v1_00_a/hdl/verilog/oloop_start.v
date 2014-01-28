// -----------------------------------------------------------------------------
//
// Copyright 2013(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//  - Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//  - Neither the name of Analog Devices, Inc. nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//  - The use of this software may or may not infringe the patent rights
//    of one or more patent holders.  This license does not release you
//    from the requirement that you obtain separate licenses from these
//    patent holders to use this software.
//  - Use of the software either in source or binary form, must be run
//    on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// -----------------------------------------------------------------------------
// FILE NAME : oloop_start.v
// MODULE NAME : oloop_start
// AUTHOR : ACostina
// AUTHOR'S EMAIL : adrian.costina@analog.com
// -----------------------------------------------------------------------------
// KEYWORDS : open loop, Motor Control
// -----------------------------------------------------------------------------
// PURPOSE : This module is used for open loop starting of a motor which is
// controlled using the BEMF sensing technique
// -----------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy      :
// Clock Domains       :
// Critical Timing     :
// Test Features       :
// Asynchronous I/F    :
// Instantiations      :
// Synthesizable (y/n) : y
// Target Device       :
// Other               :
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module oloop_start
//----------- Ports Declarations -----------------------------------------------
(
    input               clk_i,
    input               rst_i,
    input               enable_i,
    input       [2:0]   position_i,         // position as read from the BEMF sensors
    output      [2:0]   position_o          // position that is transmitted forward
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg [31:0]  step_count;         // used for counting the number of ticks in the current step
reg [31:0]  step_speed;         // used for holding the speed at which the motor should run
reg [31:0]  rotations_count;    // used to hold the number of rotations necessary to be controlled by this module
reg [31:0]  align_counter;      // counter used in the allignment process
reg [ 8:0]  motor_state;        // used in the state machine
reg [ 8:0]  motor_next_state;   // used in the state machine
reg [ 2:0]  position_reg;       // used for holding the output position while the motor is controlled by this module
reg [31:0]  speed_sync_reg1;    // synchronization register
reg [31:0]  speed_sync_reg2;    // synchronization register

//------------------------------------------------------------------------------
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------
wire         align_complete;    // signals that the motor si correctly alligned

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------
localparam OFF      = 9'b000000001;         // the motor is off
localparam ALIGN    = 9'b000000010;         // the motor is alligned to a known position
localparam PHASE1   = 9'b000000100;         // position of the motor
localparam PHASE2   = 9'b000001000;         // position of the motor
localparam PHASE3   = 9'b000010000;         // position of the motor
localparam PHASE4   = 9'b000100000;         // position of the motor
localparam PHASE5   = 9'b001000000;         // position of the motor
localparam PHASE6   = 9'b010000000;         // position of the motor
localparam RUN      = 9'b100000000;         // the motor is running, position is transmitted from the BEMF sensors

localparam [31:0] ALIGN_TIME = 32'h5000000; // time needded to allign the motors
localparam [31:0] START_ROTATIONS = 60;    // the number of rotations controlled by this module
//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

assign align_complete = align_counter < ALIGN_TIME ? 0 : 1;             // signal when the motor is alligned to a known position
assign position_o   = (motor_state == RUN || motor_state == OFF) ?      // the output position is either the one from the BEMF
                        position_i : position_reg;                      // or the one determined by this module

//synchronize the inputs
always @(posedge clk_i)
begin
    speed_sync_reg1     <= 32'h40000;
    speed_sync_reg2     <= speed_sync_reg1; // speed input is on a different clock
end

always @(posedge clk_i)
begin
    if(rst_i == 1'b1 || enable_i == 0)    // use enable as reset signal
    begin
        step_count      <= 0;
        rotations_count <= START_ROTATIONS;
    end
    else
    begin
        if (motor_next_state != motor_state)
        begin
            if (motor_state == ALIGN)
            begin
                step_speed  <= speed_sync_reg2 ; // consider the first rotations slow, each taking two times as much time as the next
            end
            else if ( motor_state == PHASE6 && rotations_count > 0 )
            begin
                rotations_count <= rotations_count - 1;
                if (rotations_count == 36)
                begin
                    step_speed <= step_speed - step_speed / 4;
                end
                if (rotations_count == 18)
                begin
                    step_speed <= step_speed - step_speed / 4;
                end
            end
            step_count  <= 0;
        end
        else
        begin
            step_count  <= step_count + 1;
        end
    end
end

always @(posedge clk_i)
begin
    if(rst_i == 1'b1)
    begin
        motor_state     <= OFF;
        align_counter   <= 0;
    end
    else
    begin
        motor_state     <= (enable_i == 1'b1 ? motor_next_state : OFF);
        align_counter   <= motor_state == ALIGN ? align_counter + 1 : 0;
    end
end


//Determine the next motor state
// The first several rotations, the step speed is computed. After that, when
// the input position has the same value as the computed position, the motor
// is controlled directly by the BEMF signals
always @(motor_state,enable_i, align_complete, step_count, step_speed, rotations_count )
begin
    motor_next_state = motor_state;
    case(motor_state)
        OFF:
        begin
            position_reg          = 3'b100;
            if(enable_i == 1'b1)
            begin
                motor_next_state = ALIGN;
            end
        end
        ALIGN:
        begin
            position_reg          = 3'b100;
            if(align_complete == 1'b1)
            begin
                motor_next_state = PHASE2;
            end
        end
        PHASE1:
        begin
            position_reg          = 3'b100;
            if(step_count > step_speed)
            begin
                motor_next_state = PHASE2;
            end
        end
        PHASE2:
        begin
            position_reg     = 3'b101;
            if(step_count > step_speed)
            begin
                motor_next_state = PHASE3;
            end
        end
        PHASE3:
        begin
            position_reg     = 3'b001;
            if(step_count > step_speed)
            begin
                motor_next_state = PHASE4;
            end
        end
        PHASE4:
        begin
            position_reg     = 3'b011;
            if(step_count > step_speed)
            begin
                motor_next_state = PHASE5;
            end
        end
        PHASE5:
        begin
            position_reg     = 3'b010;
            if(step_count > step_speed)
            begin
                motor_next_state = PHASE6;
            end
        end
        PHASE6:
        begin
            position_reg         = 3'b110;
            if (rotations_count == 0)
            begin
                motor_next_state = RUN;
            end
            else
            if(step_count > step_speed)
            begin
                motor_next_state = PHASE1;
            end
        end
        RUN:
        begin
            position_reg    = 3'b100;
        end
        default:
        begin
            position_reg        = 3'b100;
            motor_next_state    = OFF;
        end
    endcase
end

endmodule
