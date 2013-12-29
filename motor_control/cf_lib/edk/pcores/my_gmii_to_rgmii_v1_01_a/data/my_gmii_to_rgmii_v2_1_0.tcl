###############################################################################
##
## (c) Copyright 1995-2011 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and 
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.
##
###############################################################################
##
## gmii_to_rgmii_v2_1_0.tcl
##
###############################################################################

proc generate_corelevel_ucf {mhsinst} {
  set filePath [xget_ncf_dir $mhsinst]
  file mkdir $filePath

  # specify file name
  set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
  set    name_lower [string   tolower   $instname]

  set    fileName   $name_lower
  append fileName   "_wrapper.ucf"
  append filePath   $fileName

  # Open a file for writing
  set outputFile [open $filePath "w"]
  
  # Get Device and Package
  set c_device  [xget_hw_proj_setting "fpga_xdevice"]
  set c_package [xget_hw_proj_setting "fpga_package"]

  # Get source for GMII clock
  set is_external_clock [xget_hw_parameter_value $mhsinst "C_EXTERNAL_CLOCK"]

  # Clock period constraints
  # Constraint for the 200 MHz clkin clock
  puts $outputFile "# Clock period constraints"
  puts $outputFile "NET \"clkin\" TNM_NET = \"clkin_$instname\";"
  puts $outputFile "TIMESPEC \"TS_clkin_${instname}\" = PERIOD \"clkin_$instname\" 5000 ps HIGH 50%;"
  
  # Constraint for the GMII clock. 
  # If its sourced externally then a constraint must be defined for it.
  # If its sourced interbally then there is no need to define a constraint as the constraints
  # specified for the 200 MHz "clkin" will propogate downstream.
  if { $is_external_clock == 1} {
    puts $outputFile "NET \"gmii_clk\" TNM_NET = \"gmii_clk_$instname\";"
    puts $outputFile "TIMESPEC \"TS_gmii_clk_${instname}\" = PERIOD \"gmii_clk_$instname\" 8000 ps HIGH 50%;"
  }      
 
  # Constraint for RGMII RX Clock
  puts $outputFile "NET \"rgmii_rxc\" TNM_NET = \"rgmii_rxc_$instname\";"
  puts $outputFile "TIMESPEC \"TS_rgmii_rxc_${instname}\" = PERIOD \"rgmii_rxc_$instname\" 8000 ps HIGH 50%;"

  # False path constrainst
  puts $outputFile "# False path constraints"
  puts $outputFile "# False path constraints to async inputs comming directly to synchronizer"
  puts $outputFile "NET \"*SYNC_MDC/DATA_IN\" TIG;"
  puts $outputFile "NET \"*SYNC_MDIO_IN/DATA_IN\" TIG;"
  puts $outputFile "NET \"*${instname}/tx_reset_async\" TIG;"
  puts $outputFile "NET \"*${instname}/rx_reset_async\" TIG;"
  puts $outputFile "# False path constraints for Control Register outputs"
  puts $outputFile "NET \"*MANAGEMENT_inst/SPEED_SELECTION_REG<?>\" TIG;"
  puts $outputFile "NET \"*MANAGEMENT_inst/DUPLEX_MODE_REG\" TIG;"
 
  #-----------------------------------------------------------
  # IO Placement                                             - 
  #-----------------------------------------------------------
  
  puts $outputFile "# IO Placement Constraints"
  # Following pin constraints are only for ZC702 board, Following constraints different from board to board
  #if { [string compare -nocase $c_device "xc7z020"] == 0 && [string compare -nocase $c_package "clg484"] == 0} {
  #  puts $outputFile "NET rgmii_tx_ctl   LOC = N20 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"   
  #  puts $outputFile "NET rgmii_txc      LOC = K19 | IOSTANDARD = LVCMOS18  | SLEW = FAST;" 
  #  puts $outputFile "NET rgmii_txd<0>   LOC = D20 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"
  #  puts $outputFile "NET rgmii_txd<1>   LOC = N19 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"
  #  puts $outputFile "NET rgmii_txd<2>   LOC = K20 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"
  #  puts $outputFile "NET rgmii_txd<3>   LOC = L21 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"

  #  puts $outputFile "NET rgmii_rx_ctl   LOC = J20 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "NET rgmii_rxc      LOC = M22 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "NET rgmii_rxd<0>   LOC = L22 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "NET rgmii_rxd<1>   LOC = M21 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "NET rgmii_rxd<2>   LOC = K21 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "NET rgmii_rxd<3>   LOC = N17 | IOSTANDARD = LVCMOS18;" 
  #  
  #  puts $outputFile "NET MDC            LOC = B19 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "NET MDIO           LOC = C20 | IOSTANDARD = LVCMOS18;" 
  #} else {
  #  puts $outputFile "These constraints have been designed for ZC7C020CLG484. Please modify accordingly for the selected device" 
  #  puts $outputFile "#NET rgmii_tx_ctl   LOC = N20 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"   
  #  puts $outputFile "#NET rgmii_txc      LOC = K19 | IOSTANDARD = LVCMOS18  | SLEW = FAST;" 
  #  puts $outputFile "#NET rgmii_txd<0>   LOC = D20 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"
  #  puts $outputFile "#NET rgmii_txd<1>   LOC = N19 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"
  #  puts $outputFile "#NET rgmii_txd<2>   LOC = K20 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"
  #  puts $outputFile "#NET rgmii_txd<3>   LOC = L21 | IOSTANDARD = LVCMOS18  | SLEW = FAST | DRIVE = 24;"

  #  puts $outputFile "#NET rgmii_rx_ctl   LOC = J20 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "#NET rgmii_rxc      LOC = M22 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "#NET rgmii_rxd<0>   LOC = L22 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "#NET rgmii_rxd<1>   LOC = M21 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "#NET rgmii_rxd<2>   LOC = K21 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "#NET rgmii_rxd<3>   LOC = N17 | IOSTANDARD = LVCMOS18;" 
  #  
  #  puts $outputFile "#NET MDC            LOC = B19 | IOSTANDARD = LVCMOS18;" 
  #  puts $outputFile "#NET MDIO           LOC = C20 | IOSTANDARD = LVCMOS18;" 
  #}

 #-----------------------------------------------------------
 # To Adjust GMII Rx Input Setup/Hold Timing                -
 #-----------------------------------------------------------
 puts $outputFile "# To Adjust GMII Rx Input Setup/Hold Timing"
 puts $outputFile "# Please modify as per design requirements"
 puts $outputFile "INST \"*delay_rgmii_rx_ctl\"       IDELAY_VALUE  =  16;"
 puts $outputFile "INST \"*delay_rgmii_rxd*\"         IDELAY_VALUE  =  16;"
 puts $outputFile "INST \"*delay_rgmii_rx_ctl\"       IODELAY_GROUP = \"grp1\";"
 puts $outputFile "INST \"*delay_rgmii_rxd*\"         IODELAY_GROUP = \"grp1\";"
 puts $outputFile "INST \"*dlyctrl\"                  IODELAY_GROUP = \"grp1\";"
 
 close $outputFile
}
