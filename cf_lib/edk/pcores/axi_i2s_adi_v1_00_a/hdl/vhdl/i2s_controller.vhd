library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity i2s_controller is
	generic(
		C_SLOT_WIDTH	: integer := 24;						-- Width of one Slot
		-- Synthesis parameters
		C_MSB_POS		: integer := 0;						-- MSB Position in the LRCLK frame (0 - MSB first, 1 - LSB first)
		C_FRM_SYNC		: integer := 1;						-- Frame sync type (0 - 50% Duty Cycle, 1 - Pulse mode)
		C_LRCLK_POL		: integer := 0;						-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_BCLK_POL		: integer := 0 						-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
	);
	port(
		CLK_I			: in  std_logic; 					-- System clock (100 MHz)
		DATA_CLK_I		: in  std_logic;					-- Data clock should be less than CLK_I / 4
		RST_I			: in  std_logic; 					-- System reset
		BCLK_O			: out std_logic; 					-- Bit Clock
		LRCLK_O			: out std_logic;					-- Frame Clock
		SDATA_O			: out std_logic;					-- Serial Data Output
		SDATA_I			: in  std_logic;					-- Serial Data Input
		EN_TX_I			: in  std_logic;					-- Enable TX
		EN_RX_I			: in  std_logic;					-- Enable RX
		OE_S_O			: out std_logic;					-- Request new Slot Data
		WE_S_O			: out std_logic;					-- Valid Slot Data
		D_S_I			: in  std_logic_vector(C_SLOT_WIDTH-1 downto 0); 	-- Slot Data in
		D_S_O			: out std_logic_vector(C_SLOT_WIDTH-1 downto 0);	-- Slot Data out
		-- Runtime parameters
		DIV_RATE_I		: in  std_logic_vector(7 downto 0);
		LRCLK_RATE_I		: in  std_logic_vector(7 downto 0)
		--NR_CHANNELS_I	: in std_logic_vector(3 downto 0)				-- Number of channels (2 - Stereo, 4- TDM4, 8 - TDM8)
	);
end i2s_controller;

architecture Behavioral of i2s_controller is

-- Divide value for the serial clock divider
signal DIV_RATE		: natural range 0 to 255 := 0;
signal PREV_DIV_RATE 	: natural range 0 to 255 := 0;

-- Divide value for the frame clock divider
signal LRCLK_RATE	: natural range 0 to 255 := 0;
signal PREV_LRCLK_RATE 	: natural range 0 to 255 := 0;

-- Counter for the serial clock divider
signal Cnt_Bclk 	: integer range 0 to 255;

-- Counter for the frame clock divider
signal Cnt_Lrclk 	: integer range 0 to 512;
signal Cnt_Lrclk_TDM	: std_logic;

-- Counter for TDM4 and TDM8 Output Enable signal
signal Cnt_Lrclk_OE_S	 : std_logic;

-- Counter for TDM4 and TDM8 Write Enable signal
signal Cnt_Lrclk_WE_S	 : std_logic;

-- Internal synchronous BCLK signal
signal BCLK_int 	: std_logic;

-- Rising and Falling edge impulses of the serial clock
signal BCLK_Fall 	: std_logic;
signal BCLK_Rise 	: std_logic;

-- Internal synchronous LRCLK signal
signal LRCLK_int 	: std_logic;


-- 
signal SDATA_int : std_logic;

-- Data Out internal signal
signal Data_Out_int	: std_logic_vector(31 downto 0);

-- Data In internal signal
signal Data_In_int	: std_logic_vector(31 downto 0);

-- Slot internal signal
signal D_S_O_int	: std_logic_vector(C_SLOT_WIDTH-1 downto 0);

--Internal synchronous OE signals
signal OE_S_int		: std_logic;

--Internal synchronous WE signals
signal WE_S_int		: std_logic;

signal enable		: std_logic;
signal BCLK_trailing_edge : std_logic;
signal BCLK_leading_edge : std_logic;
signal BCLK_edge : std_logic;

signal EN_RX_INT : std_logic;
signal EN_TX_INT : std_logic;

signal tick : std_logic;
signal tick_d1 : std_logic;
signal tick_d2 : std_logic;
signal tick_d3 : std_logic;
signal tick_d4 : std_logic;

constant FIFO_SIZE : integer := 4;
signal data_out_fifo_wr_addr : natural range 0 to FIFO_SIZE - 1;
signal data_out_fifo_rd_addr : natural range 0 to FIFO_SIZE - 1;
type DATA_SYNC_FIFO is array (0 to FIFO_SIZE - 1) of std_logic_vector(2 downto 0);
signal data_out_fifo : DATA_SYNC_FIFO;

