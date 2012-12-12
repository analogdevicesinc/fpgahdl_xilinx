// ***************************************************************************
// ***************************************************************************
// XCOMM Setup routines
// ***************************************************************************
// ***************************************************************************
// AD9122 1x No PLL with SYNC.txt

void ad9122_setup() {

  iic_xcomm_write(IICSEL_AD9122, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000000, 0x00000020);
  iic_xcomm_write(IICSEL_AD9122, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000001, 0x00000010);
  iic_xcomm_write(IICSEL_AD9122, 0x00000003, 0x00000080);
  iic_xcomm_write(IICSEL_AD9122, 0x00000004, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000005, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000008, 0x0000003f);
  iic_xcomm_write(IICSEL_AD9122, 0x0000000a, 0x00000040);
  iic_xcomm_write(IICSEL_AD9122, 0x0000000c, 0x000000d1);
  iic_xcomm_write(IICSEL_AD9122, 0x0000000d, 0x000000d6);
  iic_xcomm_write(IICSEL_AD9122, 0x00000010, 0x00000048);
  iic_xcomm_write(IICSEL_AD9122, 0x00000011, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000016, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000017, 0x00000004);
  iic_xcomm_write(IICSEL_AD9122, 0x00000018, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x0000001b, 0x000000e0);
  iic_xcomm_write(IICSEL_AD9122, 0x0000001c, 0x00000001);
  iic_xcomm_write(IICSEL_AD9122, 0x0000001d, 0x00000001);
  iic_xcomm_write(IICSEL_AD9122, 0x0000001e, 0x00000001);
  iic_xcomm_write(IICSEL_AD9122, 0x00000030, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000031, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000032, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000033, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000034, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000035, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000036, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000038, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000039, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x0000003a, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x0000003b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x0000003c, 0x000000ae);
  iic_xcomm_write(IICSEL_AD9122, 0x0000003d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x0000003e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x0000003f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000040, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000041, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000042, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000043, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000044, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000045, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000046, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000047, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000048, 0x00000002);
  iic_xcomm_write(IICSEL_AD9122, 0x00000018, 0x00000002);
  while ((iic_xcomm_read(IICSEL_AD9122, 0x00000018, 1) & (0x1<<2)) == 0) {delay_ms(1);}
  iic_xcomm_write(IICSEL_AD9122, 0x00000018, 0x00000000);
  iic_xcomm_write(IICSEL_AD9122, 0x00000010, 0x00000088);
  while ((iic_xcomm_read(IICSEL_AD9122, 0x00000012, 1) & (0x1<<6)) == 0) {delay_ms(1);}
}

// ***************************************************************************
// ***************************************************************************
// AD9523 DAC 1x EXT REFB External Zero Delay.txt

void ad9523_reva_setup() {

  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000022);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000010, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000011, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000012, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000013, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000014, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000015, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000016, 0x00000004);
  iic_xcomm_write(IICSEL_AD9523, 0x00000017, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000018, 0x00000004);
  iic_xcomm_write(IICSEL_AD9523, 0x00000019, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x0000001a, 0x0000003a);
  iic_xcomm_write(IICSEL_AD9523, 0x0000001b, 0x00000006);
  iic_xcomm_write(IICSEL_AD9523, 0x0000001c, 0x0000008c);
  iic_xcomm_write(IICSEL_AD9523, 0x0000001d, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f0, 0x00000078);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f1, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f2, 0x00000033);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f3, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f4, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f5, 0x00000012);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f6, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f7, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x00000190, 0x00000002);
  iic_xcomm_write(IICSEL_AD9523, 0x00000191, 0x00000007);
  iic_xcomm_write(IICSEL_AD9523, 0x00000192, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000193, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x00000194, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x00000195, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000196, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x00000197, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x00000198, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000199, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019a, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019c, 0x00000002);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019d, 0x0000000f);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019f, 0x00000008);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a0, 0x00000007);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a1, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a2, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a3, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a4, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a5, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a6, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a7, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a8, 0x00000008);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a9, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001aa, 0x00000004);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ab, 0x00000008);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ac, 0x00000007);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ad, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ae, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x000001af, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b0, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b1, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b2, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b3, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b4, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b5, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b6, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b7, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b8, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b9, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ba, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001bb, 0x00000080);
  iic_xcomm_write(IICSEL_AD9523, 0x0000022c, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x0000022d, 0x00000009);
  iic_xcomm_write(IICSEL_AD9523, 0x0000022e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x0000022f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000230, 0x00000002);
  iic_xcomm_write(IICSEL_AD9523, 0x00000231, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x00000233, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000234, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f3, 0x00000002);
  iic_xcomm_write(IICSEL_AD9523, 0x00000234, 0x00000001);
  while ((iic_xcomm_read(IICSEL_AD9523, 0x0000022c, 1) & (0x1<<1)) == 0) {delay_ms(1);}
  iic_xcomm_write(IICSEL_AD9523, 0x000000f3, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000234, 0x00000001);
}

