------------------------------------------------------------------------------
------------------------------------------------------------------------------
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

library axi_spdif_tx_v1_00_a;
use axi_spdif_tx_v1_00_a.tx_package.all;

entity user_logic is
  generic
  (
    C_NUM_REG                      : integer              := 8;
    C_SLV_DWIDTH                   : integer              := 32
  );
  port
  (
    --SPDIF interface
    spdif_data_clk                 : in std_logic;
    spdif_tx_o                     : out std_logic;
    spdif_tx_int_o                 : out std_logic;

    --AXI Lite interface
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    
    --AXI streaming interface
    S_AXIS_ACLK     : in	std_logic;
    S_AXIS_TREADY	: out	std_logic;
    S_AXIS_TDATA	: in	std_logic_vector(31 downto 0);
    S_AXIS_TLAST	: in	std_logic;
    S_AXIS_TVALID	: in	std_logic
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of S_AXIS_ACLK   : signal is "CLK";
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg1                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg2                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg3                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg4                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg5                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg6                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg7                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(7 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(7 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;
  
  ------------------------------------------
  -- SPDIF signals
  ------------------------------------------
  constant USER_DATA_BUF  : integer := 0;
  constant CH_STAT_BUF    : integer := 0;
  constant RAM_ADDR_WIDTH : integer := 7;
  
  signal config_reg    : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal chstatus_reg  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
 
  signal chstat_freq : std_logic_vector(1 downto 0);
  signal chstat_gstat, chstat_preem, chstat_copy, chstat_audio : std_logic;
  signal mem_rd, mem_rd_d1, ch_status_wr, user_data_wr : std_logic;
  signal sample_data: std_logic_vector(15 downto 0);
  signal conf_mode : std_logic_vector(3 downto 0);
  signal conf_ratio : std_logic_vector(7 downto 0);
  signal conf_udaten, conf_chsten : std_logic_vector(1 downto 0);
  signal conf_tinten, conf_txdata, conf_txen : std_logic;
  signal user_data_a, user_data_b : std_logic_vector(191 downto 0);
  signal ch_stat_a, ch_stat_b : std_logic_vector(191 downto 0);
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

-- Audio samples FIFO management
    S_AXIS_TREADY  <= '1' when audio_fifo_full = '0' else '0';
    AUDIO_FIFO_PROCESS : process (S_AXIS_ACLK) is
        variable audio_fifo_free_cnt : integer range 0 to 2**RAM_ADDR_WIDTH;
    begin        
        if S_AXIS_ACLK'event and S_AXIS_ACLK = '1' then
            if Bus2IP_Resetn = '0' or conf_txdata = '0' then
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
    config_reg    <= slv_reg0;
    chstatus_reg  <= slv_reg1;

-- Configuration signals update
    conf_mode(3 downto 0)  <= config_reg(23 downto 20);
    conf_ratio(7 downto 0) <= config_reg(15 downto 8);
    UD: if USER_DATA_BUF = 1 generate
      conf_udaten(1 downto 0) <= config_reg(7 downto 6);
    end generate UD;
    NUD: if USER_DATA_BUF = 0 generate
      conf_udaten(1 downto 0) <= "00";
    end generate NUD;
    CS: if CH_STAT_BUF = 1 generate
      conf_chsten(1 downto 0) <= config_reg(5 downto 4);
    end generate CS;
    NCS: if CH_STAT_BUF = 0 generate
      conf_chsten(1 downto 0) <= "00";
    end generate NCS;
    conf_tinten <= config_reg(2);
    conf_txdata <= config_reg(1);
    conf_txen   <= config_reg(0);

-- Channel status signals update
    chstat_freq(1 downto 0) <= chstatus_reg(7 downto 6);
    chstat_gstat <= chstatus_reg(3);
    chstat_preem <= chstatus_reg(2);
    chstat_copy <= chstatus_reg(1);
    chstat_audio <= chstatus_reg(0);
    
-- User data/ch. status register write strobes
    user_data_wr <= '0';--'1' when Bus2IP_WrCE(0) = '1' and
                  --conv_integer(Bus2IP_Addr(14 downto 10)) > 31 and
                  --conv_integer(Bus2IP_Addr(14 downto 10)) < 56 else '0';
                       
    ch_status_wr <= '0'; --'1' when Bus2IP_WrCE(0) = '1' and
                  --conv_integer(Bus2IP_Addr(14 downto 10)) > 63 and
                  --conv_integer(Bus2IP_Addr(14 downto 10)) < 88 else '0';
                  
-- UserData - byte buffer
    UDB: tx_bitbuf 
      generic map (ENABLE_BUFFER => USER_DATA_BUF) 
      port map (
        up_clk => Bus2IP_Clk,
        up_rstn => Bus2IP_Resetn,
        buf_wr => user_data_wr,
        up_addr => Bus2IP_Data(20 downto 16),
        up_wdata => Bus2IP_Data(15 downto 0),
        buf_data_a => user_data_a,
        buf_data_b => user_data_b);

-- ChStat - byte buffer
    CSB: tx_bitbuf 
      generic map (ENABLE_BUFFER => CH_STAT_BUF) 
      port map (
        up_clk => Bus2IP_Clk,
        up_rstn => Bus2IP_Resetn,
        buf_wr => ch_status_wr,
        up_addr => Bus2IP_Data(20 downto 16),
        up_wdata => Bus2IP_Data(15 downto 0),
        buf_data_a => ch_stat_a,
        buf_data_b => ch_stat_b);

-- Transmit encoder
    TENC: tx_encoder 	 
      generic map (DATA_WIDTH => 16) 
      port map (
        up_clk          => Bus2IP_Clk,
        data_clk        => spdif_data_clk,  -- data clock
        resetn          => Bus2IP_Resetn,   -- resetn
        conf_mode       => conf_mode,       -- sample format
        conf_ratio      => conf_ratio,      -- clock divider
        conf_udaten     => conf_udaten,     -- user data control
        conf_chsten     => conf_chsten,     -- ch. status control
        conf_txdata     => conf_txdata,     -- sample data enable
        conf_txen       => conf_txen,       -- spdif signal enable
        user_data_a     => user_data_a,     -- ch. a user data
        user_data_b     => user_data_b,     -- ch. b user data
        ch_stat_a       => ch_stat_a,       -- ch. a status
        ch_stat_b       => ch_stat_b,       -- ch. b status
        chstat_freq     => chstat_freq,     -- sample freq.
        chstat_gstat    => chstat_gstat,    -- generation status
        chstat_preem    => chstat_preem,    -- preemphasis status
        chstat_copy     => chstat_copy,     -- copyright bit
        chstat_audio    => chstat_audio,    -- data format
        sample_data     => sample_data,     -- audio data
        mem_rd          => mem_rd,          -- sample buffer read
        channel         => channel,         -- which channel should be read
        spdif_tx_o      => spdif_tx_o);     -- SPDIF output signal

 -- Interrupt generation
    spdif_tx_int_o <= '0';

  -- internal registers access logic
  slv_reg_write_sel <= Bus2IP_WrCE(7 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(7 downto 0);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Resetn = '0' then
        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
        slv_reg2 <= (others => '0');
        slv_reg3 <= (others => '0');
        slv_reg4 <= (others => '0');
        slv_reg5 <= (others => '0');
        slv_reg6 <= (others => '0');
        slv_reg7 <= (others => '0');
      else
        case slv_reg_write_sel is
          when "10000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "01000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg1(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00100000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg2(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00010000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg3(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00001000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg4(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg5(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg6(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "00000001" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg7(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7 ) is
  begin

    case slv_reg_read_sel is
      when "10000000" => slv_ip2bus_data <= slv_reg0;
      when "01000000" => slv_ip2bus_data <= slv_reg1;
      when "00100000" => slv_ip2bus_data <= slv_reg2;
      when "00010000" => slv_ip2bus_data <= slv_reg3;
      when "00001000" => slv_ip2bus_data <= slv_reg4;
      when "00000100" => slv_ip2bus_data <= slv_reg5;
      when "00000010" => slv_ip2bus_data <= slv_reg6;
      when "00000001" => slv_ip2bus_data <= slv_reg7;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  IP2Bus_Error <= '0';

end IMP;
