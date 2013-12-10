------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Thu Dec 15 12:04:13 2011 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
library axi_spdif_rx_v1_00_a;
use axi_spdif_rx_v1_00_a.rx_package.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    DATA_WIDTH                     : integer              := 32;
    ADDR_WIDTH                     : integer              := 8;
    CH_ST_CAPTURE                  : integer              := 1;
    AXI_FREQ                       : natural              := 100;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 8;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    rx_int_o: out std_logic;
    spdif_rx_i: in std_logic;    
    spdif_rx_i_osc: out std_logic;
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
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
    M_AXIS_ACLK     : in	std_logic;
    M_AXIS_TREADY	: in	std_logic;
    M_AXIS_TDATA	: out	std_logic_vector(31 downto 0);
    M_AXIS_TLAST	: out	std_logic;
    M_AXIS_TVALID	: out	std_logic;
    M_AXIS_TKEEP    : out   std_logic_vector(3 downto 0)
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic
  signal data_out, ver_dout : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal ver_rd : std_logic;
  signal conf_rxen, conf_sample, evt_en, conf_chas, conf_valid : std_logic;
  signal conf_blken, conf_valen, conf_useren, conf_staten : std_logic;
  signal conf_paren, config_rd, config_wr : std_logic;
  signal conf_mode : std_logic_vector(3 downto 0);
  signal conf_bits, conf_dout : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal status_rd : std_logic;
  signal stat_dout: std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal imask_bits, imask_dout: std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal imask_rd, imask_wr : std_logic;
  signal istat_dout, istat_events: std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal istat_rd, istat_wr, istat_lock : std_logic;
  signal istat_lsbf, istat_hsbf, istat_paritya, istat_parityb: std_logic;
  signal istat_cap : std_logic_vector(7 downto 0);
  signal ch_st_cap_rd, ch_st_cap_wr, ch_st_data_rd: std_logic_vector(7 downto 0); 
  signal cap_dout : bus_array;
  signal ch_data, ud_a_en, ud_b_en, cs_a_en, cs_b_en: std_logic;
  signal mem_rd, sample_wr, sample_wr_d1 : std_logic;
  signal sample_din, sample_dout : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal sbuf_wr_adr, sbuf_rd_adr : std_logic_vector(ADDR_WIDTH - 2 downto 0);
  signal lock, rx_frame_start: std_logic;
  signal rx_data, rx_data_en, rx_block_start: std_logic;
  signal rx_channel_a, rx_error, lock_evt: std_logic;
  
  signal version_reg : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal control_reg : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal cap_reg     : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal chstatus_reg : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
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
  type RAM_TYPE is array (0 to (2**ADDR_WIDTH - 1)) of std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
  signal audio_fifo         : RAM_TYPE;
  signal audio_fifo_wr_addr    : std_logic_vector(ADDR_WIDTH - 1 downto 0);
  signal audio_fifo_rd_addr    : std_logic_vector(ADDR_WIDTH - 1 downto 0);
  signal tvalid                : std_logic := '0';
begin