// ***************************************************************************
// ***************************************************************************
// AD9523 RevB.txt

void ad9523_setup() {

  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000022);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000000, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000010, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000011, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000012, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000013, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000014, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000015, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000016, 0x00000004);
  iic_xcomm_write(IICSEL_AD9523, 0x00000017, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000018, 0x00000004);
  iic_xcomm_write(IICSEL_AD9523, 0x00000019, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x0000001a, 0x0000006a);
  iic_xcomm_write(IICSEL_AD9523, 0x0000001b, 0x00000005);
  iic_xcomm_write(IICSEL_AD9523, 0x0000001c, 0x0000004c);
  iic_xcomm_write(IICSEL_AD9523, 0x0000001d, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f0, 0x00000078);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f1, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f2, 0x00000033);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f3, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f4, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f5, 0x00000012);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f6, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f7, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x00000190, 0x00000002);
  iic_xcomm_write(IICSEL_AD9523, 0x00000191, 0x00000007);
  iic_xcomm_write(IICSEL_AD9523, 0x00000192, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000193, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x00000194, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x00000195, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000196, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x00000197, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x00000198, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000199, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019a, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019c, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019d, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x0000019f, 0x00000008);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a0, 0x00000007);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a1, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a2, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a3, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a4, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a5, 0x00000008);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a6, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a7, 0x00000004);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a8, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x000001a9, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001aa, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ab, 0x00000008);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ac, 0x00000007);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ad, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ae, 0x00000002);
  iic_xcomm_write(IICSEL_AD9523, 0x000001af, 0x0000000f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b0, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b1, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b2, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b3, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b4, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b5, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b6, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b7, 0x00000020);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b8, 0x0000001f);
  iic_xcomm_write(IICSEL_AD9523, 0x000001b9, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001ba, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x000001bb, 0x00000080);
  iic_xcomm_write(IICSEL_AD9523, 0x0000022c, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x0000022d, 0x00000009);
  iic_xcomm_write(IICSEL_AD9523, 0x0000022e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x0000022f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000230, 0x00000002);
  iic_xcomm_write(IICSEL_AD9523, 0x00000231, 0x00000003);
  iic_xcomm_write(IICSEL_AD9523, 0x00000233, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000234, 0x00000001);
  iic_xcomm_write(IICSEL_AD9523, 0x000000f3, 0x00000002);
  iic_xcomm_write(IICSEL_AD9523, 0x00000234, 0x00000001);
  while ((iic_xcomm_read(IICSEL_AD9523, 0x0000022c, 1) & (0x1<<1)) == 0) {delay_ms(1);}
  iic_xcomm_write(IICSEL_AD9523, 0x000000f3, 0x00000000);
  iic_xcomm_write(IICSEL_AD9523, 0x00000234, 0x00000001);
}

// ***************************************************************************
// ***************************************************************************
// AD9548 script.txt

void ad9548_reva_setup() {

  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000030);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000100, 0x00000018);
  iic_xcomm_write(IICSEL_AD9548, 0x00000101, 0x00000028);
  iic_xcomm_write(IICSEL_AD9548, 0x00000102, 0x00000045);
  iic_xcomm_write(IICSEL_AD9548, 0x00000103, 0x00000043);
  iic_xcomm_write(IICSEL_AD9548, 0x00000104, 0x000000de);
  iic_xcomm_write(IICSEL_AD9548, 0x00000105, 0x00000013);
  iic_xcomm_write(IICSEL_AD9548, 0x00000106, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000107, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000108, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000208, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000209, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020a, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020c, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000210, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000211, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000212, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000213, 0x000000ff);
  iic_xcomm_write(IICSEL_AD9548, 0x00000214, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000300, 0x00000029);
  iic_xcomm_write(IICSEL_AD9548, 0x00000301, 0x0000005c);
  iic_xcomm_write(IICSEL_AD9548, 0x00000302, 0x0000008f);
  iic_xcomm_write(IICSEL_AD9548, 0x00000303, 0x000000c2);
  iic_xcomm_write(IICSEL_AD9548, 0x00000304, 0x000000f5);
  iic_xcomm_write(IICSEL_AD9548, 0x00000305, 0x00000028);
  iic_xcomm_write(IICSEL_AD9548, 0x00000307, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000308, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000309, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030a, 0x000000ff);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030b, 0x000000ff);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030c, 0x000000ff);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000310, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000311, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000312, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000313, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000314, 0x000000e8);
  iic_xcomm_write(IICSEL_AD9548, 0x00000315, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000316, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000317, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000318, 0x00000030);
  iic_xcomm_write(IICSEL_AD9548, 0x00000319, 0x00000075);
  iic_xcomm_write(IICSEL_AD9548, 0x0000031a, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000031b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000400, 0x0000000c);
  iic_xcomm_write(IICSEL_AD9548, 0x00000401, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000402, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000403, 0x00000002);
  iic_xcomm_write(IICSEL_AD9548, 0x00000404, 0x00000004);
  iic_xcomm_write(IICSEL_AD9548, 0x00000405, 0x00000008);
  iic_xcomm_write(IICSEL_AD9548, 0x00000406, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000407, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000408, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000409, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040a, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040c, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000410, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000411, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000412, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000413, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000414, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000415, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000416, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000417, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000500, 0x000000fc);
  iic_xcomm_write(IICSEL_AD9548, 0x00000501, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000502, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000503, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000504, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000505, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000506, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000507, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000306, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000a02, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  while ((iic_xcomm_read(IICSEL_AD9548, 0x00000d01, 1) & (0x1<<0)) == 0) {delay_ms(1);}
  iic_xcomm_write(IICSEL_AD9548, 0x00000a02, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000a02, 0x00000002);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000a02, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
}

