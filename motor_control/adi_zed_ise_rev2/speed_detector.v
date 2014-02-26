// -----------------------------------------------------------------------------
//
// Copyright 2014(c) Analog Devices, Inc.
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
// FILE NAME : speed_detector.v
// MODULE NAME : speed_detector
// AUTHOR : ACostina
// AUTHOR’S EMAIL : adrian.costina@analog.com
//
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module speed_detector
//----------- Parameters Declarations -------------------------------------------
#(
    parameter   AVERAGE_WINDOW   = 32,       // Averages data on the latest samples
    parameter   LOG_2_AW         = 5,
	parameter	SAMPLE_CLK_DECIM = 10000
)
//----------- Ports Declarations -----------------------------------------------
(
    input               clk_i,
    input               rst_n_i,
    input       [ 2:0]  position_i,         // position as determined by the sensors
    output reg          new_speed_o,        // signals a new speed has been computed
    output reg  [31:0]  speed_o             // data bus with the current speed
);
//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
reg [2:0]   old_position;
reg [63:0]  avg_register;
reg [31:0]  cnt_period;
reg [31:0]  fifo[0 : AVERAGE_WINDOW - 1]; // 32 bit wide RAM
reg [LOG_2_AW - 1 : 0] write_addr;

reg [31:0]  sample_clk_div;

//------------------------------------------------------------------------------
//----------- Local Parameters -------------------------------------------------
//------------------------------------------------------------------------------
localparam MAX_SPEED_CNT = 32'h00010000;
//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// Accumulate the time for the rotations for which we want to make the average
always @(posedge clk_i)
begin
    if (rst_n_i == 1'b0)
    begin
        cnt_period      <= 32'h0;
        old_position    <= 3'h0;
		write_addr      <= 0;
		avg_register	<= MAX_SPEED_CNT;
    end
    else
    begin
        if ((position_i != old_position) || (cnt_period == MAX_SPEED_CNT))     // when the position changes
        begin
            cnt_period   <= 32'h0;           // reset the period counter
			old_position <= position_i;      // save the new position

			avg_register <= avg_register - fifo[write_addr] + cnt_period;
				
			fifo[write_addr] <= cnt_period;
			write_addr <= write_addr + 1;
        end
        else
        begin
            cnt_period  <= cnt_period + 32'h1;
        end
    end
end

// Filter the output data
always @(posedge clk_i)
begin
	if (rst_n_i == 1'b0)
	begin
		sample_clk_div <= 0;
		speed_o <= 0;
		new_speed_o <= 0;
	end
	else
	begin
		if(sample_clk_div == SAMPLE_CLK_DECIM)
		begin
			sample_clk_div <= 0;
			speed_o <= (avg_register >> LOG_2_AW);
			new_speed_o <= 1;
		end
		else
		begin
			sample_clk_div <= sample_clk_div + 1;
			new_speed_o <= 0;
		end
	end
end

endmodule
