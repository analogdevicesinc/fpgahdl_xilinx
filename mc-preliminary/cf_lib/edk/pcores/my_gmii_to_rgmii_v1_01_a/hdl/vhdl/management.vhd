-------------------------------------------------------------------------------
-- File       : management.vhd
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
-- Description:  This module is a stripped down version of the managemnet module 
--               used in the Ethernet 1000BASE-X PCS/PMA project 
--
--               This module implements a Control register through wihch the firmware
--               programs line-rate and duplex information to the GMII-to-RGMII core
--------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-- This is based on Coregen Wrappers from ISE O.40c (13.1)
-- Wrapper version 5.1
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity MANAGEMENT is
  port (
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
end MANAGEMENT;


library ieee;
use ieee.numeric_std.all;

architecture RTL of MANAGEMENT is

  -- Component declaration
  component sync_block
    generic (
      INITIALISE : bit_vector(1 downto 0) := "00"
    );
    port(
      clk        : in std_logic;
      data_in    : in std_logic;
      data_out   : out std_logic
    );
  end component; 

  component MDIO_INTERFACE
    port (
      SRESET          : in    std_logic;                      -- Global reset
      CLK             : in    std_logic;                      -- Master Clock
      MDC_RISING_IN   : in    std_logic;                      -- The rising edge of MDC
      MDIO_IN         : in    std_logic;                      -- Management Data In
      MDIO_OUT        : out   std_logic;                      -- Management Data Out
      MDIO_TRI        : out   std_logic;                      -- Management Data Tristate
      MDC_RISING_OUT  : out   std_logic;                      -- The rising edge of MDC
      ADDR_WR         : out   std_logic_vector(4 downto 0);   -- Register Address: this is held throughout the frame.
      ADDR_RD         : out   std_logic_vector(4 downto 0);   -- Register Address: this is cycle-early combinatorial.
      DATA_IN         : in    std_logic_vector(15 downto 0);  -- Data bus input
      DATA_OUT        : out   std_logic_vector(15 downto 0);  -- Data bus output
      WE              : out   std_logic;                      -- Write enable
      RD              : out   std_logic;                      -- port read flag
      PHYAD           : in    std_logic_vector(4 downto 0)    -- PHY Port address
    );
  end component;

  -- Symbolic constants for MDIO register addresses
  constant PHY_SPECIFIC_CONTROL_REG_1  : integer := 0;  -- Control Register.
  
  -- the following signals are used to capture the rising edge of MDC clock on the Higher
  -- frequency core clock CLK.  This method eliminates skew caused by using the signal MDC
  -- as a clock since it is not on a global clock buffer.
  signal MDC_REG2              : std_logic;
  signal MDC_REG3              : std_logic;
  signal MDC_RISING            : std_logic;

  -- the following signals are used to delay MDIO (input) by the pipeline delay incurred
  -- by reclocking MDC.
  signal MDIO_IN_REG2          : std_logic;
  signal MDIO_IN_REG3          : std_logic;
  signal MDIO_IN_REG4          : std_logic;

  -- the following data signals are from the point of view of the STA; i.e. the
  -- DATA_RD is data which will be read out over the MDIO, DATA_WR is data to
  -- be written into the device registers. This is only done on assertion of
  -- the MDIO_WE signal.

  -- The current register address held for write.
  signal ADDR_WR               : std_logic_vector(4 downto 0)  := (others => '0');
  -- The current register address for read.
  signal ADDR_RD               : std_logic_vector(4 downto 0)  := (others => '0');
  signal DATA_RD               : std_logic_vector(15 downto 0) := (others => '0');
  signal DATA_WR               : std_logic_vector(15 downto 0) := (others => '0');
  signal MDIO_WE               : std_logic := '0';
  signal MDIO_RD               : std_logic := '0';

  -- Register 0: Configuration register outputs
  signal RESET_REG             : std_logic := '0';                      -- Control reg, bit 15.
  signal SPEED_SELECTION_REG   : std_logic_vector(1 downto 0) := "10";  -- Control reg, bits 6,13
  signal DUPLEX_MODE_REG       : std_logic := '0';                      -- Control reg, bit 8.

  signal MDC_RISING_REG1       : std_logic;

begin  -- RTL

-------------------------------------------------------------------------------
-- Setup complete: now continue with main Management decoding logic
-------------------------------------------------------------------------------

   -- purpose: Synchronise the asynchronous input MDC.
   SYNC_MDC: SYNC_BLOCK
   port map (
      CLK       => CLK,
      DATA_IN   => MDC,
      DATA_OUT  => MDC_REG2
   );


   -- purpose: Synchronise the asynchronous input MDIO_IN.
   SYNC_MDIO_IN: SYNC_BLOCK
   port map (
      CLK       => CLK,
      DATA_IN   => MDIO_IN,
      DATA_OUT  => MDIO_IN_REG2
   );

  -- purpose: Reclock MDC several times.  From these, detect rising edges.
  -- type   : sequential
  RECLOCK_MDC : process (CLK)
  begin
    if CLK'event and CLK = '1' then
       if SRESET = '1' then
         MDC_REG3           <= '0';
         MDC_RISING_REG1    <= '0';

         MDIO_IN_REG3  <= '1';
         MDIO_IN_REG4  <= '1';

       else
         MDC_REG3           <= MDC_REG2;
         MDC_RISING_REG1    <= MDC_REG2 and (not MDC_REG3);

         MDIO_IN_REG3  <= MDIO_IN_REG2;
         MDIO_IN_REG4  <= MDIO_IN_REG3;
       end if;
    end if;
  end process RECLOCK_MDC;


  -- Instance the MDIO interface. This block handles all of the protocol over
  -- the MDIO.
  MDIO_INTERFACE_1 : MDIO_INTERFACE
    port map (
      SRESET         => SRESET,
      CLK            => CLK,
      MDC_RISING_IN  => MDC_RISING_REG1 ,
      MDIO_IN        => MDIO_IN_REG4,
      MDIO_OUT       => MDIO_OUT,
      MDIO_TRI       => MDIO_TRI,
      MDC_RISING_OUT => MDC_RISING ,
      ADDR_WR        => ADDR_WR,
      ADDR_RD        => ADDR_RD,
      DATA_IN        => DATA_RD,
      DATA_OUT       => DATA_WR,
      WE             => MDIO_WE,
      RD             => MDIO_RD,
      PHYAD          => PHYAD
    );

  -----------------------------------------------------------------------------
  -- CONFIGURATION REGISTERS: READ ADDRESS DECODING.
  -----------------------------------------------------------------------------

  -- purpose: This process is effectively an address decoder for
  --          the read operation on the MDIO. It uses the address register of
  --          the MDIO protocol block to select amongst registers and hardwires
  --          to put onto the DATA_RD port.
  -- type   : combinational
  P_DATA_RD : process (ADDR_RD, RESET_REG, SPEED_SELECTION_REG, DUPLEX_MODE_REG)
  begin
    case TO_INTEGER(unsigned(ADDR_RD)) is
      when PHY_SPECIFIC_CONTROL_REG_1 =>                   -- REGISTER 0: CONTROL REGISTER.
        DATA_RD(15)          <= RESET_REG;                 -- PHY Reset.
        DATA_RD(14)          <= '0';                       -- Loopback - ignore write.
        DATA_RD(13)          <= SPEED_SELECTION_REG(0);    -- Speed selection.
        DATA_RD(12)          <= '0';                       -- Auto-Negotiation Enable - ignore write.
        DATA_RD(11)          <= '0';                       -- Power down - ignore write.
        DATA_RD(10)          <= '0';                       -- Isolate GMII - ignore write.
        DATA_RD(9)           <= '0';                       -- Restart Auto_Negotaition - ignore write.
        DATA_RD(8)           <= DUPLEX_MODE_REG;           -- Duplex Mode.
        DATA_RD(7)           <= '0';                       -- Collision Test - ignore write.
        DATA_RD(6)           <= SPEED_SELECTION_REG(1);    -- Speed selection - ignore write.
        DATA_RD(5)           <= '0';                        -- 802.3ah: Allow Tx whatever state of Rx - ignore write.
        DATA_RD(4 downto 0)  <= "00000";                   -- Reserved.
      
      when others =>
        -- From 45.2 of 802.3ae D3.3: we should return 0's for undefined
        -- registers and operations
        DATA_RD <= (others => '0');
    end case;
  end process P_DATA_RD;

  -----------------------------------------------------------------------------
  -- CONFIGURATION REGISTERS: WRITE ADDRESS DECODING.
  -----------------------------------------------------------------------------

   -- purpose: Register 0: Config register write logic - X.0.(15,14,12,11,10,9,8,7).
   -- type   : sequential
   P_CONFIG_REG : process (CLK)
   begin
     if CLK'event and CLK = '1' then      -- rising clock edge
       if SRESET = '1' then
         RESET_REG                 <= '0';
         DUPLEX_MODE_REG           <= '0';
         SPEED_SELECTION_REG       <= (others => '0');
       elsif MDC_RISING = '1' then
         if to_integer(unsigned(ADDR_WR)) = PHY_SPECIFIC_CONTROL_REG_1 and MDIO_WE = '1' then
           if DATA_WR(15) = '1' then                            -- PHY Reset.
             RESET_REG <= '1';                                  -- The only way to set this to zero is to assert SRESET; therefore, it
           end if;                                              -- needs to be looped back outside this block and OR'ed back into SRESET.
           SPEED_SELECTION_REG <= DATA_WR(6) & DATA_WR(13);      -- Line Rate
           DUPLEX_MODE_REG    <= DATA_WR(8);                    -- Duplex Mode
         end if;
       end if;
     end if;
  end process;

  -- purpose: Assign internal signals to outputs.
  -- type   : routing
  SOFT_RESET            <= RESET_REG;
  DUPLEX_MODE           <= DUPLEX_MODE_REG;
  SPEED_SELECTION       <= SPEED_SELECTION_REG;

end RTL;

