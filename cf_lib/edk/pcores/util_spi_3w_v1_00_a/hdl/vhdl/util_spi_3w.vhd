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
-- this module converts 3 wire spi (physical) to 4 wire spi (internal)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.all;

entity util_spi_3w is
  port (
    m_clk             : in  std_logic;                      -- master clock
    x_csn             : in  std_logic_vector(1 downto 0);   -- 4 wire csn
    x_clk             : in  std_logic;                      -- 4 wire clock
    x_mosi            : in  std_logic;                      -- 4 wire mosi
    x_miso            : out std_logic;                      -- 4 wire miso
    spi_cs0n          : out std_logic;                      -- 3 wire csn (split)
    spi_cs1n          : out std_logic;
    spi_clk           : out std_logic;                      -- 3 wire clock
    spi_sdio_T        : out std_logic;                      -- 3 wire sdio (bi-dir)
    spi_sdio_O        : out std_logic;
    spi_sdio_I        : in  std_logic;

    debug_trigger     : out std_logic_vector(7 downto 0);
    debug_data        : out std_logic_vector(63 downto 0)
  );
end util_spi_3w;

architecture IMP of util_spi_3w is

  signal  x_clk_d     : std_logic := '0';
  signal  x_csn_d     : std_logic := '0';
  signal  m_enable    : std_logic := '0';
  signal  m_rdwr      : std_logic := '0';
  signal  m_bitcnt    : std_logic_vector(5 downto 0) := (others => '0');
  signal  m_clkcnt    : std_logic_vector(5 downto 0) := (others => '0');

  signal  x_csn_s     : std_logic;

begin

  -- pass most of the 4 wire stuff as it is (we only need the tristate controls)

  x_csn_s <= not(x_csn(0) and x_csn(1));
  x_miso <= spi_sdio_I;
  spi_cs0n <= x_csn(0);
  spi_cs1n <= x_csn(1);
  spi_clk <= x_clk;
  spi_sdio_T <= x_csn_s and m_enable;
  spi_sdio_O <= x_mosi;

  -- debug ports

  debug_trigger <= "0000000" & x_csn_s;
  debug_data(63 downto 23) <= (others => '0');
  debug_data(22) <= m_rdwr;
  debug_data(21) <= x_csn(1);
  debug_data(20) <= x_csn(0);
  debug_data(19) <= x_clk;
  debug_data(18) <= x_mosi;
  debug_data(17) <= x_clk_d; 
  debug_data(16) <= x_csn_d; 
  debug_data(15) <= x_csn_s; 
  debug_data(14) <= x_csn_s and m_enable;
  debug_data(13) <= spi_sdio_I;
  debug_data(12) <= m_enable;
  debug_data(11 downto  6) <= m_bitcnt;
  debug_data( 5 downto  0) <= m_clkcnt;

  -- adc uses 16bit address phase, so count and change direction if read

  p_cnts: process(m_clk) begin
    if (m_clk'event and m_clk = '1') then
      x_clk_d <= x_clk;
      x_csn_d <= x_csn_s;
      if ((m_bitcnt = 16) and (m_clkcnt = 10)) then
        m_enable <= m_rdwr;
      elsif ((x_csn_s = '0') and (x_csn_d = '1')) then
        m_enable <= '0';
      end if;
      if ((x_csn_s = '1') and (x_csn_d = '0')) then
        m_rdwr <= '0';
        m_bitcnt <= (others => '0');
      elsif ((x_clk = '1') and (x_clk_d = '0')) then
        if (m_bitcnt = 0) then
          m_rdwr <= x_mosi;
        end if;
        m_bitcnt <= m_bitcnt + 1;
      end if;
      if ((x_clk = '1') and (x_clk_d = '0')) then
        m_clkcnt <= (others => '0');
      else
        m_clkcnt <= m_clkcnt + 1;
      end if;
    end if;
  end process;

end IMP;

-- ***************************************************************************
-- ***************************************************************************
