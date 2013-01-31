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
-- This is just a bus split, because it is not possible to do this on a MHS file.
-- Incoming data is 36 bits RGB, output is 24 bit RGB., truncated!

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.all;

entity util_hdmi_tx_24b is
  port (
    hdmi_data_36      : in  std_logic_vector(35 downto 0);
    hdmi_data_24      : out std_logic_vector(23 downto 0)
  );
end util_hdmi_tx_24b;

architecture IMP of util_hdmi_tx_24b is
begin

  -- truncated RGB 24bits from RGB 36bits

  hdmi_data_24(23 downto 16) <= hdmi_data_36(35 downto 28);
  hdmi_data_24(15 downto  8) <= hdmi_data_36(23 downto 16);
  hdmi_data_24( 7 downto  0) <= hdmi_data_36(11 downto  4);

end IMP;

-- ***************************************************************************
-- ***************************************************************************