begin
	-- Division rate to ensure 48K sample rate
	-- BCLK division rate
	--DIV_RATE 	<= 32 when (NR_CHANNELS_I = "0010") else
	--                 16 when (NR_CHANNELS_I = "0100") else
	--                  8 when (NR_CHANNELS_I = "1000") else 0;
	--
	DIV_RATE <= conv_integer(DIV_RATE_I);
	-- LRCLK division rate
	--LRCLK_RATE 	<= 32 when (NR_CHANNELS_I = "0010") else
	--                 64 when (NR_CHANNELS_I = "0100") else
	--                128 when (NR_CHANNELS_I = "1000") else 0;
	--
	LRCLK_RATE <= conv_integer(LRCLK_RATE_I);

	enable <= '1' when (EN_TX_I = '1') or (EN_RX_I = '1') else '0';

	-- Generate tick signal in the DATA_CLK_I domain
	process (DATA_CLK_I)
	begin
		if rising_edge(DATA_CLK_I) then
			if (RST_I = '1') then
				tick <= '0';
			else
				tick <= not tick;
			end if;
		end if;
	end process;

	-- Synchronize tick signal into the CLK_I domain
	process (CLK_I)
	begin
		if rising_edge(CLK_I) then
			if (RST_I = '1') then
				tick_d1 <= '0';
				tick_d2 <= '0';
				data_out_fifo_wr_addr <= 0;
			else
				tick_d1 <= tick;
				tick_d2 <= tick_d1;
				if (tick_d2 xor tick_d1) = '1' then
					data_out_fifo(data_out_fifo_wr_addr)(0) <= BCLK_int;
					data_out_fifo(data_out_fifo_wr_addr)(1) <= LRCLK_int;
					data_out_fifo(data_out_fifo_wr_addr)(2) <= SDATA_int;
					data_out_fifo_wr_addr <= data_out_fifo_wr_addr + 1;
				end if;
			end if;
		end if;
	end process;

	process (DATA_CLK_I)
	begin
		if rising_edge(DATA_CLK_I) then
			if (RST_I = '1') then
				tick_d3 <= '0';
				tick_d4 <= '0';
				data_out_fifo_rd_addr <= 0;
			else
				tick_d3 <= tick_d2;
				tick_d4 <= tick_d3;
				if (tick_d3 xor tick_d4) = '1' then
					BCLK_O <= data_out_fifo(data_out_fifo_rd_addr)(0);
					LRCLK_O <= data_out_fifo(data_out_fifo_rd_addr)(1);
					SDATA_O <= data_out_fifo(data_out_fifo_rd_addr)(2);
					data_out_fifo_rd_addr <= data_out_fifo_rd_addr + 1;
				end if;
			end if;
		end if;
	end process;

-----------------------------------------------------------------------------------
-- Serial clock generation (BCLK_O, BCLK_FALL, BCLK_RISE)
-----------------------------------------------------------------------------------
	SER_CLK: process(CLK_I)
	begin
		if rising_edge(CLK_I) then
			if((RST_I = '1') or (DIV_RATE /= PREV_DIV_RATE) or (enable = '0')) then
				Cnt_Bclk <= 0;
				BCLK_Int <= '0';
				PREV_DIV_RATE <= DIV_RATE;
				BCLK_Fall <= '0';
				BCLK_Rise <= '0';
			else
				if (tick_d1 xor tick_d2) = '1' then
					if(Cnt_Bclk = DIV_RATE) then
						Cnt_Bclk <= 0;
						BCLK_Fall <= BCLK_int;
						BCLK_Rise <= not BCLK_int;
						BCLK_int <= not BCLK_int;
					else
						Cnt_Bclk <= Cnt_Bclk + 1;
					end if;
				else
					BCLK_Fall <= '0';
					BCLK_Rise <= '0';
				end if;
			end if;
		end if;
	end process SER_CLK;

	BCLK_trailing_edge <= BCLK_Rise when (C_BCLK_POL = 1) else BCLK_Fall;
	BCLK_leading_edge <= BCLK_Fall when (C_BCLK_POL = 1) else BCLK_Rise;

