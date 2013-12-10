// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
//  Author: Lars-Peter Clausen <lars@metafoo.de>
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

/*
 * Helper module for synchronizing a flag signal from one clock domain to
 * another. The source domain must make sure that it does not generate flags
 * faster than the target domain can consume them, otherwise the target domain
 * may not see the flag. The sender can use the in_busy signal to check if the
 * receiver domain has seen the flag.
 * In addition to the flag it is possible to transfer arbitrary data from the
 * source domain to target domain. In order for this to work correctly the data
 * must be kept stable (i.e. no changes) in source domain until the flag has
 * been received in the target domain. If the source domain can't guarantee that
 * the signal will remain stable it is possible to insert a hold buffer by
 * setting IN_HOLD to 1. This will insert an additional set of FF in the source
 * domain which will be loaded from in_data when in_flag is asserted. In the
 * target domain out_data is only valid during the clock cycle in which out_flag
 * is asserted. Setting OUT_HOLD to 1 will insert a set of FF in the target
 * domain that will be loaded when a flag is received. This makes it possible to
 * safely access out_data even though out_flag is not asserted.
 */
module sync_flag(
	input rstn,
	input in_clk,
	input in_flag,
	input [DATA_WIDTH-1:0] in_data,
	output in_busy,
	input out_clk,
	output out_flag,
	output [DATA_WIDTH-1:0] out_data
);

// Whether the input and output clock are asynchronous, if set to 0 the
// synchronizer will be bypassed.
parameter CLK_ASYNC = 1;
// Bit-width of the data that is transfered together with the flag.
parameter DATA_WIDTH = 1;
// If 1 an additional hold buffer will be inserted in the source domain.
parameter IN_HOLD = 0;
// If 1 an additional hold buffer will be inserted in the target domain.
parameter OUT_HOLD = 0;

reg [DATA_WIDTH-1:0] out_data_hold = 'h0;
wire [DATA_WIDTH-1:0] out_data_s;
reg out_flag_d1 = 'h0;
wire out_flag_s;

generate if (CLK_ASYNC) begin

reg in_toggle = 1'b0;
reg [DATA_WIDTH-1:0] in_data_hold = 'h0;

always @(posedge in_clk)
begin
	if (rstn == 1'b0) begin
		in_toggle <= 1'b0;
	end else begin
		if (in_flag == 1'b1)
			in_toggle <= ~in_toggle;
	end
end

reg [2:0] out_toggle = 'h0;
assign out_flag_s = out_toggle[2] ^ out_toggle[1];

always @(posedge out_clk)
begin
	if (rstn == 1'b0) begin
		out_toggle <= 3'b0;
	end else begin
		out_toggle[0] <= in_toggle;
		out_toggle[2:1] <= out_toggle[1:0];
	end
end

reg [1:0] in_toggle_ret = 'h0;
assign in_busy = in_toggle ^ in_toggle_ret[1];

always @(posedge in_clk)
begin
	if (rstn == 1'b0) begin
		in_toggle_ret <= 2'b0;
	end else begin
		in_toggle_ret[0] <= out_toggle[2];
		in_toggle_ret[1] <= in_toggle_ret[0];
	end
end

always @(posedge in_clk)
begin
	if (rstn == 1'b0) begin
		in_data_hold <= 'h0;
	end else begin
		if (in_flag == 1'b1)
			in_data_hold <= in_data;
	end
end

assign out_data_s = IN_HOLD == 1'b1 ? in_data_hold : in_data;

end else begin

assign in_busy = 1'b0;
assign out_flag_s = in_flag;
assign out_data_s = in_data;

end endgenerate

always @(posedge out_clk)
begin
	if (rstn == 1'b0) begin
		out_data_hold <= 'h0;
		out_flag_d1 <= 'h0;
	end else begin
		if (out_flag_s == 1'b1)
			out_data_hold <= out_data_s;
		out_flag_d1 <= out_flag_s;
	end
end

assign out_data = OUT_HOLD == 1'b1 ? out_data_hold : out_data_s;
assign out_flag = OUT_HOLD == 1'b1 ? out_flag_d1 : out_flag_s;

endmodule
