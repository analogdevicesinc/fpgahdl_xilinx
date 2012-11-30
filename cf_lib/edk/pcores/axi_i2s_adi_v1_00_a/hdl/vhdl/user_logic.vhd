library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

entity user_logic is
	generic
	(
		C_NUM_REG			: integer := 12;
		C_SLV_DWIDTH			: integer := 24;

		C_MSB_POS			: integer := 0;		-- MSB Position in the LRCLK frame (0 - MSB first, 1 - LSB first)
		C_FRM_SYNC			: integer := 0;		-- Frame sync type (0 - 50% Duty Cycle, 1 - Pulse mode)
		C_LRCLK_POL			: integer := 0;		-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_BCLK_POL			: integer := 0 		-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
	);
	port
	(
		-- Data clock
		DATA_CLK_I			: in  std_logic;

		-- I2S
		BCLK_O				: out std_logic;
		LRCLK_O				: out std_logic;
		SDATA_I				: in  std_logic;
		SDATA_O				: out std_logic;

		-- added mem_rd for debugging
		MEM_RD_O			: out std_logic;

		-- AXI4-Lite
		Bus2IP_Clk			: in  std_logic;
		Bus2IP_Resetn			: in  std_logic;
		Bus2IP_Data			: in  std_logic_vector(31 downto 0);
		Bus2IP_BE			: in  std_logic_vector(3 downto 0);
		Bus2IP_RdCE			: in  std_logic_vector(C_NUM_REG-1 downto 0);
		Bus2IP_WrCE			: in  std_logic_vector(C_NUM_REG-1 downto 0);
		IP2Bus_Data			: out std_logic_vector(31 downto 0);
		IP2Bus_RdAck			: out std_logic;
		IP2Bus_WrAck			: out std_logic;
		IP2Bus_Error			: out std_logic;

		-- AXI Streaming interface
		S_AXIS_ACLK			: in  std_logic;
		S_AXIS_TREADY			: out std_logic;
		S_AXIS_TDATA			: in  std_logic_vector(31 downto 0);
		S_AXIS_TLAST			: in  std_logic;
		S_AXIS_TVALID			: in  std_logic;

		M_AXIS_ACLK			: in  std_logic;
		M_AXIS_TREADY			: in  std_logic;
		M_AXIS_TDATA			: out std_logic_vector(31 downto 0);
		M_AXIS_TLAST			: out std_logic;
		M_AXIS_TVALID			: out std_logic;
		M_AXIS_TKEEP			: out std_logic_vector(3 downto 0)
	);

	attribute MAX_FANOUT			: string;
	attribute SIGIS				: string;
	attribute SIGIS of S_AXIS_ACLK		: signal is "CLK";
	attribute SIGIS of Bus2IP_Clk		: signal is "CLK";
	attribute SIGIS of Bus2IP_Resetn	: signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture Behavioral of user_logic is

component i2s_rx_tx is
	generic(
		C_SLOT_WIDTH			: integer := 24;
		C_MSB_POS			: integer := 0;
		C_FRM_SYNC			: integer := 0;
		C_LRCLK_POL			: integer := 0;
		C_BCLK_POL			: integer := 0
	);
	port(
		CLK_I				: in  std_logic;
		DATA_CLK_I			: in  std_logic;
		RST_I				: in  std_logic;
		START_TX_I			: in  std_logic;
		START_RX_I			: in  std_logic;
		STOP_RX_I			: in  std_logic;
		DIV_RATE_I			: in std_logic_vector(7 downto 0);
		LRCLK_RATE_I			: in std_logic_vector(7 downto 0);
		TX_DATA_I			: in  std_logic_vector(C_SLOT_WIDTH-1 downto 0);
		OE_S_O				: out std_logic;
		RX_DATA_O			: out std_logic_vector(C_SLOT_WIDTH-1 downto 0);
		WE_S_O				: out std_logic;
		BCLK_O				: out std_logic;
		LRCLK_O				: out std_logic;
		SDATA_I				: in  std_logic;
		SDATA_O				: out std_logic
	);
end component;

