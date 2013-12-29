--------------------------------------------------------------------------------
-- File       : gmii_to_rgmii_core.vhd
-- Author     : Xilinx Inc.
-- ------------------------------------------------------------------------------
--
-- *************************************************************************
--
-- (c) Copyright 2004-2011 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-- *************************************************************************
--
-- ------------------------------------------------------------------------------
-- Description:  This module creates a version 2.0 Reduced Gigabit Media
--               Independent Interface (RGMII v2.0) by instantiating
--               Input/Output buffers and Input/Output double data rate
--               (DDR) flip-flops as required.
--
--               This interface is used to connect the Ethernet MAC to
--               an external Ethernet PHY.
--               This module routes the rgmii_rxc from the phy chip
--               (via a bufg) onto the rx_clk line.
--               For S6 a DCM is used to shift the input clock to ensure that
--               the set-up and hold times are observed.
--               For V6 a BUFIO/BUFR combination is used for the input clock to allow
--               the use of IODELAYs on the DATA.
--------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-- This is based on Coregen Wrappers from ISE O.40c (13.1)
-- Wrapper version 5.1
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------

library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------
-- The entity declaration for the PHY IF design.
--------------------------------------------------------------------------------

entity gmii_to_rgmii_core is
  generic(
    C_EXTERNAL_CLOCK : integer range 0 to 1 := 0
  );
  port(
    -- ASynchronous resets
    tx_reset                      : in  std_logic;
    rx_reset                      : in  std_logic;
    -- Clocks
    refclk                        : in  std_logic;
    clkin                         : in  std_logic;
    gmii_clk                      : in  std_logic;
    -- The following ports are the RGMII physical interface: these will be at
    -- pins on the FPGA
    rgmii_txd                     : out std_logic_vector(3 downto 0);
    rgmii_tx_ctl                  : out std_logic;
    rgmii_txc                     : out std_logic;
    rgmii_rxd                     : in  std_logic_vector(3 downto 0);
    rgmii_rx_ctl                  : in  std_logic;
    rgmii_rxc                     : in  std_logic;
    -- The following signals are in the RGMII in-band status signals
    link_status                   : out std_logic;
    clock_speed                   : out std_logic_vector(1 downto 0);
    duplex_status                 : out std_logic;
    -- Register inputs from the MDIO module 
    speed_selection               : in  std_logic_vector(1 downto 0);
    duplex_mode                   : in  std_logic;
    -- The following ports are the internal GMII connections from IOB logic
    -- to the TEMAC core
    gmii_txd                      : in  std_logic_vector(7 downto 0);
    gmii_tx_en                    : in  std_logic;
    gmii_tx_er                    : in  std_logic;
    gmii_tx_clk                   : out std_logic;
    gmii_crs                      : out std_logic;
    gmii_col                      : out std_logic;
    gmii_rxd                      : out std_logic_vector(7 downto 0);
    gmii_rx_dv                    : out std_logic;
    gmii_rx_er                    : out std_logic;
    -- Receiver clock for the MAC and Client Logic
    gmii_rx_clk                   : out std_logic
  );
end gmii_to_rgmii_core;