// ***************************************************************************
// ***************************************************************************
// AD9548 script.txt

void ad9548_setup() {

  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000030);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000000, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x00000100, 0x00000018);
  iic_xcomm_write(IICSEL_AD9548, 0x00000101, 0x00000028);
  iic_xcomm_write(IICSEL_AD9548, 0x00000102, 0x00000045);
  iic_xcomm_write(IICSEL_AD9548, 0x00000103, 0x00000043);
  iic_xcomm_write(IICSEL_AD9548, 0x00000104, 0x000000de);
  iic_xcomm_write(IICSEL_AD9548, 0x00000105, 0x00000013);
  iic_xcomm_write(IICSEL_AD9548, 0x00000106, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000107, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000108, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000a02, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  while ((iic_xcomm_read(IICSEL_AD9548, 0x00000d01, 1) & (0x1<<0)) == 0) {delay_ms(1);}
  iic_xcomm_write(IICSEL_AD9548, 0x00000a02, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000208, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000209, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020a, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020c, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000020f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000210, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000211, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000212, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000213, 0x000000ff);
  iic_xcomm_write(IICSEL_AD9548, 0x00000214, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000300, 0x00000029);
  iic_xcomm_write(IICSEL_AD9548, 0x00000301, 0x0000005c);
  iic_xcomm_write(IICSEL_AD9548, 0x00000302, 0x0000008f);
  iic_xcomm_write(IICSEL_AD9548, 0x00000303, 0x000000c2);
  iic_xcomm_write(IICSEL_AD9548, 0x00000304, 0x000000f5);
  iic_xcomm_write(IICSEL_AD9548, 0x00000305, 0x00000028);
  iic_xcomm_write(IICSEL_AD9548, 0x00000307, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000308, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000309, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030a, 0x000000ff);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030b, 0x000000ff);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030c, 0x000000ff);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000030f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000310, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000311, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000312, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000313, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000314, 0x000000e8);
  iic_xcomm_write(IICSEL_AD9548, 0x00000315, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000316, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000317, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000318, 0x00000030);
  iic_xcomm_write(IICSEL_AD9548, 0x00000319, 0x00000075);
  iic_xcomm_write(IICSEL_AD9548, 0x0000031a, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000031b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000306, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000400, 0x0000000c);
  iic_xcomm_write(IICSEL_AD9548, 0x00000401, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000402, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000403, 0x00000002);
  iic_xcomm_write(IICSEL_AD9548, 0x00000404, 0x00000004);
  iic_xcomm_write(IICSEL_AD9548, 0x00000405, 0x00000008);
  iic_xcomm_write(IICSEL_AD9548, 0x00000406, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000407, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000408, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x00000409, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040a, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040b, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040c, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040e, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000040f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000410, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000411, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000412, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000413, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000414, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000415, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000416, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000417, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000500, 0x000000fe);
  iic_xcomm_write(IICSEL_AD9548, 0x00000501, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000502, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000503, 0x00000008);
  iic_xcomm_write(IICSEL_AD9548, 0x00000504, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000505, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000506, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000507, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000600, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000601, 0x00000055);
  iic_xcomm_write(IICSEL_AD9548, 0x00000602, 0x000000a0);
  iic_xcomm_write(IICSEL_AD9548, 0x00000603, 0x000000fc);
  iic_xcomm_write(IICSEL_AD9548, 0x00000604, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000605, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000606, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000607, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000608, 0x000000e8);
  iic_xcomm_write(IICSEL_AD9548, 0x00000609, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x0000060a, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000060b, 0x000000e8);
  iic_xcomm_write(IICSEL_AD9548, 0x0000060c, 0x00000003);
  iic_xcomm_write(IICSEL_AD9548, 0x0000060d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x0000060e, 0x00000088);
  iic_xcomm_write(IICSEL_AD9548, 0x0000060f, 0x00000013);
  iic_xcomm_write(IICSEL_AD9548, 0x00000610, 0x00000088);
  iic_xcomm_write(IICSEL_AD9548, 0x00000611, 0x00000013);
  iic_xcomm_write(IICSEL_AD9548, 0x00000612, 0x0000000e);
  iic_xcomm_write(IICSEL_AD9548, 0x00000613, 0x000000b2);
  iic_xcomm_write(IICSEL_AD9548, 0x00000614, 0x00000008);
  iic_xcomm_write(IICSEL_AD9548, 0x00000615, 0x00000082);
  iic_xcomm_write(IICSEL_AD9548, 0x00000616, 0x00000062);
  iic_xcomm_write(IICSEL_AD9548, 0x00000617, 0x00000042);
  iic_xcomm_write(IICSEL_AD9548, 0x00000618, 0x000000d8);
  iic_xcomm_write(IICSEL_AD9548, 0x00000619, 0x00000047);
  iic_xcomm_write(IICSEL_AD9548, 0x0000061a, 0x00000021);
  iic_xcomm_write(IICSEL_AD9548, 0x0000061b, 0x000000cb);
  iic_xcomm_write(IICSEL_AD9548, 0x0000061c, 0x000000c4);
  iic_xcomm_write(IICSEL_AD9548, 0x0000061d, 0x00000005);
  iic_xcomm_write(IICSEL_AD9548, 0x0000061e, 0x0000007f);
  iic_xcomm_write(IICSEL_AD9548, 0x0000061f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000620, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000621, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000622, 0x0000000b);
  iic_xcomm_write(IICSEL_AD9548, 0x00000623, 0x00000002);
  iic_xcomm_write(IICSEL_AD9548, 0x00000624, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000625, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000626, 0x00000026);
  iic_xcomm_write(IICSEL_AD9548, 0x00000627, 0x000000b0);
  iic_xcomm_write(IICSEL_AD9548, 0x00000628, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000629, 0x00000010);
  iic_xcomm_write(IICSEL_AD9548, 0x0000062a, 0x00000027);
  iic_xcomm_write(IICSEL_AD9548, 0x0000062b, 0x00000020);
  iic_xcomm_write(IICSEL_AD9548, 0x0000062c, 0x00000044);
  iic_xcomm_write(IICSEL_AD9548, 0x0000062d, 0x000000f4);
  iic_xcomm_write(IICSEL_AD9548, 0x0000062e, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x0000062f, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000630, 0x00000020);
  iic_xcomm_write(IICSEL_AD9548, 0x00000631, 0x00000044);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000a0e, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000a02, 0x00000002);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
  iic_xcomm_write(IICSEL_AD9548, 0x00000a02, 0x00000000);
  iic_xcomm_write(IICSEL_AD9548, 0x00000005, 0x00000001);
}

