
module fifo_address_gray_pipelined (
	input m_axis_aclk,
	input m_axis_aresetn,
	input m_axis_ready,
	output reg m_axis_valid,
	output [C_ADDRESS_WIDTH-1:0] m_axis_raddr_next,

	input s_axis_aclk,
	input s_axis_aresetn,
	output reg s_axis_ready,
	input s_axis_valid,
	output reg s_axis_empty,
	output [C_ADDRESS_WIDTH-1:0] s_axis_waddr
);

parameter C_ADDRESS_WIDTH = 4;

reg [C_ADDRESS_WIDTH:0] _s_axis_waddr = 'h00;
reg [C_ADDRESS_WIDTH:0] _s_axis_waddr_next;
wire [C_ADDRESS_WIDTH:0] _s_axis_raddr;

reg [C_ADDRESS_WIDTH:0] _m_axis_raddr = 'h00;
reg [C_ADDRESS_WIDTH:0] _m_axis_raddr_next;
wire [C_ADDRESS_WIDTH:0] _m_axis_waddr;

assign s_axis_waddr = _s_axis_waddr[C_ADDRESS_WIDTH-1:0];
assign m_axis_raddr_next = _m_axis_raddr_next[C_ADDRESS_WIDTH-1:0];

always @(*)
begin
	if (s_axis_ready && s_axis_valid)
		_s_axis_waddr_next <= _s_axis_waddr + 1;
	else
		_s_axis_waddr_next <= _s_axis_waddr;
end

always @(posedge s_axis_aclk)
begin
	if (s_axis_aresetn == 1'b0) begin
		_s_axis_waddr <= 'h00;
	end else begin
		_s_axis_waddr <= _s_axis_waddr_next;
	end
end

always @(*)
begin
	if (m_axis_ready && m_axis_valid)
		_m_axis_raddr_next <= _m_axis_raddr + 1;
	else
		_m_axis_raddr_next <= _m_axis_raddr;
end

always @(posedge m_axis_aclk)
begin
	if (m_axis_aresetn == 1'b0) begin
		_m_axis_raddr <= 'h00;
	end else begin
		_m_axis_raddr <= _m_axis_raddr_next;
	end
end

sync_gray #(
	.DATA_WIDTH(C_ADDRESS_WIDTH + 1)
) i_waddr_sync (
	.in_clk(s_axis_aclk),
	.in_resetn(s_axis_aresetn),
	.out_clk(m_axis_aclk),
	.out_resetn(m_axis_aresetn),
	.in_count(_s_axis_waddr),
	.out_count(_m_axis_waddr)
);

sync_gray #(
	.DATA_WIDTH(C_ADDRESS_WIDTH + 1)
) i_raddr_sync (
	.in_clk(m_axis_aclk),
	.in_resetn(m_axis_aresetn),
	.out_clk(s_axis_aclk),
	.out_resetn(s_axis_aresetn),
	.in_count(_m_axis_raddr),
	.out_count(_s_axis_raddr)
);

always @(posedge s_axis_aclk)
begin
	if (s_axis_aresetn == 1'b0) begin
		s_axis_ready <= 1'b1;
		s_axis_empty <= 1'b1;
	end else begin
		s_axis_ready <= (_s_axis_raddr[C_ADDRESS_WIDTH] == _s_axis_waddr_next[C_ADDRESS_WIDTH] ||
			_s_axis_raddr[C_ADDRESS_WIDTH-1:0] != _s_axis_waddr_next[C_ADDRESS_WIDTH-1:0]);
		s_axis_empty <= _s_axis_raddr == _s_axis_waddr_next;
	end
end

always @(posedge m_axis_aclk)
begin
	if (s_axis_aresetn == 1'b0)
		m_axis_valid <= 1'b0;
	else begin
		m_axis_valid <= _m_axis_waddr != _m_axis_raddr_next;
	end
end

endmodule

