-------------------------------------------------------------------------------
-- $Revision: 1.1 $ $Date: 2011/03/01 08:05:49 $
-- Title      : MDIO Interface
-- Project    : Ethernet 1000BASE-X PCS/PMA
-------------------------------------------------------------------------------
-- File       : mdio_interface.vhd
-- Author     : Xilinx, Inc.
-------------------------------------------------------------------------------
-- Description: This is an implementation of an MDIO-interface
-- block for the 1 Gigabit Ethernet PCS / PMA core core, which operates
-- to clause 22 of IEEE 802.3-2000.
-------------------------------------------------------------------------------
-- (c) Copyright 2002-2008 Xilinx, Inc. All rights reserved.
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
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;



entity MDIO_INTERFACE is

  port (
    SRESET          : in    std_logic;                                   -- Asynchronous reset
    CLK             : in    std_logic;                                   -- Master Clock
    MDC_RISING_IN   : in    std_logic;                                   -- The rising edge of MDC
    MDIO_IN         : in    std_logic;                                   -- Management Data In
    MDIO_OUT        : out   std_logic;                                   -- Management Data Out
    MDIO_TRI        : out   std_logic;                                   -- Management Data Tristate
    MDC_RISING_OUT  : out   std_logic;                                   -- The rising edge of MDC
    ADDR_WR         : out   std_logic_vector(4 downto 0);                -- Register Address: this is held throughout the frame.
    ADDR_RD         : out   std_logic_vector(4 downto 0);                -- Register Address: this is cycle-early combinatorial.
    DATA_IN         : in    std_logic_vector(15 downto 0);               -- Data bus input
    DATA_OUT        : out   std_logic_vector(15 downto 0);               -- Data bus output
    WE              : out   std_logic;                                   -- Write enable
    RD              : out   std_logic;                                   -- port read flag
    PHYAD           : in    std_logic_vector(4 downto 0) := "01000"      -- PHY Port address- This should be different from the Board PHY address
  );
end MDIO_INTERFACE;



library ieee;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;



architecture RTL of MDIO_INTERFACE is



  constant OPCODE_WRITE    : std_logic_vector(1 downto 0) := "01";  -- signals a write operation.
  constant OPCODE_READ     : std_logic_vector(1 downto 0) := "10";  -- signals a read operation.



  -- State machine declarations
  type STATES is (IDLE_OR_PREAMBLE, WAIT_FOR_START, OPCODE_1, OPCODE_2,
                  LD_PHYAD, LD_REGAD, TA_1, TA_2, DATA_1, DATA_2, DATA_3);

  signal STATE, NEW_STATE                : STATES;

  -- Shift register and support signals; ser/deserialises MDIO stream.
  signal SHIFT_REG                       : std_logic_vector(15 downto 0) := (others => '0');
  signal LAST_DATA_SHIFT                 : std_logic := '0';
  -- Bit counter and support signals; used to time the MDIO stream.
  signal BIT_COUNT, BIT_COUNT_LOAD_VALUE : unsigned(3 downto 0) := "0000";
  signal BIT_COUNT_LOAD_EN               : std_logic := '0';

  -- Information extracted from the Management frame.
  signal ADDRESS_MATCH                   : std_logic := '0';
  signal OPCODE                          : std_logic_vector(1 downto 0) := "00";

  -- MDIO input register.
  signal MDIO_IN_REG                     : std_logic := '0';
  signal ADDRESS_MATCH_COMB              : std_logic := '0';
  signal MDIO_OUT_TRI_COMB               : std_logic := '0';
  signal MDIO_TRI_COMB                   : std_logic := '0';
  signal MDIO_OUT_COMB                   : std_logic := '0';

  -- Shifting of MDC_RISING_IN signal
  signal MDC_RISING_REG1                 : std_logic := '0';
  signal MDC_RISING_REG2                 : std_logic := '0';
  signal MDC_RISING_REG3                 : std_logic := '0';