// ***************************************************************************
// ***************************************************************************
// ADF4351 122_88M input 2400_1M output.txt

void adf4351_rx_setup() {

  iic_xcomm_write(IICSEL_ADF4351_RX, 0x00000005, 0x00580005);
  iic_xcomm_write(IICSEL_ADF4351_RX, 0x00000004, 0x008f603c);
  iic_xcomm_write(IICSEL_ADF4351_RX, 0x00000003, 0x000004b3);
  iic_xcomm_write(IICSEL_ADF4351_RX, 0x00000002, 0x00010e42);
  iic_xcomm_write(IICSEL_ADF4351_RX, 0x00000001, 0x08000999);
  iic_xcomm_write(IICSEL_ADF4351_RX, 0x00000000, 0x00270138);
}

// ***************************************************************************
// ***************************************************************************
// ADF4351 122_88M input 2400_1M output.txt

void adf4351_tx_setup() {

  iic_xcomm_write(IICSEL_ADF4351_TX, 0x00000005, 0x00580005);
  iic_xcomm_write(IICSEL_ADF4351_TX, 0x00000004, 0x008f603c);
  iic_xcomm_write(IICSEL_ADF4351_TX, 0x00000003, 0x000004b3);
  iic_xcomm_write(IICSEL_ADF4351_TX, 0x00000002, 0x00010e42);
  iic_xcomm_write(IICSEL_ADF4351_TX, 0x00000001, 0x08000999);
  iic_xcomm_write(IICSEL_ADF4351_TX, 0x00000000, 0x00270138);
}

// ***************************************************************************
// ***************************************************************************
// AD9643 setup

void ad9643_setup() {

  iic_xcomm_write(IICSEL_AD9643, 0x00000005, 0x00000003);
  iic_xcomm_write(IICSEL_AD9643, 0x00000016, 0x00000020);
  iic_xcomm_write(IICSEL_AD9643, 0x00000017, 0x00000000);
  iic_xcomm_write(IICSEL_AD9643, 0x0000000d, 0x00000000);
  iic_xcomm_write(IICSEL_AD9643, 0x00000014, 0x00000000);
  iic_xcomm_write(IICSEL_AD9643, 0x000000ff, 0x00000001);
  iic_xcomm_write(IICSEL_AD9643, 0x000000ff, 0x00000000);
}

// ***************************************************************************
// ***************************************************************************
// dac dds function, clocks must be in mhz

u32 dds_pf(u32 phase, u32 sin_clk, u32 dac_clk) {
  u32 p_offset;
  u32 p_incr;
  p_offset = (phase*0xffff)/360;
  p_incr = ((sin_clk*0xffff)/dac_clk) | 0x1;
  return((p_offset<<16) | p_incr);
}

