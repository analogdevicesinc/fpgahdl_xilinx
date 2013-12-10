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
-- ***************************************************************************
-- ***************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;

library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

entity axi_upif is

  generic (
    C_S_AXI_MIN_SIZE          : std_logic_vector := x"0000ffff";
    C_BASEADDR                : std_logic_vector := x"ffffffff";
    C_HIGHADDR                : std_logic_vector := x"00000000");

  port (
    up_rstn                   : out std_logic;
    up_clk                    : out std_logic;
    upif_sel                  : out std_logic;
    upif_rwn                  : out std_logic;
    upif_addr                 : out std_logic_vector(31 downto 0);
    upif_wdata                : out std_logic_vector(31 downto 0);
    upif_wack                 : in  std_logic;
    upif_rdata                : in  std_logic_vector(31 downto 0);
    upif_rack                 : in  std_logic;
    s_axi_aclk                : in  std_logic;
    s_axi_aresetn             : in  std_logic;
    s_axi_awaddr              : in  std_logic_vector(31 downto 0);
    s_axi_awvalid             : in  std_logic;
    s_axi_wdata               : in  std_logic_vector(31 downto 0);
    s_axi_wstrb               : in  std_logic_vector(3 downto 0);
    s_axi_wvalid              : in  std_logic;
    s_axi_bready              : in  std_logic;
    s_axi_araddr              : in  std_logic_vector(31 downto 0);
    s_axi_arvalid             : in  std_logic;
    s_axi_rready              : in  std_logic;
    s_axi_arready             : out std_logic;
    s_axi_rdata               : out std_logic_vector(31 downto 0);
    s_axi_rresp               : out std_logic_vector(1 downto 0);
    s_axi_rvalid              : out std_logic;
    s_axi_wready              : out std_logic;
    s_axi_bresp               : out std_logic_vector(1 downto 0);
    s_axi_bvalid              : out std_logic;
    s_axi_awready             : out std_logic);

end entity axi_upif;

architecture rtl of axi_upif is

  constant ZERO_32            : std_logic_vector(31 downto 0) := (others => '0');
  constant C_TIMEOUT          : integer := 16;
  constant C_NUM_CE           : INTEGER_ARRAY_TYPE := (0  => (32));
  constant C_ADDR_RANGE       : SLV64_ARRAY_TYPE := (ZERO_32 & C_BASEADDR, ZERO_32 & C_HIGHADDR);

  signal gnd                  : std_logic;
  signal upif_sel_s           : std_logic_vector(0 downto 0);

begin

  gnd <= '0';
  upif_sel <= upif_sel_s(0);

  i_axi_lite_ipif: entity axi_lite_ipif_v1_01_a.axi_lite_ipif
    generic map (
      C_S_AXI_MIN_SIZE        => C_S_AXI_MIN_SIZE,
      C_DPHASE_TIMEOUT        => C_TIMEOUT,
      C_ARD_NUM_CE_ARRAY      => C_NUM_CE,
      C_ARD_ADDR_RANGE_ARRAY  => C_ADDR_RANGE)
    port map (
      S_AXI_ACLK              => s_axi_aclk,
      S_AXI_ARESETN           => s_axi_aresetn,
      S_AXI_AWADDR            => s_axi_awaddr,
      S_AXI_AWVALID           => s_axi_awvalid,
      S_AXI_WDATA             => s_axi_wdata,
      S_AXI_WSTRB             => s_axi_wstrb,
      S_AXI_WVALID            => s_axi_wvalid,
      S_AXI_BREADY            => s_axi_bready,
      S_AXI_ARADDR            => s_axi_araddr,
      S_AXI_ARVALID           => s_axi_arvalid,
      S_AXI_RREADY            => s_axi_rready,
      S_AXI_ARREADY           => s_axi_arready,
      S_AXI_RDATA             => s_axi_rdata,
      S_AXI_RRESP             => s_axi_rresp,
      S_AXI_RVALID            => s_axi_rvalid,
      S_AXI_WREADY            => s_axi_wready,
      S_AXI_BRESP             => s_axi_bresp,
      S_AXI_BVALID            => s_axi_bvalid,
      S_AXI_AWREADY           => s_axi_awready,
      Bus2IP_Clk              => up_clk,
      Bus2IP_Resetn           => up_rstn,
      Bus2IP_Addr             => upif_addr,
      Bus2IP_RNW              => upif_rwn,
      Bus2IP_BE               => open,
      Bus2IP_CS               => upif_sel_s,
      Bus2IP_RdCE             => open,
      Bus2IP_WrCE             => open,
      Bus2IP_Data             => upif_wdata,
      IP2Bus_WrAck            => upif_wack,
      IP2Bus_RdAck            => upif_rack,
      IP2Bus_Error            => gnd,
      IP2Bus_Data             => upif_rdata);

end rtl;

-- ***************************************************************************
-- ***************************************************************************
