////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.49d
//  \   \         Application: netgen
//  /   /         Filename: ad_mul_dsp48_1.v
// /___/   /\     Timestamp: Mon Jun 24 10:25:14 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -w -sim -ofmt verilog C:/corefpga/xilinx/cf_coregen/ml605/tmp/_cg/ad_mul_dsp48_1.ngc C:/corefpga/xilinx/cf_coregen/ml605/tmp/_cg/ad_mul_dsp48_1.v 
// Device	: 6vlx240tff1156-1
// Input file	: C:/corefpga/xilinx/cf_coregen/ml605/tmp/_cg/ad_mul_dsp48_1.ngc
// Output file	: C:/corefpga/xilinx/cf_coregen/ml605/tmp/_cg/ad_mul_dsp48_1.v
// # of Modules	: 1
// Design Name	: ad_mul_dsp48_1
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

module ad_mul_dsp48_1 (
  clk, a, b, p
)/* synthesis syn_black_box syn_noprune=1 */;
  input clk;
  input [15 : 0] a;
  input [15 : 0] b;
  output [31 : 0] p;
  
  // synthesis translate_off
  
  wire \blk00000001/sig000000bb ;
  wire \blk00000001/sig000000ba ;
  wire \blk00000001/sig000000b9 ;
  wire \blk00000001/sig000000b8 ;
  wire \blk00000001/sig000000b7 ;
  wire \blk00000001/sig000000b6 ;
  wire \blk00000001/sig000000b5 ;
  wire \blk00000001/sig000000b4 ;
  wire \blk00000001/sig000000b3 ;
  wire \blk00000001/sig000000b2 ;
  wire \blk00000001/sig000000b1 ;
  wire \blk00000001/sig000000b0 ;
  wire \blk00000001/sig000000af ;
  wire \blk00000001/sig000000ae ;
  wire \blk00000001/sig000000ad ;
  wire \blk00000001/sig000000ac ;
  wire \blk00000001/sig000000ab ;
  wire \blk00000001/sig000000aa ;
  wire \blk00000001/sig000000a9 ;
  wire \blk00000001/sig000000a8 ;
  wire \blk00000001/sig000000a7 ;
  wire \blk00000001/sig000000a6 ;
  wire \blk00000001/sig000000a5 ;
  wire \blk00000001/sig000000a4 ;
  wire \blk00000001/sig000000a3 ;
  wire \blk00000001/sig000000a2 ;
  wire \blk00000001/sig00000081 ;
  wire \blk00000001/sig00000080 ;
  wire \blk00000001/sig0000007f ;
  wire \blk00000001/sig0000007e ;
  wire \blk00000001/sig0000007d ;
  wire \blk00000001/sig0000007c ;
  wire \blk00000001/sig0000007b ;
  wire \blk00000001/sig0000007a ;
  wire \blk00000001/sig00000079 ;
  wire \blk00000001/sig00000078 ;
  wire \blk00000001/sig00000077 ;
  wire \blk00000001/sig00000076 ;
  wire \blk00000001/sig00000075 ;
  wire \blk00000001/sig00000074 ;
  wire \blk00000001/sig00000073 ;
  wire \blk00000001/sig00000072 ;
  wire \blk00000001/sig00000071 ;
  wire \blk00000001/sig00000070 ;
  wire \blk00000001/sig0000006f ;
  wire \blk00000001/sig0000006e ;
  wire \blk00000001/sig0000006d ;
  wire \blk00000001/sig0000006c ;
  wire \blk00000001/sig0000006b ;
  wire \blk00000001/sig0000006a ;
  wire \blk00000001/sig00000069 ;
  wire \blk00000001/sig00000068 ;
  wire \blk00000001/sig00000067 ;
  wire \blk00000001/sig00000066 ;
  wire \blk00000001/sig00000065 ;
  wire \blk00000001/sig00000064 ;
  wire \blk00000001/sig00000063 ;
  wire \blk00000001/sig00000062 ;
  wire \blk00000001/sig00000061 ;
  wire \blk00000001/sig00000060 ;
  wire \blk00000001/sig0000005f ;
  wire \blk00000001/sig0000005e ;
  wire \blk00000001/sig0000005d ;
  wire \blk00000001/sig0000005c ;
  wire \blk00000001/sig0000005b ;
  wire \blk00000001/sig0000005a ;
  wire \blk00000001/sig00000059 ;
  wire \blk00000001/sig00000058 ;
  wire \blk00000001/sig00000057 ;
  wire \blk00000001/sig00000056 ;
  wire \blk00000001/sig00000055 ;
  wire \blk00000001/sig00000054 ;
  wire \blk00000001/sig00000053 ;
  wire \blk00000001/sig00000052 ;
  wire \blk00000001/sig00000051 ;
  wire \blk00000001/sig00000050 ;
  wire \blk00000001/sig0000004f ;
  wire \blk00000001/sig0000004e ;
  wire \blk00000001/sig0000004d ;
  wire \blk00000001/sig0000004c ;
  wire \blk00000001/sig0000004b ;
  wire \blk00000001/sig0000004a ;
  wire \blk00000001/sig00000049 ;
  wire \blk00000001/sig00000048 ;
  wire \blk00000001/sig00000047 ;
  wire \blk00000001/sig00000046 ;
  wire \blk00000001/sig00000045 ;
  wire \blk00000001/sig00000044 ;
  wire \blk00000001/sig00000043 ;
  wire \blk00000001/sig00000042 ;
  wire \blk00000001/sig00000041 ;
  wire \blk00000001/sig00000040 ;
  wire \blk00000001/sig0000003f ;
  wire \blk00000001/sig0000003e ;
  wire \blk00000001/sig0000003d ;
  wire \blk00000001/sig0000003c ;
  wire \blk00000001/sig0000003b ;
  wire \blk00000001/sig0000003a ;
  wire \blk00000001/sig00000039 ;
  wire \blk00000001/sig00000038 ;
  wire \blk00000001/sig00000037 ;
  wire \blk00000001/sig00000036 ;
  wire \blk00000001/sig00000035 ;
  wire \blk00000001/sig00000034 ;
  wire \blk00000001/sig00000033 ;
  wire \blk00000001/sig00000032 ;
  wire \blk00000001/sig00000031 ;
  wire \blk00000001/sig00000030 ;
  wire \blk00000001/sig0000002f ;
  wire \blk00000001/sig0000002e ;
  wire \blk00000001/sig0000002d ;
  wire \blk00000001/sig0000002c ;
  wire \blk00000001/sig0000002b ;
  wire \blk00000001/sig0000002a ;
  wire \blk00000001/sig00000029 ;
  wire \blk00000001/sig00000028 ;
  wire \blk00000001/sig00000027 ;
  wire \blk00000001/sig00000026 ;
  wire \blk00000001/sig00000025 ;
  wire \blk00000001/sig00000024 ;
  wire \blk00000001/sig00000023 ;
  wire \blk00000001/sig00000022 ;
  wire \NLW_blk00000001/blk0000001a_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_UNDERFLOW_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_OVERFLOW_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_CARRYOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_CARRYOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_CARRYOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<47>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<46>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<45>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<44>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<43>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<42>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<41>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<40>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<39>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<38>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<37>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<36>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<35>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<34>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<33>_UNCONNECTED ;
  wire \NLW_blk00000001/blk0000001a_P<32>_UNCONNECTED ;
  DSP48E1 #(
    .ACASCREG ( 2 ),
    .ADREG ( 0 ),
    .ALUMODEREG ( 1 ),
    .AREG ( 2 ),
    .AUTORESET_PATDET ( "NO_RESET" ),
    .A_INPUT ( "DIRECT" ),
    .BCASCREG ( 2 ),
    .BREG ( 2 ),
    .B_INPUT ( "DIRECT" ),
    .CARRYINREG ( 1 ),
    .CARRYINSELREG ( 1 ),
    .CREG ( 1 ),
    .DREG ( 0 ),
    .INMODEREG ( 1 ),
    .MASK ( 48'h3FFFFFFFFFFF ),
    .MREG ( 1 ),
    .OPMODEREG ( 1 ),
    .PATTERN ( 48'h000000000000 ),
    .PREG ( 1 ),
    .SEL_MASK ( "MASK" ),
    .SEL_PATTERN ( "PATTERN" ),
    .USE_DPORT ( "FALSE" ),
    .USE_MULT ( "MULTIPLY" ),
    .USE_PATTERN_DETECT ( "NO_PATDET" ),
    .USE_SIMD ( "ONE48" ))
  \blk00000001/blk0000001a  (
    .PATTERNBDETECT(\NLW_blk00000001/blk0000001a_PATTERNBDETECT_UNCONNECTED ),
    .RSTC(\blk00000001/sig000000a6 ),
    .CEB1(\blk00000001/sig000000a4 ),
    .CEAD(\blk00000001/sig000000a6 ),
    .MULTSIGNOUT(\NLW_blk00000001/blk0000001a_MULTSIGNOUT_UNCONNECTED ),
    .CEC(\blk00000001/sig000000a4 ),
    .RSTM(\blk00000001/sig000000a6 ),
    .MULTSIGNIN(\blk00000001/sig000000a6 ),
    .CEB2(\blk00000001/sig000000a4 ),
    .RSTCTRL(\blk00000001/sig000000a6 ),
    .CEP(\blk00000001/sig000000a4 ),
    .CARRYCASCOUT(\blk00000001/sig000000a3 ),
    .RSTA(\blk00000001/sig000000a6 ),
    .CECARRYIN(\blk00000001/sig000000a4 ),
    .UNDERFLOW(\NLW_blk00000001/blk0000001a_UNDERFLOW_UNCONNECTED ),
    .PATTERNDETECT(\NLW_blk00000001/blk0000001a_PATTERNDETECT_UNCONNECTED ),
    .RSTALUMODE(\blk00000001/sig000000a6 ),
    .RSTALLCARRYIN(\blk00000001/sig000000a6 ),
    .CED(\blk00000001/sig000000a6 ),
    .RSTD(\blk00000001/sig000000a6 ),
    .CEALUMODE(\blk00000001/sig000000a4 ),
    .CEA2(\blk00000001/sig000000a4 ),
    .CLK(clk),
    .CEA1(\blk00000001/sig000000a4 ),
    .RSTB(\blk00000001/sig000000a6 ),
    .OVERFLOW(\NLW_blk00000001/blk0000001a_OVERFLOW_UNCONNECTED ),
    .CECTRL(\blk00000001/sig000000a4 ),
    .CEM(\blk00000001/sig000000a4 ),
    .CARRYIN(\blk00000001/sig000000a5 ),
    .CARRYCASCIN(\blk00000001/sig000000a6 ),
    .RSTINMODE(\blk00000001/sig000000a6 ),
    .CEINMODE(\blk00000001/sig000000a4 ),
    .RSTP(\blk00000001/sig000000a6 ),
    .ACOUT({\blk00000001/sig00000022 , \blk00000001/sig00000023 , \blk00000001/sig00000024 , \blk00000001/sig00000025 , \blk00000001/sig00000026 , 
\blk00000001/sig00000027 , \blk00000001/sig00000028 , \blk00000001/sig00000029 , \blk00000001/sig0000002a , \blk00000001/sig0000002b , 
\blk00000001/sig0000002c , \blk00000001/sig0000002d , \blk00000001/sig0000002e , \blk00000001/sig0000002f , \blk00000001/sig00000030 , 
\blk00000001/sig00000031 , \blk00000001/sig00000032 , \blk00000001/sig00000033 , \blk00000001/sig00000034 , \blk00000001/sig00000035 , 
\blk00000001/sig00000036 , \blk00000001/sig00000037 , \blk00000001/sig00000038 , \blk00000001/sig00000039 , \blk00000001/sig0000003a , 
\blk00000001/sig0000003b , \blk00000001/sig0000003c , \blk00000001/sig0000003d , \blk00000001/sig0000003e , \blk00000001/sig0000003f }),
    .OPMODE({\blk00000001/sig000000b0 , \blk00000001/sig000000af , \blk00000001/sig000000ae , \blk00000001/sig000000ad , \blk00000001/sig000000ac , 
\blk00000001/sig000000ab , \blk00000001/sig000000aa }),
    .PCIN({\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 }),
    .ALUMODE({\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000b1 , \blk00000001/sig000000b1 }),
    .C({\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 }),
    .CARRYOUT({\blk00000001/sig000000a2 , \NLW_blk00000001/blk0000001a_CARRYOUT<2>_UNCONNECTED , \NLW_blk00000001/blk0000001a_CARRYOUT<1>_UNCONNECTED 
, \NLW_blk00000001/blk0000001a_CARRYOUT<0>_UNCONNECTED }),
    .INMODE({\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 }),
    .BCIN({\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 }),
    .B({b[15], b[15], b[15], b[14], b[13], b[12], b[11], b[10], b[9], b[8], b[7], b[6], b[5], b[4], b[3], b[2], b[1], b[0]}),
    .BCOUT({\blk00000001/sig00000040 , \blk00000001/sig00000041 , \blk00000001/sig00000042 , \blk00000001/sig00000043 , \blk00000001/sig00000044 , 
\blk00000001/sig00000045 , \blk00000001/sig00000046 , \blk00000001/sig00000047 , \blk00000001/sig00000048 , \blk00000001/sig00000049 , 
\blk00000001/sig0000004a , \blk00000001/sig0000004b , \blk00000001/sig0000004c , \blk00000001/sig0000004d , \blk00000001/sig0000004e , 
\blk00000001/sig0000004f , \blk00000001/sig00000050 , \blk00000001/sig00000051 }),
    .D({\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , 
\blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 , \blk00000001/sig000000a4 }),
    .P({\NLW_blk00000001/blk0000001a_P<47>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<46>_UNCONNECTED , 
\NLW_blk00000001/blk0000001a_P<45>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<44>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<43>_UNCONNECTED , 
\NLW_blk00000001/blk0000001a_P<42>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<41>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<40>_UNCONNECTED , 
\NLW_blk00000001/blk0000001a_P<39>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<38>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<37>_UNCONNECTED , 
\NLW_blk00000001/blk0000001a_P<36>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<35>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<34>_UNCONNECTED , 
\NLW_blk00000001/blk0000001a_P<33>_UNCONNECTED , \NLW_blk00000001/blk0000001a_P<32>_UNCONNECTED , p[31], p[30], p[29], p[28], p[27], p[26], p[25], 
p[24], p[23], p[22], p[21], p[20], p[19], p[18], p[17], p[16], p[15], p[14], p[13], p[12], p[11], p[10], p[9], p[8], p[7], p[6], p[5], p[4], p[3], 
p[2], p[1], p[0]}),
    .A({a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[15], a[14], a[13], a[12], a[11], a[10], 
a[9], a[8], a[7], a[6], a[5], a[4], a[3], a[2], a[1], a[0]}),
    .PCOUT({\blk00000001/sig00000052 , \blk00000001/sig00000053 , \blk00000001/sig00000054 , \blk00000001/sig00000055 , \blk00000001/sig00000056 , 
\blk00000001/sig00000057 , \blk00000001/sig00000058 , \blk00000001/sig00000059 , \blk00000001/sig0000005a , \blk00000001/sig0000005b , 
\blk00000001/sig0000005c , \blk00000001/sig0000005d , \blk00000001/sig0000005e , \blk00000001/sig0000005f , \blk00000001/sig00000060 , 
\blk00000001/sig00000061 , \blk00000001/sig00000062 , \blk00000001/sig00000063 , \blk00000001/sig00000064 , \blk00000001/sig00000065 , 
\blk00000001/sig00000066 , \blk00000001/sig00000067 , \blk00000001/sig00000068 , \blk00000001/sig00000069 , \blk00000001/sig0000006a , 
\blk00000001/sig0000006b , \blk00000001/sig0000006c , \blk00000001/sig0000006d , \blk00000001/sig0000006e , \blk00000001/sig0000006f , 
\blk00000001/sig00000070 , \blk00000001/sig00000071 , \blk00000001/sig00000072 , \blk00000001/sig00000073 , \blk00000001/sig00000074 , 
\blk00000001/sig00000075 , \blk00000001/sig00000076 , \blk00000001/sig00000077 , \blk00000001/sig00000078 , \blk00000001/sig00000079 , 
\blk00000001/sig0000007a , \blk00000001/sig0000007b , \blk00000001/sig0000007c , \blk00000001/sig0000007d , \blk00000001/sig0000007e , 
\blk00000001/sig0000007f , \blk00000001/sig00000080 , \blk00000001/sig00000081 }),
    .ACIN({\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , 
\blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 , \blk00000001/sig000000a6 }),
    .CARRYINSEL({\blk00000001/sig000000a9 , \blk00000001/sig000000a8 , \blk00000001/sig000000a7 })
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000019  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000a5 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000018  (
    .C(clk),
    .D(\blk00000001/sig000000a4 ),
    .Q(\blk00000001/sig000000b2 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000017  (
    .C(clk),
    .D(\blk00000001/sig000000a4 ),
    .Q(\blk00000001/sig000000b3 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000016  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000b4 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000015  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000b5 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000014  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000b6 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000013  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000b7 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000012  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000b8 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000011  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000b9 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000010  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000ba )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000000f  (
    .C(clk),
    .D(\blk00000001/sig000000b2 ),
    .Q(\blk00000001/sig000000aa )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000000e  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000ab )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000000d  (
    .C(clk),
    .D(\blk00000001/sig000000b3 ),
    .Q(\blk00000001/sig000000ac )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000000c  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000ad )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000000b  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000ae )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk0000000a  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000af )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000009  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000b0 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000008  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000b1 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000007  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000bb )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000006  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000a7 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000005  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000a8 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \blk00000001/blk00000004  (
    .C(clk),
    .D(\blk00000001/sig000000a6 ),
    .Q(\blk00000001/sig000000a9 )
  );
  GND   \blk00000001/blk00000003  (
    .G(\blk00000001/sig000000a6 )
  );
  VCC   \blk00000001/blk00000002  (
    .P(\blk00000001/sig000000a4 )
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