architecture rtl of gmii_to_rgmii_core is

  signal gmii_rx_dv_reg         : std_logic;                        -- gmii_rx_dv registered in IOBs.
  signal gmii_rx_er_reg         : std_logic;                        -- gmii_rx_er registered in IOBs.
  signal gmii_rxd_reg           : std_logic_vector(7 downto 0);     -- gmii_rxd registered in IOBs.

  ------------------------------------------------------------------------------
  -- internal signals
  ------------------------------------------------------------------------------

  signal tx_reset_sync          : std_logic;
  signal rx_reset_sync          : std_logic;

  signal gmii_txd_falling       : std_logic_vector(3 downto 0);     -- gmii_txd signal registered on the falling edge of tx_clk.
  signal rgmii_tx_ctl_int       : std_logic;                        -- Internal RGMII transmit control signal.

  signal gmii_txd_int           : std_logic_vector(7 downto 0);
  signal gmii_tx_er_int         : std_logic;
  signal gmii_tx_en_int         : std_logic;

  signal rgmii_rxd_delay        : std_logic_vector(3 downto 0);
  signal rgmii_rx_ctl_delay     : std_logic;
  signal rgmii_rx_clk_bufio     : std_logic;

  signal rgmii_rx_ctl_reg       : std_logic;                        -- Internal RGMII receiver control signal.
  signal inband_ce              : std_logic;                        -- RGMII inband status registers clock enable
  signal rgmii_rxc_int          : std_logic;

  signal speedis10100           : std_logic;                        -- Current operating speed is 10/100

  signal gmii_tx_clk_int        : std_logic;
  signal idelayctrl_reset_sync  : std_logic;
  signal idelay_reset_cnt       : std_logic_vector(3 downto 0);     -- Counter to create a long IDELAYCTRL reset pulse.
  signal idelayctrl_reset       : std_logic;                        -- The reset pulse for the IDELAYCTRL.
  signal clkfbout               : std_logic;
  signal clkfbout_buf           : std_logic;
  signal clk_125                : std_logic;
  signal clk_25                 : std_logic;
  signal clk_10                 : std_logic;
  signal clk2p5                 : std_logic;
  signal tx_clk_int             : std_logic;
  signal clk2p5or25             : std_logic;

    ------------------------------------------------------------------------------
    -- Component declaration for the reset synchroniser
    ------------------------------------------------------------------------------
    component reset_sync
      port (
        reset_in               : in  std_logic;    -- Active high asynchronous reset
        enable                 : in  std_logic;
        clk                    : in  std_logic;    -- clock to be sync'ed to
        reset_out              : out std_logic     -- "Synchronised" reset signal
      );
    end component;

