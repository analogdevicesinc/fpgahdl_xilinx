----------------------------------------------------------------------------------
-- Copyright 2014(c) Analog Devices, Inc.
--
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--  - Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
--  - Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in
--    the documentation and/or other materials provided with the
--    distribution.
--  - Neither the name of Analog Devices, Inc. nor the names of its
--    contributors may be used to endorse or promote products derived
--    from this software without specific prior written permission.
--  - The use of this software may or may not infringe the patent rights
--    of one or more patent holders.  This license does not release you
--    from the requirement that you obtain separate licenses from these
--    patent holders to use this software.
--  - Use of the software either in source or binary form, must be run
--    on or directly connected to an Analog Devices Inc. component.
--
-- THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED
-- WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY
-- AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
-- IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- -----------------------------------------------------------------------------
-- FILE NAME :  top.vhd
-- MODULE NAME : top
-- AUTHOR : acozma
-- AUTHOR'S EMAIL : andrei.cozma@analog.com
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
port
(
    CLK_IN              : in  std_logic;
    FMC_M_FAULT         : in  std_logic;
    FMC_PWM_EN          : out std_logic;
    FMC_PWM_AH          : out std_logic;
    FMC_PWM_AL          : out std_logic;
    FMC_PWM_BH          : out std_logic;
    FMC_PWM_BL          : out std_logic;
    FMC_PWM_CH          : out std_logic;
    FMC_PWM_CL          : out std_logic;
    FMC_M1_SENSOR       : in std_logic_vector(2 downto 0);
	FMC_IA_CLK    		: inout std_logic;
    FMC_IB_CLK    		: inout std_logic;
    FMC_IT_CLK    		: inout std_logic;    
	FMC_IA_DAT        	: in std_logic;
    FMC_IB_DAT        	: in std_logic;
    FMC_IT_DAT        	: in std_logic;	 
    FMC_VBUS_CLK     	: inout std_logic;
    FMC_VBUS_DAT        : in std_logic;
	GPO					: out std_logic_vector(10 downto 0);
	GPI					: in std_logic_vector(4 downto 0)
);
end top;

