// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

#include <stdio.h>
#include <xil_io.h>
#include "xiicps.h"
#include "xuartps.h"
#include "platform.h"
#include "xparameters_ps.h"
#include "xbasic_types.h"
#include "xparameters.h"
#include "cf_xcomm_zed.h"
#include "cf_xcomm_spi.h"
#include "cf_xcomm_setup.h"
#include "cf_hdmi_setup.h"

// ***************************************************************************
// ***************************************************************************

int main() {

  u32 mode;

  init_platform();
  xil_printf("Enter 'h' for hdmi test ('s' to skip).\n\r");
  if (inbyte() == 'h') {
    hdmi();
  }

  board_select(IICSEL_XCOMM);
  iic_xcomm_select(IICSEL_XCOMM);
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
  if (inbyte() == 'd') {
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
  adc_data();

  xil_printf("done.\n\r");
  cleanup_platform();
  return(0);
}


// ***************************************************************************
// ***************************************************************************

