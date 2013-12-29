--------------------------------------------------------------------------------
-- Title      : Reset synchroniser
-- Project    : Tri-Mode Ethernet MAC
--------------------------------------------------------------------------------
-- File       : reset_sync.vhd
-- Author     : Xilinx Inc.
--------------------------------------------------------------------------------
-- Description: Both flip-flops have the same asynchronous reset signal.
--              Together the flops create a minimum of a 1 clock period
--              duration pulse which is used for synchronous reset.
--
--              The flops are placed, using RLOCs, into the same slice.
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
-------------------------------------------------------------------------------
-- This is based on Coregen Wrappers from ISE O.40c (13.1)
-- Wrapper version 5.1
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;


entity reset_sync is

  generic (INITIALISE : bit_vector(1 downto 0) := "11");
  port (
    reset_in    : in  std_logic;          -- Active high asynchronous reset
    enable      : in  std_logic;
    clk         : in  std_logic;          -- clock to be sync'ed to
    reset_out   : out std_logic           -- "Synchronised" reset signal
    );

end reset_sync;

--------------------------------------------------------------------------------

architecture rtl of reset_sync is
  signal reset_sync_reg : std_logic;
  signal reset_sync_reg2 : std_logic;

  attribute ASYNC_REG                    : string;
  attribute ASYNC_REG of reset_sync_reg  : signal is "TRUE";
  attribute ASYNC_REG of reset_sync_reg2 : signal is "TRUE";
  attribute RLOC                         : string;
  attribute RLOC      of reset_sync_reg  : signal is "X0Y0";
  attribute RLOC      of reset_sync_reg2 : signal is "X0Y0";
  attribute SHREG_EXTRACT                    : string;
  attribute SHREG_EXTRACT of reset_sync_reg  : signal is "NO";
  attribute SHREG_EXTRACT of reset_sync_reg2 : signal is "NO";
  attribute INIT                         : string;
  attribute INIT      of reset_sync_reg  : signal is "1";
  attribute INIT      of reset_sync_reg2 : signal is "1";


begin

  reset_sync1 : FDPE
  generic map (
    INIT => INITIALISE(0)
  )
  port map (
    C    => clk,
    CE   => enable,
    PRE  => reset_in,
    D    => '0',
    Q    => reset_sync_reg
  );


  reset_sync2 : FDPE
  generic map (
    INIT => INITIALISE(1)
  )
  port map (
    C    => clk,
    CE   => enable,
    PRE  => reset_in,
    D    => reset_sync_reg,
    Q    => reset_sync_reg2
  );

  reset_out <= reset_sync_reg2;

end rtl;
