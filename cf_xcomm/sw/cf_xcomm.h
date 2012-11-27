// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

#define CFAD9122_0_BASEADDR   XPAR_AXI_DAC_4D_2C_0_BASEADDR
#define CFAD9643_0_BASEADDR   XPAR_AXI_ADC_2C_0_BASEADDR
#define VDMA9122_0_BASEADDR   XPAR_AXI_VDMA_0_BASEADDR
#define DMA9643_0_BASEADDR    XPAR_AXI_DMA_0_BASEADDR
#define IIC_0_BASEADDR        XPAR_AXI_IIC_0_BASEADDR

#define CFAD9122_1_BASEADDR   XPAR_AXI_DAC_4D_2C_1_BASEADDR
#define CFAD9643_1_BASEADDR   XPAR_AXI_ADC_2C_1_BASEADDR
#define VDMA9122_1_BASEADDR   XPAR_AXI_VDMA_1_BASEADDR
#define DMA9643_1_BASEADDR    XPAR_AXI_DMA_0_BASEADDR
#define IIC_1_BASEADDR        XPAR_AXI_IIC_1_BASEADDR

#define DDR_BASEADDR          XPAR_DDR3_SDRAM_S_AXI_BASEADDR
#define UART_BASEADDR         XPAR_RS232_UART_1_BASEADDR
#define CFFFT_BASEADDR        XPAR_AXI_FFT_0_BASEADDR
#define DMAFFT_BASEADDR       XPAR_AXI_DMA_2_BASEADDR
#define GPIOLCD_BASEADDR      XPAR_AXI_GPIO_0_BASEADDR
#define DDRADC_BASEADDR       (DDR_BASEADDR + 0x00000000)
#define DDRDAC_BASEADDR       (DDR_BASEADDR + 0x00010000)

#define IICSEL_LPC            0x04
#define IICSEL_HPC            0x02
#define PIC_0_BASEADDR        0x59
#define PIC_1_BASEADDR        0x58

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
void xil_printf(const char *ctrl1, ...);

void delay_ms(u32 ms_count) {
  u32 count;
  for (count = 0; count < ((ms_count*100000)+1); count++) {
    asm("nop");
  }
}

u32 user_exit(void) {
  while (!XUartLite_IsReceiveEmpty(UART_BASEADDR)) {
    if (XUartLite_RecvByte(UART_BASEADDR) == 'q') {
      return(1);
    }
  }
  return(0);
}

void cpu_flush(void) {
  microblaze_flush_dcache();
  microblaze_invalidate_dcache();
}

void board_select(u32 sel) {
  cf_xcomm_vdma_baseaddr = (sel == IICSEL_HPC) ? VDMA9122_1_BASEADDR : VDMA9122_0_BASEADDR;
  cf_xcomm_dac_baseaddr  = (sel == IICSEL_HPC) ? CFAD9122_1_BASEADDR : CFAD9122_0_BASEADDR;
  cf_xcomm_dma_baseaddr  = (sel == IICSEL_HPC) ? DMA9643_1_BASEADDR  : DMA9643_0_BASEADDR;
  cf_xcomm_adc_baseaddr  = (sel == IICSEL_HPC) ? CFAD9643_1_BASEADDR : CFAD9643_0_BASEADDR;
  cf_xcomm_iic_baseaddr  = (sel == IICSEL_HPC) ? IIC_1_BASEADDR      : IIC_0_BASEADDR;
  cf_xcomm_pic_baseaddr  = (sel == IICSEL_HPC) ? PIC_1_BASEADDR      : PIC_0_BASEADDR;
}

// ***************************************************************************
// ***************************************************************************
