------------------------------------------------------------------------------
-- File       : gmii_to_rgmii.vhd
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
-- Description:  This is the top-level wrapper for the GMII-to-RGMII core.
--               MDIO logic, which provies the Register interface for the core, 
--               is instantiated.
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

entity my_gmii_to_rgmii is
  generic(
    C_EXTERNAL_CLOCK : integer range 0 to 1 := 0;
    C_PHYADDR        : std_logic_vector(4 downto 0) := "01000"
  );
  port(
    -- ASynchronous resets
    tx_reset                      : in    std_logic;
    rx_reset                      : in    std_logic;
    -- Clocks
    clkin                         : in    std_logic;
    gmii_clk                      : in    std_logic;
    -- The following ports are the RGMII physical interface: these will be at
    -- pins on the FPGA
    rgmii_txd                     : out   std_logic_vector(3 downto 0);
    rgmii_tx_ctl                  : out   std_logic;
    rgmii_txc                     : out   std_logic;
    rgmii_rxd                     : in    std_logic_vector(3 downto 0);
    rgmii_rx_ctl                  : in    std_logic;
    rgmii_rxc                     : in    std_logic;
    -- The following signals are in the RGMII in-band status signals
    link_status                   : out   std_logic;
    clock_speed                   : out   std_logic_vector(1 downto 0);
    duplex_status                 : out   std_logic;
    -- MDIO Interface
    MDIO_MDC                      : in    std_logic;                          -- MDIO clock i/p from GEM
    MDIO_I                        : out   std_logic;                          -- Connect this to the MDIO_I port of GEM 
    MDIO_O                        : in    std_logic;                          -- Connect this to the MDIO_O Port of GEM 
    MDIO_T                        : in    std_logic;                          -- Connect this to the MDIO_T port of GEM 
    MDC                           : out   std_logic;                          -- MDIO Clock to PHY
    MDIO                          : inout std_logic;                          -- MDIO Data line to PHY
    -- The following ports are the internal GMII connections from IOB logic
    -- to the TEMAC core
    gmii_txd                      : in    std_logic_vector(7 downto 0);
    gmii_tx_en                    : in    std_logic;
    gmii_tx_er                    : in    std_logic;
    gmii_tx_clk                   : out   std_logic;
    gmii_crs                      : out   std_logic;
    gmii_col                      : out   std_logic;
    gmii_rxd                      : out   std_logic_vector(7 downto 0);
    gmii_rx_dv                    : out   std_logic;
    gmii_rx_er                    : out   std_logic;
    gmii_rx_clk                   : out   std_logic;
    speed_mode                    : out   std_logic_vector(1 downto 0)
  );
end my_gmii_to_rgmii;