architecture Structural of top is

    signal ipif_Bus2IP_Resetn           : STD_LOGIC := '0';
    signal CLK_1MHZ                     : STD_LOGIC;
    signal CLK_IN_10MHZ                 : STD_LOGIC;
    signal CLK_IN_20MHZ                 : STD_LOGIC;
    signal CLK_IN_40MHZ                 : STD_LOGIC;
    signal CLK_IN_100MHZ                : STD_LOGIC;
    signal CONTROL0_s                   : STD_LOGIC_VECTOR(35 DOWNTO 0);
    signal CONTROL1_s                   : STD_LOGIC_VECTOR(35 DOWNTO 0);
    signal CONTROL2_s                   : STD_LOGIC_VECTOR(35 DOWNTO 0);
    signal vio_out_s                    : STD_LOGIC_VECTOR(255 DOWNTO 0);
    signal triga                        : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal trigb                        : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal run_motor_s                  : STD_LOGIC;
    signal star_delta_s                 : STD_LOGIC;
    signal dir_s                 		: STD_LOGIC;
	signal position_s                   : STD_LOGIC_VECTOR(2 downto 0);
    signal pwm_reg_s                    : STD_LOGIC_VECTOR(31 downto 0);
    signal pwm_sig_s                    : STD_LOGIC_VECTOR(31 downto 0);
    signal motor_speed_s                : STD_LOGIC_VECTOR(31 downto 0);
    signal new_motor_speed_s            : STD_LOGIC;
    signal current_sense_ia_data_ready_s: STD_LOGIC;
    signal current_sense_ib_data_ready_s: STD_LOGIC;
    signal current_sense_it_data_ready_s: STD_LOGIC;
	
    signal current_sense_ia_drv_data_ready_s: STD_LOGIC;
    signal current_sense_ib_drv_data_ready_s: STD_LOGIC;
    signal current_sense_it_drv_data_ready_s: STD_LOGIC;
	
    signal current_sense_vb_data_ready_s: STD_LOGIC;
    signal current_sense_ia_s           : STD_LOGIC_VECTOR(31 downto 0);
    signal current_sense_ib_s           : STD_LOGIC_VECTOR(31 downto 0);
    signal current_sense_it_s           : STD_LOGIC_VECTOR(31 downto 0);
    signal current_sense_vb_s           : STD_LOGIC_VECTOR(31 downto 0);
    signal current_sense_ia_drv_s       : STD_LOGIC_VECTOR(31 downto 0);
    signal current_sense_ib_drv_s       : STD_LOGIC_VECTOR(31 downto 0);
    signal current_sense_it_drv_s       : STD_LOGIC_VECTOR(31 downto 0);	

    signal motor_in_a_s                 : STD_LOGIC;
    signal motor_in_b_s                 : STD_LOGIC;
    signal motor_in_c_s                 : STD_LOGIC;
    signal motor_en_a_s                 : STD_LOGIC;
    signal motor_en_b_s                 : STD_LOGIC;
    signal motor_en_c_s                 : STD_LOGIC;
    signal motor_sensor_s               : STD_LOGIC_VECTOR(2 downto 0);
   
    signal motor_clockout_ia_s          : STD_LOGIC;
    signal motor_clockout_ib_s          : STD_LOGIC;
    signal motor_clockout_it_s          : STD_LOGIC;
    signal motor_ds_ia_s                : STD_LOGIC;
    signal motor_ds_ib_s                : STD_LOGIC;
    signal motor_ds_it_s                : STD_LOGIC;
	signal motor_clockout_ia_drv_s      : STD_LOGIC;
    signal motor_clockout_ib_drv_s      : STD_LOGIC;
    signal motor_clockout_it_drv_s      : STD_LOGIC;
    signal motor_ds_ia_drv_s            : STD_LOGIC;
    signal motor_ds_ib_drv_s            : STD_LOGIC;
    signal motor_ds_it_drv_s            : STD_LOGIC;

    component chipscope_icon
    PORT (
        CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
        CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
        CONTROL2 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
    end component;

    component chipscope_vio
    PORT (
		CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		CLK : IN STD_LOGIC;
		SYNC_OUT : OUT STD_LOGIC_VECTOR(255 DOWNTO 0));
    end component;

    component chipscope_ila
    PORT (
		CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		CLK : IN STD_LOGIC;
		DATA : IN STD_LOGIC_VECTOR(223 DOWNTO 0);
		TRIG0 : IN STD_LOGIC_VECTOR(0 TO 0));
    end component;

    component chipscope_ila2
    PORT (
		CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		CLK     : IN STD_LOGIC;
		DATA    : IN STD_LOGIC_VECTOR(34 DOWNTO 0);
		TRIG0   : IN STD_LOGIC_VECTOR(0 TO 0));
    end component;
	
    component clock_gen
    port
     (-- Clock in ports
      CLK_IN1           : in     std_logic;
      CLK_OUT1          : out    std_logic;
      CLK_OUT2          : out    std_logic;
      CLK_OUT3          : out    std_logic;
      CLK_OUT4          : out    std_logic;
      -- Status and control signals
      RESET             : in     std_logic
     );
    end component;

    component motor_driver is
    generic
    (
        PWM_BITS : integer := 11
    );
    port
    (
        clk_i       : in std_logic;
        pwm_clk_i   : in std_logic;
        rst_n_i     : in std_logic;
        run_i       : in std_logic;
        star_delta_i: in std_logic;
		dir_i		: in std_logic;
        position_i  : in std_logic_vector(2 downto 0);
        pwm_duty_i  : in std_logic_vector(PWM_BITS-1 downto 0);
        AH_o      : out std_logic;
        BH_o      : out std_logic;
        CH_o      : out std_logic;
        AL_o      : out std_logic;
        BL_o      : out std_logic;
        CL_o      : out std_logic
    );
    end component;

    component debouncer is
    generic
    (
        DEBOUNCER_LEN : integer := 4
    );
    port
    (
        clk_i   : in std_logic;
        rst_n_i : in std_logic;
        sig_i   : in std_logic;
        sig_o   : out std_logic
    );
    end component;

    component freq_divider is
         generic
    (
        DIVIDE_BY : integer := 10
    );
    port
    (
        clk_i       : in std_logic;
        rst_n_i     : in std_logic;
        clk_o       : out std_logic
    );
    end component;

    component speed_detector is
    generic
    (
        AVERAGE_WINDOW   : integer := 32;
        LOG_2_AW         : integer := 5;
        SAMPLE_CLK_DECIM : integer := 10000
    );
    port
    (
        clk_i       : in std_logic;
        rst_n_i     : in std_logic;
        position_i  : in std_logic_vector(2 downto 0);
        new_speed_o : out std_logic;
        speed_o     : out std_logic_vector(31 downto 0)
    );
    end component;

    component ad7401_c2 is
    port
   (
        fpga_clk_i      : in std_logic;
        adc_clk_i       : in std_logic;
        reset_n_i       : in std_logic;
        data_o          : out std_logic_vector(31 downto 0);
        data_rd_ready_o : out std_logic;
        adc_mdata_i     : in std_logic;
        adc_mclkin_o    : out std_logic
    );
    end component;

    component current_sensor_c2 is
    port
    (
        fpga_clk_i      : in std_logic;
        reset_n_i       : in std_logic;
        data_o          : out std_logic_vector(31 downto 0);
        data_rd_ready_o : out std_logic;
        adc_mdata_i     : in std_logic;
        adc_mclkout_i   : in std_logic
    );
    end component;

begin
    ipif_Bus2IP_Resetn          <= '1' after 100ns;

    triga(0)                    <= new_motor_speed_s;
    trigb(0)                    <= current_sense_ia_data_ready_s;

    pwm_reg_s                   <= vio_out_s(31 downto 0);
    run_motor_s                 <= vio_out_s(32);
    star_delta_s                <= vio_out_s(33);
	dir_s						<= vio_out_s(34);
	GPO(10 downto 7)			<= vio_out_s(38 downto 35);
	GPO(3 downto 0)				<= vio_out_s(42 downto 39);

    pwm_sig_s <= pwm_reg_s;

    chipscope_icon_i1 : chipscope_icon
    port map 
    (
        CONTROL0 => CONTROL0_s,
        CONTROL1 => CONTROL1_s,
        CONTROL2 => CONTROL2_s
    );

    chipscope_vio_i1 : chipscope_vio
    port map 
    (
        CONTROL => CONTROL0_s,
        CLK => CLK_IN_100MHZ,
        SYNC_OUT => vio_out_s
	);

    chipscope_ila_i1 : chipscope_ila
    port map 
    (
        CONTROL => CONTROL1_s,
        CLK => CLK_IN_100MHZ,
        DATA =>  current_sense_ia_drv_s & current_sense_ib_drv_s & current_sense_it_drv_s & current_sense_ia_s & current_sense_ib_s & current_sense_it_s & current_sense_vb_s,
        TRIG0 => trigb
	);

	chipscope_ila_i2 : chipscope_ila2
	port map 
	(
		CONTROL => CONTROL2_s,
		CLK => CLK_IN_100MHZ,
		DATA => position_s & motor_speed_s,
		TRIG0 => triga
	);

    clock_gen_i1 : clock_gen
    port map
    (-- Clock in ports
        CLK_IN1 => CLK_IN,
        CLK_OUT1 => CLK_IN_10MHZ,
        CLK_OUT2 => CLK_IN_20MHZ,
        CLK_OUT3 => CLK_IN_40MHZ,
        CLK_OUT4 => CLK_IN_100MHZ,
    -- Status and control signals
        RESET  => not ipif_Bus2IP_Resetn
    );

    motor_driver_i1 : motor_driver
    generic map
    (
        PWM_BITS => 11
    )
    port map
    (
        clk_i       => CLK_IN_10MHZ,
        pwm_clk_i   => CLK_IN_40MHZ,
        rst_n_i     => ipif_Bus2IP_Resetn,
        run_i       => run_motor_s,
        star_delta_i=> star_delta_s,
        dir_i		=> dir_s,
		position_i  => position_s,
        pwm_duty_i  => pwm_sig_s(10 downto 0),
        AH_o      => motor_in_a_s,
        BH_o      => motor_in_b_s,
        CH_o      => motor_in_c_s,
        AL_o      => motor_en_a_s,
        BL_o      => motor_en_b_s,
        CL_o      => motor_en_c_s
    );

    debouncer_i1 : debouncer
    generic map
    (
        DEBOUNCER_LEN => 4
    )
    port map
    (
        clk_i   => CLK_1MHZ,
        rst_n_i => ipif_Bus2IP_Resetn,
        sig_i   => motor_sensor_s(0),
        sig_o   => position_s(0)
    );

    debouncer_i2 : debouncer
    generic map
    (
        DEBOUNCER_LEN => 4
    )
    port map
    (
        clk_i   => CLK_1MHZ,
        rst_n_i => ipif_Bus2IP_Resetn,
        sig_i   => motor_sensor_s(1),
        sig_o   => position_s(1)
    );

    debouncer_i3 : debouncer
    generic map
    (
        DEBOUNCER_LEN => 4
    )
    port map
    (
        clk_i   => CLK_1MHZ,
        rst_n_i => ipif_Bus2IP_Resetn,
        sig_i   => motor_sensor_s(2),
        sig_o   => position_s(2)
    );

    freq_divider_i1: freq_divider
    generic map
    (
        DIVIDE_BY => 10
    )
    port map
    (
        clk_i       => CLK_IN_10MHZ,
        rst_n_i     => ipif_Bus2IP_Resetn,
        clk_o       => CLK_1MHZ
    );

    speed_detector_i1 : speed_detector
    generic map
    (
        AVERAGE_WINDOW      => 256,
        LOG_2_AW            => 8,
        SAMPLE_CLK_DECIM    => 5000
    )
    port map
    (
        clk_i       => CLK_IN_10MHZ,
        rst_n_i     => ipif_Bus2IP_Resetn,
        position_i  => position_s,
        new_speed_o => new_motor_speed_s,
        speed_o     => motor_speed_s
    );


	current_sensor_ia: ad7401_c2
	port map
	(
		fpga_clk_i      => CLK_IN_10MHZ,
		adc_clk_i       => CLK_IN_10MHZ,
		reset_n_i       => ipif_Bus2IP_Resetn,
		data_o          => current_sense_ia_s,
		data_rd_ready_o => current_sense_ia_data_ready_s,
		adc_mdata_i     => motor_ds_ia_s,
		adc_mclkin_o    => motor_clockout_ia_s
	);

	current_sensor_ib: ad7401_c2
	port map
	(
		fpga_clk_i      => CLK_IN_10MHZ,
		adc_clk_i       => CLK_IN_10MHZ,
		reset_n_i       => ipif_Bus2IP_Resetn,
		data_o          => current_sense_ib_s,
		data_rd_ready_o => current_sense_ib_data_ready_s,
		adc_mdata_i     => motor_ds_ib_s,
		adc_mclkin_o    => motor_clockout_ib_s
	);
	current_sensor_it: ad7401_c2
	port map
	(
		fpga_clk_i      => CLK_IN_10MHZ,
		adc_clk_i       => CLK_IN_10MHZ,
		reset_n_i       => ipif_Bus2IP_Resetn,
		data_o          => current_sense_it_s,
		data_rd_ready_o => current_sense_it_data_ready_s,
		adc_mdata_i     => motor_ds_it_s,
		adc_mclkin_o    => motor_clockout_it_s
	);

	current_sensor_vb: ad7401_c2
	port map
	(
		fpga_clk_i      => CLK_IN_10MHZ,
		adc_clk_i       => CLK_IN_10MHZ,
		reset_n_i       => ipif_Bus2IP_Resetn,
		data_o          => current_sense_vb_s,
		data_rd_ready_o => current_sense_vb_data_ready_s,
		adc_mdata_i     => FMC_VBUS_DAT,
		adc_mclkin_o    => FMC_VBUS_CLK
	);
	FMC_IA_CLK <= motor_clockout_ia_s;
	FMC_IB_CLK <= motor_clockout_ib_s;
	FMC_IT_CLK <= motor_clockout_it_s;
	  
	current_sensor_ia_drv: ad7401_c2
	port map
	(
		fpga_clk_i      => CLK_IN_10MHZ,
		adc_clk_i       => CLK_IN_10MHZ,
		reset_n_i       => ipif_Bus2IP_Resetn,
		data_o          => current_sense_ia_drv_s,
		data_rd_ready_o => current_sense_ia_drv_data_ready_s,
		adc_mdata_i     => motor_ds_ia_drv_s,
		adc_mclkin_o    => motor_clockout_ia_drv_s
	);

	current_sensor_ib_drv: ad7401_c2
	port map
	(
		fpga_clk_i      => CLK_IN_10MHZ,
		adc_clk_i       => CLK_IN_10MHZ,
		reset_n_i       => ipif_Bus2IP_Resetn,
		data_o          => current_sense_ib_drv_s,
		data_rd_ready_o => current_sense_ib_drv_data_ready_s,
		adc_mdata_i     => motor_ds_ib_drv_s,
		adc_mclkin_o    => motor_clockout_ib_drv_s
	);
	current_sensor_it_drv: ad7401_c2
	port map
	(
		fpga_clk_i      => CLK_IN_10MHZ,
		adc_clk_i       => CLK_IN_10MHZ,
		reset_n_i       => ipif_Bus2IP_Resetn,
		data_o          => current_sense_it_drv_s,
		data_rd_ready_o => current_sense_it_drv_data_ready_s,
		adc_mdata_i     => motor_ds_it_drv_s,
		adc_mclkin_o    => motor_clockout_it_drv_s
	);
	  
	GPO(4) <= motor_clockout_ia_drv_s;
	GPO(5) <= motor_clockout_ib_drv_s;
	GPO(6) <= motor_clockout_it_drv_s;
		  

    FMC_PWM_AH         <= motor_in_a_s;
    FMC_PWM_BH         <= motor_in_b_s;
    FMC_PWM_CH         <= motor_in_c_s;
    
	FMC_PWM_AL         <= motor_en_a_s;
    FMC_PWM_BL         <= motor_en_b_s;
    FMC_PWM_CL         <= motor_en_c_s;

	FMC_PWM_EN          <= run_motor_s;
	
    motor_ds_ia_s       <= FMC_IA_DAT;
    motor_ds_ib_s       <= FMC_IB_DAT;
    motor_ds_it_s       <= FMC_IT_DAT;
	 
	motor_ds_ia_drv_s       <= GPI(2);
    motor_ds_ib_drv_s       <= GPI(3);
    motor_ds_it_drv_s       <= GPI(4);
	
    motor_sensor_s      <= FMC_M1_SENSOR;
	
end Structural;

