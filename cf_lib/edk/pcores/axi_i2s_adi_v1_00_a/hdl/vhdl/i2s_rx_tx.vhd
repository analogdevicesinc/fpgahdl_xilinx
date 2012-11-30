library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Module Declaration
------------------------------------------------------------------------
entity i2s_rx_tx is
		generic(
			C_SLOT_WIDTH	: integer := 24;	-- Width of one Slot
			-- Synthesis parameters
			C_MSB_POS	: integer := 0;	-- MSB Position in the LRCLK frame (0 - MSB first, 1 - LSB first)
			C_FRM_SYNC	: integer := 0;	-- Frame sync type (0 - 50% Duty Cycle, 1 - Pulse mode)
			C_LRCLK_POL	: integer := 0;	-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
			C_BCLK_POL	: integer := 0	-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
		);
		port(
			-- Global signals
			CLK_I		: in  std_logic;
			DATA_CLK_I	: in  std_logic;
			RST_I		: in  std_logic;

			-- Control signals
			START_TX_I	: in  std_logic;
			START_RX_I	: in  std_logic;
			STOP_RX_I	: in  std_logic;

			DIV_RATE_I	: in  std_logic_vector(7 downto 0);
			LRCLK_RATE_I	: in  std_logic_vector(7 downto 0);

			-- Data input from user logic
			TX_DATA_I	: in  std_logic_vector(C_SLOT_WIDTH-1 downto 0);
			OE_S_O		: out std_logic;

			-- Data output to user logic
			RX_DATA_O	: out std_logic_vector(C_SLOT_WIDTH-1 downto 0);
			WE_S_O		: out std_logic;

			-- I2S Interface signals
			BCLK_O		: out std_logic;
			LRCLK_O		: out std_logic;
			SDATA_I		: in  std_logic;
			SDATA_O		: out std_logic
		);
	end i2s_rx_tx;

architecture Behavioral of i2s_rx_tx is

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
signal TxEn: std_logic;
signal RxEn: std_logic;
signal LRCLK_int: std_logic;
signal D_S_O_int: std_logic_vector(C_SLOT_WIDTH-1 downto 0);
signal WE_S_O_int: std_logic;
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
component i2s_controller
	generic(
		C_SLOT_WIDTH	: integer := 24;	-- Width of one Slot
		-- Synthesis parameter
		C_MSB_POS	: integer := 0;		-- MSB Position in the LRCLK frame (0 - MSB first, 1 - LSB first)
		C_FRM_SYNC	: integer := 0;		-- Frame sync type (0 - 50% Duty Cycle, 1 - Pulse mode)
		C_LRCLK_POL	: integer := 0;		-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_BCLK_POL	: integer := 0		-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
	);
	port(
		CLK_I		: in  std_logic;	-- System clock (100 MHz)
		DATA_CLK_I	: in  std_logic;	-- Data clock should be less than CLK_I / 4
		RST_I		: in  std_logic;	-- System reset
		BCLK_O		: out std_logic;	-- Bit Clock
		LRCLK_O		: out std_logic;	-- Frame Clock
		SDATA_O		: out std_logic;	-- Serial Data Output
		SDATA_I		: in  std_logic;	-- Serial Data Input
		EN_TX_I		: in  std_logic;	-- Enable TX
		EN_RX_I		: in  std_logic;	-- Enable RX
		OE_S_O		: out std_logic;	-- Request new Slot Data
		WE_S_O		: out std_logic;	-- Valid Slot Data
		D_S_I		: in  std_logic_vector(C_SLOT_WIDTH-1 downto 0); 	-- Slot Data in
		D_S_O		: out std_logic_vector(C_SLOT_WIDTH-1 downto 0);	-- Slot Data out
		-- Runtime parameters
		DIV_RATE_I	: in std_logic_vector(7 downto 0);
		LRCLK_RATE_I	: in std_logic_vector(7 downto 0)
	);
end component;

------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------
begin

------------------------------------------------------------------------
-- Instantiate the I2S transmitter module
------------------------------------------------------------------------
Inst_I2sRxTx: i2s_controller
generic map(
	C_SLOT_WIDTH	=> C_SLOT_WIDTH,
	C_MSB_POS	=> C_MSB_POS,
	C_FRM_SYNC	=> C_FRM_SYNC,
	C_LRCLK_POL	=> C_LRCLK_POL,
	C_BCLK_POL	=> C_BCLK_POL
)
port map(
	CLK_I		=> CLK_I,
	DATA_CLK_I	=> DATA_CLK_I,
	RST_I		=> RST_I,
	EN_TX_I		=> TxEn,
	EN_RX_I		=> RxEn,
	OE_S_O		=> OE_S_O,
	WE_S_O		=> WE_S_O_int,
	D_S_I		=> TX_DATA_I,
	D_S_O		=> D_S_O_int,
	BCLK_O		=> BCLK_O,
	LRCLK_O		=> LRCLK_int,
	SDATA_O		=> SDATA_O,
	SDATA_I		=> SDATA_I,
	DIV_RATE_I	=> DIV_RATE_I,
	LRCLK_RATE_I	=> LRCLK_RATE_I
);

LRCLK_O <= LRCLK_int;
TxEn <= START_TX_I;

------------------------------------------------------------------------
-- Assert receive enable
------------------------------------------------------------------------
RXEN_PROC: process(CLK_I)
begin
	if(CLK_I'event and CLK_I = '1') then
		if (START_RX_I = '1') then
			RxEn <= '1';
		elsif (STOP_RX_I = '1') then
			RxEn <= '0';
		end if;
	end if;
end process RXEN_PROC;

------------------------------------------------------------------------
-- Select RX Data
------------------------------------------------------------------------
RX_DATA_SEL: process(CLK_I)
begin
	if(CLK_I'event and CLK_I = '1') then
		if(WE_S_O_int = '1') then
			RX_DATA_O <= D_S_O_int;
		end if;
	end if;
end process RX_DATA_SEL;

WE_S_O <= WE_S_O_int;

end Behavioral;