void dds_setup(u32 f1, u32 f2) {
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0x1);
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x08), dds_pf( 0, f1, 500));
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x0c), dds_pf( 0, f2, 500));
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x10), dds_pf(90, f1, 500));
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x14), dds_pf(90, f2, 500));
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0x3);
  xil_printf("dac_dds: f1(%dMHz), f2(%dMHz).\n\r", f1, f2);
}

void dma_setup() {
  u32 index;
  u32 status;
  index = 0;
  while (index < 256) {
    Xil_Out32((DDRDAC_BASEADDR + ((index +  0) * 4)), 0x00007fff);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  1) * 4)), 0x30fb7640);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  2) * 4)), 0x5a815a81);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  3) * 4)), 0x764030fb);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  4) * 4)), 0x7fff0000);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  5) * 4)), 0x7640cf05);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  6) * 4)), 0x5a81a57f);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  7) * 4)), 0x30fb89c0);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  8) * 4)), 0x00008001);
    Xil_Out32((DDRDAC_BASEADDR + ((index +  9) * 4)), 0xcf0589c0);
    Xil_Out32((DDRDAC_BASEADDR + ((index + 10) * 4)), 0xa57fa57f);
    Xil_Out32((DDRDAC_BASEADDR + ((index + 11) * 4)), 0x89c0cf05);
    Xil_Out32((DDRDAC_BASEADDR + ((index + 12) * 4)), 0x80010000);
    Xil_Out32((DDRDAC_BASEADDR + ((index + 13) * 4)), 0x89c030fb);
    Xil_Out32((DDRDAC_BASEADDR + ((index + 14) * 4)), 0xa57f5a81);
    Xil_Out32((DDRDAC_BASEADDR + ((index + 15) * 4)), 0xcf057640);
    index = index + 16;
  }
  cpu_flush();
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x18), 0x2ba85691);
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0x0);
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0x1);
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0xf);
  Xil_Out32((cf_xcomm_vdma_baseaddr + 0x000), 0x00000003); // enable circular mode
  Xil_Out32((cf_xcomm_vdma_baseaddr + 0x05c), DDRDAC_BASEADDR); // start address
  Xil_Out32((cf_xcomm_vdma_baseaddr + 0x060), DDRDAC_BASEADDR); // start address
  Xil_Out32((cf_xcomm_vdma_baseaddr + 0x064), DDRDAC_BASEADDR); // start address
  Xil_Out32((cf_xcomm_vdma_baseaddr + 0x058), (index*4)); // h offset (2048 * 4) bytes
  Xil_Out32((cf_xcomm_vdma_baseaddr + 0x054), (index*4)); // h size (1920 * 4) bytes
  Xil_Out32((cf_xcomm_vdma_baseaddr + 0x050), 1); // v size (1080)
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x28), 0x3); // clear status
  xil_printf("dac_dma: f(%dMHz).\n\r", (500/(16*3)));
  delay_ms(10);
  status = Xil_In32((cf_xcomm_dac_baseaddr + 0x28));
  if (status != 0x0) {
    xil_printf("dma_setup: status(%x)\n\r", status);
  }
}

u32 dac_sed(u32 s0, u32 s1, u32 display) {
  u32 rdata;
  u32 status;
  iic_xcomm_write(IICSEL_AD9122, 0x68, ((s0>> 0) & 0xff));
  iic_xcomm_write(IICSEL_AD9122, 0x69, ((s0>> 8) & 0xff));
  iic_xcomm_write(IICSEL_AD9122, 0x6a, ((s1>> 0) & 0xff));
  iic_xcomm_write(IICSEL_AD9122, 0x6b, ((s1>> 8) & 0xff));
  iic_xcomm_write(IICSEL_AD9122, 0x6c, ((s0>>16) & 0xff));
  iic_xcomm_write(IICSEL_AD9122, 0x6d, ((s0>>24) & 0xff));
  iic_xcomm_write(IICSEL_AD9122, 0x6e, ((s1>>16) & 0xff));
  iic_xcomm_write(IICSEL_AD9122, 0x6f, ((s1>>24) & 0xff));
  iic_xcomm_write(IICSEL_AD9122, 0x67, 0x00);
  iic_xcomm_write(IICSEL_AD9122, 0x67, 0x80);
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0x11);
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x40), s0);
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x44), s1);
  Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0x13);
  delay_ms(10);
  iic_xcomm_write(IICSEL_AD9122, 0x67, 0xa3);
  iic_xcomm_write(IICSEL_AD9122, 0x07, 0x1c);
  delay_ms(100);
  status = 0;
  if (display == 1) {
    xil_printf("dac_sed: s0(0x%08x), s1(0x%08x)\n\r", s0, s1);
  }
  rdata = iic_xcomm_read(IICSEL_AD9122, 0x67, 0);
  if ((rdata & 0x20) == 0x20) {
    status = 1;
    if (display == 1) {
      xil_printf("ERROR: Addr(0x67) Data(0x%02x)!\n\r", rdata);
    }
  }
  rdata = iic_xcomm_read(IICSEL_AD9122, 0x07, 0);
  if ((rdata & 0x02) == 0x02) {
    status = 1;
    if (display == 1) {
      xil_printf("ERROR: Addr(0x07) Data(0x%02x)!\n\r", rdata);
    }
  }
  rdata = iic_xcomm_read(IICSEL_AD9122, 0x70, 0);
  if (rdata != 0x00) {
    status = 1;
    if (display == 1) {
      xil_printf("ERROR: Addr(0x70) Data(0x%02x)!\n\r", rdata);
    }
  }
  rdata = iic_xcomm_read(IICSEL_AD9122, 0x71, 0);
  if (rdata != 0x00) {
    status = 1;
    if (display == 1) {
      xil_printf("ERROR: Addr(0x71) Data(0x%02x)!\n\r", rdata);
    }
  }
  rdata = iic_xcomm_read(IICSEL_AD9122, 0x72, 0);
  if (rdata != 0x00) {
    status = 1;
    if (display == 1) {
      xil_printf("ERROR: Addr(0x72) Data(0x%02x)!\n\r", rdata);
    }
  }
  rdata = iic_xcomm_read(IICSEL_AD9122, 0x73, 0);
  if (rdata != 0x00) {
    status = 1;
    if (display == 1) {
      xil_printf("ERROR: Addr(0x73) Data(0x%02x)!\n\r", rdata);
    }
  }
  return(status);
}

