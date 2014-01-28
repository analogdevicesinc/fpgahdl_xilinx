
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

module encoder_stub
(
    input               clk_i,
    input       [2:0]   position_i,
    output  reg         encoder_a_o,
    output  reg         encoder_b_o,
    output  reg         encoder_index_o
);

// Local localparams

localparam ONE      = 4'b0001;
localparam TWO      = 4'b0010;
localparam THREE    = 4'b0100;
localparam FOUR     = 4'b1000;

reg     [3:0]   state_enc           = ONE;  // current state
reg     [3:0]   next_state_enc      = ONE;  // next state
reg     [2:0]   position_enc        = 0;    // holds the last known position
reg     [31:0]  position_steps_s    = 0;    // number of steps (changes in the position of the shaft)
reg     [21:0]  enc_step_duration_s = 0;    // gives the duration of one step, as a function of the duration of a full rotation
reg     [31:0]  ticks_per_rotation  = 0;    // total time for a complete rotation
reg     [21:0]  enc_step_timer_s    = 0;
reg     [9:0]   index_counter_s     = 0;    // used to generate index signal
reg             change_state        = 0;

always @(posedge clk_i )
begin
    ticks_per_rotation <= ticks_per_rotation + 1;

    if (position_enc!= position_i)
    begin
        position_enc <= position_i;
        if (position_steps_s == 32'd23)
        begin
            position_steps_s    <= 32'd0;
            enc_step_duration_s <= ticks_per_rotation >> 10;
            ticks_per_rotation  <= 0;
        end
        else
        begin
            position_steps_s <= position_steps_s + 1;
        end
    end
end

always @(posedge clk_i)
begin
    if ( enc_step_timer_s > enc_step_duration_s - 1 )
    begin
        enc_step_timer_s    <= 0;
        change_state        <= 1'b1;
        index_counter_s     <= index_counter_s + 10'h1;
    end
    else
    begin
        enc_step_timer_s    <= enc_step_timer_s + 22'h1;
        change_state        <= 1'b0;
    end
end

always @(posedge clk_i)
begin
    state_enc <= next_state_enc;
end

always @(posedge clk_i)
begin
    next_state_enc  <= state_enc;
    if (index_counter_s == 0)
    begin
        encoder_index_o <= 1'b1;
    end
    else
    begin
        encoder_index_o <= 1'b0;
    end

    case (state_enc)
        ONE:
        begin
            encoder_a_o <= 1'b0;
            encoder_b_o <= 1'b0;
            if (change_state == 1'b1)
            begin
                next_state_enc <= TWO;
            end
        end
        TWO:
        begin
            encoder_a_o <= 1'b0;
            encoder_b_o <= 1'b1;
            if (change_state == 1'b1)
            begin
                next_state_enc <= THREE;
            end
        end
        THREE:
        begin
            encoder_a_o <= 1'b1;
            encoder_b_o <= 1'b1;
            if (change_state == 1'b1)
            begin
                next_state_enc <= FOUR;
            end
        end
        FOUR:
        begin
            encoder_a_o <= 1'b1;
            encoder_b_o <= 1'b0;
            if (change_state == 1'b1)
            begin
                next_state_enc <= ONE;
            end
        end
        default:
        begin
            next_state_enc <= ONE;
        end
    endcase
end

endmodule
