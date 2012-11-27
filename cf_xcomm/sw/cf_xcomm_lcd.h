// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

void lcd_write_1(u32 data) {
  u32 count;
  Xil_Out32(GPIOLCD_BASEADDR, (0x00 | (data&0x3f)));
  Xil_Out32(GPIOLCD_BASEADDR, (0x00 | (data&0x3f)));
  for (count = 0; count < 13; count++) {
    asm("nop");
  }
  Xil_Out32(GPIOLCD_BASEADDR, (0x40 | (data&0x3f)));
  Xil_Out32(GPIOLCD_BASEADDR, (0x40 | (data&0x3f)));
  for (count = 0; count < 26; count++) {
    asm("nop");
  }
  Xil_Out32(GPIOLCD_BASEADDR, (0x00 | (data&0x3f)));
  Xil_Out32(GPIOLCD_BASEADDR, (0x00 | (data&0x3f)));
  for (count = 0; count < 13; count++) {
    asm("nop");
  }
}

void lcd_write(u32 cntrl, u32 data) {
  u32 count;
  lcd_write_1((((cntrl<<4)&0x30) | ((data>>4)&0xf)));
  for (count = 0; count < 100; count++) {
    asm("nop");
  }
  lcd_write_1((((cntrl<<4)&0x30) | ((data>>0)&0xf)));
  for (count = 0; count < 4000; count++) {
    asm("nop");
  }
}

void lcd_display() {

  Xil_Out32((GPIOLCD_BASEADDR + 0x04), 0x00); // outputs
  Xil_Out32(GPIOLCD_BASEADDR, 0x00);

  delay_ms(16);
  lcd_write_1(0x3);
  delay_ms(5);
  lcd_write_1(0x3);
  delay_ms(1);
  lcd_write_1(0x3);
  delay_ms(1);
  lcd_write_1(0x2);
  delay_ms(1);

  lcd_write(0x0, 0x28);
  lcd_write(0x0, 0x06);
  lcd_write(0x0, 0x0c);
  lcd_write(0x0, 0x01);
  delay_ms(2);

  lcd_write(0x0, 0x02);
  lcd_write(0x2, 0x41);
  lcd_write(0x2, 0x6e);
  lcd_write(0x2, 0x61);
  lcd_write(0x2, 0x6c);
  lcd_write(0x2, 0x6f);
  lcd_write(0x2, 0x67);
  lcd_write(0x2, 0x20);
  lcd_write(0x2, 0x44);
  lcd_write(0x2, 0x65);
  lcd_write(0x2, 0x76);
  lcd_write(0x2, 0x69);
  lcd_write(0x2, 0x63);
  lcd_write(0x2, 0x65);
  lcd_write(0x2, 0x73);
  lcd_write(0x2, 0x20);

  lcd_write(0x0, 0xa8);
  lcd_write(0x2, 0x41);
  lcd_write(0x2, 0x44);
  lcd_write(0x2, 0x2d);
  lcd_write(0x2, 0x46);
  lcd_write(0x2, 0x4d);
  lcd_write(0x2, 0x43);
  lcd_write(0x2, 0x4f);
  lcd_write(0x2, 0x4d);
  lcd_write(0x2, 0x4d);
  lcd_write(0x2, 0x53);
  lcd_write(0x2, 0x31);
  lcd_write(0x2, 0x2d);
  lcd_write(0x2, 0x45);
  lcd_write(0x2, 0x42);
  lcd_write(0x2, 0x5a);
  lcd_write(0x2, 0x20);

  xil_printf("Analog Devices, AD-FMCOMMS1-EBZ\n\r");
}

// ***************************************************************************
// ***************************************************************************