------------------------------------------
-- Signals for user logic slave model s/w accessible register example
------------------------------------------
signal I2S_RST_I			: std_logic;
signal I2S_RST_TX_FIFO			: std_logic;
signal I2S_RST_RX_FIFO			: std_logic;
signal START_TX_I_int			: std_logic;
signal START_RX_I_int			: std_logic;
signal OE_S_O_int			: std_logic;
signal WE_S_O_int			: std_logic;
signal RX_DATA_O_int			: std_logic_vector(C_SLV_DWIDTH-1 downto 0);
signal TX_DATA_I_int			: std_logic_vector(C_SLV_DWIDTH-1 downto 0);
signal mem_rd				: std_logic;
signal mem_rd_d1			: std_logic;
signal sample_wr			: std_logic;
signal sample_wr_d1			: std_logic;

signal period_cnt			: integer range 0 to 65535;
signal period_cnt2			: integer range 0 to 65535;

signal I2S_RESET_REG			: std_logic_vector(31 downto 0);
signal I2S_CONTROL_REG			: std_logic_vector(31 downto 0);
signal I2S_CLK_CONTROL_REG		: std_logic_vector(31 downto 0);
signal I2S_STATUS_REG			: std_logic_vector(31 downto 0);
signal DIV_RATE_REG			: std_logic_vector(7 downto 0);
signal LRCLK_RATE_REG			: std_logic_vector(7 downto 0);
signal I2S_NR_CHAN_REG			: std_logic_vector(31 downto 0);
signal PERIOD_CNT_REG			: std_logic_vector(31 downto 0);
signal slv_reg7				: std_logic_vector(31 downto 0);
signal slv_reg4				: std_logic_vector(31 downto 0);
signal slv_reg8				: std_logic_vector(31 downto 0);
signal slv_reg9				: std_logic_vector(31 downto 0);
signal I2S_REG10			: std_logic_vector(31 downto 0);
signal I2S_REG11			: std_logic_vector(31 downto 0);
signal slv_reg_write_sel		: std_logic_vector(11 downto 0);
signal slv_reg_read_sel			: std_logic_vector(11 downto 0);
signal slv_ip2bus_data			: std_logic_vector(31 downto 0);
signal slv_read_ack			: std_logic;
signal slv_write_ack			: std_logic;

-- Audio samples FIFO
constant RAM_ADDR_WIDTH			: integer := 7;
type RAM_TYPE is array (0 to (2**RAM_ADDR_WIDTH - 1)) of std_logic_vector(31 downto 0);

-- TX FIFO signals
signal audio_fifo_tx			: RAM_TYPE;
signal audio_fifo_tx_wr_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal audio_fifo_tx_rd_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal audio_fifo_tx_full		: std_logic;
signal audio_fifo_tx_empty		: std_logic;

-- RX FIFO signals
signal audio_fifo_rx			: RAM_TYPE;
signal audio_fifo_rx_wr_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal audio_fifo_rx_rd_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal tvalid				: std_logic := '0';
signal rx_tlast				: std_logic;
signal drain_tx_dma			: std_logic;