begin  -- RTL



  -- purpose: Register the input MDIO signal.
  -- type:    sequential
  MDIO_IN_REGISTER : process (CLK)
  begin
    if CLK'event and CLK = '1' then
       if SRESET = '1' then
         MDIO_IN_REG <= '1';
       elsif MDC_RISING_IN = '1' then
         MDIO_IN_REG <= MDIO_IN;
       end if;
    end if;
  end process MDIO_IN_REGISTER;


  -- purpose: Reclock MDC several times.  From these, detect rising edges.
  -- type   : sequential
  RECLOCK_MDC : process (CLK)
  begin
    if CLK'event and CLK = '1' then
       if SRESET = '1' then
         MDC_RISING_REG1    <= '0';
         MDC_RISING_REG2    <= '0';
         MDC_RISING_REG3    <= '0';
       else
         MDC_RISING_REG1    <= MDC_RISING_IN;
         MDC_RISING_REG2    <= MDC_RISING_REG1;
         MDC_RISING_REG3    <= MDC_RISING_REG2;
       end if;
    end if;
  end process RECLOCK_MDC;

  MDC_RISING_OUT     <= MDC_RISING_REG3;

  -- purpose: Constructs a state machine to handle communication
  --          over an MDIO interface.
  -- type:    combinatorial
  -- inputs : MDIO, STATE, BIT_COUNT
  -- outputs: ADDR, WE
  STATE_COMB : process (MDIO_IN_REG, STATE, BIT_COUNT)
  begin
    case STATE is
      when IDLE_OR_PREAMBLE =>              -- IDLE and PREAMBLE states combined since we may not receive a
        if MDIO_IN_REG = '0' then           -- preamble of 32 continous '1's (preamble suppression supported).
          NEW_STATE <= WAIT_FOR_START;      -- Instead, logic waits for a '0' and then enters WAIT_FOR_START.
        else
          NEW_STATE <= IDLE_OR_PREAMBLE;
        end if;

      when WAIT_FOR_START =>                -- WAIT_FOR_START is entered with a '0' and left with a following '1'.
        if MDIO_IN_REG = '1' then           -- If MDIO floats to GND during IDLE, this is OK: logic waits for a
          NEW_STATE <= OPCODE_1;            -- following '1', thereby detecting '0'-'1' transition.
        else
          NEW_STATE <= WAIT_FOR_START;
        end if;

      when OPCODE_1 =>
        NEW_STATE <= OPCODE_2;

      when OPCODE_2 =>
        NEW_STATE <= LD_PHYAD;

      when LD_PHYAD =>                      -- This state machine always completes even if PHYAD doesn't match.
        if BIT_COUNT = 0 then               -- This is necessary so that the start opcode of '0'-to-'1' is not
          NEW_STATE <= LD_REGAD;            -- misinterpeted by loosing sync. with the frame.
        else
          NEW_STATE <= LD_PHYAD;
        end if;

      when LD_REGAD =>
        if BIT_COUNT = 0 then
          NEW_STATE <= TA_1;
        else
          NEW_STATE <= LD_REGAD;
        end if;

      when TA_1 =>
        NEW_STATE <= TA_2;

      when TA_2 =>
        NEW_STATE <= DATA_1;

      when DATA_1 =>                        -- Due to MDIO being registered on both input and output, this creates
        if BIT_COUNT = 0 then               -- a 2-clock discrepency between driving data for a read and receiving
          NEW_STATE <= DATA_2;              -- data during a write.  DATA_1 state is 14 clocks long.  For a read,
        else                                -- data is driven during states TA_1, TA_2, DATA_1 (16 bits total).
          NEW_STATE <= DATA_1;              -- For a write, data is received during states DATA_1, DATA_2, DATA_3
        end if;                             -- (16 clocks total).

      when DATA_2 =>
        NEW_STATE <= DATA_3;

      when DATA_3 =>
        NEW_STATE <= IDLE_OR_PREAMBLE;

      when others =>
        NEW_STATE <= IDLE_OR_PREAMBLE;
    end case;

  end process STATE_COMB;



  -- purpose: State machine flipflop synthesis
  -- type:    sequential
  STATE_CLOCKED : process (CLK)
  begin
    if CLK'event and CLK = '1' then     -- rising clock edge
       if SRESET = '1' then
         STATE <= IDLE_OR_PREAMBLE;
       elsif MDC_RISING_IN = '1' then
         STATE <= NEW_STATE;
       end if;
    end if;
  end process STATE_CLOCKED;



  -----------------------------------------------------------------------------
  -- Bit counter
  -- Used to count down cycles in the protocol stream.
  -- No reset required here, since BIT_COUNT_LOAD_EN will sort this out before
  -- BIT_COUNT is required.  The value loaded into BIT_COUNT is one less than
  -- required.  For example:
  -- In LD_PHYAD field, 4 is loaded into BIT_COUNT.  Counting down to 0 takes
  -- 5 clocks in total.

  P_BIT_COUNT : process (CLK)
  begin  -- process P_BIT_COUNT
    if CLK'event and CLK = '1' then     -- rising clock edge
       if MDC_RISING_IN = '1' then
         if BIT_COUNT_LOAD_EN = '1' then
           BIT_COUNT <= BIT_COUNT_LOAD_VALUE;
         else
           -- Count down, but don't wrap at zero
           if BIT_COUNT /= 0 then
             BIT_COUNT <= BIT_COUNT - 1;
           end if;
         end if;
       end if;
    end if;
  end process P_BIT_COUNT;

  -- purpose: sets up the correct value for loading into the bit counter. Keeps
  --          loading 4 in to count the bits in the PHYAD field, loads 4 to count the bits
  --          in the REGAD field, and 13 to count the bits in the DATA_1 payload
  --          (NOTE: DATA_2 and DATA_3 states complete 16 bit payload).
  -- type   : combinational
  -- inputs : STATE, BIT_COUNT
  -- outputs: BIT_COUNT_LOAD_EN, BIT_COUNT_LOAD_VALUE
  P_BIT_COUNT_LOAD : process (STATE, BIT_COUNT)
  begin  -- process P_BIT_COUNT_LOAD
    case STATE is
      when OPCODE_2 =>
        -- load counter for PHYAD field length
        BIT_COUNT_LOAD_EN    <= '1';
        BIT_COUNT_LOAD_VALUE <= TO_UNSIGNED(4, 4);
      when LD_PHYAD =>
        if unsigned(BIT_COUNT) = 0 then
          -- load counter for REGAD field length
          BIT_COUNT_LOAD_EN    <= '1';
          BIT_COUNT_LOAD_VALUE <= TO_UNSIGNED(4, 4);
        else
          BIT_COUNT_LOAD_EN    <= '0';
          BIT_COUNT_LOAD_VALUE <= (others => '0');
        end if;
      when TA_2 =>
        -- load counter for ADDRESS/DATA_1 field length
        BIT_COUNT_LOAD_EN    <= '1';
        BIT_COUNT_LOAD_VALUE <= TO_UNSIGNED(13, 4);   -- Set to count 14 bits.  State DATA_2 and DATA_3 count extra
      when others =>                                  -- 2 bits to account for 16 bit payload.
        BIT_COUNT_LOAD_EN    <= '0';
        BIT_COUNT_LOAD_VALUE <= (others => '0');
    end case;
  end process P_BIT_COUNT_LOAD;
  -----------------------------------------------------------------------------



  -- purpose: Generate a Shift register.
  --          No reset since it'll flush itself nicely.
  --          This continually clocks data in from MDIO_IN; various values are captured off
  --          of the parallel side during the MDIO_IN cycle
  -- type:    sequential

  LAST_SHIFT : process (CLK)
  begin
    if CLK'event and CLK = '1' then     -- rising clock edge
      if MDC_RISING_REG1 = '1' and STATE = DATA_3 then
           LAST_DATA_SHIFT <= '1';
      else
           LAST_DATA_SHIFT <= '0';
      end if;
    end if;
  end process LAST_SHIFT;

  P_SHIFT : process (CLK)
  begin
    if CLK'event and CLK = '1' then     -- rising clock edge
      if MDC_RISING_IN = '1' or LAST_DATA_SHIFT = '1' then
         if STATE = LD_REGAD and BIT_COUNT = 0 then
           -- Load up the shift register in case we're being queried
           SHIFT_REG <= DATA_IN;
         else
           -- read in a single bit of MDIO_IN
           SHIFT_REG <= SHIFT_REG(14 downto 0) & MDIO_IN_REG;
         end if;
      end if;
    end if;
  end process P_SHIFT;



  -- purpose: Capture OPCODE when it is valid in the shift register
  -- type:    sequential
  P_CAPTURE_OPCODE : process(CLK)
  begin
    if CLK'event and CLK = '1' then     -- rising clock edge
      if MDC_RISING_IN = '1' then
         if STATE = LD_PHYAD and BIT_COUNT = 4 then
           OPCODE <= SHIFT_REG(1 downto 0);
         end if;
      end if;
    end if;
  end process P_CAPTURE_OPCODE;



  -- purpose: Generates a match signal if the contents of the shift register
  --          point to this PHY device.  The ADDRESS_MATCH signal is held
  --          until the following frame.  If the OPCODE is a read, the MDIO
  --          will only be driven by this PHY during the DATA state if
  --          ADDRESS_MATCH is also true.
  -- type   : sequential
  P_ADDRESS_MATCH : process (CLK)
  begin  -- process P_ADDRESS_MATCH
    if CLK'event and CLK = '1' then     -- rising clock edge
       if SRESET = '1' then
         ADDRESS_MATCH <= '0';
       elsif MDC_RISING_IN = '1' then
         if STATE = LD_PHYAD then
            ADDRESS_MATCH <= ADDRESS_MATCH_COMB;
         end if;
      end if;
    end if;
  end process P_ADDRESS_MATCH;

