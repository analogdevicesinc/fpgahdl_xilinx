
module splitter (
	input clk,
	input resetn,

	input s_valid,
	output s_ready,

	output [C_NUM_M-1:0] m_valid,
	input [C_NUM_M-1:0] m_ready
);

parameter C_NUM_M = 2;

reg [C_NUM_M-1:0] acked;

assign s_ready = &(m_ready | acked);
assign m_valid = s_valid ? ~acked : {C_NUM_M{1'b0}};

always @(posedge clk)
begin
	if (resetn == 1'b0) begin
		acked <= {C_NUM_M{1'b0}};
	end else begin
		if (s_valid & s_ready)
			acked <= {C_NUM_M{1'b0}};
		else
			acked <= acked | (m_ready & m_valid);
	end
end

endmodule
