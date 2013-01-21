-- ***************************************************************************
-- ***************************************************************************
-- Copyright 2011(c) Analog Devices, Inc.
-- 
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--     - Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     - Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in
--       the documentation and/or other materials provided with the
--       distribution.
--     - Neither the name of Analog Devices, Inc. nor the names of its
--       contributors may be used to endorse or promote products derived
--       from this software without specific prior written permission.
--     - The use of this software may or may not infringe the patent rights
--       of one or more patent holders.  This license does not release you
--       from the requirement that you obtain separate licenses from these
--       patent holders to use this software.
--     - Use of the software either in source or binary form, must be run
--       on or directly connected to an Analog Devices Inc. component.
--    
-- THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED.
--
-- IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
-- RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
-- BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
-- STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
-- THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- ***************************************************************************
-- ***************************************************************************
-- this module simply generates an fpga output clock from an input clock net

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.all;

entity util_outclk_lvds is
  port (
    ref_clk           : in  std_logic;  -- clock input
    clk_out_p         : out std_logic;  -- output clock (lvds)
    clk_out_n         : out std_logic
  );
end util_outclk_lvds;

architecture IMP of util_outclk_lvds is

  component ODDR
    generic (
      DDR_CLK_EDGE : string := "OPPOSITE_EDGE";
      INIT : bit := '0';
      SRTYPE : string := "SYNC"
    );
    port (
      R   : in  std_ulogic;
      S   : in  std_ulogic;
      CE  : in  std_ulogic;
      D1  : in  std_ulogic;
      D2  : in  std_ulogic;
      C   : in  std_ulogic;
      Q   : out std_ulogic
    );
  end component;

  component OBUFDS
    generic (
      IOSTANDARD : string := "LVDS_25";
      CAPACITANCE : string := "DONT_CARE";
      DRIVE : integer := 12
    );
    port (
      I   : in  std_ulogic;
      O   : out std_ulogic;
      OB  : out std_ulogic
    );
  end component;

  signal  clk_s   : std_ulogic;

begin

  -- oddr is used to drive output (this reduces skew to IOB->PAD)

  i_ddr : ODDR
    generic map (
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT => '0',
      SRTYPE => "SYNC"
    )
    port map (
      R   => '0',
      S   => '0',
      CE  => '1',
      D1  => '1',
      D2  => '0',
      C   => ref_clk,
      Q   => clk_s
    );

  i_obuf : OBUFDS
    generic map (
      IOSTANDARD => "LVDS_25"
    )
    port map (
      I => clk_s,
      O => clk_out_p,
      OB => clk_out_n
    );

end IMP;

-- ***************************************************************************
-- ***************************************************************************
