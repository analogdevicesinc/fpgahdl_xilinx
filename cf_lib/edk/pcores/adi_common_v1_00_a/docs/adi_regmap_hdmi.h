/* Register Map Definitions */
/* Tue Nov 26 10:04:57 2013 */


/* HDMI Transmit */

#define REG_RSTN                       0x0010                    /*HDMI Interface Control & Status */
#define RSTN                           (1 << 0)                  /* RW, Reset, a common reset is used for all the
                                                                 interface modules, The default is reset (0x0),
                                                                 software must write 0x1 to bring up the core. */
#define REG_CNTRL                      0x0011                    /*HDMI Interface Control & Status */
#define FULL_RANGE                     (1 << 1)                  /* RW, If clear (0x0), RGB data is limited to 0x10
                                                                 to 0xeb. */
#define CSC_BYPASS                     (1 << 0)                  /* RW, If set (0x1) bypasses color space conversion
                                                                 (if equipped). */
#define REG_CNTRL                      0x0012                    /*HDMI Interface Control & Status */
#define SOURCE_SEL(x)                  (((x) & 0x3) << 0)        /* RW, Select the HDMI data source- register
                                                                 constant (0x3), incr-pattern (0x2), input (0x1)
                                                                 or disabled (0x0). */
#define REG_CNTRL                      0x0013                    /*HDMI Interface Control & Status */
#define CONST_RGB(x)                   (((x) & 0xffffff) << 0)   /* RW, This is the RGB value transmitted, if the
                                                                 source is constant (see above). */
#define REG_CLK_FREQ                   0x0015                    /*HDMI Interface Control & Status */
#define CLK_FREQ(x)                    (((x) & 0xffffffff) << 0) /* RO, Interface clock frequency. This is relative
                                                                 to the processor clock and in many cases is
                                                                 100MHz. The number is represented as unsigned
                                                                 16.16 format. Assuming a 100MHz processor clock
                                                                 the minimum is 1.523kHz and maximum is 6.554THz.
                                                                 The actual interface clock is CLK_FREQ *
                                                                 CLK_RATIO (see below). Note that the actual
                                                                 sampling clock may not be the same as the
                                                                 interface clock- software must consider device
                                                                 specific implementation parameters to calculate
                                                                 the final sampling clock. */
#define REG_CLK_RATIO                  0x0016                    /*HDMI Interface Control & Status */
#define CLK_RATIO(x)                   (((x) & 0xffffffff) << 0) /* RO, Interface clock ratio - as a factor actual
                                                                 received clock. This is implementation specific
                                                                 and depends on any serial to parallel conversion
                                                                 and interface type (ddr/sdr/qdr). */
#define REG_STATUS                     0x0017                    /*ADC Interface Control & Status */
#define STATUS                         (1 << 0)                  /* RO, Interface status, if set indicates no errors.
                                                                 If not set, there are errors, software may try
                                                                 resetting the cores. */
#define REG_VDMA_STATUS                0x0018                    /*HDMI Interface Control & Status */
#define VDMA_OVF                       (1 << 1)                  /* RW1C, If set, indicates vdma overflow. */
#define VDMA_UNF                       (1 << 0)                  /* RW1C, If set, indicates vdma underflow. */
#define REG_TPM_STATUS                 0x0019                    /*HDMI Interface Control & Status */
#define HDMI_TPM_OOS                   (1 << 1)                  /* RW1C, If set, indicates TPM OOS at the HDMI
                                                                 interface. */
#define VDMA_TPM_OOS                   (1 << 0)                  /* RW1C, If set, indicates TPM OOS at the VDMA
                                                                 interface. */
#define REG_HSYNC_1                    0x0100                    /*HDMI Interface Control & Status */
#define H_LINE_ACTIVE(x)               (((x) & 0xffff) << 16)    /* RW, This is the horizontal line active pixel
                                                                 width (active resolution length). e.g. 1920
                                                                 (1080p) */
#define H_LINE_WIDTH(x)                (((x) & 0xffff) << 0)     /* RW, This is the horizontal line width (no. of
                                                                 pixel clocks per line). e.g. 2200 (1080p) */
#define REG_HSYNC_2                    0x0101                    /*HDMI Interface Control & Status */
#define H_SYNC_WIDTH(x)                (((x) & 0xffff) << 0)     /* RW, This is the horizontal sync width (no. of
                                                                 pixel clocks). e.g. 44 (1080p) */
#define REG_HSYNC_3                    0x0102                    /*HDMI Interface Control & Status */
#define H_ENABLE_MAX(x)                (((x) & 0xffff) << 16)    /* RW, This is the horizontal data enable maximum.
                                                                 It is the sum of H_ENABLE_MIN and the active
                                                                 pixel width. e.g. 2112 (192 + 1920) (1080p) */
#define H_ENABLE_MIN(x)                (((x) & 0xffff) << 0)     /* RW, This is the horizontal data enable minimum.
                                                                 It is the sum of horizontal back porch (number of
                                                                 clock cycles between the falling edge of HSYNC to
                                                                 the rising edge of DE) and the sync width. e.g.
                                                                 192 (44 + 148) (1080p) */
#define REG_VSYNC_1                    0x0110                    /*HDMI Interface Control & Status */
#define V_FRAME_ACTIVE(x)              (((x) & 0xffff) << 16)    /* RW, This is the vertical frame active line width
                                                                 (active resolution height). e.g. 1080 (1080p) */
#define V_FRAME_WIDTH(x)               (((x) & 0xffff) << 0)     /* RW, This is the vertical frame width (no. of
                                                                 lines per frame). e.g. 1125 (1080p) */
#define REG_VSYNC_2                    0x0111                    /*HDMI Interface Control & Status */
#define V_SYNC_WIDTH(x)                (((x) & 0xffff) << 0)     /* RW, This is the vertical sync width (no. of
                                                                 lines). e.g. 5 (1080p) */
#define REG_VSYNC_3                    0x0112                    /*HDMI Interface Control & Status */
#define V_ENABLE_MAX(x)                (((x) & 0xffff) << 16)    /* RW, This is the vertical data enable maximum. It
                                                                 is the sum of V_ENABLE_MIN and the active pixel
                                                                 height. e.g. 1121 (41 + 1080) (1080p) */
#define V_ENABLE_MIN(x)                (((x) & 0xffff) << 0)     /* RW, This is the vertical data enable minimum. It
                                                                 is the sum of vertical back porch (number of
                                                                 lines between the falling edge of VSYNC to the
                                                                 rising edge of DE) and the sync width. e.g. 41
                                                                 (36 + 5) (1080p) */