architecture rtl of my_gmii_to_rgmii is

  -- Componnet declaration
  -- MDIO module
  component MANAGEMENT is
    port(
      SRESET                : in    std_logic;                                  -- Asynchronous reset
      CLK                   : in    std_logic;                                  -- Master clock
      MDC                   : in    std_logic;                                  -- Management Data Clock
      MDIO_IN               : in    std_logic;                                  -- Management Data In
      MDIO_OUT              : out   std_logic;                                  -- Management Data Out
      MDIO_TRI              : out   std_logic;                                  -- Management Data Tristate
      PHYAD                 : in    std_logic_vector(4 downto 0) := "01000";    -- Port address to recognise. This should be different from the Board PHY address
      -- Register 16: PHY Specific Configuration Register Outputs
      SOFT_RESET            : out   std_logic;                                  -- Reset all parts of the core under MDIO control.
      DUPLEX_MODE           : out   std_logic;                                  -- Set Duplex Mode.
      SPEED_SELECTION       : out   std_logic_vector(1 downto 0)                -- Indicates Line-rate at which the external PHY is operating
    );
  end component;
  
  -- GMII to RGMII Converter module 
  component gmii_to_rgmii_core is
    generic(
      C_EXTERNAL_CLOCK : integer range 0 to 1 := 0
    );
    port(
      -- ASynchronous resets
      tx_reset                      : in  std_logic;
      rx_reset                      : in  std_logic;
      -- Clocks
      refclk                        : in  std_logic;
      clkin                         : in  std_logic;                                     -- 200MHz clock input
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
  end component;

  -- Reset synchronizer
  component reset_sync
    port (
      reset_in               : in  std_logic;    -- Active high asynchronous reset
      enable                 : in  std_logic;
      clk                    : in  std_logic;    -- clock to be sync'ed to
      reset_out              : out std_logic     -- "Synchronised" reset signal
    );
  end component;

  -- Internal Signals
  signal gmii_clk_int         : std_logic;
  signal clkin_bufg           : std_logic;

  signal reset_to_mgmt        : std_logic;
  signal reset_to_mgmt_sync   : std_logic;
  signal mdio_iobuf_out       : std_logic;
  signal MDIO_OUT             : std_logic;
  signal MDIO_TRI             : std_logic;
  signal SOFT_RESET           : std_logic;
  signal DUPLEX_MODE          : std_logic;
  signal SPEED_SELECTION      : std_logic_vector(1 downto 0);

  signal tx_reset_async       : std_logic;
  signal rx_reset_async       : std_logic;

begin

  -- Instantiate bufg for clkin
  clk200_bufg: BUFG
    port map(
      O   => clkin_bufg,
      I   => clkin
    );

  -- Instantiate the MDIO module
  reset_to_mgmt <= tx_reset or rx_reset or SOFT_RESET;
  
  i_reset_sync_mgmt_reset: reset_sync
    port map(
      reset_in  =>  reset_to_mgmt,
      enable    =>  '1',
      clk       =>  clkin_bufg,
      reset_out =>  reset_to_mgmt_sync
    );

  MANAGEMENT_inst: MANAGEMENT
    port map(
      SRESET          => reset_to_mgmt_sync,
      CLK             => clkin_bufg,
      MDC             => MDIO_MDC, 
      MDIO_IN         => MDIO_O, 
      MDIO_OUT        => MDIO_OUT,
      MDIO_TRI        => MDIO_TRI,
      PHYAD           => C_PHYADDR,
      -- Register 16: PHY Specific Configuration Register Outputs
      SOFT_RESET      => SOFT_RESET, 
      DUPLEX_MODE     => DUPLEX_MODE,
      SPEED_SELECTION => SPEED_SELECTION
    );

  -- Instantiate the Bi-Directional buffer for MDIO line
  IOBUF_inst: IOBUF
    port map( 
      O  => mdio_iobuf_out,
      IO => MDIO,
      I  => MDIO_O,
      T  => MDIO_T
    ); 
  
  -- Mux the MDIO_I line to GEM. In a MDIO read cycle, the MDIO_I is sourced from the MANAGEMENT module
  MDIO_I <= --MDIO_OUT when MDIO_TRI = '0' else
            mdio_iobuf_out;

  -- Assign the MDC clock
  MDC <= MDIO_MDC;

  -- Instantiate the GMII to RGMII converter module
  tx_reset_async <= SOFT_RESET or tx_reset;
  rx_reset_async <= SOFT_RESET or rx_reset;

  external_clock_gen: if(C_EXTERNAL_CLOCK = 1) generate
  begin
    gmii_clk_int <= gmii_clk;
  end generate external_clock_gen;
                                                        
  internal_clock_gen: if(C_EXTERNAL_CLOCK = 0) generate
  begin
    gmii_clk_int <= '0';
  end generate internal_clock_gen;

  gmii_to_rgmii_inst: gmii_to_rgmii_core
    generic map(
      C_EXTERNAL_CLOCK => C_EXTERNAL_CLOCK
    ) 
    port map(
      -- ASynchronous resets
      tx_reset       => tx_reset_async,
      rx_reset       => rx_reset_async,
      -- Clocks
      refclk         => clkin_bufg,
      clkin          => clkin,
      gmii_clk       => gmii_clk_int,
      -- The following ports are the RGMII physical interface: these will be at
      -- pins on the FPGA
      rgmii_txd      => rgmii_txd,
      rgmii_tx_ctl   => rgmii_tx_ctl,
      rgmii_txc      => rgmii_txc,
      rgmii_rxd      => rgmii_rxd,
      rgmii_rx_ctl   => rgmii_rx_ctl,
      rgmii_rxc      => rgmii_rxc,
      -- The following signals are in the RGMII in-band status signals 
      link_status    => link_status,
      clock_speed    => clock_speed,
      duplex_status  => duplex_status,
      -- Register inputs from the MDIO module 
      speed_selection => SPEED_SELECTION, 
      duplex_mode     => DUPLEX_MODE,
      -- The following ports are the internal GMII connections from IOB logic
      -- to the TEMAC core
      gmii_txd       => gmii_txd,
      gmii_tx_en     => gmii_tx_en,
      gmii_tx_er     => gmii_tx_er,
      gmii_tx_clk    => gmii_tx_clk,
      gmii_crs       => gmii_crs,
      gmii_col       => gmii_col,
      gmii_rxd       => gmii_rxd,
      gmii_rx_dv     => gmii_rx_dv,
      gmii_rx_er     => gmii_rx_er,
      -- Receiver clock for the MAC and Client Logic 
      gmii_rx_clk    => gmii_rx_clk
  );

  speed_mode <= SPEED_SELECTION;

end rtl;
