------------------------------------------------------------------------------
-- axi_i2s_adi.vhd - entity/architecture pair
------------------------------------------------------------------------------
-- IMPORTANT:
-- DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
--
-- SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
--
-- TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
-- PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
-- OF THE USER_LOGIC ENTITY.
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2011 Xilinx, Inc.	All rights reserved.						**
-- **																																			 **
-- ** Xilinx, Inc.																													**
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"				 **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND			 **
-- ** SOLUTIONS FOR XILINX DEVICES.	BY PROVIDING THIS DESIGN, CODE,				**
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,				**
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION					 **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,		 **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE			**
-- ** FOR YOUR IMPLEMENTATION.	XILINX EXPRESSLY DISCLAIMS ANY							**
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE							 **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR				**
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF			 **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS			 **
-- ** FOR A PARTICULAR PURPOSE.																						 **
-- **																																			 **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:					axi_i2s_adi.vhd
-- Version:					 1.00.a
-- Description:			 Top level design, instantiates library components and user logic.
-- Date:							Thu Apr 26 17:49:16 2012 (by Create and Import Peripheral Wizard)
-- VHDL Standard:		 VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--	 active low signals:										"*_n"
--	 clock signals:												 "clk", "clk_div#", "clk_#x"
--	 reset signals:												 "rst", "rst_n"
--	 generics:															"C_*"
--	 user defined types:										"*_TYPE"
--	 state machine next state:							"*_ns"
--	 state machine current state:					 "*_cs"
--	 combinatorial signals:								 "*_com"
--	 pipelined or register delay signals:	 "*_d#"
--	 counter signals:											 "*cnt*"
--	 clock enable signals:									"*_ce"
--	 internal version of output port:			 "*_i"
--	 device pins:													 "*_pin"
--	 ports:																 "- Names begin with Uppercase"
--	 processes:														 "*_PROCESS"
--	 component instantiations:							"<ENTITY_>I_<#|FUNC>"
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

library axi_i2s_adi_v1_00_a;
use axi_i2s_adi_v1_00_a.user_logic;

Library UNISIM;
use UNISIM.vcomponents.all;
------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--	 C_S_AXI_DATA_WIDTH					 -- 
--	 C_S_AXI_ADDR_WIDTH					 -- 
--	 C_S_AXI_MIN_SIZE						 -- 
--	 C_USE_WSTRB									-- 
--	 C_DPHASE_TIMEOUT						 -- 
--	 C_BASEADDR									 -- AXI4LITE slave: base address
--	 C_HIGHADDR									 -- AXI4LITE slave: high address
--	 C_FAMILY										 -- 
--	 C_NUM_REG										-- Number of software accessible registers
--	 C_NUM_MEM										-- Number of address-ranges
--	 C_SLV_AWIDTH								 -- Slave interface address bus width
--	 C_SLV_DWIDTH								 -- Slave interface data bus width
--
-- Definition of Ports:
--	 S_AXI_ACLK									 -- 
--	 S_AXI_ARESETN								-- 
--	 S_AXI_AWADDR								 -- 
--	 S_AXI_AWVALID								-- 
--	 S_AXI_WDATA									-- 
--	 S_AXI_WSTRB									-- 
--	 S_AXI_WVALID								 -- 
--	 S_AXI_BREADY								 -- 
--	 S_AXI_ARADDR								 -- 
--	 S_AXI_ARVALID								-- 
--	 S_AXI_RREADY								 -- 
--	 S_AXI_ARREADY								-- 
--	 S_AXI_RDATA									-- 
--	 S_AXI_RRESP									-- 
--	 S_AXI_RVALID								 -- 
--	 S_AXI_WREADY								 -- 
--	 S_AXI_BRESP									-- 
--	 S_AXI_BVALID								 -- 
--	 S_AXI_AWREADY								-- 
------------------------------------------------------------------------------

