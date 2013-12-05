////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.49d
//  \   \         Application: netgen
//  /   /         Filename: ad_dds_1.v
// /___/   /\     Timestamp: Thu Jun 06 11:13:56 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -w -sim -ofmt verilog C:/corefpga/xilinx/cf_lib/edk/pcores/adi_common_v1_00_a/netlist/m_netlist/ad_dds_1/tmp/_cg/ad_dds_1.ngc C:/corefpga/xilinx/cf_lib/edk/pcores/adi_common_v1_00_a/netlist/m_netlist/ad_dds_1/tmp/_cg/ad_dds_1.v 
// Device	: 6vlx240tff1156-1
// Input file	: C:/corefpga/xilinx/cf_lib/edk/pcores/adi_common_v1_00_a/netlist/m_netlist/ad_dds_1/tmp/_cg/ad_dds_1.ngc
// Output file	: C:/corefpga/xilinx/cf_lib/edk/pcores/adi_common_v1_00_a/netlist/m_netlist/ad_dds_1/tmp/_cg/ad_dds_1.v
// # of Modules	: 1
// Design Name	: ad_dds_1
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

module ad_dds_1 (
  clk, sclr, phase_in, sine
)/* synthesis syn_black_box syn_noprune=1 */;
  input clk;
  input sclr;
  input [15 : 0] phase_in;
  output [15 : 0] sine;
  
  // synthesis translate_off
  
  wire sig00000001;
  wire sig00000002;
  wire sig00000003;
  wire sig00000004;
  wire sig00000005;
  wire sig00000006;
  wire sig00000007;
  wire sig00000008;
  wire sig00000009;
  wire sig0000000a;
  wire sig0000000b;
  wire sig0000000c;
  wire sig0000000d;
  wire sig0000000e;
  wire sig0000000f;
  wire sig00000010;
  wire sig00000011;
  wire sig00000012;
  wire sig00000013;
  wire sig00000014;
  wire sig00000015;
  wire sig00000016;
  wire sig00000017;
  wire sig00000018;
  wire sig00000019;
  wire sig0000001a;
  wire sig0000001b;
  wire sig0000001c;
  wire sig0000001d;
  wire sig0000001e;
  wire sig0000001f;
  wire sig00000020;
  wire sig00000021;
  wire sig00000022;
  wire sig00000023;
  wire sig00000024;
  wire sig00000025;
  wire sig00000026;
  wire sig00000027;
  wire sig00000028;
  wire sig00000029;
  wire sig0000002a;
  wire sig0000002b;
  wire sig0000002c;
  wire sig0000002d;
  wire sig0000002e;
  wire sig0000002f;
  wire sig00000030;
  wire sig00000031;
  wire sig00000032;
  wire sig00000033;
  wire sig00000034;
  wire sig00000035;
  wire sig00000036;
  wire sig00000037;
  wire sig00000038;
  wire sig00000039;
  wire sig0000003a;
  wire sig0000003b;
  wire sig0000003c;
  wire sig0000003d;
  wire sig0000003e;
  wire sig0000003f;
  wire sig00000040;
  wire sig00000041;
  wire sig00000042;
  wire sig00000043;
  wire sig00000044;
  wire sig00000045;
  wire sig00000046;
  wire sig00000047;
  wire sig00000048;
  wire sig00000049;
  wire sig0000004a;
  wire sig0000004b;
  wire sig0000004c;
  wire sig0000004d;
  wire sig0000004e;
  wire sig0000004f;
  wire sig00000050;
  wire sig00000051;
  wire sig00000052;
  wire sig00000053;
  wire sig00000054;
  wire sig00000055;
  wire sig00000056;
  wire sig00000057;
  wire sig00000058;
  wire sig00000059;
  wire sig0000005a;
  wire sig0000005b;
  wire sig0000005c;
  wire sig0000005d;
  wire sig0000005e;
  wire sig0000005f;
  wire sig00000060;
  wire sig00000061;
  wire sig00000062;
  wire sig00000063;
  wire sig00000064;
  wire sig00000065;
  wire sig00000066;
  wire sig00000067;
  wire sig00000068;
  wire sig00000069;
  wire sig0000006a;
  wire sig0000006b;
  wire sig0000006c;
  wire sig0000006d;
  wire sig0000006e;
  wire sig0000006f;
  wire sig00000070;
  wire sig00000071;
  wire sig00000072;
  wire sig00000073;
  wire sig00000074;
  wire sig00000075;
  wire sig00000076;
  wire sig00000077;
  wire sig00000078;
  wire sig00000079;
  wire sig0000007a;
  wire sig0000007b;
  wire sig0000007c;
  wire sig0000007d;
  wire sig0000007e;
  wire sig0000007f;
  wire sig00000080;
  wire sig00000081;
  wire sig00000082;
  wire sig00000083;
  wire sig00000084;
  wire sig00000085;
  wire sig00000086;
  wire sig00000087;
  wire sig00000088;
  wire sig00000089;
  wire sig0000008a;
  wire sig0000008b;
  wire sig0000008c;
  wire sig0000008d;
  wire sig0000008e;
  wire sig0000008f;
  wire sig00000090;
  wire sig00000091;
  wire sig00000092;
  wire sig00000093;
  wire sig00000094;
  wire sig00000095;
  wire sig00000096;
  wire sig00000097;
  wire sig00000098;
  wire sig00000099;
  wire sig0000009a;
  wire sig0000009b;
  wire sig0000009c;
  wire sig0000009d;
  wire sig0000009e;
  wire sig0000009f;
  wire sig000000a0;
  wire sig000000a1;
  wire sig000000a2;
  wire sig000000a3;
  wire sig000000a4;
  wire sig000000a5;
  wire sig000000a6;
  wire sig000000a7;
  wire sig000000a8;
  wire sig000000a9;
  wire sig000000aa;
  wire sig000000ab;
  wire sig000000ac;
  wire sig000000ad;
  wire sig000000ae;
  wire sig000000af;
  wire sig000000b0;
  wire sig000000b1;
  wire sig000000b2;
  wire sig000000b3;
  wire sig000000b4;
  wire sig000000b5;
  wire sig000000b6;
  wire sig000000b7;
  wire sig000000b8;
  wire sig000000b9;
  wire sig000000ba;
  wire sig000000bb;
  wire sig000000bc;
  wire sig000000bd;
  wire sig000000be;
  wire sig000000bf;
  wire sig000000c0;
  wire sig000000c1;
  wire sig000000c2;
  wire sig000000c3;
  wire sig000000c4;
  wire sig000000c5;
  wire sig000000c6;
  wire sig000000c7;
  wire \NLW_blk00000096_DIBDI<15>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<14>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<13>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<12>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<11>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<10>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<9>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<8>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<7>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<6>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<5>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<4>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<3>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<2>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<1>_UNCONNECTED ;
  wire \NLW_blk00000096_DIBDI<0>_UNCONNECTED ;
  wire \NLW_blk00000096_DIPBDIP<1>_UNCONNECTED ;
  wire \NLW_blk00000096_DIPBDIP<0>_UNCONNECTED ;
  wire \NLW_blk00000096_DOPADOP<1>_UNCONNECTED ;
  wire \NLW_blk00000096_DOPADOP<0>_UNCONNECTED ;
  wire \NLW_blk00000096_DOPBDOP<1>_UNCONNECTED ;
  wire \NLW_blk00000096_DOPBDOP<0>_UNCONNECTED ;
  wire \NLW_blk00000097_P<41>_UNCONNECTED ;
  wire \NLW_blk00000097_P<40>_UNCONNECTED ;
  wire \NLW_blk00000097_P<39>_UNCONNECTED ;
  wire \NLW_blk00000097_P<38>_UNCONNECTED ;
  wire \NLW_blk00000097_P<37>_UNCONNECTED ;
  wire \NLW_blk00000097_P<36>_UNCONNECTED ;
  wire \NLW_blk00000097_P<35>_UNCONNECTED ;
  wire \NLW_blk00000097_P<34>_UNCONNECTED ;
  wire \NLW_blk00000097_P<33>_UNCONNECTED ;
  wire \NLW_blk00000097_P<32>_UNCONNECTED ;
  wire \NLW_blk00000097_P<31>_UNCONNECTED ;
  wire \NLW_blk00000097_P<30>_UNCONNECTED ;
  wire \NLW_blk00000097_P<29>_UNCONNECTED ;
  wire \NLW_blk00000097_P<28>_UNCONNECTED ;
  wire \NLW_blk00000097_P<27>_UNCONNECTED ;
  wire \NLW_blk00000097_P<26>_UNCONNECTED ;
  wire NLW_blk00000097_PATTERNBDETECT_UNCONNECTED;
  wire NLW_blk00000097_MULTSIGNOUT_UNCONNECTED;
  wire NLW_blk00000097_CARRYCASCOUT_UNCONNECTED;
  wire NLW_blk00000097_UNDERFLOW_UNCONNECTED;
  wire NLW_blk00000097_PATTERNDETECT_UNCONNECTED;
  wire NLW_blk00000097_OVERFLOW_UNCONNECTED;
  wire \NLW_blk00000097_ACOUT<29>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<28>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<27>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<26>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<25>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<24>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<23>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<22>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<21>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<20>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<19>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<18>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000097_ACOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000097_CARRYOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000097_CARRYOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000097_CARRYOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000097_CARRYOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000097_BCOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000097_P<47>_UNCONNECTED ;
  wire \NLW_blk00000097_P<46>_UNCONNECTED ;
  wire \NLW_blk00000097_P<45>_UNCONNECTED ;
  wire \NLW_blk00000097_P<44>_UNCONNECTED ;
  wire \NLW_blk00000097_P<43>_UNCONNECTED ;
  wire \NLW_blk00000097_P<42>_UNCONNECTED ;
  wire \NLW_blk00000097_P<25>_UNCONNECTED ;
  wire \NLW_blk00000097_P<24>_UNCONNECTED ;
  wire \NLW_blk00000097_P<23>_UNCONNECTED ;
  wire \NLW_blk00000097_P<22>_UNCONNECTED ;
  wire \NLW_blk00000097_P<21>_UNCONNECTED ;
  wire \NLW_blk00000097_P<20>_UNCONNECTED ;
  wire \NLW_blk00000097_P<19>_UNCONNECTED ;
  wire \NLW_blk00000097_P<18>_UNCONNECTED ;
  wire \NLW_blk00000097_P<17>_UNCONNECTED ;
  wire \NLW_blk00000097_P<16>_UNCONNECTED ;
  wire \NLW_blk00000097_P<15>_UNCONNECTED ;
  wire \NLW_blk00000097_P<14>_UNCONNECTED ;
  wire \NLW_blk00000097_P<13>_UNCONNECTED ;
  wire \NLW_blk00000097_P<12>_UNCONNECTED ;
  wire \NLW_blk00000097_P<11>_UNCONNECTED ;
  wire \NLW_blk00000097_P<10>_UNCONNECTED ;
  wire \NLW_blk00000097_P<9>_UNCONNECTED ;
  wire \NLW_blk00000097_P<8>_UNCONNECTED ;
  wire \NLW_blk00000097_P<7>_UNCONNECTED ;
  wire \NLW_blk00000097_P<6>_UNCONNECTED ;
  wire \NLW_blk00000097_P<5>_UNCONNECTED ;
  wire \NLW_blk00000097_P<4>_UNCONNECTED ;
  wire \NLW_blk00000097_P<3>_UNCONNECTED ;
  wire \NLW_blk00000097_P<2>_UNCONNECTED ;
  wire \NLW_blk00000097_P<1>_UNCONNECTED ;
  wire \NLW_blk00000097_P<0>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<47>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<46>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<45>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<44>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<43>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<42>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<41>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<40>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<39>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<38>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<37>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<36>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<35>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<34>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<33>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<32>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<31>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<30>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<29>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<28>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<27>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<26>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<25>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<24>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<23>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<22>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<21>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<20>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<19>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<18>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000097_PCOUT<0>_UNCONNECTED ;
  wire NLW_blk00000098_PATTERNBDETECT_UNCONNECTED;
  wire NLW_blk00000098_MULTSIGNOUT_UNCONNECTED;
  wire NLW_blk00000098_CARRYCASCOUT_UNCONNECTED;
  wire NLW_blk00000098_UNDERFLOW_UNCONNECTED;
  wire NLW_blk00000098_PATTERNDETECT_UNCONNECTED;
  wire NLW_blk00000098_OVERFLOW_UNCONNECTED;
  wire \NLW_blk00000098_ACOUT<29>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<28>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<27>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<26>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<25>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<24>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<23>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<22>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<21>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<20>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<19>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<18>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000098_ACOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000098_CARRYOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000098_CARRYOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000098_CARRYOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000098_CARRYOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000098_BCOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000098_P<47>_UNCONNECTED ;
  wire \NLW_blk00000098_P<46>_UNCONNECTED ;
  wire \NLW_blk00000098_P<45>_UNCONNECTED ;
  wire \NLW_blk00000098_P<44>_UNCONNECTED ;
  wire \NLW_blk00000098_P<43>_UNCONNECTED ;
  wire \NLW_blk00000098_P<42>_UNCONNECTED ;
  wire \NLW_blk00000098_P<25>_UNCONNECTED ;
  wire \NLW_blk00000098_P<24>_UNCONNECTED ;
  wire \NLW_blk00000098_P<23>_UNCONNECTED ;
  wire \NLW_blk00000098_P<22>_UNCONNECTED ;
  wire \NLW_blk00000098_P<21>_UNCONNECTED ;
  wire \NLW_blk00000098_P<20>_UNCONNECTED ;
  wire \NLW_blk00000098_P<19>_UNCONNECTED ;
  wire \NLW_blk00000098_P<18>_UNCONNECTED ;
  wire \NLW_blk00000098_P<17>_UNCONNECTED ;
  wire \NLW_blk00000098_P<16>_UNCONNECTED ;
  wire \NLW_blk00000098_P<15>_UNCONNECTED ;
  wire \NLW_blk00000098_P<14>_UNCONNECTED ;
  wire \NLW_blk00000098_P<13>_UNCONNECTED ;
  wire \NLW_blk00000098_P<12>_UNCONNECTED ;
  wire \NLW_blk00000098_P<11>_UNCONNECTED ;
  wire \NLW_blk00000098_P<10>_UNCONNECTED ;
  wire \NLW_blk00000098_P<9>_UNCONNECTED ;
  wire \NLW_blk00000098_P<8>_UNCONNECTED ;
  wire \NLW_blk00000098_P<7>_UNCONNECTED ;
  wire \NLW_blk00000098_P<6>_UNCONNECTED ;
  wire \NLW_blk00000098_P<5>_UNCONNECTED ;
  wire \NLW_blk00000098_P<4>_UNCONNECTED ;
  wire \NLW_blk00000098_P<3>_UNCONNECTED ;
  wire \NLW_blk00000098_P<2>_UNCONNECTED ;
  wire \NLW_blk00000098_P<1>_UNCONNECTED ;
  wire \NLW_blk00000098_P<0>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<47>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<46>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<45>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<44>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<43>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<42>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<41>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<40>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<39>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<38>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<37>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<36>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<35>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<34>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<33>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<32>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<31>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<30>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<29>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<28>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<27>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<26>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<25>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<24>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<23>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<22>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<21>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<20>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<19>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<18>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000098_PCOUT<0>_UNCONNECTED ;
  wire NLW_blk00000099_PATTERNBDETECT_UNCONNECTED;
  wire NLW_blk00000099_MULTSIGNOUT_UNCONNECTED;
  wire NLW_blk00000099_CARRYCASCOUT_UNCONNECTED;
  wire NLW_blk00000099_UNDERFLOW_UNCONNECTED;
  wire NLW_blk00000099_PATTERNDETECT_UNCONNECTED;
  wire NLW_blk00000099_OVERFLOW_UNCONNECTED;
  wire \NLW_blk00000099_ACOUT<29>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<28>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<27>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<26>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<25>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<24>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<23>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<22>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<21>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<20>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<19>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<18>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000099_ACOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000099_CARRYOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000099_CARRYOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000099_CARRYOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000099_CARRYOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000099_BCOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000099_P<47>_UNCONNECTED ;
  wire \NLW_blk00000099_P<46>_UNCONNECTED ;
  wire \NLW_blk00000099_P<45>_UNCONNECTED ;
  wire \NLW_blk00000099_P<44>_UNCONNECTED ;
  wire \NLW_blk00000099_P<43>_UNCONNECTED ;
  wire \NLW_blk00000099_P<42>_UNCONNECTED ;
  wire \NLW_blk00000099_P<41>_UNCONNECTED ;
  wire \NLW_blk00000099_P<40>_UNCONNECTED ;
  wire \NLW_blk00000099_P<39>_UNCONNECTED ;
  wire \NLW_blk00000099_P<38>_UNCONNECTED ;
  wire \NLW_blk00000099_P<37>_UNCONNECTED ;
  wire \NLW_blk00000099_P<36>_UNCONNECTED ;
  wire \NLW_blk00000099_P<17>_UNCONNECTED ;
  wire \NLW_blk00000099_P<16>_UNCONNECTED ;
  wire \NLW_blk00000099_P<15>_UNCONNECTED ;
  wire \NLW_blk00000099_P<14>_UNCONNECTED ;
  wire \NLW_blk00000099_P<13>_UNCONNECTED ;
  wire \NLW_blk00000099_P<12>_UNCONNECTED ;
  wire \NLW_blk00000099_P<11>_UNCONNECTED ;
  wire \NLW_blk00000099_P<10>_UNCONNECTED ;
  wire \NLW_blk00000099_P<9>_UNCONNECTED ;
  wire \NLW_blk00000099_P<8>_UNCONNECTED ;
  wire \NLW_blk00000099_P<7>_UNCONNECTED ;
  wire \NLW_blk00000099_P<6>_UNCONNECTED ;
  wire \NLW_blk00000099_P<5>_UNCONNECTED ;
  wire \NLW_blk00000099_P<4>_UNCONNECTED ;
  wire \NLW_blk00000099_P<3>_UNCONNECTED ;
  wire \NLW_blk00000099_P<2>_UNCONNECTED ;
  wire \NLW_blk00000099_P<1>_UNCONNECTED ;
  wire \NLW_blk00000099_P<0>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<47>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<46>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<45>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<44>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<43>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<42>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<41>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<40>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<39>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<38>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<37>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<36>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<35>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<34>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<33>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<32>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<31>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<30>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<29>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<28>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<27>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<26>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<25>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<24>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<23>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<22>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<21>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<20>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<19>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<18>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000099_PCOUT<0>_UNCONNECTED ;
  VCC   blk00000001 (
    .P(sig00000001)
  );
  GND   blk00000002 (
    .G(sig00000034)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000003 (
    .C(clk),
    .D(sig00000011),
    .Q(sig00000045)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000004 (
    .C(clk),
    .D(sig00000010),
    .Q(sig00000044)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000005 (
    .C(clk),
    .D(sig0000000f),
    .Q(sig00000043)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000006 (
    .C(clk),
    .D(sig0000000e),
    .Q(sig00000042)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000007 (
    .C(clk),
    .D(sig0000000d),
    .Q(sig00000041)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000008 (
    .C(clk),
    .D(sig0000000c),
    .Q(sig00000040)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000009 (
    .C(clk),
    .D(sig0000000b),
    .Q(sig0000003f)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000000a (
    .C(clk),
    .D(sig0000000a),
    .Q(sig0000003e)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000000b (
    .C(clk),
    .D(sig00000009),
    .Q(sig0000003d)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000000c (
    .C(clk),
    .D(sig00000008),
    .Q(sig0000003c)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000000d (
    .C(clk),
    .D(sig00000007),
    .Q(sig0000003b)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000000e (
    .C(clk),
    .D(sig00000006),
    .Q(sig0000003a)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000000f (
    .C(clk),
    .D(sig00000005),
    .Q(sig00000039)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000010 (
    .C(clk),
    .D(sig00000004),
    .Q(sig00000038)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000011 (
    .C(clk),
    .D(sig00000003),
    .Q(sig00000037)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000012 (
    .C(clk),
    .D(sig00000002),
    .Q(sig00000036)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000013 (
    .C(clk),
    .D(sig00000001),
    .Q(sig00000035)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000014 (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000074)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000015 (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000073)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000016 (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000072)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000017 (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000071)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000018 (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000070)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000019 (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000006f)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000001a (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000006e)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000001b (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000006d)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000001c (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000006c)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000001d (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000006b)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000001e (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000006a)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000001f (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000069)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000020 (
    .C(clk),
    .D(sig00000021),
    .Q(sig00000056)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000021 (
    .C(clk),
    .D(sig00000020),
    .Q(sig00000055)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000022 (
    .C(clk),
    .D(sig0000001f),
    .Q(sig00000054)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000023 (
    .C(clk),
    .D(sig0000001e),
    .Q(sig00000053)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000024 (
    .C(clk),
    .D(sig0000001d),
    .Q(sig00000052)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000025 (
    .C(clk),
    .D(sig0000001c),
    .Q(sig00000051)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000026 (
    .C(clk),
    .D(sig0000001b),
    .Q(sig00000050)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000027 (
    .C(clk),
    .D(sig0000001a),
    .Q(sig0000004f)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000028 (
    .C(clk),
    .D(sig00000019),
    .Q(sig0000004e)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000029 (
    .C(clk),
    .D(sig00000018),
    .Q(sig0000004d)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000002a (
    .C(clk),
    .D(sig00000017),
    .Q(sig0000004c)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000002b (
    .C(clk),
    .D(sig00000016),
    .Q(sig0000004b)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000002c (
    .C(clk),
    .D(sig00000015),
    .Q(sig0000004a)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000002d (
    .C(clk),
    .D(sig00000014),
    .Q(sig00000049)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000002e (
    .C(clk),
    .D(sig00000013),
    .Q(sig00000048)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000002f (
    .C(clk),
    .D(sig00000012),
    .Q(sig00000047)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000030 (
    .C(clk),
    .D(sig00000001),
    .Q(sig00000046)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000031 (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000080)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000032 (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000007f)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000033 (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000007e)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000034 (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000007d)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000035 (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000007c)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000036 (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000007b)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000037 (
    .C(clk),
    .D(sig00000034),
    .Q(sig0000007a)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000038 (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000079)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000039 (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000078)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000003a (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000077)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000003b (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000076)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000003c (
    .C(clk),
    .D(sig00000034),
    .Q(sig00000075)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000003d (
    .C(clk),
    .D(sig00000068),
    .Q(sig00000033)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000003e (
    .C(clk),
    .D(sig00000067),
    .Q(sig00000032)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000003f (
    .C(clk),
    .D(sig00000066),
    .Q(sig00000031)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000040 (
    .C(clk),
    .D(sig00000065),
    .Q(sig00000030)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000041 (
    .C(clk),
    .D(sig00000064),
    .Q(sig0000002f)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000042 (
    .C(clk),
    .D(sig00000063),
    .Q(sig0000002e)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000043 (
    .C(clk),
    .D(sig00000062),
    .Q(sig0000002d)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000044 (
    .C(clk),
    .D(sig00000061),
    .Q(sig0000002c)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000045 (
    .C(clk),
    .D(sig00000060),
    .Q(sig0000002b)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000046 (
    .C(clk),
    .D(sig0000005f),
    .Q(sig0000002a)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000047 (
    .C(clk),
    .D(sig0000005e),
    .Q(sig00000029)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000048 (
    .C(clk),
    .D(sig0000005d),
    .Q(sig00000028)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000049 (
    .C(clk),
    .D(sig0000005c),
    .Q(sig00000027)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000004a (
    .C(clk),
    .D(sig0000005b),
    .Q(sig00000026)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000004b (
    .C(clk),
    .D(sig0000005a),
    .Q(sig00000025)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000004c (
    .C(clk),
    .D(sig00000059),
    .Q(sig00000024)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000004d (
    .C(clk),
    .D(sig00000058),
    .Q(sig00000023)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000004e (
    .C(clk),
    .D(sig00000057),
    .Q(sig00000022)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000004f (
    .C(clk),
    .D(sig00000081),
    .Q(sig000000bd)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000050 (
    .C(clk),
    .D(sig00000093),
    .Q(sig000000bc)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000051 (
    .C(clk),
    .D(sig00000092),
    .Q(sig000000bb)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000052 (
    .C(clk),
    .D(sig00000091),
    .Q(sig000000ba)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000053 (
    .C(clk),
    .D(sig00000090),
    .Q(sig000000b9)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000054 (
    .C(clk),
    .D(sig0000008f),
    .Q(sig000000b8)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000055 (
    .C(clk),
    .D(sig0000008e),
    .Q(sig000000b7)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000056 (
    .C(clk),
    .D(sig0000008d),
    .Q(sig000000b6)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000057 (
    .C(clk),
    .D(sig0000008c),
    .Q(sig000000b5)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000058 (
    .C(clk),
    .D(sig0000008b),
    .Q(sig000000b4)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000059 (
    .C(clk),
    .D(phase_in[15]),
    .Q(sig000000c7)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000005a (
    .C(clk),
    .D(sig0000008a),
    .Q(sig000000c6)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000005b (
    .C(clk),
    .D(sig00000089),
    .Q(sig000000c5)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000005c (
    .C(clk),
    .D(sig00000088),
    .Q(sig000000c4)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000005d (
    .C(clk),
    .D(sig00000087),
    .Q(sig000000c3)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000005e (
    .C(clk),
    .D(sig00000086),
    .Q(sig000000c2)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000005f (
    .C(clk),
    .D(sig00000085),
    .Q(sig000000c1)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000060 (
    .C(clk),
    .D(sig00000084),
    .Q(sig000000c0)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000061 (
    .C(clk),
    .D(sig00000083),
    .Q(sig000000bf)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000062 (
    .C(clk),
    .D(sig00000082),
    .Q(sig000000be)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000063 (
    .C(clk),
    .D(sig000000a3),
    .Q(sig00000011)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000064 (
    .C(clk),
    .D(sig000000a2),
    .Q(sig00000010)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000065 (
    .C(clk),
    .D(sig000000a1),
    .Q(sig0000000f)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000066 (
    .C(clk),
    .D(sig000000a0),
    .Q(sig0000000e)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000067 (
    .C(clk),
    .D(sig0000009f),
    .Q(sig0000000d)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000068 (
    .C(clk),
    .D(sig0000009e),
    .Q(sig0000000c)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000069 (
    .C(clk),
    .D(sig0000009d),
    .Q(sig0000000b)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000006a (
    .C(clk),
    .D(sig0000009c),
    .Q(sig0000000a)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000006b (
    .C(clk),
    .D(sig0000009b),
    .Q(sig00000009)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000006c (
    .C(clk),
    .D(sig0000009a),
    .Q(sig00000008)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000006d (
    .C(clk),
    .D(sig00000099),
    .Q(sig00000007)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000006e (
    .C(clk),
    .D(sig00000098),
    .Q(sig00000006)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000006f (
    .C(clk),
    .D(sig00000097),
    .Q(sig00000005)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000070 (
    .C(clk),
    .D(sig00000096),
    .Q(sig00000004)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000071 (
    .C(clk),
    .D(sig00000095),
    .Q(sig00000003)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000072 (
    .C(clk),
    .D(sig00000094),
    .Q(sig00000002)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000073 (
    .C(clk),
    .D(sig000000b3),
    .Q(sig00000021)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000074 (
    .C(clk),
    .D(sig000000b2),
    .Q(sig00000020)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000075 (
    .C(clk),
    .D(sig000000b1),
    .Q(sig0000001f)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000076 (
    .C(clk),
    .D(sig000000b0),
    .Q(sig0000001e)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000077 (
    .C(clk),
    .D(sig000000af),
    .Q(sig0000001d)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000078 (
    .C(clk),
    .D(sig000000ae),
    .Q(sig0000001c)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000079 (
    .C(clk),
    .D(sig000000ad),
    .Q(sig0000001b)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000007a (
    .C(clk),
    .D(sig000000ac),
    .Q(sig0000001a)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000007b (
    .C(clk),
    .D(sig000000ab),
    .Q(sig00000019)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000007c (
    .C(clk),
    .D(sig000000aa),
    .Q(sig00000018)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000007d (
    .C(clk),
    .D(sig000000a9),
    .Q(sig00000017)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000007e (
    .C(clk),
    .D(sig000000a8),
    .Q(sig00000016)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk0000007f (
    .C(clk),
    .D(sig000000a7),
    .Q(sig00000015)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000080 (
    .C(clk),
    .D(sig000000a6),
    .Q(sig00000014)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000081 (
    .C(clk),
    .D(sig000000a5),
    .Q(sig00000013)
  );
  FD #(
    .INIT ( 1'b0 ))
  blk00000082 (
    .C(clk),
    .D(sig000000a4),
    .Q(sig00000012)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk00000083 (
    .I0(phase_in[5]),
    .I1(phase_in[14]),
    .O(sig0000008b)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk00000084 (
    .I0(phase_in[5]),
    .I1(phase_in[14]),
    .O(sig00000082)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk00000085 (
    .I0(phase_in[7]),
    .I1(phase_in[14]),
    .O(sig0000008d)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk00000086 (
    .I0(phase_in[7]),
    .I1(phase_in[14]),
    .O(sig00000084)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk00000087 (
    .I0(phase_in[8]),
    .I1(phase_in[14]),
    .O(sig0000008e)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk00000088 (
    .I0(phase_in[8]),
    .I1(phase_in[14]),
    .O(sig00000085)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk00000089 (
    .I0(phase_in[6]),
    .I1(phase_in[14]),
    .O(sig0000008c)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk0000008a (
    .I0(phase_in[6]),
    .I1(phase_in[14]),
    .O(sig00000083)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk0000008b (
    .I0(phase_in[10]),
    .I1(phase_in[14]),
    .O(sig00000090)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk0000008c (
    .I0(phase_in[10]),
    .I1(phase_in[14]),
    .O(sig00000087)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk0000008d (
    .I0(phase_in[11]),
    .I1(phase_in[14]),
    .O(sig00000091)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk0000008e (
    .I0(phase_in[11]),
    .I1(phase_in[14]),
    .O(sig00000088)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk0000008f (
    .I0(phase_in[9]),
    .I1(phase_in[14]),
    .O(sig0000008f)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk00000090 (
    .I0(phase_in[9]),
    .I1(phase_in[14]),
    .O(sig00000086)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk00000091 (
    .I0(phase_in[13]),
    .I1(phase_in[14]),
    .O(sig00000093)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk00000092 (
    .I0(phase_in[13]),
    .I1(phase_in[14]),
    .O(sig0000008a)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  blk00000093 (
    .I0(phase_in[12]),
    .I1(phase_in[14]),
    .O(sig00000092)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk00000094 (
    .I0(phase_in[12]),
    .I1(phase_in[14]),
    .O(sig00000089)
  );
  LUT2 #(
    .INIT ( 4'h6 ))
  blk00000095 (
    .I0(phase_in[15]),
    .I1(phase_in[14]),
    .O(sig00000081)
  );
  RAMB18E1 #(
    .INIT_00 ( 256'h061605B1054D04E80484041F03BB035602F2028D022901C4016000FB00970032 ),
    .INIT_01 ( 256'h0C5A0BF60B910B2D0AC90A650A01099D093808D40870080B07A7074306DE067A ),
    .INIT_02 ( 256'h1296123311CF116B110810A410410FDD0F790F150EB10E4D0DEA0D860D220CBE ),
    .INIT_03 ( 256'h18C718641802179F173C16D91676161315B0154D14EA1487142413C0135D12F9 ),
    .INIT_04 ( 256'h1EE91E871E251DC41D621D001C9E1C3C1BDA1B781B161AB31A5119EF198C192A ),
    .INIT_05 ( 256'h24F72497243723D62376231522B4225421F32192213120D0206E200D1FAC1F4A ),
    .INIT_06 ( 256'h2AEF2A902A3229D32974291428B5285627F62797273726D72678261825B82558 ),
    .INIT_07 ( 256'h30CD307030122FB52F582EFA2E9D2E3F2DE12D842D252CC72C692C0B2BAC2B4E ),
    .INIT_08 ( 256'h368C363135D6357A351F34C33468340C33B0335432F8329C323F31E331863129 ),
    .INIT_09 ( 256'h3C293BD13B783B1F3AC53A6C3A1239B9395F390538AB385137F7379C374136E7 ),
    .INIT_0A ( 256'h41A2414C40F5409E40473FF03F993F423EEB3E933E3B3DE33D8B3D333CDB3C82 ),
    .INIT_0B ( 256'h46F2469E464A45F645A2454E44F944A4444F43FA43A5434F42FA42A4424E41F8 ),
    .INIT_0C ( 256'h4C164BC54B744B234AD14A804A2E49DC498A493748E54892483F47EC47994746 ),
    .INIT_0D ( 256'h510C50BE507050214FD34F844F354EE64E974E484DF84DA84D584D084CB84C67 ),
    .INIT_0E ( 256'h55CF5584553954EE54A35458540C53C05374532752DB528E524151F451A75159 ),
    .INIT_0F ( 256'h5A5D5A1659CF5987593F58F758AE5866581D57D4578B574156F856AE5664561A ),
    .INIT_10 ( 256'h5EB45E705E2D5DE85DA45D5F5D1A5CD55C905C4A5C055BBF5B785B325AEB5AA5 ),
    .INIT_11 ( 256'h62D162916250621061CF618E614D610B60CA6088604660035FC15F7E5F3B5EF8 ),
    .INIT_12 ( 256'h66B06674663765FB65BE65816543650664C8648A644C640D63CE638F63506310 ),
    .INIT_13 ( 256'h6A506A1869DF69A7696E693568FC68C26888684E681367D9679E6763672766EC ),
    .INIT_14 ( 256'h6DAE6D7B6D466D126CDD6CA86C736C3D6C086BD16B9B6B656B2E6AF76ABF6A88 ),
    .INIT_15 ( 256'h70C9709A706A703970096FD86FA76F766F446F136EE16EAE6E7C6E496E166DE2 ),
    .INIT_16 ( 256'h739F73737348731C72F072C47297726A723D720F71E271B371857157712870F9 ),
    .INIT_17 ( 256'h762D760675DF75B7759075687540751774EF74C6749C74737449741F73F473CA ),
    .INIT_18 ( 256'h7872784F782D780A77E777C477A0777C77587734770F76EA76C5769F76797653 ),
    .INIT_19 ( 256'h7A6C7A4F7A317A1379F579D679B77998797879597938791878F778D678B57894 ),
    .INIT_1A ( 256'h7C1C7C037BEA7BD17BB77B9D7B837B687B4E7B337B177AFB7ADF7AC37AA77A8A ),
    .INIT_1B ( 256'h7D7F7D6B7D567D427D2D7D187D037CED7CD77CC07CAA7C937C7C7C647C4C7C34 ),
    .INIT_1C ( 256'h7E947E857E767E667E567E467E357E247E137E017DF07DDE7DCB7DB87DA57D92 ),
    .INIT_1D ( 256'h7F5B7F517F477F3C7F317F257F1A7F0E7F017EF57EE87EDB7ECD7EBF7EB17EA3 ),
    .INIT_1E ( 256'h7FD47FCF7FC97FC37FBD7FB77FB07FA97FA17F9A7F927F897F817F787F6F7F65 ),
    .INIT_1F ( 256'h7FFE7FFE7FFD7FFC7FFB7FF97FF77FF57FF37FF07FED7FEA7FE67FE27FDE7FD9 ),
    .INIT_20 ( 256'hF9EAFA4FFAB3FB18FB7CFBE1FC45FCAAFD0EFD73FDD7FE3CFEA0FF05FF69FFCE ),
    .INIT_21 ( 256'hF3A6F40AF46FF4D3F537F59BF5FFF663F6C8F72CF790F7F5F859F8BDF922F986 ),
    .INIT_22 ( 256'hED6AEDCDEE31EE95EEF8EF5CEFBFF023F087F0EBF14FF1B3F216F27AF2DEF342 ),
    .INIT_23 ( 256'hE739E79CE7FEE861E8C4E927E98AE9EDEA50EAB3EB16EB79EBDCEC40ECA3ED07 ),
    .INIT_24 ( 256'hE117E179E1DBE23CE29EE300E362E3C4E426E488E4EAE54DE5AFE611E674E6D6 ),
    .INIT_25 ( 256'hDB09DB69DBC9DC2ADC8ADCEBDD4CDDACDE0DDE6EDECFDF30DF92DFF3E054E0B6 ),
    .INIT_26 ( 256'hD511D570D5CED62DD68CD6ECD74BD7AAD80AD869D8C9D929D988D9E8DA48DAA8 ),
    .INIT_27 ( 256'hCF33CF90CFEED04BD0A8D106D163D1C1D21FD27CD2DBD339D397D3F5D454D4B2 ),
    .INIT_28 ( 256'hC974C9CFCA2ACA86CAE1CB3DCB98CBF4CC50CCACCD08CD64CDC1CE1DCE7ACED7 ),
    .INIT_29 ( 256'hC3D7C42FC488C4E1C53BC594C5EEC647C6A1C6FBC755C7AFC809C864C8BFC919 ),
    .INIT_2A ( 256'hBE5EBEB4BF0BBF62BFB9C010C067C0BEC115C16DC1C5C21DC275C2CDC325C37E ),
    .INIT_2B ( 256'hB90EB962B9B6BA0ABA5EBAB2BB07BB5CBBB1BC06BC5BBCB1BD06BD5CBDB2BE08 ),
    .INIT_2C ( 256'hB3EAB43BB48CB4DDB52FB580B5D2B624B676B6C9B71BB76EB7C1B814B867B8BA ),
    .INIT_2D ( 256'hAEF4AF42AF90AFDFB02DB07CB0CBB11AB169B1B8B208B258B2A8B2F8B348B399 ),
    .INIT_2E ( 256'hAA31AA7CAAC7AB12AB5DABA8ABF4AC40AC8CACD9AD25AD72ADBFAE0CAE59AEA7 ),
    .INIT_2F ( 256'hA5A3A5EAA631A679A6C1A709A752A79AA7E3A82CA875A8BFA908A952A99CA9E6 ),
    .INIT_30 ( 256'hA14CA190A1D3A218A25CA2A1A2E6A32BA370A3B6A3FBA441A488A4CEA515A55B ),
    .INIT_31 ( 256'h9D2F9D6F9DB09DF09E319E729EB39EF59F369F789FBA9FFDA03FA082A0C5A108 ),
    .INIT_32 ( 256'h9950998C99C99A059A429A7F9ABD9AFA9B389B769BB49BF39C329C719CB09CF0 ),
    .INIT_33 ( 256'h95B095E896219659969296CB9704973E977897B297ED98279862989D98D99914 ),
    .INIT_34 ( 256'h9252928592BA92EE93239358938D93C393F8942F9465949B94D2950995419578 ),
    .INIT_35 ( 256'h8F378F668F968FC78FF790289059908A90BC90ED911F9152918491B791EA921E ),
    .INIT_36 ( 256'h8C618C8D8CB88CE48D108D3C8D698D968DC38DF18E1E8E4D8E7B8EA98ED88F07 ),
    .INIT_37 ( 256'h89D389FA8A218A498A708A988AC08AE98B118B3A8B648B8D8BB78BE18C0C8C36 ),
    .INIT_38 ( 256'h878E87B187D387F68819883C8860888488A888CC88F18916893B8961898789AD ),
    .INIT_39 ( 256'h859485B185CF85ED860B862A86498668868886A786C886E88709872A874B876C ),
    .INIT_3A ( 256'h83E483FD8416842F84498463847D849884B284CD84E985058521853D85598576 ),
    .INIT_3B ( 256'h8281829582AA82BE82D382E882FD8313832983408356836D8384839C83B483CC ),
    .INIT_3C ( 256'h816C817B818A819A81AA81BA81CB81DC81ED81FF8210822282358248825B826E ),
    .INIT_3D ( 256'h80A580AF80B980C480CF80DB80E680F280FF810B8118812581338141814F815D ),
    .INIT_3E ( 256'h802C80318037803D8043804980508057805F8066806E8077807F80888091809B ),
    .INIT_3F ( 256'h8002800280038004800580078009800B800D801080138016801A801E80228027 ),
    .INIT_A ( 18'h00000 ),
    .INIT_B ( 18'h00000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ),
    .DOA_REG ( 1 ),
    .DOB_REG ( 1 ),
    .READ_WIDTH_A ( 18 ),
    .READ_WIDTH_B ( 18 ),
    .WRITE_WIDTH_A ( 18 ),
    .WRITE_WIDTH_B ( 0 ),
    .INITP_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .RAM_MODE ( "TDP" ),
    .RDADDR_COLLISION_HWCONFIG ( "DELAYED_WRITE" ),
    .RSTREG_PRIORITY_A ( "RSTREG" ),
    .RSTREG_PRIORITY_B ( "RSTREG" ),
    .SRVAL_A ( 18'h00000 ),
    .SRVAL_B ( 18'h00000 ),
    .SIM_COLLISION_CHECK ( "ALL" ),
    .INIT_FILE ( "NONE" ))
  blk00000096 (
    .CLKARDCLK(clk),
    .CLKBWRCLK(clk),
    .ENARDEN(sig00000001),
    .ENBWREN(sig00000001),
    .REGCEAREGCE(sig00000001),
    .REGCEB(sig00000001),
    .RSTRAMARSTRAM(sig00000034),
    .RSTRAMB(sig00000034),
    .RSTREGARSTREG(sig00000034),
    .RSTREGB(sig00000034),
    .ADDRARDADDR({sig000000c7, sig000000c6, sig000000c5, sig000000c4, sig000000c3, sig000000c2, sig000000c1, sig000000c0, sig000000bf, sig000000be, 
sig00000001, sig00000001, sig00000001, sig00000001}),
    .ADDRBWRADDR({sig000000bd, sig000000bc, sig000000bb, sig000000ba, sig000000b9, sig000000b8, sig000000b7, sig000000b6, sig000000b5, sig000000b4, 
sig00000001, sig00000001, sig00000001, sig00000001}),
    .DIADI({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034}),
    .DIBDI({\NLW_blk00000096_DIBDI<15>_UNCONNECTED , \NLW_blk00000096_DIBDI<14>_UNCONNECTED , \NLW_blk00000096_DIBDI<13>_UNCONNECTED , 
\NLW_blk00000096_DIBDI<12>_UNCONNECTED , \NLW_blk00000096_DIBDI<11>_UNCONNECTED , \NLW_blk00000096_DIBDI<10>_UNCONNECTED , 
\NLW_blk00000096_DIBDI<9>_UNCONNECTED , \NLW_blk00000096_DIBDI<8>_UNCONNECTED , \NLW_blk00000096_DIBDI<7>_UNCONNECTED , 
\NLW_blk00000096_DIBDI<6>_UNCONNECTED , \NLW_blk00000096_DIBDI<5>_UNCONNECTED , \NLW_blk00000096_DIBDI<4>_UNCONNECTED , 
\NLW_blk00000096_DIBDI<3>_UNCONNECTED , \NLW_blk00000096_DIBDI<2>_UNCONNECTED , \NLW_blk00000096_DIBDI<1>_UNCONNECTED , 
\NLW_blk00000096_DIBDI<0>_UNCONNECTED }),
    .DIPADIP({sig00000034, sig00000034}),
    .DIPBDIP({\NLW_blk00000096_DIPBDIP<1>_UNCONNECTED , \NLW_blk00000096_DIPBDIP<0>_UNCONNECTED }),
    .DOADO({sig000000b3, sig000000b2, sig000000b1, sig000000b0, sig000000af, sig000000ae, sig000000ad, sig000000ac, sig000000ab, sig000000aa, 
sig000000a9, sig000000a8, sig000000a7, sig000000a6, sig000000a5, sig000000a4}),
    .DOBDO({sig000000a3, sig000000a2, sig000000a1, sig000000a0, sig0000009f, sig0000009e, sig0000009d, sig0000009c, sig0000009b, sig0000009a, 
sig00000099, sig00000098, sig00000097, sig00000096, sig00000095, sig00000094}),
    .DOPADOP({\NLW_blk00000096_DOPADOP<1>_UNCONNECTED , \NLW_blk00000096_DOPADOP<0>_UNCONNECTED }),
    .DOPBDOP({\NLW_blk00000096_DOPBDOP<1>_UNCONNECTED , \NLW_blk00000096_DOPBDOP<0>_UNCONNECTED }),
    .WEA({sig00000034, sig00000034}),
    .WEBWE({sig00000034, sig00000034, sig00000034, sig00000034})
  );
  DSP48E #(
    .ACASCREG ( 1 ),
    .ALUMODEREG ( 1 ),
    .AREG ( 1 ),
    .AUTORESET_PATTERN_DETECT ( "FALSE" ),
    .AUTORESET_PATTERN_DETECT_OPTINV ( "MATCH" ),
    .A_INPUT ( "DIRECT" ),
    .BCASCREG ( 1 ),
    .BREG ( 1 ),
    .B_INPUT ( "DIRECT" ),
    .CARRYINREG ( 1 ),
    .CARRYINSELREG ( 0 ),
    .CREG ( 1 ),
    .MASK ( 48'h3FFFFFFFFFFF ),
    .MREG ( 1 ),
    .MULTCARRYINREG ( 0 ),
    .OPMODEREG ( 0 ),
    .PATTERN ( 48'h000000000000 ),
    .PREG ( 1 ),
    .SEL_MASK ( "MASK" ),
    .SEL_PATTERN ( "PATTERN" ),
    .SEL_ROUNDING_MASK ( "SEL_MASK" ),
    .SIM_MODE ( "SAFE" ),
    .USE_MULT ( "MULT_S" ),
    .USE_PATTERN_DETECT ( "NO_PATDET" ),
    .USE_SIMD ( "ONE48" ))
  blk00000097 (
    .CLK(clk),
    .PATTERNBDETECT(NLW_blk00000097_PATTERNBDETECT_UNCONNECTED),
    .RSTC(sig00000034),
    .CEB1(sig00000034),
    .MULTSIGNOUT(NLW_blk00000097_MULTSIGNOUT_UNCONNECTED),
    .CEC(sig00000001),
    .RSTM(sig00000034),
    .MULTSIGNIN(sig00000034),
    .CEB2(sig00000001),
    .RSTCTRL(sig00000034),
    .CEP(sig00000001),
    .CARRYCASCOUT(NLW_blk00000097_CARRYCASCOUT_UNCONNECTED),
    .RSTA(sig00000034),
    .CECARRYIN(sig00000001),
    .UNDERFLOW(NLW_blk00000097_UNDERFLOW_UNCONNECTED),
    .PATTERNDETECT(NLW_blk00000097_PATTERNDETECT_UNCONNECTED),
    .RSTALUMODE(sig00000034),
    .RSTALLCARRYIN(sig00000034),
    .CEALUMODE(sig00000001),
    .CEA2(sig00000001),
    .CEA1(sig00000034),
    .RSTB(sig00000034),
    .CEMULTCARRYIN(sig00000034),
    .OVERFLOW(NLW_blk00000097_OVERFLOW_UNCONNECTED),
    .CECTRL(sig00000034),
    .CEM(sig00000001),
    .CARRYIN(sig00000034),
    .CARRYCASCIN(sig00000034),
    .RSTP(sig00000034),
    .CARRYINSEL({sig00000034, sig00000034, sig00000034}),
    .A({sig00000021, sig00000021, sig00000021, sig00000021, sig00000021, sig00000021, sig00000021, sig00000021, sig00000021, sig00000021, sig00000021
, sig00000021, sig00000021, sig00000020, sig0000001f, sig0000001e, sig0000001d, sig0000001c, sig0000001b, sig0000001a, sig00000019, sig00000018, 
sig00000017, sig00000016, sig00000015, sig00000014, sig00000013, sig00000012, sig00000001, sig00000034}),
    .C({sig00000045, sig00000045, sig00000045, sig00000045, sig00000045, sig00000045, sig00000045, sig00000044, sig00000043, sig00000042, sig00000041
, sig00000040, sig0000003f, sig0000003e, sig0000003d, sig0000003c, sig0000003b, sig0000003a, sig00000039, sig00000038, sig00000037, sig00000036, 
sig00000035, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000001, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034}),
    .B({sig00000033, sig00000032, sig00000031, sig00000030, sig0000002f, sig0000002e, sig0000002d, sig0000002c, sig0000002b, sig0000002a, sig00000029
, sig00000028, sig00000027, sig00000026, sig00000025, sig00000024, sig00000023, sig00000022}),
    .P({\NLW_blk00000097_P<47>_UNCONNECTED , \NLW_blk00000097_P<46>_UNCONNECTED , \NLW_blk00000097_P<45>_UNCONNECTED , 
\NLW_blk00000097_P<44>_UNCONNECTED , \NLW_blk00000097_P<43>_UNCONNECTED , \NLW_blk00000097_P<42>_UNCONNECTED , \NLW_blk00000097_P<41>_UNCONNECTED , 
\NLW_blk00000097_P<40>_UNCONNECTED , \NLW_blk00000097_P<39>_UNCONNECTED , \NLW_blk00000097_P<38>_UNCONNECTED , \NLW_blk00000097_P<37>_UNCONNECTED , 
\NLW_blk00000097_P<36>_UNCONNECTED , \NLW_blk00000097_P<35>_UNCONNECTED , \NLW_blk00000097_P<34>_UNCONNECTED , \NLW_blk00000097_P<33>_UNCONNECTED , 
\NLW_blk00000097_P<32>_UNCONNECTED , \NLW_blk00000097_P<31>_UNCONNECTED , \NLW_blk00000097_P<30>_UNCONNECTED , \NLW_blk00000097_P<29>_UNCONNECTED , 
\NLW_blk00000097_P<28>_UNCONNECTED , \NLW_blk00000097_P<27>_UNCONNECTED , \NLW_blk00000097_P<26>_UNCONNECTED , \NLW_blk00000097_P<25>_UNCONNECTED , 
\NLW_blk00000097_P<24>_UNCONNECTED , \NLW_blk00000097_P<23>_UNCONNECTED , \NLW_blk00000097_P<22>_UNCONNECTED , \NLW_blk00000097_P<21>_UNCONNECTED , 
\NLW_blk00000097_P<20>_UNCONNECTED , \NLW_blk00000097_P<19>_UNCONNECTED , \NLW_blk00000097_P<18>_UNCONNECTED , \NLW_blk00000097_P<17>_UNCONNECTED , 
\NLW_blk00000097_P<16>_UNCONNECTED , \NLW_blk00000097_P<15>_UNCONNECTED , \NLW_blk00000097_P<14>_UNCONNECTED , \NLW_blk00000097_P<13>_UNCONNECTED , 
\NLW_blk00000097_P<12>_UNCONNECTED , \NLW_blk00000097_P<11>_UNCONNECTED , \NLW_blk00000097_P<10>_UNCONNECTED , \NLW_blk00000097_P<9>_UNCONNECTED , 
\NLW_blk00000097_P<8>_UNCONNECTED , \NLW_blk00000097_P<7>_UNCONNECTED , \NLW_blk00000097_P<6>_UNCONNECTED , \NLW_blk00000097_P<5>_UNCONNECTED , 
\NLW_blk00000097_P<4>_UNCONNECTED , \NLW_blk00000097_P<3>_UNCONNECTED , \NLW_blk00000097_P<2>_UNCONNECTED , \NLW_blk00000097_P<1>_UNCONNECTED , 
\NLW_blk00000097_P<0>_UNCONNECTED }),
    .ACOUT({\NLW_blk00000097_ACOUT<29>_UNCONNECTED , \NLW_blk00000097_ACOUT<28>_UNCONNECTED , \NLW_blk00000097_ACOUT<27>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<26>_UNCONNECTED , \NLW_blk00000097_ACOUT<25>_UNCONNECTED , \NLW_blk00000097_ACOUT<24>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<23>_UNCONNECTED , \NLW_blk00000097_ACOUT<22>_UNCONNECTED , \NLW_blk00000097_ACOUT<21>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<20>_UNCONNECTED , \NLW_blk00000097_ACOUT<19>_UNCONNECTED , \NLW_blk00000097_ACOUT<18>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<17>_UNCONNECTED , \NLW_blk00000097_ACOUT<16>_UNCONNECTED , \NLW_blk00000097_ACOUT<15>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<14>_UNCONNECTED , \NLW_blk00000097_ACOUT<13>_UNCONNECTED , \NLW_blk00000097_ACOUT<12>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<11>_UNCONNECTED , \NLW_blk00000097_ACOUT<10>_UNCONNECTED , \NLW_blk00000097_ACOUT<9>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<8>_UNCONNECTED , \NLW_blk00000097_ACOUT<7>_UNCONNECTED , \NLW_blk00000097_ACOUT<6>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<5>_UNCONNECTED , \NLW_blk00000097_ACOUT<4>_UNCONNECTED , \NLW_blk00000097_ACOUT<3>_UNCONNECTED , 
\NLW_blk00000097_ACOUT<2>_UNCONNECTED , \NLW_blk00000097_ACOUT<1>_UNCONNECTED , \NLW_blk00000097_ACOUT<0>_UNCONNECTED }),
    .OPMODE({sig00000034, sig00000001, sig00000001, sig00000034, sig00000001, sig00000034, sig00000001}),
    .PCIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034}),
    .ALUMODE({sig00000034, sig00000034, sig00000001, sig00000001}),
    .CARRYOUT({\NLW_blk00000097_CARRYOUT<3>_UNCONNECTED , \NLW_blk00000097_CARRYOUT<2>_UNCONNECTED , \NLW_blk00000097_CARRYOUT<1>_UNCONNECTED , 
\NLW_blk00000097_CARRYOUT<0>_UNCONNECTED }),
    .BCIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034}),
    .BCOUT({\NLW_blk00000097_BCOUT<17>_UNCONNECTED , \NLW_blk00000097_BCOUT<16>_UNCONNECTED , \NLW_blk00000097_BCOUT<15>_UNCONNECTED , 
\NLW_blk00000097_BCOUT<14>_UNCONNECTED , \NLW_blk00000097_BCOUT<13>_UNCONNECTED , \NLW_blk00000097_BCOUT<12>_UNCONNECTED , 
\NLW_blk00000097_BCOUT<11>_UNCONNECTED , \NLW_blk00000097_BCOUT<10>_UNCONNECTED , \NLW_blk00000097_BCOUT<9>_UNCONNECTED , 
\NLW_blk00000097_BCOUT<8>_UNCONNECTED , \NLW_blk00000097_BCOUT<7>_UNCONNECTED , \NLW_blk00000097_BCOUT<6>_UNCONNECTED , 
\NLW_blk00000097_BCOUT<5>_UNCONNECTED , \NLW_blk00000097_BCOUT<4>_UNCONNECTED , \NLW_blk00000097_BCOUT<3>_UNCONNECTED , 
\NLW_blk00000097_BCOUT<2>_UNCONNECTED , \NLW_blk00000097_BCOUT<1>_UNCONNECTED , \NLW_blk00000097_BCOUT<0>_UNCONNECTED }),
    .PCOUT({\NLW_blk00000097_PCOUT<47>_UNCONNECTED , \NLW_blk00000097_PCOUT<46>_UNCONNECTED , \NLW_blk00000097_PCOUT<45>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<44>_UNCONNECTED , \NLW_blk00000097_PCOUT<43>_UNCONNECTED , \NLW_blk00000097_PCOUT<42>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<41>_UNCONNECTED , \NLW_blk00000097_PCOUT<40>_UNCONNECTED , \NLW_blk00000097_PCOUT<39>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<38>_UNCONNECTED , \NLW_blk00000097_PCOUT<37>_UNCONNECTED , \NLW_blk00000097_PCOUT<36>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<35>_UNCONNECTED , \NLW_blk00000097_PCOUT<34>_UNCONNECTED , \NLW_blk00000097_PCOUT<33>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<32>_UNCONNECTED , \NLW_blk00000097_PCOUT<31>_UNCONNECTED , \NLW_blk00000097_PCOUT<30>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<29>_UNCONNECTED , \NLW_blk00000097_PCOUT<28>_UNCONNECTED , \NLW_blk00000097_PCOUT<27>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<26>_UNCONNECTED , \NLW_blk00000097_PCOUT<25>_UNCONNECTED , \NLW_blk00000097_PCOUT<24>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<23>_UNCONNECTED , \NLW_blk00000097_PCOUT<22>_UNCONNECTED , \NLW_blk00000097_PCOUT<21>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<20>_UNCONNECTED , \NLW_blk00000097_PCOUT<19>_UNCONNECTED , \NLW_blk00000097_PCOUT<18>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<17>_UNCONNECTED , \NLW_blk00000097_PCOUT<16>_UNCONNECTED , \NLW_blk00000097_PCOUT<15>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<14>_UNCONNECTED , \NLW_blk00000097_PCOUT<13>_UNCONNECTED , \NLW_blk00000097_PCOUT<12>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<11>_UNCONNECTED , \NLW_blk00000097_PCOUT<10>_UNCONNECTED , \NLW_blk00000097_PCOUT<9>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<8>_UNCONNECTED , \NLW_blk00000097_PCOUT<7>_UNCONNECTED , \NLW_blk00000097_PCOUT<6>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<5>_UNCONNECTED , \NLW_blk00000097_PCOUT<4>_UNCONNECTED , \NLW_blk00000097_PCOUT<3>_UNCONNECTED , 
\NLW_blk00000097_PCOUT<2>_UNCONNECTED , \NLW_blk00000097_PCOUT<1>_UNCONNECTED , \NLW_blk00000097_PCOUT<0>_UNCONNECTED }),
    .ACIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034})
  );
  DSP48E #(
    .ACASCREG ( 1 ),
    .ALUMODEREG ( 1 ),
    .AREG ( 1 ),
    .AUTORESET_PATTERN_DETECT ( "FALSE" ),
    .AUTORESET_PATTERN_DETECT_OPTINV ( "MATCH" ),
    .A_INPUT ( "DIRECT" ),
    .BCASCREG ( 1 ),
    .BREG ( 1 ),
    .B_INPUT ( "DIRECT" ),
    .CARRYINREG ( 1 ),
    .CARRYINSELREG ( 0 ),
    .CREG ( 1 ),
    .MASK ( 48'h3FFFFFFFFFFF ),
    .MREG ( 1 ),
    .MULTCARRYINREG ( 0 ),
    .OPMODEREG ( 0 ),
    .PATTERN ( 48'h000000000000 ),
    .PREG ( 1 ),
    .SEL_MASK ( "MASK" ),
    .SEL_PATTERN ( "PATTERN" ),
    .SEL_ROUNDING_MASK ( "SEL_MASK" ),
    .SIM_MODE ( "SAFE" ),
    .USE_MULT ( "MULT_S" ),
    .USE_PATTERN_DETECT ( "NO_PATDET" ),
    .USE_SIMD ( "ONE48" ))
  blk00000098 (
    .CLK(clk),
    .PATTERNBDETECT(NLW_blk00000098_PATTERNBDETECT_UNCONNECTED),
    .RSTC(sig00000034),
    .CEB1(sig00000034),
    .MULTSIGNOUT(NLW_blk00000098_MULTSIGNOUT_UNCONNECTED),
    .CEC(sig00000001),
    .RSTM(sig00000034),
    .MULTSIGNIN(sig00000034),
    .CEB2(sig00000001),
    .RSTCTRL(sig00000034),
    .CEP(sig00000001),
    .CARRYCASCOUT(NLW_blk00000098_CARRYCASCOUT_UNCONNECTED),
    .RSTA(sig00000034),
    .CECARRYIN(sig00000001),
    .UNDERFLOW(NLW_blk00000098_UNDERFLOW_UNCONNECTED),
    .PATTERNDETECT(NLW_blk00000098_PATTERNDETECT_UNCONNECTED),
    .RSTALUMODE(sig00000034),
    .RSTALLCARRYIN(sig00000034),
    .CEALUMODE(sig00000001),
    .CEA2(sig00000001),
    .CEA1(sig00000034),
    .RSTB(sig00000034),
    .CEMULTCARRYIN(sig00000034),
    .OVERFLOW(NLW_blk00000098_OVERFLOW_UNCONNECTED),
    .CECTRL(sig00000034),
    .CEM(sig00000001),
    .CARRYIN(sig00000034),
    .CARRYCASCIN(sig00000034),
    .RSTP(sig00000034),
    .CARRYINSEL({sig00000034, sig00000034, sig00000034}),
    .A({sig00000011, sig00000011, sig00000011, sig00000011, sig00000011, sig00000011, sig00000011, sig00000011, sig00000011, sig00000011, sig00000011
, sig00000011, sig00000011, sig00000010, sig0000000f, sig0000000e, sig0000000d, sig0000000c, sig0000000b, sig0000000a, sig00000009, sig00000008, 
sig00000007, sig00000006, sig00000005, sig00000004, sig00000003, sig00000002, sig00000001, sig00000034}),
    .C({sig00000056, sig00000056, sig00000056, sig00000056, sig00000056, sig00000056, sig00000056, sig00000055, sig00000054, sig00000053, sig00000052
, sig00000051, sig00000050, sig0000004f, sig0000004e, sig0000004d, sig0000004c, sig0000004b, sig0000004a, sig00000049, sig00000048, sig00000047, 
sig00000046, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000001, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034}),
    .B({sig00000033, sig00000032, sig00000031, sig00000030, sig0000002f, sig0000002e, sig0000002d, sig0000002c, sig0000002b, sig0000002a, sig00000029
, sig00000028, sig00000027, sig00000026, sig00000025, sig00000024, sig00000023, sig00000022}),
    .P({\NLW_blk00000098_P<47>_UNCONNECTED , \NLW_blk00000098_P<46>_UNCONNECTED , \NLW_blk00000098_P<45>_UNCONNECTED , 
\NLW_blk00000098_P<44>_UNCONNECTED , \NLW_blk00000098_P<43>_UNCONNECTED , \NLW_blk00000098_P<42>_UNCONNECTED , sine[15], sine[14], sine[13], sine[12]
, sine[11], sine[10], sine[9], sine[8], sine[7], sine[6], sine[5], sine[4], sine[3], sine[2], sine[1], sine[0], \NLW_blk00000098_P<25>_UNCONNECTED , 
\NLW_blk00000098_P<24>_UNCONNECTED , \NLW_blk00000098_P<23>_UNCONNECTED , \NLW_blk00000098_P<22>_UNCONNECTED , \NLW_blk00000098_P<21>_UNCONNECTED , 
\NLW_blk00000098_P<20>_UNCONNECTED , \NLW_blk00000098_P<19>_UNCONNECTED , \NLW_blk00000098_P<18>_UNCONNECTED , \NLW_blk00000098_P<17>_UNCONNECTED , 
\NLW_blk00000098_P<16>_UNCONNECTED , \NLW_blk00000098_P<15>_UNCONNECTED , \NLW_blk00000098_P<14>_UNCONNECTED , \NLW_blk00000098_P<13>_UNCONNECTED , 
\NLW_blk00000098_P<12>_UNCONNECTED , \NLW_blk00000098_P<11>_UNCONNECTED , \NLW_blk00000098_P<10>_UNCONNECTED , \NLW_blk00000098_P<9>_UNCONNECTED , 
\NLW_blk00000098_P<8>_UNCONNECTED , \NLW_blk00000098_P<7>_UNCONNECTED , \NLW_blk00000098_P<6>_UNCONNECTED , \NLW_blk00000098_P<5>_UNCONNECTED , 
\NLW_blk00000098_P<4>_UNCONNECTED , \NLW_blk00000098_P<3>_UNCONNECTED , \NLW_blk00000098_P<2>_UNCONNECTED , \NLW_blk00000098_P<1>_UNCONNECTED , 
\NLW_blk00000098_P<0>_UNCONNECTED }),
    .ACOUT({\NLW_blk00000098_ACOUT<29>_UNCONNECTED , \NLW_blk00000098_ACOUT<28>_UNCONNECTED , \NLW_blk00000098_ACOUT<27>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<26>_UNCONNECTED , \NLW_blk00000098_ACOUT<25>_UNCONNECTED , \NLW_blk00000098_ACOUT<24>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<23>_UNCONNECTED , \NLW_blk00000098_ACOUT<22>_UNCONNECTED , \NLW_blk00000098_ACOUT<21>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<20>_UNCONNECTED , \NLW_blk00000098_ACOUT<19>_UNCONNECTED , \NLW_blk00000098_ACOUT<18>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<17>_UNCONNECTED , \NLW_blk00000098_ACOUT<16>_UNCONNECTED , \NLW_blk00000098_ACOUT<15>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<14>_UNCONNECTED , \NLW_blk00000098_ACOUT<13>_UNCONNECTED , \NLW_blk00000098_ACOUT<12>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<11>_UNCONNECTED , \NLW_blk00000098_ACOUT<10>_UNCONNECTED , \NLW_blk00000098_ACOUT<9>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<8>_UNCONNECTED , \NLW_blk00000098_ACOUT<7>_UNCONNECTED , \NLW_blk00000098_ACOUT<6>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<5>_UNCONNECTED , \NLW_blk00000098_ACOUT<4>_UNCONNECTED , \NLW_blk00000098_ACOUT<3>_UNCONNECTED , 
\NLW_blk00000098_ACOUT<2>_UNCONNECTED , \NLW_blk00000098_ACOUT<1>_UNCONNECTED , \NLW_blk00000098_ACOUT<0>_UNCONNECTED }),
    .OPMODE({sig00000034, sig00000001, sig00000001, sig00000034, sig00000001, sig00000034, sig00000001}),
    .PCIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034}),
    .ALUMODE({sig00000034, sig00000034, sig00000034, sig00000034}),
    .CARRYOUT({\NLW_blk00000098_CARRYOUT<3>_UNCONNECTED , \NLW_blk00000098_CARRYOUT<2>_UNCONNECTED , \NLW_blk00000098_CARRYOUT<1>_UNCONNECTED , 
\NLW_blk00000098_CARRYOUT<0>_UNCONNECTED }),
    .BCIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034}),
    .BCOUT({\NLW_blk00000098_BCOUT<17>_UNCONNECTED , \NLW_blk00000098_BCOUT<16>_UNCONNECTED , \NLW_blk00000098_BCOUT<15>_UNCONNECTED , 
\NLW_blk00000098_BCOUT<14>_UNCONNECTED , \NLW_blk00000098_BCOUT<13>_UNCONNECTED , \NLW_blk00000098_BCOUT<12>_UNCONNECTED , 
\NLW_blk00000098_BCOUT<11>_UNCONNECTED , \NLW_blk00000098_BCOUT<10>_UNCONNECTED , \NLW_blk00000098_BCOUT<9>_UNCONNECTED , 
\NLW_blk00000098_BCOUT<8>_UNCONNECTED , \NLW_blk00000098_BCOUT<7>_UNCONNECTED , \NLW_blk00000098_BCOUT<6>_UNCONNECTED , 
\NLW_blk00000098_BCOUT<5>_UNCONNECTED , \NLW_blk00000098_BCOUT<4>_UNCONNECTED , \NLW_blk00000098_BCOUT<3>_UNCONNECTED , 
\NLW_blk00000098_BCOUT<2>_UNCONNECTED , \NLW_blk00000098_BCOUT<1>_UNCONNECTED , \NLW_blk00000098_BCOUT<0>_UNCONNECTED }),
    .PCOUT({\NLW_blk00000098_PCOUT<47>_UNCONNECTED , \NLW_blk00000098_PCOUT<46>_UNCONNECTED , \NLW_blk00000098_PCOUT<45>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<44>_UNCONNECTED , \NLW_blk00000098_PCOUT<43>_UNCONNECTED , \NLW_blk00000098_PCOUT<42>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<41>_UNCONNECTED , \NLW_blk00000098_PCOUT<40>_UNCONNECTED , \NLW_blk00000098_PCOUT<39>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<38>_UNCONNECTED , \NLW_blk00000098_PCOUT<37>_UNCONNECTED , \NLW_blk00000098_PCOUT<36>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<35>_UNCONNECTED , \NLW_blk00000098_PCOUT<34>_UNCONNECTED , \NLW_blk00000098_PCOUT<33>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<32>_UNCONNECTED , \NLW_blk00000098_PCOUT<31>_UNCONNECTED , \NLW_blk00000098_PCOUT<30>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<29>_UNCONNECTED , \NLW_blk00000098_PCOUT<28>_UNCONNECTED , \NLW_blk00000098_PCOUT<27>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<26>_UNCONNECTED , \NLW_blk00000098_PCOUT<25>_UNCONNECTED , \NLW_blk00000098_PCOUT<24>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<23>_UNCONNECTED , \NLW_blk00000098_PCOUT<22>_UNCONNECTED , \NLW_blk00000098_PCOUT<21>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<20>_UNCONNECTED , \NLW_blk00000098_PCOUT<19>_UNCONNECTED , \NLW_blk00000098_PCOUT<18>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<17>_UNCONNECTED , \NLW_blk00000098_PCOUT<16>_UNCONNECTED , \NLW_blk00000098_PCOUT<15>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<14>_UNCONNECTED , \NLW_blk00000098_PCOUT<13>_UNCONNECTED , \NLW_blk00000098_PCOUT<12>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<11>_UNCONNECTED , \NLW_blk00000098_PCOUT<10>_UNCONNECTED , \NLW_blk00000098_PCOUT<9>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<8>_UNCONNECTED , \NLW_blk00000098_PCOUT<7>_UNCONNECTED , \NLW_blk00000098_PCOUT<6>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<5>_UNCONNECTED , \NLW_blk00000098_PCOUT<4>_UNCONNECTED , \NLW_blk00000098_PCOUT<3>_UNCONNECTED , 
\NLW_blk00000098_PCOUT<2>_UNCONNECTED , \NLW_blk00000098_PCOUT<1>_UNCONNECTED , \NLW_blk00000098_PCOUT<0>_UNCONNECTED }),
    .ACIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034})
  );
  DSP48E #(
    .ACASCREG ( 1 ),
    .ALUMODEREG ( 1 ),
    .AREG ( 1 ),
    .AUTORESET_PATTERN_DETECT ( "FALSE" ),
    .AUTORESET_PATTERN_DETECT_OPTINV ( "MATCH" ),
    .A_INPUT ( "DIRECT" ),
    .BCASCREG ( 1 ),
    .BREG ( 1 ),
    .B_INPUT ( "DIRECT" ),
    .CARRYINREG ( 1 ),
    .CARRYINSELREG ( 0 ),
    .CREG ( 1 ),
    .MASK ( 48'h3FFFFFFFFFFF ),
    .MREG ( 1 ),
    .MULTCARRYINREG ( 0 ),
    .OPMODEREG ( 0 ),
    .PATTERN ( 48'h000000000000 ),
    .PREG ( 1 ),
    .SEL_MASK ( "MASK" ),
    .SEL_PATTERN ( "PATTERN" ),
    .SEL_ROUNDING_MASK ( "SEL_MASK" ),
    .SIM_MODE ( "SAFE" ),
    .USE_MULT ( "MULT_S" ),
    .USE_PATTERN_DETECT ( "NO_PATDET" ),
    .USE_SIMD ( "ONE48" ))
  blk00000099 (
    .CLK(clk),
    .PATTERNBDETECT(NLW_blk00000099_PATTERNBDETECT_UNCONNECTED),
    .RSTC(sig00000034),
    .CEB1(sig00000034),
    .MULTSIGNOUT(NLW_blk00000099_MULTSIGNOUT_UNCONNECTED),
    .CEC(sig00000001),
    .RSTM(sig00000034),
    .MULTSIGNIN(sig00000034),
    .CEB2(sig00000001),
    .RSTCTRL(sig00000034),
    .CEP(sig00000001),
    .CARRYCASCOUT(NLW_blk00000099_CARRYCASCOUT_UNCONNECTED),
    .RSTA(sig00000034),
    .CECARRYIN(sig00000001),
    .UNDERFLOW(NLW_blk00000099_UNDERFLOW_UNCONNECTED),
    .PATTERNDETECT(NLW_blk00000099_PATTERNDETECT_UNCONNECTED),
    .RSTALUMODE(sig00000034),
    .RSTALLCARRYIN(sig00000034),
    .CEALUMODE(sig00000001),
    .CEA2(sig00000001),
    .CEA1(sig00000034),
    .RSTB(sig00000034),
    .CEMULTCARRYIN(sig00000034),
    .OVERFLOW(NLW_blk00000099_OVERFLOW_UNCONNECTED),
    .CECTRL(sig00000034),
    .CEM(sig00000001),
    .CARRYIN(sig00000034),
    .CARRYCASCIN(sig00000034),
    .RSTP(sig00000034),
    .CARRYINSEL({sig00000034, sig00000034, sig00000034}),
    .B({sig00000034, sig00000001, sig00000001, sig00000034, sig00000034, sig00000001, sig00000034, sig00000034, sig00000001, sig00000034, sig00000034
, sig00000034, sig00000034, sig00000001, sig00000001, sig00000001, sig00000001, sig00000001}),
    .P({\NLW_blk00000099_P<47>_UNCONNECTED , \NLW_blk00000099_P<46>_UNCONNECTED , \NLW_blk00000099_P<45>_UNCONNECTED , 
\NLW_blk00000099_P<44>_UNCONNECTED , \NLW_blk00000099_P<43>_UNCONNECTED , \NLW_blk00000099_P<42>_UNCONNECTED , \NLW_blk00000099_P<41>_UNCONNECTED , 
\NLW_blk00000099_P<40>_UNCONNECTED , \NLW_blk00000099_P<39>_UNCONNECTED , \NLW_blk00000099_P<38>_UNCONNECTED , \NLW_blk00000099_P<37>_UNCONNECTED , 
\NLW_blk00000099_P<36>_UNCONNECTED , sig00000068, sig00000067, sig00000066, sig00000065, sig00000064, sig00000063, sig00000062, sig00000061, 
sig00000060, sig0000005f, sig0000005e, sig0000005d, sig0000005c, sig0000005b, sig0000005a, sig00000059, sig00000058, sig00000057, 
\NLW_blk00000099_P<17>_UNCONNECTED , \NLW_blk00000099_P<16>_UNCONNECTED , \NLW_blk00000099_P<15>_UNCONNECTED , \NLW_blk00000099_P<14>_UNCONNECTED , 
\NLW_blk00000099_P<13>_UNCONNECTED , \NLW_blk00000099_P<12>_UNCONNECTED , \NLW_blk00000099_P<11>_UNCONNECTED , \NLW_blk00000099_P<10>_UNCONNECTED , 
\NLW_blk00000099_P<9>_UNCONNECTED , \NLW_blk00000099_P<8>_UNCONNECTED , \NLW_blk00000099_P<7>_UNCONNECTED , \NLW_blk00000099_P<6>_UNCONNECTED , 
\NLW_blk00000099_P<5>_UNCONNECTED , \NLW_blk00000099_P<4>_UNCONNECTED , \NLW_blk00000099_P<3>_UNCONNECTED , \NLW_blk00000099_P<2>_UNCONNECTED , 
\NLW_blk00000099_P<1>_UNCONNECTED , \NLW_blk00000099_P<0>_UNCONNECTED }),
    .A({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034
, sig00000034, sig00000034, phase_in[4], phase_in[3], phase_in[2], phase_in[1], phase_in[0], sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034}),
    .ACOUT({\NLW_blk00000099_ACOUT<29>_UNCONNECTED , \NLW_blk00000099_ACOUT<28>_UNCONNECTED , \NLW_blk00000099_ACOUT<27>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<26>_UNCONNECTED , \NLW_blk00000099_ACOUT<25>_UNCONNECTED , \NLW_blk00000099_ACOUT<24>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<23>_UNCONNECTED , \NLW_blk00000099_ACOUT<22>_UNCONNECTED , \NLW_blk00000099_ACOUT<21>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<20>_UNCONNECTED , \NLW_blk00000099_ACOUT<19>_UNCONNECTED , \NLW_blk00000099_ACOUT<18>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<17>_UNCONNECTED , \NLW_blk00000099_ACOUT<16>_UNCONNECTED , \NLW_blk00000099_ACOUT<15>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<14>_UNCONNECTED , \NLW_blk00000099_ACOUT<13>_UNCONNECTED , \NLW_blk00000099_ACOUT<12>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<11>_UNCONNECTED , \NLW_blk00000099_ACOUT<10>_UNCONNECTED , \NLW_blk00000099_ACOUT<9>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<8>_UNCONNECTED , \NLW_blk00000099_ACOUT<7>_UNCONNECTED , \NLW_blk00000099_ACOUT<6>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<5>_UNCONNECTED , \NLW_blk00000099_ACOUT<4>_UNCONNECTED , \NLW_blk00000099_ACOUT<3>_UNCONNECTED , 
\NLW_blk00000099_ACOUT<2>_UNCONNECTED , \NLW_blk00000099_ACOUT<1>_UNCONNECTED , \NLW_blk00000099_ACOUT<0>_UNCONNECTED }),
    .OPMODE({sig00000034, sig00000001, sig00000001, sig00000034, sig00000001, sig00000034, sig00000001}),
    .PCIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034}),
    .ALUMODE({sig00000034, sig00000034, sig00000034, sig00000034}),
    .C({sig00000001, sig00000001, sig00000001, sig00000001, sig00000001, sig00000001, sig00000001, sig00000001, sig00000001, sig00000001, sig00000001
, sig00000001, sig00000001, sig00000001, sig00000001, sig00000034, sig00000034, sig00000001, sig00000001, sig00000034, sig00000001, sig00000001, 
sig00000034, sig00000001, sig00000001, sig00000001, sig00000001, sig00000034, sig00000034, sig00000034, sig00000034, sig00000001, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034}),
    .CARRYOUT({\NLW_blk00000099_CARRYOUT<3>_UNCONNECTED , \NLW_blk00000099_CARRYOUT<2>_UNCONNECTED , \NLW_blk00000099_CARRYOUT<1>_UNCONNECTED , 
\NLW_blk00000099_CARRYOUT<0>_UNCONNECTED }),
    .BCIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034}),
    .BCOUT({\NLW_blk00000099_BCOUT<17>_UNCONNECTED , \NLW_blk00000099_BCOUT<16>_UNCONNECTED , \NLW_blk00000099_BCOUT<15>_UNCONNECTED , 
\NLW_blk00000099_BCOUT<14>_UNCONNECTED , \NLW_blk00000099_BCOUT<13>_UNCONNECTED , \NLW_blk00000099_BCOUT<12>_UNCONNECTED , 
\NLW_blk00000099_BCOUT<11>_UNCONNECTED , \NLW_blk00000099_BCOUT<10>_UNCONNECTED , \NLW_blk00000099_BCOUT<9>_UNCONNECTED , 
\NLW_blk00000099_BCOUT<8>_UNCONNECTED , \NLW_blk00000099_BCOUT<7>_UNCONNECTED , \NLW_blk00000099_BCOUT<6>_UNCONNECTED , 
\NLW_blk00000099_BCOUT<5>_UNCONNECTED , \NLW_blk00000099_BCOUT<4>_UNCONNECTED , \NLW_blk00000099_BCOUT<3>_UNCONNECTED , 
\NLW_blk00000099_BCOUT<2>_UNCONNECTED , \NLW_blk00000099_BCOUT<1>_UNCONNECTED , \NLW_blk00000099_BCOUT<0>_UNCONNECTED }),
    .PCOUT({\NLW_blk00000099_PCOUT<47>_UNCONNECTED , \NLW_blk00000099_PCOUT<46>_UNCONNECTED , \NLW_blk00000099_PCOUT<45>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<44>_UNCONNECTED , \NLW_blk00000099_PCOUT<43>_UNCONNECTED , \NLW_blk00000099_PCOUT<42>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<41>_UNCONNECTED , \NLW_blk00000099_PCOUT<40>_UNCONNECTED , \NLW_blk00000099_PCOUT<39>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<38>_UNCONNECTED , \NLW_blk00000099_PCOUT<37>_UNCONNECTED , \NLW_blk00000099_PCOUT<36>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<35>_UNCONNECTED , \NLW_blk00000099_PCOUT<34>_UNCONNECTED , \NLW_blk00000099_PCOUT<33>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<32>_UNCONNECTED , \NLW_blk00000099_PCOUT<31>_UNCONNECTED , \NLW_blk00000099_PCOUT<30>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<29>_UNCONNECTED , \NLW_blk00000099_PCOUT<28>_UNCONNECTED , \NLW_blk00000099_PCOUT<27>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<26>_UNCONNECTED , \NLW_blk00000099_PCOUT<25>_UNCONNECTED , \NLW_blk00000099_PCOUT<24>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<23>_UNCONNECTED , \NLW_blk00000099_PCOUT<22>_UNCONNECTED , \NLW_blk00000099_PCOUT<21>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<20>_UNCONNECTED , \NLW_blk00000099_PCOUT<19>_UNCONNECTED , \NLW_blk00000099_PCOUT<18>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<17>_UNCONNECTED , \NLW_blk00000099_PCOUT<16>_UNCONNECTED , \NLW_blk00000099_PCOUT<15>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<14>_UNCONNECTED , \NLW_blk00000099_PCOUT<13>_UNCONNECTED , \NLW_blk00000099_PCOUT<12>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<11>_UNCONNECTED , \NLW_blk00000099_PCOUT<10>_UNCONNECTED , \NLW_blk00000099_PCOUT<9>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<8>_UNCONNECTED , \NLW_blk00000099_PCOUT<7>_UNCONNECTED , \NLW_blk00000099_PCOUT<6>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<5>_UNCONNECTED , \NLW_blk00000099_PCOUT<4>_UNCONNECTED , \NLW_blk00000099_PCOUT<3>_UNCONNECTED , 
\NLW_blk00000099_PCOUT<2>_UNCONNECTED , \NLW_blk00000099_PCOUT<1>_UNCONNECTED , \NLW_blk00000099_PCOUT<0>_UNCONNECTED }),
    .ACIN({sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, 
sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034, sig00000034})
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