-----------------------------------------------------------------------------------
-- Frame clock generator (LRCLK_O)
-----------------------------------------------------------------------------------
	LRCLK_GEN: process(CLK_I)
	begin
		if rising_edge(CLK_I) then
			-- Reset
			if((RST_I = '1') or (LRCLK_RATE /= PREV_LRCLK_RATE) or (enable = '0')) then
				Cnt_Lrclk <= 0;
				LRCLK_int <= '0';
				PREV_LRCLK_RATE <= LRCLK_RATE;
				if(C_FRM_SYNC = 1) then
					Cnt_Lrclk <= LRCLK_RATE*2;
				end if;
			-- 50% Duty Cycle LRCLK signal, used for Stereo Mode
			elsif(C_FRM_SYNC = 0) then
				if (BCLK_trailing_edge = '1') then
					if(Cnt_Lrclk = LRCLK_RATE-1) then
						Cnt_Lrclk <= 0;
						LRCLK_int <= not LRCLK_int;
					else
						Cnt_Lrclk <= Cnt_Lrclk + 1;
					end if;
				end if;
			-- Pulse mode LRCLK signal, used for TDM4 and TDM8
			elsif(C_FRM_SYNC = 1) then
				if (BCLK_trailing_edge = '1') then
					-- If the number of bits has been sent, pulse new frame
					if(Cnt_Lrclk = LRCLK_RATE*2) then
						Cnt_Lrclk <= 0;
						LRCLK_int <= '1';
					else
						LRCLK_int <= '0';
						Cnt_Lrclk <= Cnt_Lrclk + 1;
					end if;
				end if;
			end if;
		end if;
	end process LRCLK_GEN;

	-- Used to change data in the Slots in TDM Mode
	Cnt_Lrclk_TDM <= '0' when ((Cnt_Lrclk = 0)or(Cnt_Lrclk = 32)or(Cnt_Lrclk = 64)or(Cnt_Lrclk = 96)or
	                           (Cnt_Lrclk = 128)or(Cnt_Lrclk = 160)or(Cnt_Lrclk=192)or(Cnt_Lrclk=224)or(Cnt_Lrclk=256))
	                           else '1';

	-- Used to signal data request (TX)
	Cnt_Lrclk_OE_S <= '1' when ((Cnt_Lrclk = 0)or(Cnt_Lrclk = 32)or(Cnt_Lrclk = 64)or(Cnt_Lrclk = 96)or
	                            (Cnt_Lrclk = 128)or(Cnt_Lrclk = 160)or(Cnt_Lrclk=192)or(Cnt_Lrclk=224))
	                            else '0';

	-- Used to signal valid data (RX)
	Cnt_Lrclk_WE_S <= '1' when (Cnt_Lrclk = 1)or(Cnt_Lrclk = 33)or(Cnt_Lrclk = 65)or(Cnt_Lrclk = 97)or
	                           (Cnt_Lrclk = 129)or(Cnt_Lrclk = 161)or(Cnt_Lrclk=193)or(Cnt_Lrclk=225)
	                           else '0';

-----------------------------------------------------------------------------------
-- Load in parallel data, shift out serial data (SDATA_O)
-----------------------------------------------------------------------------------
	SER_DATA_O: process(CLK_I)
	begin
		if rising_edge(CLK_I) then
			-- Reset
			if((RST_I = '1') or (enable = '0')) then
				-- If 50% Duty Cycle
				if(C_FRM_SYNC = 0) then
					Data_Out_int(31) <= '0';
					Data_Out_int(30 downto 31-C_SLOT_WIDTH) <= D_S_I;
					Data_Out_int(30-C_SLOT_WIDTH downto 0) <= (others => '0');
				-- If Pulse mode
				elsif(C_FRM_SYNC = 1) then
					Data_Out_int(31 downto 32-C_SLOT_WIDTH) <= D_S_I;
					Data_Out_int(31-C_SLOT_WIDTH downto 0) <= (others => '0');
				end if;
			elsif((Cnt_Lrclk_TDM = '0')and(BCLK_leading_edge = '1')) then
				-- 50% Duty Cycle mode
				if(C_FRM_SYNC = 0) then
					Data_Out_int(31) <= '0';
					Data_Out_int(30 downto 31-C_SLOT_WIDTH) <= D_S_I;
					Data_Out_int(30-C_SLOT_WIDTH downto 0) <= (others => '0');
				-- If Pulse mode
				elsif(C_FRM_SYNC = 1) then
					Data_Out_int(31 downto 32-C_SLOT_WIDTH) <= D_S_I;
					Data_Out_int(31-C_SLOT_WIDTH downto 0) <= (others => '0');
				end if;
			-- Shift out serial data
			elsif(BCLK_trailing_edge = '1') then
				Data_Out_int <= Data_Out_int(30 downto 0) & '0';
			end if;
		end if;
	end process SER_DATA_O;

	-- Serial data output
	SDATA_int <= Data_Out_int(31) when ((EN_TX_I = '1') and (C_MSB_POS = 0)) else
				 Data_Out_int(0) when ((EN_TX_I = '1') and (C_MSB_POS = 1)) else '0';