entity axi_i2s_adi is
	generic
	(
		-- ADD USER GENERICS BELOW THIS LINE ---------------
		C_DATA_WIDTH		: integer := 24;
		C_MSB_POS		: integer := 0;		-- MSB Position in the LRCLK frame (0 - MSB first, 1 - LSB first)
		C_FRM_SYNC		: integer := 0;		-- Frame sync type (0 - 50% Duty Cycle, 1 - Pulse mode)
		C_LRCLK_POL		: integer := 0;		-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_BCLK_POL		: integer := 0; 	-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
		-- ADD USER GENERICS ABOVE THIS LINE ---------------

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol parameters, do not add to or delete
		C_S_AXI_DATA_WIDTH	: integer			:= 32;
		C_S_AXI_ADDR_WIDTH	: integer			:= 32;
		C_S_AXI_MIN_SIZE	: std_logic_vector		:= X"000001FF";
		C_USE_WSTRB		: integer			:= 0;
		C_DPHASE_TIMEOUT	: integer			:= 8;
		C_BASEADDR		: std_logic_vector		:= X"FFFFFFFF";
		C_HIGHADDR		: std_logic_vector		:= X"00000000";
		C_FAMILY		: string			:= "virtex6";
		C_NUM_REG		: integer			:= 1;
		C_NUM_MEM		: integer			:= 1;
		C_SLV_AWIDTH		: integer			:= 32;
		C_SLV_DWIDTH		: integer			:= 32
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);
	port
	(
		-- ADD USER PORTS BELOW THIS LINE ------------------
		DATA_CLK_I		: in  std_logic;
		BCLK_O			: out std_logic;
		LRCLK_O			: out std_logic;
		SDATA_I			: in  std_logic;
		SDATA_O			: out std_logic;

		-- MEM_RD_O for debugging
		MEM_RD_O		: out std_logic;
		--

		ACLK			: in  std_logic;
		ARESETN			: in  std_logic;
		S_AXIS_TREADY		: out std_logic;
		S_AXIS_TDATA		: in  std_logic_vector(31 downto 0);
		S_AXIS_TLAST		: in  std_logic;
		S_AXIS_TVALID		: in  std_logic;

		M_AXIS_ACLK		: in  std_logic;
		M_AXIS_TREADY		: in  std_logic;
		M_AXIS_TDATA		: out std_logic_vector(31 downto 0);
		M_AXIS_TLAST		: out std_logic;
		M_AXIS_TVALID		: out std_logic;
		M_AXIS_TKEEP		: out std_logic_vector(3 downto 0);


		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add to or delete
		S_AXI_ACLK		: in  std_logic;
		S_AXI_ARESETN		: in  std_logic;
		S_AXI_AWADDR		: in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWVALID		: in  std_logic;
		S_AXI_WDATA		: in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB		: in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID		: in  std_logic;
		S_AXI_BREADY		: in  std_logic;
		S_AXI_ARADDR		: in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARVALID		: in  std_logic;
		S_AXI_RREADY		: in  std_logic;
		S_AXI_ARREADY		: out std_logic;
		S_AXI_RDATA		: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP		: out std_logic_vector(1 downto 0);
		S_AXI_RVALID		: out std_logic;
		S_AXI_WREADY		: out std_logic;
		S_AXI_BRESP		: out std_logic_vector(1 downto 0);
		S_AXI_BVALID		: out std_logic;
		S_AXI_AWREADY		: out std_logic
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);

	attribute MAX_FANOUT : string;
	attribute SIGIS : string;
	attribute SIGIS of ACLK : signal is "CLK";
	attribute MAX_FANOUT of S_AXI_ACLK : signal is "10000";
	attribute MAX_FANOUT of S_AXI_ARESETN : signal is "10000";
	attribute SIGIS of S_AXI_ACLK : signal is "Clk";
	attribute SIGIS of S_AXI_ARESETN : signal is "Rst";
