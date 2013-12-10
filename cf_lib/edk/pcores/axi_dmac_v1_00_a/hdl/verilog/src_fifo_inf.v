module dmac_src_fifo_inf (
	input clk,
	input resetn,

	input enable,
	output enabled,
	input sync_id,
	output sync_id_ret,

	input [C_ID_WIDTH-1:0] request_id,
	output [C_ID_WIDTH-1:0] response_id,
	input eot,

	input en,
	input [C_DATA_WIDTH-1:0] din,
	output reg overflow,

	input fifo_ready,
	output fifo_valid,
	output [C_DATA_WIDTH-1:0] fifo_data,

	input req_valid,
	output req_ready,
	input [3:0] req_last_burst_length,
	input req_sync_on_user
);

parameter C_ID_WIDTH = 3;
parameter C_DATA_WIDTH = 64;
parameter C_LENGTH_WIDTH = 24;

reg valid;
wire ready;
reg [C_DATA_WIDTH-1:0] buffer;

always @(posedge clk)
begin
	if (resetn == 1'b0) begin
		valid <= 1'b0;
		overflow <= 1'b0;
	end else begin
		if (enable) begin
			if (en) begin
				buffer <= din;
				valid <= 1'b1;
			end else if (ready) begin
				valid <= 1'b0;
			end
			overflow <= en & valid & ~ready;
		end else begin
			if (ready)
				valid <= 1'b0;
			overflow <= en;
		end
	end
end

assign sync_id_ret = sync_id;

dmac_data_mover # (
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DATA_WIDTH(C_DATA_WIDTH),
	.C_DISABLE_WAIT_FOR_ID(0)
) i_data_mover (
	.s_axi_aclk(clk),
	.s_axi_aresetn(resetn),

	.enable(enable),
	.enabled(enabled),
	.sync_id(sync_id),

	.request_id(request_id),
	.response_id(response_id),
	.eot(eot),
	
	.req_valid(req_valid),
	.req_ready(req_ready),
	.req_last_burst_length(req_last_burst_length),

	.s_axi_ready(ready),
	.s_axi_valid(valid),
	.s_axi_data(buffer),
	.m_axi_ready(fifo_ready),
	.m_axi_valid(fifo_valid),
	.m_axi_data(fifo_data)
);

endmodule
