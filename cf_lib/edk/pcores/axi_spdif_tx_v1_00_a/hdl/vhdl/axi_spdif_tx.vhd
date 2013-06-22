------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Copyright 2011-2013(c) Analog Devices, Inc.
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
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- andrei.cozma@analog.com (c) Analog Devices Inc.
------------------------------------------------------------------------------
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;

library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

library axi_spdif_tx_v1_00_a;
use axi_spdif_tx_v1_00_a.tx_package.all;

entity axi_spdif_tx is
  generic
  (
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector     := X"00000000";
    C_FAMILY                       : string               := "virtex6";
    C_NUM_REG                      : integer              := 1;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32
  );
  port
  (
  
    --SPDIF ports
    spdif_data_clk : in std_logic;
    spdif_tx_o     : out std_logic;
    
    --AXI Lite interface
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic;
    
    --AXI streaming interface
    S_AXIS_ACLK	        : in	std_logic;
    S_AXIS_ARESETN	        : in	std_logic;
    S_AXIS_TREADY	: out	std_logic;
    S_AXIS_TDATA	: in	std_logic_vector(31 downto 0);
    S_AXIS_TLAST	: in	std_logic;
    S_AXIS_TVALID	: in	std_logic    
  );
end entity axi_spdif_tx;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_spdif_tx is

  constant USER_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant IPIF_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant ZERO_ADDR_PAD                  : std_logic_vector(0 to 31) := (others => '0');
  constant USER_SLV_BASEADDR              : std_logic_vector     := C_BASEADDR;
  constant USER_SLV_HIGHADDR              : std_logic_vector     := C_HIGHADDR;

  constant IPIF_ARD_ADDR_RANGE_ARRAY      : SLV64_ARRAY_TYPE     := 
    (
      ZERO_ADDR_PAD & USER_SLV_BASEADDR,  -- user logic slave space base address
      ZERO_ADDR_PAD & USER_SLV_HIGHADDR   -- user logic slave space high address
    );

  constant USER_SLV_NUM_REG               : integer              := 2;
  constant USER_NUM_REG                   : integer              := USER_SLV_NUM_REG;
  constant TOTAL_IPIF_CE                  : integer              := USER_NUM_REG;

  constant IPIF_ARD_NUM_CE_ARRAY          : INTEGER_ARRAY_TYPE   := 
    (
      0  => (USER_SLV_NUM_REG)            -- number of ce for user logic slave space
    );

  ------------------------------------------
  -- Index for CS/CE
  ------------------------------------------
  constant USER_SLV_CS_INDEX              : integer              := 0;
  constant USER_SLV_CE_INDEX              : integer              := calc_start_ce_index(IPIF_ARD_NUM_CE_ARRAY, USER_SLV_CS_INDEX);

  constant USER_CE_INDEX                  : integer              := USER_SLV_CE_INDEX;

  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations
  ------------------------------------------
  signal ipif_Bus2IP_Clk                : std_logic;
  signal ipif_Bus2IP_Resetn             : std_logic;
  signal ipif_Bus2IP_Addr               : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal ipif_Bus2IP_RNW                : std_logic;
  signal ipif_Bus2IP_BE                 : std_logic_vector(IPIF_SLV_DWIDTH/8-1 downto 0);
  signal ipif_Bus2IP_CS                 : std_logic_vector((IPIF_ARD_ADDR_RANGE_ARRAY'LENGTH)/2-1 downto 0);
  signal ipif_Bus2IP_RdCE               : std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal ipif_Bus2IP_WrCE               : std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal ipif_Bus2IP_Data               : std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
  signal user_Bus2IP_RdCE               : std_logic_vector(USER_NUM_REG-1 downto 0);
  signal user_Bus2IP_WrCE               : std_logic_vector(USER_NUM_REG-1 downto 0);
  signal user_IP2Bus_Data               : std_logic_vector(USER_SLV_DWIDTH-1 downto 0);
  signal user_IP2Bus_RdAck              : std_logic;
  signal user_IP2Bus_WrAck              : std_logic;
  signal user_IP2Bus_Error              : std_logic;

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg_write_sel              : std_logic_vector(1 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(1 downto 0);
  signal slv_user_IP2Bus_Data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;
  
  ------------------------------------------
  -- SPDIF signals
  ------------------------------------------
  constant RAM_ADDR_WIDTH : integer := 7;
  
  signal config_reg    : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal chstatus_reg  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
 
  signal chstat_freq : std_logic_vector(1 downto 0);
  signal chstat_gstat, chstat_preem, chstat_copy, chstat_audio : std_logic;
  signal mem_rd, mem_rd_d1, ch_status_wr, user_data_wr : std_logic;
  signal sample_data: std_logic_vector(15 downto 0);
  signal conf_mode : std_logic_vector(3 downto 0);
  signal conf_ratio : std_logic_vector(7 downto 0);
  signal conf_tinten, conf_txdata, conf_txen : std_logic;
  signal channel : std_logic;

  ------------------------------------------
  -- Audio samples FIFO  
  ------------------------------------------
  type RAM_TYPE is array (0 to (2**RAM_ADDR_WIDTH - 1)) of std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
  signal audio_fifo          : RAM_TYPE;
  signal audio_fifo_wr_addr  : std_logic_vector(RAM_ADDR_WIDTH - 1 downto 0);
  signal audio_fifo_rd_addr  : std_logic_vector(RAM_ADDR_WIDTH - 1 downto 0);
  signal audio_fifo_full     : std_logic;
begin

  ------------------------------------------
  -- instantiate axi_lite_ipif
  ------------------------------------------
  AXI_LITE_IPIF_I : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
    generic map
    (
      C_S_AXI_DATA_WIDTH             => IPIF_SLV_DWIDTH,
      C_S_AXI_ADDR_WIDTH             => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_MIN_SIZE               => C_S_AXI_MIN_SIZE,
      C_USE_WSTRB                    => C_USE_WSTRB,
      C_DPHASE_TIMEOUT               => C_DPHASE_TIMEOUT,
      C_ARD_ADDR_RANGE_ARRAY         => IPIF_ARD_ADDR_RANGE_ARRAY,
      C_ARD_NUM_CE_ARRAY             => IPIF_ARD_NUM_CE_ARRAY,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      S_AXI_ACLK                     => S_AXI_ACLK,
      S_AXI_ARESETN                  => S_AXI_ARESETN,
      S_AXI_AWADDR                   => S_AXI_AWADDR,
      S_AXI_AWVALID                  => S_AXI_AWVALID,
      S_AXI_WDATA                    => S_AXI_WDATA,
      S_AXI_WSTRB                    => S_AXI_WSTRB,
      S_AXI_WVALID                   => S_AXI_WVALID,
      S_AXI_BREADY                   => S_AXI_BREADY,
      S_AXI_ARADDR                   => S_AXI_ARADDR,
      S_AXI_ARVALID                  => S_AXI_ARVALID,
      S_AXI_RREADY                   => S_AXI_RREADY,
      S_AXI_ARREADY                  => S_AXI_ARREADY,
      S_AXI_RDATA                    => S_AXI_RDATA,
      S_AXI_RRESP                    => S_AXI_RRESP,
      S_AXI_RVALID                   => S_AXI_RVALID,
      S_AXI_WREADY                   => S_AXI_WREADY,
      S_AXI_BRESP                    => S_AXI_BRESP,
      S_AXI_BVALID                   => S_AXI_BVALID,
      S_AXI_AWREADY                  => S_AXI_AWREADY,
      Bus2IP_Clk                     => ipif_Bus2IP_Clk,
      Bus2IP_Resetn                  => ipif_Bus2IP_Resetn,
      Bus2IP_Addr                    => ipif_Bus2IP_Addr,
      Bus2IP_RNW                     => ipif_Bus2IP_RNW,
      Bus2IP_BE                      => ipif_Bus2IP_BE,
      Bus2IP_CS                      => ipif_Bus2IP_CS,
      Bus2IP_RdCE                    => ipif_Bus2IP_RdCE,
      Bus2IP_WrCE                    => ipif_Bus2IP_WrCE,
      Bus2IP_Data                    => ipif_Bus2IP_Data,
      IP2Bus_WrAck                   => user_IP2Bus_WrAck,
      IP2Bus_RdAck                   => user_IP2Bus_RdAck,
      IP2Bus_Error                   => user_IP2Bus_Error,
      IP2Bus_Data                    => user_IP2Bus_Data
    );

	user_Bus2IP_RdCE <= ipif_Bus2IP_RdCE(USER_NUM_REG-1 downto 0);
	user_Bus2IP_WrCE <= ipif_Bus2IP_WrCE(USER_NUM_REG-1 downto 0);

	-- Audio samples FIFO management
    S_AXIS_TREADY  <= '1' when audio_fifo_full = '0' else '0';
    AUDIO_FIFO_PROCESS : process (S_AXIS_ACLK) is
        variable audio_fifo_free_cnt : integer range 0 to 2**RAM_ADDR_WIDTH;
    begin        
        if S_AXIS_ACLK'event and S_AXIS_ACLK = '1' then
            if ipif_Bus2IP_Resetn = '0' or conf_txdata = '0' then
                audio_fifo_wr_addr  <= (others => '0');
                audio_fifo_rd_addr  <= (others => '0');
                audio_fifo_free_cnt := 2**RAM_ADDR_WIDTH;
                audio_fifo_full     <= '0';
                mem_rd_d1           <= '0';
            else
                mem_rd_d1 <= mem_rd;
                
                if ((S_AXIS_TVALID = '1') and (audio_fifo_free_cnt > 0)) then
                    audio_fifo(conv_integer(audio_fifo_wr_addr)) <= S_AXIS_TDATA;
                    audio_fifo_wr_addr <= audio_fifo_wr_addr + '1';
                    audio_fifo_free_cnt := audio_fifo_free_cnt - 1;
                end if;
                
                if((channel = '1') and (mem_rd_d1 = '1' and mem_rd = '0') and (audio_fifo_free_cnt < (2**RAM_ADDR_WIDTH)))then
                    audio_fifo_rd_addr <= audio_fifo_rd_addr + '1';
                    audio_fifo_free_cnt := audio_fifo_free_cnt + 1;
                end if; 
                
                if(audio_fifo_free_cnt = 0)then
                    audio_fifo_full <= '1';
                else
                    audio_fifo_full <= '0';
                end if;
                
                if(channel = '1') then
                    sample_data(15 downto 0) <= audio_fifo(conv_integer(audio_fifo_rd_addr))(31 downto 16);
                else
                    sample_data(15 downto 0) <= audio_fifo(conv_integer(audio_fifo_rd_addr))(15 downto 0);
                end if;
            end if;
        end if;
    end process AUDIO_FIFO_PROCESS;

	-- SPDIF registers update

	-- Configuration signals update
    conf_mode(3 downto 0)  <= config_reg(23 downto 20);
    conf_ratio(7 downto 0) <= config_reg(15 downto 8);
    conf_tinten <= config_reg(2);
    conf_txdata <= config_reg(1);
    conf_txen   <= config_reg(0);

	-- Channel status signals update
    chstat_freq(1 downto 0) <= chstatus_reg(7 downto 6);
    chstat_gstat <= chstatus_reg(3);
    chstat_preem <= chstatus_reg(2);
    chstat_copy <= chstatus_reg(1);
    chstat_audio <= chstatus_reg(0);
    

	-- Transmit encoder
    TENC: tx_encoder 	 
      generic map (DATA_WIDTH => 16) 
      port map (
        up_clk          => ipif_Bus2IP_Clk,
        data_clk        => spdif_data_clk,  -- data clock
        resetn          => ipif_Bus2IP_Resetn,   -- resetn
        conf_mode       => conf_mode,       -- sample format
        conf_ratio      => conf_ratio,      -- clock divider
        conf_txdata     => conf_txdata,     -- sample data enable
        conf_txen       => conf_txen,       -- spdif signal enable
        chstat_freq     => chstat_freq,     -- sample freq.
        chstat_gstat    => chstat_gstat,    -- generation status
        chstat_preem    => chstat_preem,    -- preemphasis status
        chstat_copy     => chstat_copy,     -- copyright bit
        chstat_audio    => chstat_audio,    -- data format
        sample_data     => sample_data,     -- audio data
        mem_rd          => mem_rd,          -- sample buffer read
        channel         => channel,         -- which channel should be read
        spdif_tx_o      => spdif_tx_o);     -- SPDIF output signal

  -- internal registers access logic
  slv_reg_write_sel <= user_Bus2IP_WrCE(1 downto 0);
  slv_reg_read_sel  <= user_Bus2IP_RdCE(1 downto 0);
  slv_write_ack     <= user_Bus2IP_WrCE(0) or user_Bus2IP_WrCE(1);
  slv_read_ack      <= user_Bus2IP_RdCE(0) or user_Bus2IP_RdCE(1);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( ipif_Bus2IP_Clk ) is
  begin

    if ipif_Bus2IP_Clk'event and ipif_Bus2IP_Clk = '1' then
      if ipif_Bus2IP_Resetn = '0' then
        config_reg <= (others => '0');
        chstatus_reg <= (others => '0');
      else
        case slv_reg_write_sel is
          when "10" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( ipif_Bus2IP_BE(byte_index) = '1' ) then
                config_reg(byte_index*8+7 downto byte_index*8) <= ipif_Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "01" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( ipif_Bus2IP_BE(byte_index) = '1' ) then
                chstatus_reg(byte_index*8+7 downto byte_index*8) <= ipif_Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, config_reg, chstatus_reg) is
  begin

    case slv_reg_read_sel is
      when "10" => slv_user_IP2Bus_Data <= config_reg;
      when "01" => slv_user_IP2Bus_Data <= chstatus_reg;
      when others => slv_user_IP2Bus_Data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  user_IP2Bus_Data  <= slv_user_IP2Bus_Data when slv_read_ack = '1' else
                  (others => '0');

  user_IP2Bus_WrAck <= slv_write_ack;
  user_IP2Bus_RdAck <= slv_read_ack;
  user_IP2Bus_Error <= '0';

end IMP;
