module dmac_dest_axi_stream (
	input s_axis_aclk,
	input s_axis_aresetn,

	input enable,
	output enabled,
	input sync_id,
	output sync_id_ret,

	input [C_ID_WIDTH-1:0] request_id,
	output [C_ID_WIDTH-1:0] response_id,
	output [C_ID_WIDTH-1:0] data_id,
	input data_eot,
	input response_eot,

	input m_axis_ready,
	output m_axis_valid,
	output [C_S_AXIS_DATA_WIDTH-1:0] m_axis_data,

	output fifo_ready,
	input fifo_valid,
	input [C_S_AXIS_DATA_WIDTH-1:0] fifo_data,

	input req_valid,
	output req_ready,
	input [3:0] req_last_burst_length,

	output response_valid,
	input response_ready,
	output response_resp_eot,
	output [1:0] response_resp
);

parameter C_ID_WIDTH = 3;
parameter C_S_AXIS_DATA_WIDTH = 64;
parameter C_LENGTH_WIDTH = 24;

assign sync_id_ret = sync_id;
wire data_enabled;
wire [C_ID_WIDTH-1:0] data_id;

// We are not allowed to just de-assert valid, but if the streaming target does
// not accept any samples anymore we'd lock up the DMA core. So retain the last
// beat when disabled until it is accepted. But if in the meantime the DMA core
// is re-enabled and new data becomes available overwrite the old.

dmac_data_mover # (
	.C_ID_WIDTH(C_ID_WIDTH),
	.C_DATA_WIDTH(C_S_AXIS_DATA_WIDTH),
	.C_DISABLE_WAIT_FOR_ID(0)
) i_data_mover (
	.s_axi_aclk(s_axis_aclk),
	.s_axi_aresetn(s_axis_aresetn),

	.enable(enable),
	.enabled(data_enabled),
	.sync_id(sync_id),

	.request_id(request_id),
	.response_id(data_id),
	.eot(data_eot),
	
	.req_valid(req_valid),
	.req_ready(req_ready),
	.req_last_burst_length(req_last_burst_length),

	.m_axi_ready(m_axis_ready),
	.m_axi_valid(m_axis_valid),
	.m_axi_data(m_axis_data),
	.s_axi_ready(_fifo_ready),
	.s_axi_valid(fifo_valid),
	.s_axi_data(fifo_data)
);

dmac_response_generator # (
	.C_ID_WIDTH(C_ID_WIDTH)
) i_response_generator (
	.clk(s_axis_aclk),
	.resetn(s_axis_aresetn),

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

assign fifo_ready = _fifo_ready | ~enabled;

endmodule