end entity axi_i2s_adi;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_i2s_adi is

	constant USER_SLV_DWIDTH		: integer			:= C_S_AXI_DATA_WIDTH;

	constant IPIF_SLV_DWIDTH		: integer			:= C_S_AXI_DATA_WIDTH;

	constant ZERO_ADDR_PAD			: std_logic_vector(0 to 31)	:= (others => '0');
	constant USER_SLV_BASEADDR		: std_logic_vector		:= C_BASEADDR;
	constant USER_SLV_HIGHADDR		: std_logic_vector		:= C_HIGHADDR;

	constant IPIF_ARD_ADDR_RANGE_ARRAY	: SLV64_ARRAY_TYPE		:=
		(
			ZERO_ADDR_PAD & USER_SLV_BASEADDR,	-- user logic slave space base address
			ZERO_ADDR_PAD & USER_SLV_HIGHADDR	 -- user logic slave space high address
		);

	constant USER_SLV_NUM_REG		: integer			:= 12;
	constant USER_NUM_REG			: integer			:= USER_SLV_NUM_REG;
	constant TOTAL_IPIF_CE			: integer			:= USER_NUM_REG;

	constant IPIF_ARD_NUM_CE_ARRAY		: INTEGER_ARRAY_TYPE		:=
		(
			0	=> (USER_SLV_NUM_REG)						-- number of ce for user logic slave space
		);

	------------------------------------------
	-- Index for CS/CE
	------------------------------------------
	constant USER_SLV_CS_INDEX		: integer	:= 0;
	constant USER_SLV_CE_INDEX		: integer	:= calc_start_ce_index(IPIF_ARD_NUM_CE_ARRAY, USER_SLV_CS_INDEX);
	constant USER_CE_INDEX			: integer	:= USER_SLV_CE_INDEX;

	------------------------------------------
	-- IP Interconnect (IPIC) signal declarations
	------------------------------------------
	signal ipif_Bus2IP_Clk			: std_logic;
	signal ipif_Bus2IP_Resetn		: std_logic;
	signal ipif_Bus2IP_Addr			: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal ipif_Bus2IP_RNW			: std_logic;
	signal ipif_Bus2IP_BE			: std_logic_vector(IPIF_SLV_DWIDTH/8-1 downto 0);
	signal ipif_Bus2IP_CS			: std_logic_vector((IPIF_ARD_ADDR_RANGE_ARRAY'LENGTH)/2-1 downto 0);
	signal ipif_Bus2IP_RdCE			: std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
	signal ipif_Bus2IP_WrCE			: std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
	signal ipif_Bus2IP_Data			: std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
	signal ipif_IP2Bus_WrAck		: std_logic;
	signal ipif_IP2Bus_RdAck		: std_logic;
	signal ipif_IP2Bus_Error		: std_logic;
	signal ipif_IP2Bus_Data			: std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
	signal user_Bus2IP_RdCE			: std_logic_vector(USER_NUM_REG-1 downto 0);
	signal user_Bus2IP_WrCE			: std_logic_vector(USER_NUM_REG-1 downto 0);
	signal user_IP2Bus_Data			: std_logic_vector(USER_SLV_DWIDTH-1 downto 0);
	signal user_IP2Bus_RdAck		: std_logic;
	signal user_IP2Bus_WrAck		: std_logic;
	signal user_IP2Bus_Error		: std_logic;


	-- bufg
	signal LRCLK_BUFG_I			: std_logic;
	signal BCLK_BUFG_I			: std_logic;

begin

	------------------------------------------
	-- instantiate axi_lite_ipif
	------------------------------------------
	AXI_LITE_IPIF_I : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
	generic map
	(
		C_S_AXI_DATA_WIDTH		=> IPIF_SLV_DWIDTH,
		C_S_AXI_ADDR_WIDTH		=> C_S_AXI_ADDR_WIDTH,
		C_S_AXI_MIN_SIZE		=> C_S_AXI_MIN_SIZE,
		C_USE_WSTRB			=> C_USE_WSTRB,
		C_DPHASE_TIMEOUT		=> C_DPHASE_TIMEOUT,
		C_ARD_ADDR_RANGE_ARRAY		=> IPIF_ARD_ADDR_RANGE_ARRAY,
		C_ARD_NUM_CE_ARRAY		=> IPIF_ARD_NUM_CE_ARRAY,
		C_FAMILY			=> C_FAMILY
	)
	port map
	(
		S_AXI_ACLK			=> S_AXI_ACLK,
		S_AXI_ARESETN			=> S_AXI_ARESETN,
		S_AXI_AWADDR			=> S_AXI_AWADDR,
		S_AXI_AWVALID			=> S_AXI_AWVALID,
		S_AXI_WDATA			=> S_AXI_WDATA,
		S_AXI_WSTRB			=> S_AXI_WSTRB,
		S_AXI_WVALID			=> S_AXI_WVALID,
		S_AXI_BREADY			=> S_AXI_BREADY,
		S_AXI_ARADDR			=> S_AXI_ARADDR,
		S_AXI_ARVALID			=> S_AXI_ARVALID,
		S_AXI_RREADY			=> S_AXI_RREADY,
		S_AXI_ARREADY			=> S_AXI_ARREADY,
		S_AXI_RDATA			=> S_AXI_RDATA,
		S_AXI_RRESP			=> S_AXI_RRESP,
		S_AXI_RVALID			=> S_AXI_RVALID,
		S_AXI_WREADY			=> S_AXI_WREADY,
		S_AXI_BRESP			=> S_AXI_BRESP,
		S_AXI_BVALID			=> S_AXI_BVALID,
		S_AXI_AWREADY			=> S_AXI_AWREADY,
		Bus2IP_Clk			=> ipif_Bus2IP_Clk,
		Bus2IP_Resetn			=> ipif_Bus2IP_Resetn,
		Bus2IP_Addr			=> ipif_Bus2IP_Addr,
		Bus2IP_RNW			=> ipif_Bus2IP_RNW,
		Bus2IP_BE			=> ipif_Bus2IP_BE,
		Bus2IP_CS			=> ipif_Bus2IP_CS,
		Bus2IP_RdCE			=> ipif_Bus2IP_RdCE,
		Bus2IP_WrCE			=> ipif_Bus2IP_WrCE,
		Bus2IP_Data			=> ipif_Bus2IP_Data,
		IP2Bus_WrAck			=> ipif_IP2Bus_WrAck,
		IP2Bus_RdAck			=> ipif_IP2Bus_RdAck,
		IP2Bus_Error			=> ipif_IP2Bus_Error,
		IP2Bus_Data			=> ipif_IP2Bus_Data
	);


	------------------------------------------
	-- instantiate User Logic
	------------------------------------------
	USER_LOGIC_I : entity axi_i2s_adi_v1_00_a.user_logic
	generic map
	(
		C_MSB_POS		=> C_MSB_POS,
		C_FRM_SYNC		=> C_FRM_SYNC,
		C_LRCLK_POL		=> C_LRCLK_POL,
		C_BCLK_POL		=> C_BCLK_POL,
		-- MAP USER GENERICS ABOVE THIS LINE ---------------

		C_NUM_REG		=> USER_NUM_REG,
		C_SLV_DWIDTH		=> C_DATA_WIDTH
	)
	port map
	(
		DATA_CLK_I		=> DATA_CLK_I,
		-- MAP USER PORTS BELOW THIS LINE ------------------
		BCLK_O			=> BCLK_BUFG_I,
		LRCLK_O			=> LRCLK_BUFG_I,
		SDATA_I			=> SDATA_I,
		SDATA_O			=> SDATA_O,
		-- debug only
		MEM_RD_O		=> MEM_RD_O,
		--
		Bus2IP_Clk		=> ipif_Bus2IP_Clk,
		Bus2IP_Resetn		=> ipif_Bus2IP_Resetn,
		Bus2IP_Data		=> ipif_Bus2IP_Data,
		Bus2IP_BE		=> ipif_Bus2IP_BE,
		Bus2IP_RdCE		=> user_Bus2IP_RdCE,
		Bus2IP_WrCE		=> user_Bus2IP_WrCE,
		IP2Bus_Data		=> user_IP2Bus_Data,
		IP2Bus_RdAck		=> user_IP2Bus_RdAck,
		IP2Bus_WrAck		=> user_IP2Bus_WrAck,
		IP2Bus_Error		=> user_IP2Bus_Error,

		S_AXIS_ACLK		=> ACLK,
		S_AXIS_TREADY		=> S_AXIS_TREADY,
		S_AXIS_TDATA		=> S_AXIS_TDATA,
		S_AXIS_TLAST		=> S_AXIS_TLAST,
		S_AXIS_TVALID		=> S_AXIS_TVALID,

		M_AXIS_ACLK		=> M_AXIS_ACLK,
		M_AXIS_TREADY		=> M_AXIS_TREADY,
		M_AXIS_TDATA		=> M_AXIS_TDATA,
		M_AXIS_TLAST		=> M_AXIS_TLAST,
		M_AXIS_TVALID		=> M_AXIS_TVALID,
		M_AXIS_TKEEP		=> M_AXIS_TKEEP
	);

	----- bufg
	BUFG_inst_BCLK : BUFG
	port map (
		O => LRCLK_O, -- 1-bit Clock buffer output
		I => LRCLK_BUFG_I -- 1-bit Clock buffer input
	);

	BUFG_inst_LRCLK : BUFG
	port map (
		O => BCLK_O, -- 1-bit Clock buffer output
		I => BCLK_BUFG_I -- 1-bit Clock buffer input
	);
	------------------------------------------
	-- connect internal signals
	------------------------------------------
	ipif_IP2Bus_Data <= user_IP2Bus_Data;
	ipif_IP2Bus_WrAck <= user_IP2Bus_WrAck;
	ipif_IP2Bus_RdAck <= user_IP2Bus_RdAck;
	ipif_IP2Bus_Error <= user_IP2Bus_Error;

	user_Bus2IP_RdCE <= ipif_Bus2IP_RdCE(USER_NUM_REG-1 downto 0);
	user_Bus2IP_WrCE <= ipif_Bus2IP_WrCE(USER_NUM_REG-1 downto 0);

end IMP;