ADDRESS_MATCH_COMB <= '1' when  SHIFT_REG(3 downto 0) & MDIO_IN_REG = PHYAD or
              SHIFT_REG(3 downto 0) & MDIO_IN_REG = "00000" else '0';

  -----------------------------------------------------------------------------
  -- purpose: The decision whether or not to drive the shared MDIO
  --          line is made in this process. It will only occur if a read has been
  --          requested and if the correct point in the waveform has been reached.
  -- type   : sequential
  P_MDIO : process (CLK)
  begin  -- process P_MDIO
    if CLK'event and CLK = '1' then
       if SRESET = '1' then
           MDIO_OUT <= '1';
           MDIO_TRI <= '1';
       elsif MDC_RISING_IN = '1' then
           case STATE is
             when LD_REGAD =>
                 MDIO_OUT <= MDIO_OUT_TRI_COMB;
                 MDIO_TRI <= MDIO_OUT_TRI_COMB;
             when TA_1 | TA_2 | DATA_1 =>      -- Only drive MDIO data during these states (16 clks).

                 MDIO_OUT <= MDIO_OUT_COMB;    -- output the top bit

                 MDIO_TRI <= MDIO_TRI_COMB;

             when others =>
               MDIO_OUT <= '1';
               MDIO_TRI <= '1';
           end case;
       end if;
    end if;
  end process P_MDIO;

  MDIO_OUT_TRI_COMB <= '0' when OPCODE = OPCODE_READ and ADDRESS_MATCH = '1' and BIT_COUNT = 0 else '1';
  MDIO_OUT_COMB     <= '0' when OPCODE = OPCODE_READ and ADDRESS_MATCH = '1' and SHIFT_REG(15) = '0' else '1';
  MDIO_TRI_COMB     <= '0' when OPCODE = OPCODE_READ and ADDRESS_MATCH = '1' else '1';
  -----------------------------------------------------------------------------

  -- purpose: Assign Register Address for a read cycle (valid 1 clock cycle only).
  -- type:    routing
  ADDR_RD <= SHIFT_REG(3 downto 0) & MDIO_IN_REG;



  -- purpose: Capture Register Address for a write cycle  (held througout the frame).
  -- type:    sequential
  P_ADDR : process (CLK)
  begin  -- process P_ADDR
    if CLK'event and CLK = '1' then     -- rising clock edge
       if SRESET = '1' then
         ADDR_WR <= (others => '0');
       elsif MDC_RISING_IN = '1' then
          if STATE = LD_REGAD and BIT_COUNT = 0 then
             ADDR_WR <= SHIFT_REG(3 downto 0) & MDIO_IN_REG;
          end if;
       end if;
    end if;
  end process P_ADDR;



  -----------------------------------------------------------------------------
  -- purpose: Process and assignments for DATA_OUT. The DATA_OUT port is connected
  --          directly to the shift register, but the WE (Write Enable) signal is driven
  --          from the correct state of the machine to ensure that the shift register
  --          contents are the frame field.  This is at the very end of the frame as
  --          marked by the state DATA_3.
  --          The RD flag is used to clear the contents of sticky bits that have been
  --          read by the STA entity.
  -- type:    sequential
  P_DATA_OUT : process(CLK)
  begin
    if CLK'event and CLK = '1' then
       if SRESET = '1' then
          WE <= '0';
          RD <= '0';
       elsif MDC_RISING_REG2 = '1' then
         if STATE = DATA_3 and ADDRESS_MATCH = '1' then
           if OPCODE = OPCODE_WRITE then
             WE <= '1';
             RD <= '0';
           elsif OPCODE = OPCODE_READ then
             WE <= '0';
             RD <= '1';
           else
             WE <= '0';
             RD <= '0';
           end if;
         else
           WE <= '0';
           RD <= '0';
         end if;
       end if;
    end if;
  end process P_DATA_OUT;

  DATA_OUT <= SHIFT_REG;



end RTL;




