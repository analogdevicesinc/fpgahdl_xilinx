/* Register Map Definitions */
/* Mon Jul 22 13:34:11 2013 */


/* SUMMARY (ADC) */

#define ADC_General                    0x0000                    /*0x0000 - 0x000f */
#define ADC_Common                     0x0010                    /*0x0010 - 0x002f */
#define ADC_Channel_0                  0x0100                    /*0x0100 - 0x010f */
#define ADC_Channel_1                  0x0110                    /*0x0110 - 0x011f */
#define ADC_Channel_15                 0x01f0                    /*0x01f0 - 0x01ff */

/* SUMMARY (DAC) */

#define DAC_General                    0x1000                    /*0x1000 - 0x100f */
#define DAC_Common                     0x1010                    /*0x1010 - 0x1040 */
#define DAC_Channel_0                  0x1100                    /*0x1100 - 0x110f */
#define DAC_Channel_1                  0x1110                    /*0x1110 - 0x111f */
#define DAC_Channel_15                 0x11f0                    /*0x11f0 - 0x11ff */
#define JESD                           0x0010                    /*0x0010 - 0x00ff */
#define DDR_Controller                 0x0010                    /*0x0010 - 0x00ff */

/* GENERAL */

#define REG_VERSION                    0x0000                    /*Version and Scratch Registers */
#define VERSION(x)                     (((x) & 0xffffffff) << 0) /* RO, Version number. */
#define REG_ID                         0x0001                    /*Version and Scratch Registers */
#define ID(x)                          (((x) & 0xffffffff) << 0) /* RO, Instance identifier number. */
#define REG_SCRATCH                    0x0002                    /*Version and Scratch Registers */
#define SCRATCH(x)                     (((x) & 0xffffffff) << 0) /* RW, Scratch register. */