begin

	drain_process: process (Bus2IP_Clk) is
	variable START_TX_I_int_d1 : std_logic;
	begin
		if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
			if Bus2IP_Resetn = '0' then
				drain_tx_dma <= '0';
			else
				if S_AXIS_TLAST = '1' then
					drain_tx_dma <= '0';
				elsif START_TX_I_int_d1 = '1' and START_TX_I_int = '0' then
					drain_tx_dma <= '1';
				end if;
				START_TX_I_int_d1 := START_TX_I_int;
			end if;
		end if;
	end process;

	-- Audio FIFO samples management
	-- TX FIFO
	S_AXIS_TREADY <= '1' when (audio_fifo_tx_full = '0' or drain_tx_dma = '1') else '0';
	mem_rd <= OE_S_O_int;

	-- MEM_RD_O for debugging
	MEM_RD_O <= mem_rd;
	--
	AUDIO_FIFO_TX_PROCESS : process(S_AXIS_ACLK) is
		variable audio_fifo_free_cnt : integer range 0 to 2**RAM_ADDR_WIDTH;
	begin
		if(S_AXIS_ACLK'event and S_AXIS_ACLK = '1') then
			if(Bus2IP_Resetn = '0') then
				audio_fifo_tx_wr_addr	<= 0;
				audio_fifo_tx_rd_addr	<= 0;
				audio_fifo_free_cnt 	:= 2**RAM_ADDR_WIDTH;
				audio_fifo_tx_full	<= '0';
				audio_fifo_tx_empty	<= '1';
				mem_rd_d1 		<= '0';
			elsif(I2S_RST_TX_FIFO = '1') then
				-- Fill TX FIFO with zeros
				for i in 0 to (2**RAM_ADDR_WIDTH - 1) loop
					audio_fifo_tx(conv_integer(i)) <= (others => '0');
				end loop;
				-- Reset FIFO counters
				audio_fifo_tx_wr_addr 	<= 0;
				audio_fifo_tx_rd_addr 	<= 0;
				audio_fifo_free_cnt 	:= 2**RAM_ADDR_WIDTH;
				audio_fifo_tx_full	<= '0';
				audio_fifo_tx_empty	<= '1';
				mem_rd_d1 		<= '0';
			else
				mem_rd_d1 <= mem_rd;

				if((S_AXIS_TVALID = '1')and(audio_fifo_free_cnt > 0)) then
					audio_fifo_tx(audio_fifo_tx_wr_addr) <= S_AXIS_TDATA;
					audio_fifo_tx_wr_addr 	<= audio_fifo_tx_wr_addr + 1;
					audio_fifo_free_cnt := audio_fifo_free_cnt - 1;
				end if;

				if(((mem_rd_d1 = '1')and(mem_rd = '0'))and(audio_fifo_free_cnt < (2**RAM_ADDR_WIDTH))) then
					audio_fifo_tx_rd_addr <= audio_fifo_tx_rd_addr + 1;
					audio_fifo_free_cnt := audio_fifo_free_cnt + 1;
				end if;

				if(audio_fifo_free_cnt = 0) then
					audio_fifo_tx_full <= '1';
				else
					audio_fifo_tx_full <= '0';
				end if;

				if(audio_fifo_free_cnt = 2**RAM_ADDR_WIDTH) then
					audio_fifo_tx_empty <= '1';
				else
					audio_fifo_tx_empty <= '0';
				end if;

				--TX_DATA_I_int(C_SLV_DWIDTH-1 downto 0) <= audio_fifo_tx(audio_fifo_tx_rd_addr)(C_SLV_DWIDTH-1 downto 0);
				TX_DATA_I_int(C_SLV_DWIDTH-1 downto 0) <= audio_fifo_tx(audio_fifo_tx_rd_addr)(31 downto 32-C_SLV_DWIDTH);
			end if;
		end if;
	end process AUDIO_FIFO_TX_PROCESS;

	-- RX FIFO
	sample_wr <= WE_S_O_int;
	AUDIO_FIFO_RX_PROCESS: process(M_AXIS_ACLK) is
		variable data_cnt : integer range 0 to 2**RAM_ADDR_WIDTH-1;
	begin
		if(M_AXIS_ACLK'event and M_AXIS_ACLK = '1') then
			if(Bus2IP_Resetn = '0') then
				audio_fifo_rx_wr_addr <= 0;
				audio_fifo_rx_rd_addr <= 0;
				data_cnt := 0;
			elsif(I2S_RST_RX_FIFO = '1') then
				-- Fill TX FIFO with zeros
				for i in 0 to (2**RAM_ADDR_WIDTH - 1) loop
					audio_fifo_rx(conv_integer(i)) <= (others => '0');
				end loop;
				-- Reset FIFO counters
				audio_fifo_rx_wr_addr <= 0;
				audio_fifo_rx_rd_addr <= 0;
				data_cnt := 0;
			else
				sample_wr_d1 <= sample_wr;
				if((sample_wr_d1 = '0')and(sample_wr = '1')) then
					audio_fifo_rx(audio_fifo_rx_wr_addr) <= RX_DATA_O_int & "00000000";
					--audio_fifo_rx(audio_fifo_rx_wr_addr) <= "0" & RX_DATA_O_int & "0000000";
					audio_fifo_rx_wr_addr <= audio_fifo_rx_wr_addr + 1;
					if(data_cnt < (2**RAM_ADDR_WIDTH - 1)) then
						data_cnt := data_cnt + 1;
					end if;
				end if;
				if((tvalid = '1')and(M_AXIS_TREADY = '1')) then
					audio_fifo_rx_rd_addr <= audio_fifo_rx_rd_addr + 1;
					data_cnt := data_cnt - 1;
					-- Added counter
					if(period_cnt2 = 0) then
						period_cnt2 <= period_cnt;
						rx_tlast <= '1';
					else
						period_cnt2 <= period_cnt2 - 1;
						rx_tlast <= '0';
					end if;
				end if;
				if(data_cnt > 0) then
					tvalid <= '1';
				else
					tvalid <= '0';
				end if;
			end if;
		end if;
	end process AUDIO_FIFO_RX_PROCESS;
	M_AXIS_TDATA 	<= audio_fifo_rx(audio_fifo_rx_rd_addr);
	M_AXIS_TVALID 	<= tvalid;
	M_AXIS_TLAST 	<= rx_tlast;
	M_AXIS_TKEEP 	<= "1111";

	Inst_I2sCtl: i2s_rx_tx
	generic map(
		C_SLOT_WIDTH	=> C_SLV_DWIDTH,
		C_MSB_POS	=> C_MSB_POS,
		C_FRM_SYNC	=> C_FRM_SYNC,
		C_LRCLK_POL	=> C_LRCLK_POL,
		C_BCLK_POL	=> C_BCLK_POL
	)
	port map(
		CLK_I		=> Bus2IP_Clk,
		DATA_CLK_I	=> DATA_CLK_I,
		RST_I		=> I2S_RST_I,
		START_TX_I	=> START_TX_I_int,
		START_RX_I	=> START_RX_I_int,
		STOP_RX_I	=> rx_tlast,
		DIV_RATE_I	=> DIV_RATE_REG,
		LRCLK_RATE_I	=> LRCLK_RATE_REG,
		TX_DATA_I	=> TX_DATA_I_int,
		OE_S_O		=> OE_S_O_int,
		WE_S_O		=> WE_S_O_int,
		RX_DATA_O	=> RX_DATA_O_int,
		BCLK_O		=> BCLK_O,
		LRCLK_O		=> LRCLK_O,
		SDATA_I		=> SDATA_I,
		SDATA_O		=> SDATA_O
	);
	------------------------------------------
	slv_reg_write_sel	<= Bus2IP_WrCE(11 downto 0);
	slv_reg_read_sel	<= Bus2IP_RdCE(11 downto 0);
	slv_write_ack		<= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7) or Bus2IP_WrCE(8) or Bus2IP_WrCE(9) or Bus2IP_WrCE(10) or Bus2IP_WrCE(11);
	slv_read_ack		<= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7) or Bus2IP_RdCE(8) or Bus2IP_RdCE(9) or Bus2IP_RdCE(10) or Bus2IP_RdCE(11);

	I2S_RST_I		<= I2S_RESET_REG(0);
	I2S_RST_TX_FIFO		<= I2S_RESET_REG(1);
	I2S_RST_RX_FIFO		<= I2S_RESET_REG(2);
	START_TX_I_int		<= I2S_CONTROL_REG(0);
	START_RX_I_int		<= I2S_CONTROL_REG(1);
	DIV_RATE_REG		<= I2S_CLK_CONTROL_REG(7 downto 0);
	LRCLK_RATE_REG		<= I2S_CLK_CONTROL_REG(23 downto 16);
	period_cnt		<= conv_integer(PERIOD_CNT_REG);

	-- implement slave model software accessible register(s)
	SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
	begin
		if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
			if Bus2IP_Resetn = '0' then
				I2S_RESET_REG <= (others => '0');
				I2S_CONTROL_REG <= (others => '0');
				I2S_CLK_CONTROL_REG <= (others => '0');
				I2S_STATUS_REG <= (others => '0');
				I2S_NR_CHAN_REG <= (others => '0');
				PERIOD_CNT_REG <= (others => '0');
				slv_reg7 <= (others => '0');
				slv_reg8 <= (others => '0');
				slv_reg9 <= (others => '0');
				I2S_REG10 <= (others => '0');
				I2S_REG11 <= (others => '0');
			else
				-- Auto-clear the Reset Register bits
				I2S_RESET_REG(0) <= '0';
				I2S_RESET_REG(1) <= '0';
				I2S_RESET_REG(2) <= '0';
				case slv_reg_write_sel is
					when "100000000000" => -- 0x00 RESET
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								I2S_RESET_REG(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "010000000000" => -- 0x04 CONTROL
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								I2S_CONTROL_REG(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "001000000000" => -- 0x08 CLOCK CONTROL
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								I2S_CLK_CONTROL_REG(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000100000000" => -- 0x0C RESERVED
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								slv_reg4(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000010000000" => -- 0x10 STATUS
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								I2S_STATUS_REG(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000001000000" => -- 0x14 NR CHANNELS REG
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								I2S_NR_CHAN_REG(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000000100000" => -- 0x18 PERIOD_CNT_REG
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								PERIOD_CNT_REG(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000000010000" => -- 0x1C
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								slv_reg7(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000000001000" => -- 0x20
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								slv_reg8(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000000000100" =>
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								slv_reg9(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000000000010" =>
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								I2S_REG10(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when "000000000001" =>
						for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								I2S_REG11(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
							end if;
						end loop;
					when others =>
						--LRCLK_RATE_REG(31 downto 0) <= RX_DATA_O_int & "00000000";
						I2S_STATUS_REG(0) <= OE_S_O_int;
						I2S_STATUS_REG(1) <= WE_S_O_int;
						I2S_STATUS_REG(2) <= audio_fifo_tx_full;
						I2S_STATUS_REG(3) <= audio_fifo_tx_empty;
						I2S_STATUS_REG(31 downto 24) <= conv_std_logic_vector(audio_fifo_rx_wr_addr, 8);
						I2S_STATUS_REG(23 downto 16) <= conv_std_logic_vector(audio_fifo_rx_rd_addr, 8);
				end case;
			end if;
		end if;

	end process SLAVE_REG_WRITE_PROC;

	-- implement slave model software accessible register(s) read mux
	SLAVE_REG_READ_PROC : process( slv_reg_read_sel, I2S_RESET_REG, I2S_CONTROL_REG, I2S_STATUS_REG, DIV_RATE_REG, LRCLK_RATE_REG, I2S_NR_CHAN_REG, PERIOD_CNT_REG, slv_reg7, slv_reg8, slv_reg9, I2S_REG10, I2S_REG11 ) is
	begin
		case slv_reg_read_sel is
			when "100000000000" => slv_ip2bus_data <= I2S_RESET_REG;
			when "010000000000" => slv_ip2bus_data <= I2S_CONTROL_REG;
			when "001000000000" => slv_ip2bus_data <= I2S_CLK_CONTROL_REG;
			when "000100000000" => slv_ip2bus_data <= slv_reg4;
			when "000010000000" => slv_ip2bus_data <= I2S_STATUS_REG;
			when "000001000000" => slv_ip2bus_data <= I2S_NR_CHAN_REG;
			when "000000100000" => slv_ip2bus_data <= PERIOD_CNT_REG;
			when "000000010000" => slv_ip2bus_data <= slv_reg7;
			when "000000001000" => slv_ip2bus_data <= slv_reg8;
			when "000000000100" => slv_ip2bus_data <= slv_reg9;
			when "000000000010" => slv_ip2bus_data <= I2S_REG10;
			when "000000000001" => slv_ip2bus_data <= I2S_REG11;
			when others => slv_ip2bus_data <= (others => '0');
		end case;
	end process SLAVE_REG_READ_PROC;

	------------------------------------------
	-- Example code to drive IP to Bus signals
	------------------------------------------
	IP2Bus_Data <= slv_ip2bus_data when slv_read_ack = '1' else (others => '0');
	IP2Bus_WrAck <= slv_write_ack;
	IP2Bus_RdAck <= slv_read_ack;
	IP2Bus_Error <= '0';

end Behavioral;
