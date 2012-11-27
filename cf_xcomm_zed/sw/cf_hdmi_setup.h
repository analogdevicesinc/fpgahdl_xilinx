// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// HDMI defines

#define H_STRIDE            1920
#define H_COUNT             2200
#define H_ACTIVE            1920
#define H_WIDTH             44
#define H_FP                88
#define H_BP                148
#define V_COUNT             1125
#define V_ACTIVE            1080
#define V_WIDTH             5
#define V_FP                4
#define V_BP                36
#define A_SAMPLE_FREQ       48000
#define A_FREQ              1400

#define H_DE_MIN (H_WIDTH+H_BP)
#define H_DE_MAX (H_WIDTH+H_BP+H_ACTIVE)
#define V_DE_MIN (V_WIDTH+V_BP)
#define V_DE_MAX (V_WIDTH+V_BP+V_ACTIVE)
#define VIDEO_LENGTH  (H_ACTIVE*V_ACTIVE)
#define AUDIO_LENGTH  (A_SAMPLE_FREQ/A_FREQ)

// ***************************************************************************
// ***************************************************************************

void iic_hdmi_select(u32 sel) {
  u32 rdata;
  rdata = sel;
  xil_printf("iic_hdmi_select: %02x\n\r", rdata);
  delay_ms(10);
}

void iic_hdmi_write(u32 daddr, u32 waddr, u32 wdata) {
  Xil_Out32((IICH_BASEADDR + 0x100), 0x002); // reset tx fifo
  Xil_Out32((IICH_BASEADDR + 0x100), 0x001); // enable iic
  Xil_Out32((IICH_BASEADDR + 0x108), (0x100 | (daddr<<1))); // select
  Xil_Out32((IICH_BASEADDR + 0x108), waddr); // address
  Xil_Out32((IICH_BASEADDR + 0x108), (0x200 | wdata)); // data
  while ((Xil_In32(IICH_BASEADDR + 0x104) & 0x80) == 0x00) {delay_ms(1);}
  delay_ms(10);
}

u32 iic_hdmi_read(u32 daddr, u32 raddr, u32 display) {
  u32 rdata;
  Xil_Out32((IICH_BASEADDR + 0x100), 0x002); // reset tx fifo
  Xil_Out32((IICH_BASEADDR + 0x100), 0x001); // enable iic
  Xil_Out32((IICH_BASEADDR + 0x108), (0x100 | (daddr<<1))); // select
  Xil_Out32((IICH_BASEADDR + 0x108), raddr); // address
  Xil_Out32((IICH_BASEADDR + 0x108), (0x101 | (daddr<<1))); // select
  Xil_Out32((IICH_BASEADDR + 0x108), 0x201); // data
  while ((Xil_In32(IICH_BASEADDR + 0x104) & 0x40) == 0x40) {delay_ms(1);}
  delay_ms(10);
  rdata = Xil_In32(IICH_BASEADDR + 0x10c) & 0xff;
  if (display == 1) {
    xil_printf("iic_read: addr(%02x) data(%02x)\n\r", raddr, rdata);
  }
  delay_ms(10);
  return(rdata);
}

// ***************************************************************************
// ***************************************************************************

void ddr_video_wr() {

  u32 v;
  u32 h;
  u32 dcnt;
  u32 dcolor;

  dcnt = 0;
  dcolor = 0;
  xil_printf("DDR write: started\n\r");
  for (v = 0; v < V_ACTIVE; v++) {
    dcolor = (((6*v)/V_ACTIVE) == 0) ? 0x0000ff : dcolor;
    dcolor = (((6*v)/V_ACTIVE) == 1) ? 0x00ff00 : dcolor;
    dcolor = (((6*v)/V_ACTIVE) == 2) ? 0x00ffff : dcolor;
    dcolor = (((6*v)/V_ACTIVE) == 3) ? 0xff0000 : dcolor;
    dcolor = (((6*v)/V_ACTIVE) == 4) ? 0xff00ff : dcolor;
    dcolor = (((6*v)/V_ACTIVE) == 5) ? 0xffff00 : dcolor;
    for (h = 0; h < H_ACTIVE; h++) {
      Xil_Out32((DDRVIDEO_BASEADDR+(dcnt*4)), dcolor);
      dcnt = dcnt + 1;
    }
  }
  cpu_flush();
  xil_printf("DDR write: completed (total %d)\n\r", dcnt);
}

