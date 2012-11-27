// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

#include <stdio.h>
#include "platform.h"
#include "xbasic_types.h"
#include "xstatus.h"
#include "xil_io.h"
#include "xparameters.h"
#include "xuartlite_l.h"
#include "cf_xcomm_vc707.h"
#include "cf_xcomm_lcd.h"
#include "cf_xcomm_spi.h"
#include "cf_xcomm_setup.h"

// ***************************************************************************
// ***************************************************************************

int main() {

  u32 mode;

  init_platform();
  lcd_display();
  board_select(IICSEL_LPC);
  iic_xcomm_select(IICSEL_LPC);
  iic_xcomm_test();

  xil_printf("reading defaults\n\r");
  iic_xcomm_read(IICSEL_AD9122, 0x008, 1);
  iic_xcomm_read(IICSEL_AD9643, 0x001, 1);
  iic_xcomm_read(IICSEL_AD9548, 0x002, 1);
  iic_xcomm_read(IICSEL_AD9523, 0x194, 1);

  xil_printf("running board setup\n\r");
  ad9548_setup();
  ad9523_setup();
  adf4351_rx_setup();
  adf4351_tx_setup();
  ad9122_setup();
  ad9643_setup();
  dac_setup();
  adc_setup();

  xil_printf("Enter 'd' for dma ('s' to skip).\n\r");
  if (XUartLite_RecvByte(UART_BASEADDR) == 'd') {
    dma_setup();
  } else {
    dds_setup(6, 6);
  }

  for (mode = 0x1; mode <= 0x7; mode++) {
    adc_test(mode, 0x1);
    adc_test(mode, 0x0);
  }
  adc_test(0xf, 0x1);
  adc_test(0xf, 0x0);

  xil_printf("Running FFT, enter 'q' to exit.\n\r");
  while (user_exit() == 0) {
    adc_fft(1024, 1);
  }

  xil_printf("done.\n\r");
  cleanup_platform();
  return(0);
}


// ***************************************************************************
// ***************************************************************************

