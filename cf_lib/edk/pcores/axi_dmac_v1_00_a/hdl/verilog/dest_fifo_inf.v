module dmac_dest_fifo_inf (
	input clk,
	input resetn,

	input enable,
	output enabled,
	input sync_id,
	output sync_id_ret,

	input [C_ID_WIDTH-1:0] request_id,
	output [C_ID_WIDTH-1:0] response_id,
	output [C_ID_WIDTH-1:0] data_id,
	input data_eot,
	input response_eot,

	input en,
	output [C_DATA_WIDTH-1:0] dout,
	output reg valid,
	output reg underflow,

	output fifo_ready,
	input fifo_valid,
	input [C_DATA_WIDTH-1:0] fifo_data,

	input req_valid,
	output req_ready,
	input [3:0] req_last_burst_length,

	output response_valid,
	input response_ready,
	output response_resp_eot,
	output [1:0] response_resp
);

parameter C_ID_WIDTH = 3;
parameter C_DATA_WIDTH = 64;
parameter C_LENGTH_WIDTH = 24;

assign sync_id_ret = sync_id;
wire data_enabled;
wire [C_ID_WIDTH-1:0] data_id;

wire _fifo_ready;
assign fifo_ready = _fifo_ready | ~enabled;

reg data_ready;
wire data_valid;

always @(posedge clk)
begin
	if (resetn == 1'b0) begin
		data_ready <= 1'b1;
		underflow <= 1'b0;
		valid <= 1'b0;
	end else begin
		if (enable == 1'b1) begin
			valid <= data_valid & en;
			data_ready <= en & data_valid;
			underflow <= en & ~data_valid;
		end else begin
			valid <= 1'b0;
			data_ready <= 1'b1;
			underflow <= en;
		end
	end
end

dmac_data_mover # (
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DATA_WIDTH(C_DATA_WIDTH),
	.C_DISABLE_WAIT_FOR_ID(0)
) i_data_mover (
	.s_axi_aclk(clk),
	.s_axi_aresetn(resetn),

	.enable(enable),
	.enabled(data_enabled),
	.sync_id(sync_id),

	.request_id(request_id),
	.response_id(data_id),
	.eot(data_eot),
	
	.req_valid(req_valid),
	.req_ready(req_ready),
	.req_last_burst_length(req_last_burst_length),

	.s_axi_ready(_fifo_ready),
	.s_axi_valid(fifo_valid),
	.s_axi_data(fifo_data),
	.m_axi_ready(data_ready),
	.m_axi_valid(data_valid),
	.m_axi_data(dout)
);

dmac_response_generator # (
	.C_ID_WIDTH(C_ID_WIDTH)
) i_response_generator (
	.clk(clk),
	.resetn(resetn),

	.enable(data_enabled),
	.enabled(enabled),
	.sync_id(sync_id),

	.request_id(data_id),
	.response_id(response_id),

	.eot(response_eot),

	.resp_valid(response_valid),
	.resp_ready(response_ready),
	.resp_eot(response_resp_eot),
	.resp_resp(response_resp)
);

endmodule