begin

  GEN_INTERNAL_CLOCK : if C_EXTERNAL_CLOCK /= 1 generate
    begin

      mmcm_adv_inst: MMCME2_ADV
        generic map(
          BANDWIDTH            => "OPTIMIZED",
          CLKOUT4_CASCADE      => FALSE,
          COMPENSATION         => "ZHOLD",
          STARTUP_WAIT         => FALSE,
          DIVCLK_DIVIDE        => 1,
          CLKFBOUT_MULT_F      => 5.000,
          CLKFBOUT_PHASE       => 0.000,
          CLKFBOUT_USE_FINE_PS => FALSE,
          CLKOUT0_DIVIDE_F     => 8.000,
          CLKOUT0_PHASE        => 0.000,
          CLKOUT0_DUTY_CYCLE   => 0.500,
          CLKOUT0_USE_FINE_PS  => FALSE,
          CLKOUT1_DIVIDE       => 40,
          CLKOUT1_PHASE        => 0.000,
          CLKOUT1_DUTY_CYCLE   => 0.500,
          CLKOUT1_USE_FINE_PS  => FALSE,
          CLKOUT2_DIVIDE       => 100,
          CLKOUT2_PHASE        => 0.000,
          CLKOUT2_DUTY_CYCLE   => 0.500,
          CLKOUT2_USE_FINE_PS  => FALSE,
          CLKIN1_PERIOD        => 5.000,
          REF_JITTER1          => 0.010
        )
        port map(
          -- Output clocks
          CLKFBOUT            => clkfbout,
          CLKFBOUTB           => open,
          CLKOUT0             => clk_125,
          CLKOUT0B            => open,
          CLKOUT1             => clk_25,
          CLKOUT1B            => open,
          CLKOUT2             => clk_10,
          CLKOUT2B            => open,
          CLKOUT3             => open,
          CLKOUT3B            => open,
          CLKOUT4             => open,
          CLKOUT5             => open,
          CLKOUT6             => open,
          -- Input clock control
          CLKFBIN             => clkfbout,
          CLKIN1              => clkin,
          CLKIN2              => '0',
          -- Tied to always select the primary input clock
          CLKINSEL            => '1',
          -- Ports for dynamic reconfiguration
          DADDR               => (others => '0'),
          DCLK                => '0',
          DEN                 => '0',
          DI                  => (others => '0'),
          DO                  => open,
          DRDY                => open,
          DWE                 => '0',
          -- Ports for dynamic phase shift
          PSCLK               => '0',
          PSEN                => '0',
          PSINCDEC            => '0',
          PSDONE              => open,
          -- Other control and status signals
          LOCKED              => open,
          CLKINSTOPPED        => open,
          CLKFBSTOPPED        => open,
          PWRDWN              => '0',
          RST                 => '0'
        );
     
     -- Output buffering
     -------------------------------------
     clk10_div_buf: BUFR
       generic map (
         BUFR_DIVIDE => "4")
       port map (
         I   => clk_10,
         CE  => '1',
         CLR => '0',
         O   => clk2p5
       );

     clkmux_bufgmux0: BUFGMUX
       generic map (
         CLK_SEL_TYPE => "SYNC"
       )
       port map(
         S  => speed_selection(0),
         I0 => clk2p5,
         I1 => clk_25,
         O  => clk2p5or25
       );

     clkmux_bufgmux1: BUFGMUX
       generic map(
         CLK_SEL_TYPE => "SYNC"
       )
       port map(
        S  => speed_selection(1),
        I0 => clk2p5or25,
        I1 => clk_125,
        O  => gmii_tx_clk_int
       );
    
  end generate GEN_INTERNAL_CLOCK;   

  GEN_EXTERNAL_CLOCK: if C_EXTERNAL_CLOCK = 1 generate
    begin
      gmii_clk_bufg: BUFG
      port map(
       O => gmii_tx_clk_int,
       I => gmii_clk
      );
    
  end generate GEN_EXTERNAL_CLOCK;   

  -- Speed indicator
  speedis10100 <= not speed_selection(1);

  -----------------------------------------------------------------------------
  -- Synchronize Tx and Rx Resets 
  -----------------------------------------------------------------------------
  i_reset_sync_tx_reset: reset_sync
    port map(
      reset_in  =>  tx_reset,
      enable    =>  '1',
      clk       =>  gmii_tx_clk_int,
      reset_out =>  tx_reset_sync
    );

  i_reset_sync_rx_reset: reset_sync
    port map(
      reset_in  =>  rx_reset,
      enable    =>  '1',
      clk       =>  rgmii_rxc_int,
      reset_out =>  rx_reset_sync
    );

  -----------------------------------------------------------------------------
  -- Route internal signals to output ports :
  -----------------------------------------------------------------------------

  gmii_rxd   <= gmii_rxd_reg;
  gmii_rx_dv <= gmii_rx_dv_reg;
  gmii_rx_er <= gmii_rx_er_reg;
   
  -----------------------------------------------------------------------------
  -- RGMII Transmitter Logic :
  -- drive TX signals through IOBs onto RGMII interface
  -----------------------------------------------------------------------------

  -- Encode rgmii ctl signal
  rgmii_tx_ctl_int <= gmii_tx_en_int xor gmii_tx_er_int;

  gmii_tx_clk <= gmii_tx_clk_int;

  -- Instantiate Double Data Rate Output components.
  -- Put data and control signals through ODELAY components to
  -- provide similiar net delays to those seen on the clk signal.
  gmii_tx_reg: process(gmii_tx_clk_int)
  begin
    if(gmii_tx_clk_int'event and gmii_tx_clk_int = '1') then
      if(tx_reset_sync = '1') then
        gmii_txd_int   <= "00000000";
        gmii_tx_en_int <= '0';
        gmii_tx_er_int <= '0';
      else
        gmii_txd_int   <= gmii_txd;
        gmii_tx_en_int <= gmii_tx_en;
        gmii_tx_er_int <= gmii_tx_er;
      end if;
    end if;
  end process gmii_tx_reg;

  datadupmux : process(speedis10100, gmii_txd_int)
  begin
    if speedis10100 = '0' then
      gmii_txd_falling <= gmii_txd_int(7 downto 4);
    else
      gmii_txd_falling <= gmii_txd_int(3 downto 0);
    end if;
  end process datadupmux;

  rgmii_txd_out : ODDR
    generic map(
      DDR_CLK_EDGE   => "SAME_EDGE"
    )
    port map(
       Q  => rgmii_txc,
       C  => gmii_tx_clk_int,
       CE => '1',
       D1 => '1',
       D2 => '0',
       R  => tx_reset_sync,
       S  => '0'
    );

  txdata_out_bus:  for I in 3 downto 0 generate
    -- DDR_CLK_EDGE attribute specifies expected input data alignment to ODDR.
    begin
      rgmii_txd_out: ODDR
      generic map(
        DDR_CLK_EDGE   => "SAME_EDGE"
      )
      port map(
        Q  => rgmii_txd(I),
        C  => gmii_tx_clk_int,
        CE => '1',
        D1 => gmii_txd_int(I),
        D2 => gmii_txd_falling(I),
        R  => tx_reset_sync,
        S  => '0'
      );
  end generate;

   rgmii_tx_ctl_out : ODDR
     generic map(
       DDR_CLK_EDGE      => "SAME_EDGE"
     )
     port map(
       Q  => rgmii_tx_ctl,
       C  => gmii_tx_clk_int,
       CE => '1',
       D1 => gmii_tx_en_int,
       D2 => rgmii_tx_ctl_int,
       R  => tx_reset_sync,
       S  => '0'
     );

  -----------------------------------------------------------------------------
  -- RGMII Receiver Clock Logic
  -----------------------------------------------------------------------------
  bufr_rgmii_rx_clk: BUFR
    generic map(
      BUFR_DIVIDE => "1"
    )
    port map(
      I   => rgmii_rxc,
      CE  => '1',
      CLR => '0',
      O   => rgmii_rxc_int
    );

  bufg_rgmii_rx_clk: BUFG
    port map(
      I => rgmii_rxc_int,
      O => gmii_rx_clk
    );

  -----------------------------------------------------------------------------
  -- RGMII Receiver Logic : receive signals through IOBs from RGMII interface
  -----------------------------------------------------------------------------
  dlyctrl: IDELAYCTRL
    port map(
      RDY    => open,
      REFCLK => refclk,
      RST    => idelayctrl_reset
    );

  -- Create a synchronous reset in the IDELAYCTRL refclk clock domain.
  idelayctrl_reset_gen  : reset_sync
    port map(
      clk        => refclk,
      enable     => '1',
      reset_in   => rx_reset_sync,
      reset_out  => idelayctrl_reset_sync
    );
  
  -- Reset circuitry for the IDELAYCTRL reset.

  -- The IDELAYCTRL must experience a pulse which is at least 50 ns in
  -- duration.  This is ten clock cycles of the 200MHz refclk.  Here we
  -- drive the reset pulse for 12 clock cycles.
  process(refclk)
  begin
    if refclk'event and refclk = '1' then
      if idelayctrl_reset_sync = '1' then
        idelay_reset_cnt <= "0000";
        idelayctrl_reset <= '1';
      else
        idelayctrl_reset <= '1';
        case idelay_reset_cnt is
          when "0000"  => idelay_reset_cnt <= "0001";
          when "0001"  => idelay_reset_cnt <= "0010";
          when "0010"  => idelay_reset_cnt <= "0011";
          when "0011"  => idelay_reset_cnt <= "0100";
          when "0100"  => idelay_reset_cnt <= "0101";
          when "0101"  => idelay_reset_cnt <= "0110";
          when "0110"  => idelay_reset_cnt <= "0111";
          when "0111"  => idelay_reset_cnt <= "1000";
          when "1000"  => idelay_reset_cnt <= "1001";
          when "1001"  => idelay_reset_cnt <= "1010";
          when "1010"  => idelay_reset_cnt <= "1011";
          when "1011"  => idelay_reset_cnt <= "1100";
          when "1100"  => idelay_reset_cnt <= "1101";
          when "1101"  => idelay_reset_cnt <= "1110";
          when others  => idelay_reset_cnt <= "1110";
                          idelayctrl_reset <= '0';
        end case;
      end if;
    end if;
  end process;

  -- Drive input RGMII Rx signals from PADS through IODELAYS.

  -- Please modify the IODELAY_VALUE according to your design.
  -- For more information on IDELAYCTRL and IODELAY, please refer to
  -- the User Guide.
  delay_rgmii_rx_ctl: IODELAYE1
    generic map(
      IDELAY_TYPE    => "FIXED",
      DELAY_SRC      => "I"
    )
    port map(
      IDATAIN        => rgmii_rx_ctl,
      ODATAIN        => '0',
      DATAOUT        => rgmii_rx_ctl_delay,
      DATAIN         => '0',
      C              => '0',
      T              => '1',
      CE             => '0',
      INC            => '0',
      CINVCTRL       => '0',
      CLKIN          => '0',
      CNTVALUEIN     => "00000",
      RST            => '0'
    );

  rxdata_bus: for I in 3 downto 0 generate
    delay_rgmii_rxd : IODELAYE1
      generic map(
        IDELAY_TYPE    => "FIXED",
        DELAY_SRC      => "I"
      )
      port map(
        IDATAIN        => rgmii_rxd(I),
        ODATAIN        => '0',
        DATAOUT        => rgmii_rxd_delay(I),
        DATAIN         => '0',
        C              => '0',
        T              => '1',
        CE             => '0',
        INC            => '0',
        CINVCTRL       => '0',
        CLKIN          => '0',
        CNTVALUEIN     => "00000",
        RST            => '0'
      );

  end generate;

  -- Instantiate Double Data Rate Input flip-flops.
  rxdata_in_bus: for I in 3 downto 0 generate
    -- DDR_CLK_EDGE attribute specifies output data alignment from IDDR component
  begin
    rgmii_rx_data_in: IDDR
      generic map(
        DDR_CLK_EDGE   => "SAME_EDGE_PIPELINED"
      )
      port map(
        Q1  => gmii_rxd_reg(I),
        Q2  => gmii_rxd_reg(I+4),
        C   => rgmii_rxc_int,
        CE  => '1',
        D   => rgmii_rxd_delay(I),
        R   => '0',
        S   => '0'
      );
  end generate;

  rgmii_rx_ctl_in: IDDR
    generic map(
      DDR_CLK_EDGE => "SAME_EDGE_PIPELINED"
    )
    port map(
      Q1  => gmii_rx_dv_reg,
      Q2  => rgmii_rx_ctl_reg,
      C   => rgmii_rxc_int,
      CE  => '1',
      D   => rgmii_rx_ctl_delay,
      R   => '0',
      S   => '0'
    );

  -- Decode gmii_rx_er signal
  gmii_rx_er_reg <= gmii_rx_dv_reg xor rgmii_rx_ctl_reg;

  -----------------------------------------------------------------------------
  -- RGMII Inband Status Registers :
  -- extract the inband status from received rgmii data
  -----------------------------------------------------------------------------

  -- Enable inband status registers during Interframe Gap
  inband_ce <= gmii_rx_dv_reg nor gmii_rx_er_reg;

  reg_inband_status: process(rgmii_rxc_int)
  begin
    if rgmii_rxc_int'event and rgmii_rxc_int ='1' then
      if rx_reset_sync = '1' then
        link_status                <= '0';
        clock_speed(1 downto 0)    <= "00";
        duplex_status              <= '0';
      elsif inband_ce = '1' then
        link_status             <= gmii_rxd_reg(0);
        clock_speed(1 downto 0) <= gmii_rxd_reg(2 downto 1);
        duplex_status           <= gmii_rxd_reg(3);
      end if;
    end if;
  end process reg_inband_status;

  -----------------------------------------------------------------------------
  -- Create the GMII-style Collision and Carrier Sense signals from RGMII
  -----------------------------------------------------------------------------
  gmii_col <= (gmii_tx_en_int or gmii_tx_er_int) and (gmii_rx_dv_reg or gmii_rx_er_reg) when duplex_mode = '0' else
              '0';

  gmii_crs <= (gmii_tx_en_int or gmii_tx_er_int) or (gmii_rx_dv_reg or gmii_rx_er_reg) when duplex_mode = '0' else
              '0';
  
end rtl;