void ddr_audio_wr() {

  u32 n;
  u32 scnt;
  u32 sincr;

  xil_printf("DDR audio write: started\n\r");
  scnt = 0;
  sincr = (65536*2)/AUDIO_LENGTH;
  for (n = 0; n < 32; n++) {
	  Xil_Out32((DDRAUDIO_BASEADDR+(n*4)), 0x00); // init descriptors
  }
  Xil_Out32((DDRAUDIO_BASEADDR+0x00), (DDRAUDIO_BASEADDR + 0x40)); // next descriptor
  Xil_Out32((DDRAUDIO_BASEADDR+0x08), (DDRAUDIO_BASEADDR + 0x80)); // start address
  Xil_Out32((DDRAUDIO_BASEADDR+0x40), (DDRAUDIO_BASEADDR + 0x00)); // next descriptor
  Xil_Out32((DDRAUDIO_BASEADDR+0x48), (DDRAUDIO_BASEADDR + 0x80)); // start address
  Xil_Out32((DDRAUDIO_BASEADDR+0x18), (0x8000000 | (AUDIO_LENGTH*8))); // no. of bytes
  Xil_Out32((DDRAUDIO_BASEADDR+0x58), (0x4000000 | (AUDIO_LENGTH*8))); // no. of bytes
  Xil_Out32((DDRAUDIO_BASEADDR+0x1c), 0x00); // status
  Xil_Out32((DDRAUDIO_BASEADDR+0x5c), 0x00); // status
  for (n = 0; n < AUDIO_LENGTH; n++) {
    Xil_Out32((DDRAUDIO_BASEADDR+0x80+(n*4)), ((scnt << 16) | scnt));
    scnt = (n > (AUDIO_LENGTH/2)) ? (scnt-sincr) : (scnt+sincr);
  }
  cpu_flush();
  xil_printf("DDR audio write: completed (total %d)\n\r", AUDIO_LENGTH);
}

// ***************************************************************************
// ***************************************************************************