void dac_setup() {
  u32 dci_delay;
  u32 status;
  status = 0;
  for (dci_delay = 0; dci_delay < 4; dci_delay++) {
    Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0x0);
    Xil_Out32((cf_xcomm_dac_baseaddr + 0x04), 0x1);
    Xil_Out32((cf_xcomm_dac_baseaddr + 0x20), 0x1111);
    iic_xcomm_write(IICSEL_AD9122, 0x16, dci_delay);
    iic_xcomm_read(IICSEL_AD9122, 0x16, 0x1);
    if (dac_sed(0xaaaaaaaa, 0x55555555, 0x0) == 0) {
      if (dac_sed(0x55555555, 0xaaaaaaaa, 0x0) == 0) {
        xil_printf("dac_setup: zero error delay is %d\n\r", dci_delay);
        status = 1;
        break;
      }
    }
  }
  if (status == 0) {
    xil_printf("dac_setup: can not set a zero error delay!\n\r");
  }
  dac_sed(0x0000aaaa, 0x00000000, 0x1);
  dac_sed(0x00005555, 0x00000000, 0x1);
  dac_sed(0xaaaa0000, 0x00000000, 0x1);
  dac_sed(0x55550000, 0x00000000, 0x1);
  dac_sed(0x00000000, 0x0000aaaa, 0x1);
  dac_sed(0x00000000, 0x00005555, 0x1);
  dac_sed(0x00000000, 0xaaaa0000, 0x1);
  dac_sed(0x00000000, 0x55550000, 0x1);
  dac_sed(0x00000000, 0x00000000, 0x1);
  dac_sed(0xaaaaaaaa, 0x55555555, 0x1);
  dac_sed(0x55555555, 0xaaaaaaaa, 0x1);
  return;
}

// ***************************************************************************
// ***************************************************************************
// adc functions

u32 adc_delay_1(u32 delay) {

  u32 i;
  u32 rdata;

  for (i = 0; i < 15; i++) {
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), 0x00000); // delay write
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), (0x20000 | (i<<8) | delay)); // delay write
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), (0x20000 | (i<<8) | delay)); // delay write
  }
  for (i = 0; i < 15; i++) {
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), 0x00000); // delay read
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), (0x30000 | (i<<8))); // delay read
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), (0x30000 | (i<<8))); // delay read
    rdata = Xil_In32(cf_xcomm_adc_baseaddr + 0x020);
    if (rdata != (0x100 | delay)) {
      xil_printf("adc_delay_1: sel(%2d), data(%04x)\n\r", i, rdata);
    }
  }
  return(0);
}

u32 adc_delay() {

  u32 delay;
  u32 error;
  u32 lasterr;
  u32 startdelay;
  u32 stopdelay;

  lasterr = 1;
  startdelay = 32;
  stopdelay = 31;

  for (delay = 0; delay < 32; delay++) {
    adc_delay_1(delay);
    delay_ms(10);
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x14), 0xff);
    delay_ms(100);
    error = Xil_In32(cf_xcomm_adc_baseaddr + 0x14) & 0x3c;
    if (error == 0) {
      if (lasterr == 1) {
        startdelay = delay;
      }
      lasterr = 0;
    } else {
      if (lasterr == 0) {
        stopdelay = delay;
        break;
      }
      lasterr = 1;
    }
  }
  if (startdelay > 31) {
    adc_delay_1(0);
    return(1);
  }
  delay = startdelay + ((stopdelay - startdelay)/2);
  xil_printf("adc_setup: setting zero error delay (%d)\n\r", delay);
  adc_delay_1(delay);
  return(0);
}