-----------------------------------------------------------------------------------
-- Shift in serial data, load out parallel data (SDATA_I)
-----------------------------------------------------------------------------------
	SER_DATA_I: process(CLK_I)
	begin
		if rising_edge(CLK_I) then
			-- Reset
			if((RST_I = '1') or (enable = '0')) then
				Data_In_int <= (others => '0');
				D_S_O_int <= (others => '0');
			-- 50% Duty Cycle mode
			elsif(C_FRM_SYNC = 0) then
				-- Stereo mode
				-- Load parallel data
				-- Depending on BCLK polarity settings
				if((Cnt_Lrclk_TDM = '0') and (BCLK_trailing_edge = '1')) then
					D_S_O_int <= Data_In_int(31 downto 32-C_SLOT_WIDTH);
					Data_In_int <= (others => '0');
				-- Shift in serial data
				-- Depending on BCLK polarity settings
				elsif(BCLK_leading_edge = '1') then
					Data_In_int <= Data_In_int(30 downto 0) & SDATA_I;
				end if;
			-- Pulse mode
			elsif(C_FRM_SYNC = 1) then
				-- Load parallel data
				-- Depending on BCLK polarity settings
				if((Cnt_Lrclk_TDM = '0')and(BCLK_trailing_edge = '1')) then
					D_S_O_int <= Data_In_int(31 downto 32-C_SLOT_WIDTH);
					Data_In_int <= (others => '0');
				-- Shift in serial data
				-- Depending on BCLK polarity settings
				elsif((Lrclk_int = '0')and(BCLK_leading_edge = '1')) then
					Data_In_int <= Data_In_int(30 downto 0) & SDATA_I;
				end if;
			end if;
		end if;
	end process SER_DATA_I;

	D_S_O <= D_S_O_int;

------------------------------------------------------------------------
-- Output Enable signals (for FIFO)
------------------------------------------------------------------------
	OE_GEN: process(CLK_I)
	begin
		if rising_edge(CLK_I) then
			if((RST_I = '1') or (enable = '0')) then
				 OE_S_int <= '0';
			else
				if((Cnt_Lrclk_OE_S = '1')and(BCLK_trailing_edge = '1')) then
					OE_S_int <= '1';
				else
					OE_S_int <= '0';
				end if;
			end if;
		end if;
	end process OE_GEN;

	EN_TX_INT_GEN: process(CLK_I)
	begin
		if rising_edge(CLK_I) then
			if (RST_I = '1') then
				EN_TX_INT <= '0';
			else
				-- After enabling TX the first request needs to be syncronized to Cnt_Lrclk = 0
				-- otherwise we will mess up the channel order.
				if((EN_TX_I = '1') and (Lrclk_int = '0') and (Cnt_Lrclk = 0) and (BCLK_trailing_edge = '1')) then
					EN_TX_INT <= '1';
				elsif (EN_TX_I = '0') then
					EN_TX_INT <= '0';
				end if;
			end if;
		end if;
	end process EN_TX_INT_GEN;

	OE_S_O <= OE_S_int when (EN_TX_INT = '1') else '0';

------------------------------------------------------------------------
-- Write Enable signals (for FIFO)
------------------------------------------------------------------------
	WE_GEN: process(CLK_I)
	begin
		if rising_edge(CLK_I) then
			if((RST_I = '1') or (enable = '0')) then
				WE_S_int <= '0';
			else
				-- Depending on BCLK polarity settings
				if((Cnt_Lrclk_WE_S = '1')and(BCLK_leading_edge = '1')) then
					WE_S_int <= '1';
				else
					WE_S_int <= '0';
				end if;
			end if;
		end if;
	end process WE_GEN;

	EN_RX_INT_GEN: process(CLK_I)
	begin
		if rising_edge(CLK_I) then
			if (RST_I = '1') then
				EN_RX_INT <= '0';
			else
				-- After enabling RX the first request needs to be syncronized to Cnt_Lrclk = 31
				-- otherwise we will mess up the channel order.
				if((EN_RX_I = '1') and (Lrclk_int = '0') and (Cnt_Lrclk = 1) and (BCLK_trailing_edge = '1')) then
					EN_RX_INT <= '1';
				elsif (EN_RX_I = '0') then
					EN_RX_INT <= '0';
				end if;
			end if;
		end if;
	end process EN_RX_INT_GEN;

	WE_S_O <= WE_S_int when (EN_RX_INT = '1') else '0';

end Behavioral;