-- Audio samples FIFO management
    AUDIO_FIFO_PROCESS : process (M_AXIS_ACLK) is
    variable data_cnt : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    begin        
        if M_AXIS_ACLK'event and M_AXIS_ACLK = '1' then
            if Bus2IP_Resetn = '0' then
                audio_fifo_wr_addr <= (others => '0');
                audio_fifo_rd_addr <= (others => '0');
                data_cnt := "00000000";
            else
            sample_wr_d1 <= sample_wr;
                if ((sample_wr_d1 = '0')and(sample_wr = '1')) then
                    audio_fifo(conv_integer(audio_fifo_wr_addr)) <= sample_din;
                    audio_fifo_wr_addr <= audio_fifo_wr_addr + '1';
                    if(data_cnt < (2**ADDR_WIDTH - 1)) then
                        data_cnt := data_cnt + '1';
                    end if;
                end if;
                if((tvalid = '1') and (M_AXIS_TREADY = '1'))
                then
                    audio_fifo_rd_addr <= audio_fifo_rd_addr + '1';
                    data_cnt := data_cnt - '1';
                end if;
                if(data_cnt > 0)
                then
                    tvalid <= '1';
                else 
                    tvalid <= '0';
                end if;
            end if;
        end if;
    end process AUDIO_FIFO_PROCESS;
    M_AXIS_TDATA <= audio_fifo(conv_integer(audio_fifo_rd_addr(ADDR_WIDTH-1 downto 0)));
    M_AXIS_TVALID <= tvalid;
    M_AXIS_TLAST  <= '0';
    M_AXIS_TKEEP  <= "1111";
    
  -- SPDIF registers update
  version_reg   <= slv_reg0;
  control_reg    <= slv_reg1;
  slv_reg2      <= chstatus_reg;
  cap_reg       <= slv_reg3;
  --USER logic implementation added here
  -------------------------------------------------------------------------------
  -- Version Register
  -------------------------------------------------------------------------------
  version_reg(31 downto 20) <= (others => '0');
  version_reg(19 downto 16) <= std_logic_vector(to_unsigned(CH_ST_CAPTURE, 4));
  version_reg(15 downto 12) <= (others => '0');
  version_reg(11 downto 5)  <= std_logic_vector(to_unsigned(ADDR_WIDTH,7));
  version_reg(4)            <= '1';
  version_reg(3 downto 0)   <= "0001";
  --------------------------------------------------------------------------------
  
  --------------------------------------------------------------------------------
  -- Control Register
  --------------------------------------------------------------------------------
  conf_mode(3 downto 0)     <= control_reg(23 downto 20);
  conf_paren                <= control_reg(19);
  conf_staten               <= control_reg(18);
  conf_useren               <= control_reg(17);
  conf_valen                <= control_reg(16);
  conf_blken                <= control_reg(5);
  conf_valid                <= control_reg(4);
  conf_chas                 <= control_reg(3);
  evt_en                    <= control_reg(2);
  conf_sample               <= control_reg(1);
  conf_rxen                 <= control_reg(0);
  --------------------------------------------------------------------------------
  
  --------------------------------------------------------------------------------
  -- Status Register
  --------------------------------------------------------------------------------
  STAT: rx_status_reg
    generic map 
    (
        DATA_WIDTH => DATA_WIDTH
    )
    port map 
    (
        up_clk          => Bus2IP_Clk,
        status_rd       => Bus2IP_RdCE(2),
        lock            => lock,
        chas            => conf_chas,
        rx_block_start  => rx_block_start,
        ch_data         => rx_data,
        cs_a_en         => cs_a_en,
        cs_b_en         => cs_b_en,
        status_dout     => chstatus_reg
    ); 
  --------------------------------------------------------------------------------
  
  --------------------------------------------------------------------------------
  -- Capture Register
  --------------------------------------------------------------------------------
  GCAP: if DATA_WIDTH = 32 and CH_ST_CAPTURE > 0 
  generate
      CAPR: for k in 0 to CH_ST_CAPTURE - 1 
      generate
          CHST: rx_cap_reg
          port map 
          (
              clk => Bus2IP_Clk,
              rst => Bus2IP_Resetn,
              --cap_ctrl_wr => ch_st_cap_wr(k),
              --cap_ctrl_rd => ch_st_cap_rd(k),
              --cap_data_rd => ch_st_data_rd(k),
              cap_reg => cap_reg,
              cap_din => Bus2IP_Data,
              cap_dout => cap_dout(k),
              cap_evt => istat_cap(k),
              rx_block_start => rx_block_start,
              ch_data => rx_data,
              ud_a_en => ud_a_en,
              ud_b_en => ud_b_en,
              cs_a_en => cs_a_en,
              cs_b_en => cs_b_en
          );
      end generate CAPR;
      -- unused capture registers set to zero
      UCAPR: if CH_ST_CAPTURE < 8 
      generate
          UC: for k in CH_ST_CAPTURE to 7 
          generate
            cap_dout(k) <= (others => '0');
          end generate UC;
      end generate UCAPR;
  end generate GCAP;
  --------------------------------------------------------------------------------
  
  --------------------------------------------------------------------------------
  -- Phase decoder
  --------------------------------------------------------------------------------
  PDET: rx_phase_det
    generic map 
    (
        AXI_FREQ => AXI_FREQ   -- WishBone frequency in MHz
    )
    port map 
    (
        up_clk => Bus2IP_Clk,
        rxen => conf_rxen,
        spdif => spdif_rx_i,
        lock => lock,
        lock_evt => lock_evt,
        rx_data => rx_data,
        rx_data_en => rx_data_en,
        rx_block_start => rx_block_start,
        rx_frame_start => rx_frame_start,
        rx_channel_a => rx_channel_a,
        rx_error => rx_error,
        ud_a_en => ud_a_en,
        ud_b_en => ud_b_en,
        cs_a_en => cs_a_en,
        cs_b_en => cs_b_en
    );
    spdif_rx_i_osc <= spdif_rx_i;
  --------------------------------------------------------------------------------
  
  --------------------------------------------------------------------------------
  -- Rx Decoder
  --------------------------------------------------------------------------------
  FDEC: rx_decode
    generic map 
    (
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map 
    (
        up_clk => Bus2IP_Clk,
        conf_rxen => conf_rxen,
        conf_sample => conf_sample,
        conf_valid => conf_valid,
        conf_mode => conf_mode,
        conf_blken => conf_blken,
        conf_valen => conf_valen,
        conf_useren => conf_useren,
        conf_staten => conf_staten, 
        conf_paren => conf_paren, 
        lock => lock,
        rx_data => rx_data,
        rx_data_en => rx_data_en,
        rx_block_start => rx_block_start,
        rx_frame_start => rx_frame_start, 
        rx_channel_a => rx_channel_a,
        wr_en => sample_wr,
        wr_addr => sbuf_wr_adr,
        wr_data => sample_din,
        stat_paritya => istat_paritya,
        stat_parityb => istat_parityb,
        stat_lsbf => istat_lsbf,
        stat_hsbf => istat_hsbf
    );
    rx_int_o <= sample_wr;
    
  --------------------------------------------------------------------------------
  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
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
        --slv_reg2 <= (others => '0');
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
          --when "00100000" =>
            --for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              --if ( Bus2IP_BE(byte_index) = '1' ) then
                --slv_reg2(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              --end if;
            --end loop;
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