void adc_setup() {
  u32 dco_inv;
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), 0x00000);
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), 0x2ff00);
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x01c), 0x2ff00);
  iic_xcomm_write(IICSEL_AD9643, 0x0d, 0x5);
  iic_xcomm_write(IICSEL_AD9643, 0x14, 0x0);
  iic_xcomm_write(IICSEL_AD9643, 0xff, 0x1);
  iic_xcomm_write(IICSEL_AD9643, 0xff, 0x0);
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x24), 0x3);
  dco_inv = iic_xcomm_read(IICSEL_AD9643, 0x16, 0);
  iic_xcomm_write(IICSEL_AD9643, 0x16, (dco_inv & 0x7f));
  iic_xcomm_write(IICSEL_AD9643, 0xff, 0x1);
  iic_xcomm_write(IICSEL_AD9643, 0xff, 0x0);
  iic_xcomm_read(IICSEL_AD9643, 0x16, 1);
  delay_ms(10);
  if (adc_delay()) {
    dco_inv = iic_xcomm_read(IICSEL_AD9643, 0x16, 0);
    iic_xcomm_write(IICSEL_AD9643, 0x16, (dco_inv | 0x80));
    iic_xcomm_write(IICSEL_AD9643, 0xff, 0x1);
    iic_xcomm_write(IICSEL_AD9643, 0xff, 0x0);
    iic_xcomm_read(IICSEL_AD9643, 0x16, 1);
    delay_ms(10);
    if (adc_delay()) {
      xil_printf("adc_setup: can not set a zero error delay!\n\r");
      adc_delay_1(0);
    }
  }
}

void adc_capture(u32 qwcnt, u32 sa, u32 iqsel) {
  Xil_Out32((cf_xcomm_dma_baseaddr + 0x030), 4); // reset dma
  Xil_Out32((cf_xcomm_dma_baseaddr + 0x030), 0); // clear dma operations
  Xil_Out32((cf_xcomm_dma_baseaddr + 0x030), 1); // enable dma operations
  Xil_Out32((cf_xcomm_dma_baseaddr + 0x048), sa); // capture start address
  Xil_Out32((cf_xcomm_dma_baseaddr + 0x058), (qwcnt * 8)); // number of bytes
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x008), iqsel); // channel enables
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x00c), 0x0); // capture disable
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x010), 0xf); // clear status
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x014), 0xf); // clear status
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x00c), (0x10000 | (qwcnt-1))); // start capture
  do {delay_ms(1);}
  while ((Xil_In32(cf_xcomm_adc_baseaddr + 0x010) & 0x1) == 1);
  if ((Xil_In32(cf_xcomm_adc_baseaddr + 0x010) & 0x02) == 0x02) {
    xil_printf("adc_capture: overflow occured, data may be corrupted\n\r");
  }
  cpu_flush();
}

