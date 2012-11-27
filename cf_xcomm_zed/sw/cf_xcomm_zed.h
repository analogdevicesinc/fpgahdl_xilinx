// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

#define CFAD9122_BASEADDR     XPAR_AXI_DAC_4D_2C_0_BASEADDR
#define CFAD9643_BASEADDR     XPAR_AXI_ADC_2C_0_BASEADDR
#define VDMA9122_BASEADDR     XPAR_AXI_VDMA_1_BASEADDR
#define DMA9643_BASEADDR      XPAR_AXI_DMA_1_BASEADDR
#define CFCLKGEN_BASEADDR     XPAR_AXI_CLKGEN_0_BASEADDR
#define CFVIDEO_BASEADDR      XPAR_AXI_HDMI_TX_16B_0_BASEADDR
#define CFAUDIO_BASEADDR      XPAR_AXI_SPDIF_TX_0_BASEADDR
#define DMAVIDEO_BASEADDR     XPAR_AXI_VDMA_0_BASEADDR
#define DMAAUDIO_BASEADDR     XPAR_AXI_DMA_0_BASEADDR
#define DDR_BASEADDR          XPAR_DDR_MEM_BASEADDR
#define UART_BASEADDR         XPS_UART1_BASEADDR
#define IIC_BASEADDR          XPAR_AXI_IIC_1_BASEADDR
#define IICH_BASEADDR         XPAR_AXI_IIC_0_BASEADDR
#define DDRADC_BASEADDR       DDR_BASEADDR + 0x6000000
#define DDRDAC_BASEADDR       DDR_BASEADDR + 0x6001000
#define DDRVIDEO_BASEADDR     DDR_BASEADDR + 0x2000000
#define DDRAUDIO_BASEADDR     DDR_BASEADDR + 0x1000000
#define CFFFT_BASEADDR        DDR_BASEADDR
#define DMAFFT_BASEADDR       DDR_BASEADDR
#define IICSEL_HDMI           0x02
#define IICSEL_XCOMM          0x20
#define IICSEL_ADV7511        0x39
#define PIC_BASEADDR          0x58

// ***************************************************************************
// ***************************************************************************
// board specific functions

u32 cf_xcomm_vdma_baseaddr;
u32 cf_xcomm_dac_baseaddr;
u32 cf_xcomm_dma_baseaddr;
u32 cf_xcomm_adc_baseaddr;
u32 cf_xcomm_iic_baseaddr;
u32 cf_xcomm_pic_baseaddr;

extern char inbyte(void);
void Xil_DCacheFlush(void);
void xil_printf(const char *ctrl1, ...);

void delay_ms(u32 ms_count) {
  u32 count;
  for (count = 0; count < ((ms_count*800000)+1); count++) {
    asm("nop");
  }
}

u32 user_exit(void) {
  while (XUartPs_IsReceiveData(UART_BASEADDR)) {
    if (inbyte() == 'q') {
      return(1);
    }
  }
  return(0);
}

void cpu_flush(void) {
  Xil_DCacheFlush();
}

void board_select() {
  cf_xcomm_vdma_baseaddr = VDMA9122_BASEADDR;
  cf_xcomm_dac_baseaddr  = CFAD9122_BASEADDR;
  cf_xcomm_dma_baseaddr  = DMA9643_BASEADDR;
  cf_xcomm_adc_baseaddr  = CFAD9643_BASEADDR;
  cf_xcomm_iic_baseaddr  = IIC_BASEADDR;
  cf_xcomm_pic_baseaddr  = PIC_BASEADDR;
}

// ***************************************************************************
// ***************************************************************************
