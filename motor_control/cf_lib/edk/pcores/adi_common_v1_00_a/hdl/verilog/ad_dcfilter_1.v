////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.49d
//  \   \         Application: netgen
//  /   /         Filename: ad_dcfilter_1.v
// /___/   /\     Timestamp: Thu Jun 06 11:12:40 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog ./tmp/_cg/ad_dcfilter_1.ngc ./tmp/_cg/ad_dcfilter_1.v 
// Device	: 6vlx240tff1156-1
// Input file	: ./tmp/_cg/ad_dcfilter_1.ngc
// Output file	: ./tmp/_cg/ad_dcfilter_1.v
// # of Modules	: 1
// Design Name	: ad_dcfilter_1
// Xilinx        : C:\Xilinx\14.4\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module ad_dcfilter_1 (
  clk, a, b, c, d, p
)/* synthesis syn_black_box syn_noprune=1 */;
  input clk;
  input [15 : 0] a;
  input [15 : 0] b;
  input [15 : 0] c;
  input [15 : 0] d;
  output [32 : 0] p;
  
  // synthesis translate_off
  
  wire \BU2/N1 ;
  wire \BU2/N0 ;
  wire \BU2/carrycascout ;
  wire \BU2/carryout ;
  wire \BU2/carrycascin ;
  wire NLW_VCC_P_UNCONNECTED;
  wire NLW_GND_G_UNCONNECTED;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_UNDERFLOW_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_OVERFLOW_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_CARRYOUT<2>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_CARRYOUT<1>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_CARRYOUT<0>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<47>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<46>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<45>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<44>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<43>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<42>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<41>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<40>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<39>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<38>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<37>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<36>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<35>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<34>_UNCONNECTED ;
  wire \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<33>_UNCONNECTED ;
  wire [15 : 0] a_2;
  wire [15 : 0] b_3;
  wire [15 : 0] c_4;
  wire [15 : 0] d_5;
  wire [32 : 0] p_6;
  wire [15 : 0] \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q ;
  wire [47 : 0] \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q ;
  wire [47 : 0] \BU2/pcout ;
  wire [17 : 0] \BU2/bcout ;
  wire [29 : 0] \BU2/acout ;
  wire [17 : 0] \BU2/bcin ;
  wire [29 : 0] \BU2/acin ;
  wire [47 : 0] \BU2/pcin ;
  assign
    a_2[15] = a[15],
    a_2[14] = a[14],
    a_2[13] = a[13],
    a_2[12] = a[12],
    a_2[11] = a[11],
    a_2[10] = a[10],
    a_2[9] = a[9],
    a_2[8] = a[8],
    a_2[7] = a[7],
    a_2[6] = a[6],
    a_2[5] = a[5],
    a_2[4] = a[4],
    a_2[3] = a[3],
    a_2[2] = a[2],
    a_2[1] = a[1],
    a_2[0] = a[0],
    b_3[15] = b[15],
    b_3[14] = b[14],
    b_3[13] = b[13],
    b_3[12] = b[12],
    b_3[11] = b[11],
    b_3[10] = b[10],
    b_3[9] = b[9],
    b_3[8] = b[8],
    b_3[7] = b[7],
    b_3[6] = b[6],
    b_3[5] = b[5],
    b_3[4] = b[4],
    b_3[3] = b[3],
    b_3[2] = b[2],
    b_3[1] = b[1],
    b_3[0] = b[0],
    c_4[15] = c[15],
    c_4[14] = c[14],
    c_4[13] = c[13],
    c_4[12] = c[12],
    c_4[11] = c[11],
    c_4[10] = c[10],
    c_4[9] = c[9],
    c_4[8] = c[8],
    c_4[7] = c[7],
    c_4[6] = c[6],
    c_4[5] = c[5],
    c_4[4] = c[4],
    c_4[3] = c[3],
    c_4[2] = c[2],
    c_4[1] = c[1],
    c_4[0] = c[0],
    d_5[15] = d[15],
    d_5[14] = d[14],
    d_5[13] = d[13],
    d_5[12] = d[12],
    d_5[11] = d[11],
    d_5[10] = d[10],
    d_5[9] = d[9],
    d_5[8] = d[8],
    d_5[7] = d[7],
    d_5[6] = d[6],
    d_5[5] = d[5],
    d_5[4] = d[4],
    d_5[3] = d[3],
    d_5[2] = d[2],
    d_5[1] = d[1],
    d_5[0] = d[0],
    p[32] = p_6[32],
    p[31] = p_6[31],
    p[30] = p_6[30],
    p[29] = p_6[29],
    p[28] = p_6[28],
    p[27] = p_6[27],
    p[26] = p_6[26],
    p[25] = p_6[25],
    p[24] = p_6[24],
    p[23] = p_6[23],
    p[22] = p_6[22],
    p[21] = p_6[21],
    p[20] = p_6[20],
    p[19] = p_6[19],
    p[18] = p_6[18],
    p[17] = p_6[17],
    p[16] = p_6[16],
    p[15] = p_6[15],
    p[14] = p_6[14],
    p[13] = p_6[13],
    p[12] = p_6[12],
    p[11] = p_6[11],
    p[10] = p_6[10],
    p[9] = p_6[9],
    p[8] = p_6[8],
    p[7] = p_6[7],
    p[6] = p_6[6],
    p[5] = p_6[5],
    p[4] = p_6[4],
    p[3] = p_6[3],
    p[2] = p_6[2],
    p[1] = p_6[1],
    p[0] = p_6[0];
  VCC   VCC_0 (
    .P(NLW_VCC_P_UNCONNECTED)
  );
  GND   GND_1 (
    .G(NLW_GND_G_UNCONNECTED)
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_0  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [0]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_1  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [1]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [1])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_2  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [2]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [2])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_3  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [3]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [3])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_4  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [4]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [4])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_5  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [5]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [5])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_6  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [6]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [6])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_7  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [7]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [7])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_8  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [8]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [8])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_9  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [9]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [9])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_10  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [10]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [10])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_11  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [11]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [11])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_12  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [12]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [12])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_13  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [13]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [13])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_14  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [14]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [14])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_15  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [15])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_16  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [16])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_17  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [17])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_18  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [18])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_19  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [19])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_20  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [20])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_21  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [21])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_22  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [22])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_23  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [23])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_24  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [24])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_25  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [25])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_26  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [26])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_27  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [27])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_28  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [28])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_29  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [29])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_30  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [30])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_31  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [31])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_32  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [32])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_33  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [33])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_34  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [34])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_35  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [35])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_36  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [36])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_37  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [37])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_38  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [38])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_39  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [39])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_40  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [40])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_41  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [41])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_42  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [42])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_43  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [43])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_44  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [44])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_45  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [45])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_46  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [46])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q_47  (
    .C(clk),
    .D(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [47])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_0  (
    .C(clk),
    .D(c_4[0]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_1  (
    .C(clk),
    .D(c_4[1]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [1])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_2  (
    .C(clk),
    .D(c_4[2]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [2])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_3  (
    .C(clk),
    .D(c_4[3]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [3])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_4  (
    .C(clk),
    .D(c_4[4]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [4])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_5  (
    .C(clk),
    .D(c_4[5]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [5])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_6  (
    .C(clk),
    .D(c_4[6]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [6])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_7  (
    .C(clk),
    .D(c_4[7]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [7])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_8  (
    .C(clk),
    .D(c_4[8]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [8])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_9  (
    .C(clk),
    .D(c_4[9]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [9])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_10  (
    .C(clk),
    .D(c_4[10]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [10])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_11  (
    .C(clk),
    .D(c_4[11]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [11])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_12  (
    .C(clk),
    .D(c_4[12]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [12])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_13  (
    .C(clk),
    .D(c_4[13]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [13])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_14  (
    .C(clk),
    .D(c_4[14]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [14])
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q_15  (
    .C(clk),
    .D(c_4[15]),
    .Q(\BU2/U0/i_synth_option.i_synth_model/i_has_c.i_c123/opt_has_pipe.first_q [15])
  );
  DSP48E1 #(
    .ACASCREG ( 1 ),
    .ADREG ( 1 ),
    .ALUMODEREG ( 0 ),
    .AREG ( 1 ),
    .AUTORESET_PATDET ( "NO_RESET" ),
    .A_INPUT ( "DIRECT" ),
    .BCASCREG ( 1 ),
    .BREG ( 1 ),
    .B_INPUT ( "DIRECT" ),
    .CARRYINREG ( 0 ),
    .CARRYINSELREG ( 0 ),
    .CREG ( 1 ),
    .DREG ( 0 ),
    .INMODEREG ( 0 ),
    .MASK ( 48'h3FFFFFFFFFFF ),
    .MREG ( 1 ),
    .OPMODEREG ( 0 ),
    .PATTERN ( 48'h000000000000 ),
    .PREG ( 0 ),
    .SEL_MASK ( "MASK" ),
    .SEL_PATTERN ( "PATTERN" ),
    .USE_DPORT ( "TRUE" ),
    .USE_MULT ( "MULTIPLY" ),
    .USE_PATTERN_DETECT ( "NO_PATDET" ),
    .USE_SIMD ( "ONE48" ))
  \BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive  (
    .PATTERNBDETECT(\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_PATTERNBDETECT_UNCONNECTED ),
    .RSTC(\BU2/N0 ),
    .CEB1(\BU2/N0 ),
    .CEAD(\BU2/N1 ),
    .MULTSIGNOUT(\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_MULTSIGNOUT_UNCONNECTED ),
    .CEC(\BU2/N1 ),
    .RSTM(\BU2/N0 ),
    .MULTSIGNIN(\BU2/N0 ),
    .CEB2(\BU2/N1 ),
    .RSTCTRL(\BU2/N0 ),
    .CEP(\BU2/N0 ),
    .CARRYCASCOUT(\BU2/carrycascout ),
    .RSTA(\BU2/N0 ),
    .CECARRYIN(\BU2/N0 ),
    .UNDERFLOW(\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_UNDERFLOW_UNCONNECTED ),
    .PATTERNDETECT(\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_PATTERNDETECT_UNCONNECTED ),
    .RSTALUMODE(\BU2/N0 ),
    .RSTALLCARRYIN(\BU2/N0 ),
    .CED(\BU2/N1 ),
    .RSTD(\BU2/N0 ),
    .CEALUMODE(\BU2/N0 ),
    .CEA2(\BU2/N1 ),
    .CLK(clk),
    .CEA1(\BU2/N0 ),
    .RSTB(\BU2/N0 ),
    .OVERFLOW(\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_OVERFLOW_UNCONNECTED ),
    .CECTRL(\BU2/N0 ),
    .CEM(\BU2/N1 ),
    .CARRYIN(\BU2/N0 ),
    .CARRYCASCIN(\BU2/carrycascin ),
    .RSTINMODE(\BU2/N0 ),
    .CEINMODE(\BU2/N0 ),
    .RSTP(\BU2/N0 ),
    .ACOUT({\BU2/acout [29], \BU2/acout [28], \BU2/acout [27], \BU2/acout [26], \BU2/acout [25], \BU2/acout [24], \BU2/acout [23], \BU2/acout [22], 
\BU2/acout [21], \BU2/acout [20], \BU2/acout [19], \BU2/acout [18], \BU2/acout [17], \BU2/acout [16], \BU2/acout [15], \BU2/acout [14], 
\BU2/acout [13], \BU2/acout [12], \BU2/acout [11], \BU2/acout [10], \BU2/acout [9], \BU2/acout [8], \BU2/acout [7], \BU2/acout [6], \BU2/acout [5], 
\BU2/acout [4], \BU2/acout [3], \BU2/acout [2], \BU2/acout [1], \BU2/acout [0]}),
    .OPMODE({\BU2/N0 , \BU2/N1 , \BU2/N1 , \BU2/N0 , \BU2/N1 , \BU2/N0 , \BU2/N1 }),
    .PCIN({\BU2/pcin [47], \BU2/pcin [46], \BU2/pcin [45], \BU2/pcin [44], \BU2/pcin [43], \BU2/pcin [42], \BU2/pcin [41], \BU2/pcin [40], 
\BU2/pcin [39], \BU2/pcin [38], \BU2/pcin [37], \BU2/pcin [36], \BU2/pcin [35], \BU2/pcin [34], \BU2/pcin [33], \BU2/pcin [32], \BU2/pcin [31], 
\BU2/pcin [30], \BU2/pcin [29], \BU2/pcin [28], \BU2/pcin [27], \BU2/pcin [26], \BU2/pcin [25], \BU2/pcin [24], \BU2/pcin [23], \BU2/pcin [22], 
\BU2/pcin [21], \BU2/pcin [20], \BU2/pcin [19], \BU2/pcin [18], \BU2/pcin [17], \BU2/pcin [16], \BU2/pcin [15], \BU2/pcin [14], \BU2/pcin [13], 
\BU2/pcin [12], \BU2/pcin [11], \BU2/pcin [10], \BU2/pcin [9], \BU2/pcin [8], \BU2/pcin [7], \BU2/pcin [6], \BU2/pcin [5], \BU2/pcin [4], 
\BU2/pcin [3], \BU2/pcin [2], \BU2/pcin [1], \BU2/pcin [0]}),
    .ALUMODE({\BU2/N0 , \BU2/N0 , \BU2/N0 , \BU2/N0 }),
    .C({\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [47], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [46], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [45], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [44], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [43], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [42], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [41], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [40], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [39], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [38], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [37], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [36], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [35], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [34], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [33], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [32], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [31], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [30], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [29], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [28], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [27], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [26], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [25], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [24], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [23], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [22], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [21], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [20], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [19], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [18], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [17], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [16], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [15], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [14], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [13], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [12], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [11], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [10], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [9], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [8], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [7], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [6], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [5], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [4], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [3], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [2], 
\BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [1], \BU2/U0/i_synth_option.i_synth_model/i_c4/opt_has_pipe.first_q [0]}),
    .CARRYOUT({\BU2/carryout , \NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_CARRYOUT<2>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_CARRYOUT<1>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_CARRYOUT<0>_UNCONNECTED }),
    .INMODE({\BU2/N0 , \BU2/N1 , \BU2/N1 , \BU2/N0 , \BU2/N0 }),
    .BCIN({\BU2/bcin [17], \BU2/bcin [16], \BU2/bcin [15], \BU2/bcin [14], \BU2/bcin [13], \BU2/bcin [12], \BU2/bcin [11], \BU2/bcin [10], 
\BU2/bcin [9], \BU2/bcin [8], \BU2/bcin [7], \BU2/bcin [6], \BU2/bcin [5], \BU2/bcin [4], \BU2/bcin [3], \BU2/bcin [2], \BU2/bcin [1], \BU2/bcin [0]})
,
    .B({b_3[15], b_3[15], b_3[15], b_3[14], b_3[13], b_3[12], b_3[11], b_3[10], b_3[9], b_3[8], b_3[7], b_3[6], b_3[5], b_3[4], b_3[3], b_3[2], b_3[1]
, b_3[0]}),
    .BCOUT({\BU2/bcout [17], \BU2/bcout [16], \BU2/bcout [15], \BU2/bcout [14], \BU2/bcout [13], \BU2/bcout [12], \BU2/bcout [11], \BU2/bcout [10], 
\BU2/bcout [9], \BU2/bcout [8], \BU2/bcout [7], \BU2/bcout [6], \BU2/bcout [5], \BU2/bcout [4], \BU2/bcout [3], \BU2/bcout [2], \BU2/bcout [1], 
\BU2/bcout [0]}),
    .D({d_5[15], d_5[15], d_5[15], d_5[15], d_5[15], d_5[15], d_5[15], d_5[15], d_5[15], d_5[15], d_5[14], d_5[13], d_5[12], d_5[11], d_5[10], d_5[9]
, d_5[8], d_5[7], d_5[6], d_5[5], d_5[4], d_5[3], d_5[2], d_5[1], d_5[0]}),
    .P({\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<47>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<46>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<45>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<44>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<43>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<42>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<41>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<40>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<39>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<38>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<37>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<36>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<35>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<34>_UNCONNECTED , 
\NLW_BU2/U0/i_synth_option.i_synth_model/opt_vx6.i_uniwrap/i_primitive_P<33>_UNCONNECTED , p_6[32], p_6[31], p_6[30], p_6[29], p_6[28], p_6[27], 
p_6[26], p_6[25], p_6[24], p_6[23], p_6[22], p_6[21], p_6[20], p_6[19], p_6[18], p_6[17], p_6[16], p_6[15], p_6[14], p_6[13], p_6[12], p_6[11], 
p_6[10], p_6[9], p_6[8], p_6[7], p_6[6], p_6[5], p_6[4], p_6[3], p_6[2], p_6[1], p_6[0]}),
    .A({a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[15], a_2[14]
, a_2[13], a_2[12], a_2[11], a_2[10], a_2[9], a_2[8], a_2[7], a_2[6], a_2[5], a_2[4], a_2[3], a_2[2], a_2[1], a_2[0]}),
    .PCOUT({\BU2/pcout [47], \BU2/pcout [46], \BU2/pcout [45], \BU2/pcout [44], \BU2/pcout [43], \BU2/pcout [42], \BU2/pcout [41], \BU2/pcout [40], 
\BU2/pcout [39], \BU2/pcout [38], \BU2/pcout [37], \BU2/pcout [36], \BU2/pcout [35], \BU2/pcout [34], \BU2/pcout [33], \BU2/pcout [32], 
\BU2/pcout [31], \BU2/pcout [30], \BU2/pcout [29], \BU2/pcout [28], \BU2/pcout [27], \BU2/pcout [26], \BU2/pcout [25], \BU2/pcout [24], 
\BU2/pcout [23], \BU2/pcout [22], \BU2/pcout [21], \BU2/pcout [20], \BU2/pcout [19], \BU2/pcout [18], \BU2/pcout [17], \BU2/pcout [16], 
\BU2/pcout [15], \BU2/pcout [14], \BU2/pcout [13], \BU2/pcout [12], \BU2/pcout [11], \BU2/pcout [10], \BU2/pcout [9], \BU2/pcout [8], \BU2/pcout [7], 
\BU2/pcout [6], \BU2/pcout [5], \BU2/pcout [4], \BU2/pcout [3], \BU2/pcout [2], \BU2/pcout [1], \BU2/pcout [0]}),
    .ACIN({\BU2/acin [29], \BU2/acin [28], \BU2/acin [27], \BU2/acin [26], \BU2/acin [25], \BU2/acin [24], \BU2/acin [23], \BU2/acin [22], 
\BU2/acin [21], \BU2/acin [20], \BU2/acin [19], \BU2/acin [18], \BU2/acin [17], \BU2/acin [16], \BU2/acin [15], \BU2/acin [14], \BU2/acin [13], 
\BU2/acin [12], \BU2/acin [11], \BU2/acin [10], \BU2/acin [9], \BU2/acin [8], \BU2/acin [7], \BU2/acin [6], \BU2/acin [5], \BU2/acin [4], 
\BU2/acin [3], \BU2/acin [2], \BU2/acin [1], \BU2/acin [0]}),
    .CARRYINSEL({\BU2/N0 , \BU2/N0 , \BU2/N0 })
  );
  VCC   \BU2/XST_VCC  (
    .P(\BU2/N1 )
  );
  GND   \BU2/XST_GND  (
    .G(\BU2/N0 )
  );

// synthesis translate_on

endmodule

// synthesis translate_off

`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

// synthesis translate_on