void adc_test(u32 mode, u32 format) {
  u32 n;
  u32 rdata;
  u32 adata;
  u32 bdata;
  u32 edata;
  iic_xcomm_write(IICSEL_AD9643, 0x0d, mode);
  iic_xcomm_write(IICSEL_AD9643, 0x14, format);
  iic_xcomm_write(IICSEL_AD9643, 0xff, 0x1);
  iic_xcomm_write(IICSEL_AD9643, 0xff, 0x0);
  adc_capture(16, DDRADC_BASEADDR, 0x3);
  delay_ms(10);
  xil_printf("adc_test: mode(%2d), format(%2d)\n\r", mode, format);
  if (mode == 0xf) {
    for (n = 0; n < 16; n++) {
      rdata = Xil_In32(DDRADC_BASEADDR + (n*8));
      if (n == 0) {
        adata = rdata & 0xffff;
        bdata = (rdata>>16) & 0xffff;
      } else {
        adata = (adata+1) & 0x3fff;
        bdata = (bdata+1) & 0x3fff;
      }
      edata = (bdata<<16) | adata;
      if (rdata != edata) {
        xil_printf("  ERROR[%2d]: rcv(%08x), exp(%08x)\n\r", n, rdata, edata);
      }
    }
    return;
  }
  if (mode == 0x7) {
    for (n = 0; n < 32; n++) {
      rdata = Xil_In32(DDRADC_BASEADDR + (n*4));
      if (n == 0) {
        adata = ((rdata & 0xffff) == 0x3fff) ? 0x3fff : 0x0000;
        bdata = (((rdata>>16) & 0xffff) == 0x3fff) ? 0x3fff : 0x0000;
      } else {
        adata = (adata == 0x3fff) ? 0x0000 : 0x3fff;
        bdata = (bdata == 0x3fff) ? 0x0000 : 0x3fff;
      }
      edata = (bdata<<16) | adata;
      if (rdata != edata) {
        xil_printf("  ERROR[%2d]: rcv(%08x), exp(%08x)\n\r", n, rdata, edata);
      }
    }
    return;
  }
  if ((mode == 0x5) || (mode == 0x6)) {
    if (format == 0x1) return;
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x24), ((mode == 0x5) ? 0x3 : 0x0));
    delay_ms(10);
    Xil_Out32((cf_xcomm_adc_baseaddr + 0x14), 0xff);
    delay_ms(100);
    if ((Xil_In32(cf_xcomm_adc_baseaddr + 0x14) & 0x3c) != 0) {
      xil_printf("  ERROR: PN status(%02x).\n\r", Xil_In32(cf_xcomm_adc_baseaddr + 0x14));
    }
    return;
  }
  if (mode == 0x4) {
    for (n = 0; n < 32; n++) {
      rdata = Xil_In32(DDRADC_BASEADDR + (n*4));
      if (n == 0) {
        adata = ((rdata & 0xffff) == 0x2aaa) ? 0x2aaa : 0x1555;
        bdata = (((rdata>>16) & 0xffff) == 0x2aaa) ? 0x2aaa : 0x1555;
      } else {
        adata = (adata == 0x2aaa) ? 0x1555 : 0x2aaa;
        bdata = (bdata == 0x2aaa) ? 0x1555 : 0x2aaa;
      }
      edata = (bdata<<16) | adata;
      if (rdata != edata) {
        xil_printf("  ERROR[%2d]: rcv(%08x), exp(%08x)\n\r", n, rdata, edata);
      }
    }
    return;
  }
  edata = 0xffffffff;
  if ((mode == 0x1) && (format == 0)) edata = 0x20002000;
  if ((mode == 0x2) && (format == 0)) edata = 0x3fff3fff;
  if ((mode == 0x3) && (format == 0)) edata = 0x00000000;
  if ((mode == 0x1) && (format == 1)) edata = 0x00000000;
  if ((mode == 0x2) && (format == 1)) edata = 0x1fff1fff;
  if ((mode == 0x3) && (format == 1)) edata = 0x20002000;
  for (n = 0; n < 32; n++) {
    rdata = Xil_In32(DDRADC_BASEADDR + (n*4));
    if (rdata != edata) {
      xil_printf("  ERROR[%2d]: rcv(%08x), exp(%08x)\n\r", n, rdata, edata);
    }
  }
}

void adc_data() {
  iic_xcomm_write(IICSEL_AD9643, 0x0d, 0x00);
  iic_xcomm_write(IICSEL_AD9643, 0x14, 0x01);
  iic_xcomm_write(IICSEL_AD9643, 0xff, 0x01);
  iic_xcomm_write(IICSEL_AD9643, 0xff, 0x00);
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x40), 0x8000); // scale & offset (A)
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x44), 0x8000); // scale & offset (B), use 0x7893 for rev.a
  Xil_Out32((cf_xcomm_adc_baseaddr + 0x2c), 0x6); // scale & offset and sign extension enable
}

void adc_fft(u32 dwcnt, u32 iqsel) {

  u32 nfft;
  u32 nsize;
  u32 status;

  nfft = 1;
  nsize = dwcnt;
  while ((nsize/2) > 1) {
    nfft = nfft + 1;
    nsize = nsize/2;
  }

  adc_data();
  adc_capture((dwcnt/4), DDRADC_BASEADDR, iqsel);
  xil_printf("adc_fft: nfft(%02x), samples(%04x).\n\r", nfft, dwcnt);
  Xil_Out32((CFFFT_BASEADDR + 0x08), 0x0); // window enable and increment count
  Xil_Out32((CFFFT_BASEADDR + 0x08), 0x1003f); // window enable and increment count
  Xil_Out32((CFFFT_BASEADDR + 0x04), (0x55700 | nfft)); // fft select
  Xil_Out32((CFFFT_BASEADDR + 0x0c), 0xfffff); // clear status
  Xil_Out32((DMAFFT_BASEADDR + 0x00), 0); // clear dma operations
  Xil_Out32((DMAFFT_BASEADDR + 0x00), 1); // enable dma operations
  Xil_Out32((DMAFFT_BASEADDR + 0x18), DDRADC_BASEADDR); // start address
  Xil_Out32((DMAFFT_BASEADDR + 0x28), (dwcnt * 2)); // number of bytes
  Xil_Out32((DMAFFT_BASEADDR + 0x30), 0); // clear dma operations
  Xil_Out32((DMAFFT_BASEADDR + 0x30), 1); // enable dma operations
  Xil_Out32((DMAFFT_BASEADDR + 0x48), (DDRADC_BASEADDR+(dwcnt*8))); // start address
  Xil_Out32((DMAFFT_BASEADDR + 0x58), (dwcnt*8)); // number of bytes
  do {delay_ms(1);}
  while ((Xil_In32(DMAFFT_BASEADDR + 0x34) & 0x2) == 0x0);
  status = Xil_In32(CFFFT_BASEADDR + 0x0c);
  if (status != 0x01) {
    xil_printf("adc_fft: errors found (%x) data may be corrupted\n\r", status);
  }
}

// ***************************************************************************
// ***************************************************************************