void hdmi() {

  u32 data;

  xil_printf("hdmi\n\r");
  ddr_video_wr();
  ddr_audio_wr();
  iic_hdmi_select(IICSEL_HDMI);

  data = Xil_In32(CFCLKGEN_BASEADDR + (0x1f*4));
  if ((data & 0x1) == 0x0) {
    xil_printf("clkgen (148.5MHz) out of lock (0x%04x)\n\r", data);
    return;
  }

  Xil_Out32((DMAVIDEO_BASEADDR + 0x000), 0x00000003); // enable circular mode
  Xil_Out32((DMAVIDEO_BASEADDR + 0x05c), DDRVIDEO_BASEADDR); // start address
  Xil_Out32((DMAVIDEO_BASEADDR + 0x060), DDRVIDEO_BASEADDR); // start address
  Xil_Out32((DMAVIDEO_BASEADDR + 0x064), DDRVIDEO_BASEADDR); // start address
  Xil_Out32((DMAVIDEO_BASEADDR + 0x058), (H_STRIDE*4)); // h offset (2048 * 4) bytes
  Xil_Out32((DMAVIDEO_BASEADDR + 0x054), (H_ACTIVE*4)); // h size (1920 * 4) bytes
  Xil_Out32((DMAVIDEO_BASEADDR + 0x050), V_ACTIVE); // v size (1080)

  Xil_Out32((CFVIDEO_BASEADDR + 0x08), ((H_WIDTH << 16) | H_COUNT));
  Xil_Out32((CFVIDEO_BASEADDR + 0x0c), ((H_DE_MIN << 16) | H_DE_MAX));
  Xil_Out32((CFVIDEO_BASEADDR + 0x10), ((V_WIDTH << 16) | V_COUNT));
  Xil_Out32((CFVIDEO_BASEADDR + 0x14), ((V_DE_MIN << 16) | V_DE_MAX));
  Xil_Out32((CFVIDEO_BASEADDR + 0x04), 0x00000000); // disable
  Xil_Out32((CFVIDEO_BASEADDR + 0x04), 0x00000001); // enable

  Xil_Out32((CFAUDIO_BASEADDR + 0x04), 0x040); // sample frequency
  Xil_Out32((CFAUDIO_BASEADDR + 0x00), 0x103); // clock ratio, data enable & signal enable

  // wait for hpd

  while ((iic_hdmi_read(IICSEL_ADV7511, 0x96, 0x00) & 0x80) != 0x80) {
    delay_ms(1);
  }

  iic_hdmi_write(IICSEL_ADV7511, 0x01, 0x00);
  iic_hdmi_write(IICSEL_ADV7511, 0x02, 0x18);
  iic_hdmi_write(IICSEL_ADV7511, 0x03, 0x00);
  iic_hdmi_write(IICSEL_ADV7511, 0x15, 0x01);
  iic_hdmi_write(IICSEL_ADV7511, 0x16, 0xb5);
  iic_hdmi_write(IICSEL_ADV7511, 0x18, 0x46);
  iic_hdmi_write(IICSEL_ADV7511, 0x40, 0x80);
  iic_hdmi_write(IICSEL_ADV7511, 0x41, 0x10);
  iic_hdmi_write(IICSEL_ADV7511, 0x48, 0x08);
  iic_hdmi_write(IICSEL_ADV7511, 0x49, 0xa8);

  iic_hdmi_write(IICSEL_ADV7511, 0x4c, 0x00);
  iic_hdmi_write(IICSEL_ADV7511, 0x55, 0x20);
  iic_hdmi_write(IICSEL_ADV7511, 0x56, 0x08);
  iic_hdmi_write(IICSEL_ADV7511, 0x96, 0x20);
  iic_hdmi_write(IICSEL_ADV7511, 0x98, 0x03);
  iic_hdmi_write(IICSEL_ADV7511, 0x99, 0x02);
  iic_hdmi_write(IICSEL_ADV7511, 0x9a, 0xe0);
  iic_hdmi_write(IICSEL_ADV7511, 0x9c, 0x30);
  iic_hdmi_write(IICSEL_ADV7511, 0x9d, 0x61);
  iic_hdmi_write(IICSEL_ADV7511, 0xa2, 0xa4);
  iic_hdmi_write(IICSEL_ADV7511, 0xa3, 0xa4);
  iic_hdmi_write(IICSEL_ADV7511, 0xa5, 0x44);
  iic_hdmi_write(IICSEL_ADV7511, 0xab, 0x40);
  iic_hdmi_write(IICSEL_ADV7511, 0xaf, 0x06);
  iic_hdmi_write(IICSEL_ADV7511, 0xba, 0x00);
  iic_hdmi_write(IICSEL_ADV7511, 0xd0, 0x3c);
  iic_hdmi_write(IICSEL_ADV7511, 0xd1, 0xff);
  iic_hdmi_write(IICSEL_ADV7511, 0xde, 0x9c);
  iic_hdmi_write(IICSEL_ADV7511, 0xe0, 0xd0);
  iic_hdmi_write(IICSEL_ADV7511, 0xe4, 0x60);
  iic_hdmi_write(IICSEL_ADV7511, 0xf9, 0x00);
  iic_hdmi_write(IICSEL_ADV7511, 0xfa, 0x00);
  iic_hdmi_write(IICSEL_ADV7511, 0x17, 0x02);

  iic_hdmi_write(IICSEL_ADV7511, 0x0a, 0x10);
  iic_hdmi_write(IICSEL_ADV7511, 0x0b, 0x8e);
  iic_hdmi_write(IICSEL_ADV7511, 0x0c, 0x00);
  iic_hdmi_write(IICSEL_ADV7511, 0x73, 0x01);
  iic_hdmi_write(IICSEL_ADV7511, 0x14, 0x02);

  iic_hdmi_read(IICSEL_ADV7511, 0x42, 0x01);
  iic_hdmi_read(IICSEL_ADV7511, 0xc8, 0x01);
  iic_hdmi_read(IICSEL_ADV7511, 0x9e, 0x01);
  iic_hdmi_read(IICSEL_ADV7511, 0x96, 0x01);
  iic_hdmi_read(IICSEL_ADV7511, 0x3e, 0x01);
  iic_hdmi_read(IICSEL_ADV7511, 0x3d, 0x01);
  iic_hdmi_read(IICSEL_ADV7511, 0x3c, 0x01);

  Xil_Out32((CFVIDEO_BASEADDR + 0x18), 0xff); // clear status

  xil_printf("generating audio clicks (press 'q' to exit).\n\r");
  while (user_exit() == 0) {
    Xil_Out32((DDRAUDIO_BASEADDR+0x1c), 0x00); // status
    Xil_Out32((DDRAUDIO_BASEADDR+0x5c), 0x00); // status
    cpu_flush();
    Xil_Out32((DMAAUDIO_BASEADDR + 0x00), 0); // clear dma operations
    Xil_Out32((DMAAUDIO_BASEADDR + 0x08), DDRAUDIO_BASEADDR); // head descr.
	  Xil_Out32((DMAAUDIO_BASEADDR + 0x00), 1); // enable dma operations
    Xil_Out32((DMAAUDIO_BASEADDR + 0x10), (DDRAUDIO_BASEADDR+0x40)); // tail descr.
    delay_ms(100);
  }

  xil_printf("hdmi done.\n\r");
}

// ***************************************************************************
// ***************************************************************************
