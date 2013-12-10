module dmac_src_axi_stream (
	input s_axis_aclk,
	input s_axis_aresetn,

	input enable,
	output enabled,
	input sync_id,
	output sync_id_ret,

	input [C_ID_WIDTH-1:0] request_id,
	output [C_ID_WIDTH-1:0] response_id,
	input eot,

	output s_axis_ready,
	input s_axis_valid,
	input [C_S_AXIS_DATA_WIDTH-1:0] s_axis_data,
	input [0:0] s_axis_user,

	input fifo_ready,
	output fifo_valid,
	output [C_S_AXIS_DATA_WIDTH-1:0] fifo_data,

	input req_valid,
	output req_ready,
	input [3:0] req_last_burst_length,
	input req_sync_on_user
);

parameter C_ID_WIDTH = 3;
parameter C_S_AXIS_DATA_WIDTH = 64;
parameter C_LENGTH_WIDTH = 24;

reg needs_sync = 1'b0;
wire sync = s_axis_user[0];
wire has_sync = ~needs_sync | sync;
wire sync_valid = s_axis_valid & has_sync;
assign sync_id_ret = sync_id;

always @(posedge s_axis_aclk)
begin
	if (s_axis_aresetn == 1'b0) begin
		needs_sync <= 1'b0;
	end else begin
		if (s_axis_valid && s_axis_ready && sync) begin
			needs_sync <= 1'b0;
		end else if (req_valid && req_ready) begin
			needs_sync <= req_sync_on_user;
		end
	end
end

dmac_data_mover # (
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DATA_WIDTH(C_S_AXIS_DATA_WIDTH),
	.C_DISABLE_WAIT_FOR_ID(0)
) i_data_mover (
	.s_axi_aclk(s_axis_aclk),
	.s_axi_aresetn(s_axis_aresetn),

	.enable(enable),
	.enabled(enabled),
	.sync_id(sync_id),

	.request_id(request_id),
	.response_id(response_id),
	.eot(eot),
	
	.req_valid(req_valid),
	.req_ready(req_ready),
	.req_last_burst_length(req_last_burst_length),

	.s_axi_ready(s_axis_ready),
	.s_axi_valid(sync_valid),
	.s_axi_data(s_axis_data),
	.m_axi_ready(fifo_ready),
	.m_axi_valid(fifo_valid),
	.m_axi_data(fifo_data)
);

endmodule
