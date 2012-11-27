// ***************************************************************************
// ***************************************************************************
// XCOMM IIC functions
// ***************************************************************************
// ***************************************************************************

#define IICSEL_AD9122         0x00
#define IICSEL_AD9643         0x01
#define IICSEL_AD9548         0x02
#define IICSEL_AD9523         0x03
#define IICSEL_ADF4351_RX     0x04
#define IICSEL_ADF4351_TX     0x05
#define IICSEL_AD8366         0x06

static u32 IICDATA_CS[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40};
static u32 IICDATA_DW[] = {   8,    8,    8,    8,   32,   32,   16};
static u32 IICDATA_AW[] = {   8,   16,   16,   16,    0,    0,    0};
static u32 IICDATA_WM[] = {   0,    1,    1,    1,    0,    0,    0};

// ***************************************************************************
// ***************************************************************************
// i2c functions

void iic_xcomm_print(u32 sel, u32 addr, u32 rdata) {
  if (sel == IICSEL_AD9122)     {xil_printf("iic_xcomm_read(AD9122): ");}
  if (sel == IICSEL_AD9643)     {xil_printf("iic_xcomm_read(AD9643): ");}
  if (sel == IICSEL_AD9548)     {xil_printf("iic_xcomm_read(AD9548): ");}
  if (sel == IICSEL_AD9523)     {xil_printf("iic_xcomm_read(AD9523): ");}
  if (sel == IICSEL_ADF4351_RX) {xil_printf("iic_xcomm_read(ADF4351_RX): ");}
  if (sel == IICSEL_ADF4351_TX) {xil_printf("iic_xcomm_read(ADF4351_TX): ");}
  if (sel == IICSEL_AD8366)     {xil_printf("iic_xcomm_read(AD8366): ");}
  xil_printf("sel(%02x) addr(%04x) data(%04x)\n\r", sel, addr, rdata);
}

void iic_xcomm_select(u32 sel) {
  u32 rdata;
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4e);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), 0x01);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), sel);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), 0x74);
  while ((Xil_In32(cf_xcomm_iic_baseaddr + 0x10) & 0x01) == 0x00) {}
  delay_ms(10);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4f);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), 0x01);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x00);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), 0x74);
  while ((Xil_In32(cf_xcomm_iic_baseaddr + 0x04) & 0x20) == 0x00) {}
  rdata = Xil_In32(cf_xcomm_iic_baseaddr + 0x0c) & 0xff;
  xil_printf("iic_xcomm_select: %02x\n\r", rdata);
  delay_ms(10);
}

void iic_xcomm_test() {
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4e);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), 0x01);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x02);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), cf_xcomm_pic_baseaddr);
  while ((Xil_In32(cf_xcomm_iic_baseaddr + 0x10) & 0x01) == 0x00) {}
  delay_ms(10);
}

void iic_xcomm_write(u32 sel, u32 addr, u32 data) {

  u32 cs;
  u32 dataw;
  u32 addrw;
  u32 m3w4w;
  u32 wdata;
  u32 wwidth;

  cs = IICDATA_CS[sel];
  dataw = IICDATA_DW[sel];
  addrw = IICDATA_AW[sel];
  m3w4w = IICDATA_WM[sel];
  wdata = (addr<<dataw) | data;
  wwidth = dataw + addrw;

  Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4e);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), 0x05);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x03); // control write
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x00); // spi settings high
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), (0x2a | (m3w4w<<6))); // spi settings low
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), ((cs>>8) & 0xff)); // chip select high
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), (cs & 0xff)); // chip select low
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), cf_xcomm_pic_baseaddr);
  while ((Xil_In32(cf_xcomm_iic_baseaddr + 0x10) & 0x01) == 0x00) {}
  delay_ms(10);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4e);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), ((wwidth/8)+1));
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x04); // data write
  if (wwidth >= 32) {Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), ((wdata>>24) & 0xff));} // data
  if (wwidth >= 24) {Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), ((wdata>>16) & 0xff));} // data 
  if (wwidth >= 16) {Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), ((wdata>> 8) & 0xff));} // data 
  if (wwidth >=  8) {Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), (wdata & 0xff));} // data
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), cf_xcomm_pic_baseaddr);
  while ((Xil_In32(cf_xcomm_iic_baseaddr+0x10) & 0x01) == 0x00) {}
  delay_ms(10);
}

u32 iic_xcomm_read(u32 sel, u32 addr, u32 display) {

  u32 cs;
  u32 dataw;
  u32 addrw;
  u32 addrm;
  u32 m3w4w;
  u32 rdata;

  cs = IICDATA_CS[sel];
  dataw = IICDATA_DW[sel];
  addrw = IICDATA_AW[sel];
  m3w4w = IICDATA_WM[sel];
  addrm = addr | (0x1<<(addrw-1));

  if (addrw > 0) {
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4e);
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), 0x05);
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x03); // control write
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x00); // spi settings high
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), (0x0a | (m3w4w<<6))); // spi settings low
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), ((cs>>8) & 0xff)); // chip select high
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), (cs & 0xff)); // chip select low
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), cf_xcomm_pic_baseaddr);
    while ((Xil_In32(cf_xcomm_iic_baseaddr + 0x10) & 0x01) == 0x00) {}
    delay_ms(10);
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4e);
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), ((addrw/8)+1));
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x04); // data write
    if (addrw >= 16) {Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), ((addrm>>8) & 0xff));} // data 
    if (addrw >=  8) {Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), (addrm & 0xff));} // data
    Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), cf_xcomm_pic_baseaddr);
    while ((Xil_In32(cf_xcomm_iic_baseaddr+0x10) & 0x01) == 0x00) {}
    delay_ms(10);
  }

  Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4e);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), 0x05);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x03); // control write
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), ((dataw/8)<<2)); // spi settings high
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), (0x2a | (m3w4w<<6))); // spi settings low
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), ((cs>>8) & 0xff)); // chip select high
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), (cs & 0xff)); // chip select low
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), cf_xcomm_pic_baseaddr);
  while ((Xil_In32(cf_xcomm_iic_baseaddr + 0x10) & 0x01) == 0x00) {}
  delay_ms(10);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x00), 0x3f4f);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x10), 0xff);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x14), (dataw/8));
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x0c), 0x00);
  Xil_Out32((cf_xcomm_iic_baseaddr + 0x08), cf_xcomm_pic_baseaddr);
  while ((Xil_In32(cf_xcomm_iic_baseaddr + 0x10) & 0x01) == 0x00) {}
  delay_ms(10);
  rdata = Xil_In32(cf_xcomm_iic_baseaddr + 0x0c) & 0xff;
  if (dataw >= 16) {rdata = (rdata<<8) | (Xil_In32(cf_xcomm_iic_baseaddr + 0x0c) & 0xff);}
  if (dataw >= 24) {rdata = (rdata<<8) | (Xil_In32(cf_xcomm_iic_baseaddr + 0x0c) & 0xff);}
  if (dataw >= 32) {rdata = (rdata<<8) | (Xil_In32(cf_xcomm_iic_baseaddr + 0x0c) & 0xff);}
  if (display == 1) {
    iic_xcomm_print(sel, addr, rdata);
  }
  delay_ms(10);
  return(rdata);
}

// ***************************************************************************
// ***************************************************************************
