-- ***************************************************************************
-- ***************************************************************************
-- ***************************************************************************
-- ***************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.all;

entity util_outclk_lvds is
  port (
    ref_clk           : in  std_logic;
    clk_out_p         : out std_logic;
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
