/* Register Map Definitions */
/* Tue Nov 26 10:04:57 2013 */


/* FFT Common */

#define REG_RSTN                       0x0010                    /*FFT Interface Control & Status */
#define RSTN                           (1 << 0)                  /* RW, Reset, default is IN-RESET (0x0), software
                                                                 must write 0x1 to bring up the core. */
#define REG_CNTRL                      0x0011                    /*FFT Interface Control & Status */
#define CFG_DATA(x)                    (((x) & 0xffffffff) << 0) /* RW, The configuration data is passed as it is to
                                                                 the FFT core. The format is dependent on the
                                                                 Xilinx's IP core. */
#define REG_CNTRL                      0x0012                    /*FFT Interface Control & Status */
#define ENABLE                         (1 << 16)                 /* RW, The H. window enable (requires 0->1
                                                                 transition). */
#define INCR(x)                        (((x) & 0xffff) << 0)     /* RW, This is the window phase increment function -
                                                                 cos(phase). */
#define REG_STATUS                     0x0017                    /*FFT Interface Control & Status */
#define STATUS                         (1 << 0)                  /* RO, Interface status, if set indicates no errors.
                                                                 If not set, there are errors, software may try
                                                                 resetting the cores. */
#define REG_STATUS                     0x0018                    /*FFT Interface Control & Status */
#define STATUS(x)                      (((x) & 0xfffff) << 0)    /* RW1C, The FFT status is passed to the software
                                                                 through this register. The fields are controlled
                                                                 by the Xilinx's IP core. */

