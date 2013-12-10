/* Register Map Definitions */
/* Tue Nov 26 10:04:57 2013 */


/* DAC Common */

#define REG_RSTN                       0x1010                    /*DAC Interface Control & Status */
#define MMCM_RSTN                      (1 << 1)                  /* RW, MMCM reset only (required for DRP access).
                                                                 Reset, default is IN-RESET (0x0), software must
                                                                 write 0x1 to bring up the core. */
#define RSTN                           (1 << 0)                  /* RW, Reset, default is IN-RESET (0x0), software
                                                                 must write 0x1 to bring up the core. */
#define REG_CNTRL_1                    0x1011                    /*DAC Interface Control & Status */
#define ENABLE                         (1 << 0)                  /* RW, A 0 to 1 transition enables all the data
                                                                 channels. */
#define REG_CNTRL_2                    0x1012                    /*DAC Interface Control & Status */
#define PAR_TYPE                       (1 << 7)                  /* RW, Select parity even (0x0) or odd (0x1). */
#define PAR_ENB                        (1 << 6)                  /* RW, Select parity (0x1) or frame (0x0) mode. */
#define R1_MODE                        (1 << 5)                  /* RW, Select number of RF channels 1 (0x1) or 2
                                                                 (0x0). */
#define DATA_FORMAT                    (1 << 4)                  /* RW, Select data format 2's complement (0x0) or
                                                                 offset binary (0x1). NOT-APPLICABLE if
                                                                 DAC_DP_DISABLE is set (0x1). */
#define DATA_SEL(x)                    (((x) & 0xf) << 0)        /* RW, Select dds (4'h0), sed (4'h01) or ddr (4'h02)
                                                                 as dac data. */
#define REG_RATECNTRL                  0x1013                    /*DAC Interface Control & Status */
#define RATE(x)                        (((x) & 0xff) << 0)       /* RW, The effective dac rate (the maximum possible
                                                                 rate is dependent on the interface clock). The
                                                                 samples are generated at 1/RATE of the interface
                                                                 clock. */
#define REG_FRAME                      0x1014                    /*DAC Interface Control & Status */
#define FRAME                          (1 << 0)                  /* RW, The use of frame is device specific. Usually
                                                                 a 0 -> 1 transition generates a FRAME (1 DCI
                                                                 clock period) pulse on the interface. */
#define REG_STATUS                     0x1015                    /*DAC Interface Control & Status */
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
#define REG_STATUS                     0x1016                    /*DAC Interface Control & Status */
#define CLK_RATIO(x)                   (((x) & 0xffffffff) << 0) /* RO, Interface clock ratio - as a factor actual
                                                                 received clock. This is implementation specific
                                                                 and depends on any serial to parallel conversion
                                                                 and interface type (ddr/sdr/qdr). */
#define REG_STATUS                     0x1017                    /*DAC Interface Control & Status */
#define STATUS                         (1 << 0)                  /* RO, Interface status, if set indicates no errors.
                                                                 If not set, there are errors, software may try
                                                                 resetting the cores. */
#define REG_DRP_CNTRL                  0x101c                    /*DRP Control & Status */
#define DRP_RWN                        (1 << 28)                 /* RW, DRP read (0x1) or write (0x0) select (does
                                                                 not include GTX lanes). */
#define DRP_ADDRESS(x)                 (((x) & 0xfff) << 16)     /* RW, DRP address, designs that contain more than
                                                                 one DRP accessible primitives have selects based
                                                                 on the most significant bits (does not include
                                                                 GTX lanes). */
#define DRP_WDATA(x)                   (((x) & 0xffff) << 0)     /* RW, DRP write data (does not include GTX lanes). */
#define REG_DRP_STATUS                 0x101d                    /*DAC Interface Control & Status */
#define DRP_STATUS                     (1 << 16)                 /* RO, If set indicates busy (access pending). The
                                                                 read data may not be valid if this bit is set
                                                                 (does not include GTX lanes). */
#define DRP_RDATA(x)                   (((x) & 0xffff) << 0)     /* RO, DRP read data (does not include GTX lanes). */
#define REG_UI_STATUS                  0x1022                    /*User Interface Status */
#define UI_OVF                         (1 << 1)                  /* RW1C, User Interface overflow. If set, indicates
                                                                 an overflow occured during data transfer at the
                                                                 user interface (FIFO interface). Software must
                                                                 write a 0x1 to clear this register bit. */
#define UI_UNF                         (1 << 0)                  /* RW1C, User Interface underflow. If set, indicates
                                                                 an underflow occured during data transfer at the
                                                                 user interface (FIFO interface). Software must
                                                                 write a 0x1 to clear this register bit. */
#define REG_USR_CNTRL_1                0x1028                    /*DAC User Control & Status */
#define USR_CHANMAX(x)                 (((x) & 0xff) << 0)       /* RW, This indicates the maximum number of inputs
                                                                 for the channel data multiplexers. User may add
                                                                 different processing modules as inputs to the
                                                                 dac. NOT-APPLICABLE if DAC_DP_DISABLE is set
                                                                 (0x1). */
#define REG_USR_CNTRL_1                0x0030                    /*DAC Interface Control & Status */
#define DAC_DP_DISABLE                 (1 << 0)                  /* RO, This indicates the data path disable setting
                                                                 of this pcore. If disabled, most of the HDL data
                                                                 path modules are disabled allowing an external
                                                                 core full access to the raw DAC data. */

/* DAC Channel */

#define REG_CHAN_CNTRL_1               0x1100                    /*DAC Channel Control & Status (channel - 0) */
#define DDS_SCALE_1(x)                 (((x) & 0xf) << 0)        /* RW, The DDS scale for tone 1. The DDS for a
                                                                 channel consists of two tones. The final output
                                                                 is (channel_1 << scale_1) + (channel_2 <<
                                                                 scale_2) NOT-APPLICABLE if DAC_DP_DISABLE is set
                                                                 (0x1). */
#define REG_CHAN_CNTRL_2               0x1101                    /*DAC Channel Control & Status (channel - 0) */
#define DDS_INIT_1(x)                  (((x) & 0xffff) << 16)    /* RW, The DDS phase initialization for tone 1. The
                                                                 DDS for a channel consists of two tones. The
                                                                 final output is (channel_1 << scale_1) +
                                                                 (channel_2 << scale_2) NOT-APPLICABLE if
                                                                 DAC_DP_DISABLE is set (0x1). */
#define DDS_INCR_1(x)                  (((x) & 0xffff) << 0)     /* RW, The DDS phase increment for tone 1. The DDS
                                                                 for a channel consists of two tones. The final
                                                                 output is (channel_1 << scale_1) + (channel_2 <<
                                                                 scale_2) NOT-APPLICABLE if DAC_DP_DISABLE is set
                                                                 (0x1). */
#define REG_CHAN_CNTRL_3               0x1102                    /*DAC Channel Control & Status (channel - 0) */
#define DDS_SCALE_2(x)                 (((x) & 0xf) << 0)        /* RW, The DDS scale for tone 2. The DDS for a
                                                                 channel consists of two tones. The final output
                                                                 is (channel_1 << scale_1) + (channel_2 <<
                                                                 scale_2) NOT-APPLICABLE if DAC_DP_DISABLE is set
                                                                 (0x1). */
#define REG_CHAN_CNTRL_4               0x1103                    /*DAC Channel Control & Status (channel - 0) */
#define DDS_INIT_2(x)                  (((x) & 0xffff) << 16)    /* RW, The DDS phase initialization for tone 2. The
                                                                 DDS for a channel consists of two tones. The
                                                                 final output is (channel_1 << scale_1) +
                                                                 (channel_2 << scale_2) NOT-APPLICABLE if
                                                                 DAC_DP_DISABLE is set (0x1). */
#define DDS_INCR_2(x)                  (((x) & 0xffff) << 0)     /* RW, The DDS phase increment for tone 2. The DDS
                                                                 for a channel consists of two tones. The final
                                                                 output is (channel_1 << scale_1) + (channel_2 <<
                                                                 scale_2) NOT-APPLICABLE if DAC_DP_DISABLE is set
                                                                 (0x1). */
#define REG_CHAN_CNTRL_5               0x1104                    /*DAC Channel Control & Status (channel - 0) */
#define DDS_PATT_2(x)                  (((x) & 0xffff) << 16)    /* RW, The DDS data pattern for this channel. */
#define DDS_PATT_1(x)                  (((x) & 0xffff) << 0)     /* RW, The DDS data pattern for this channel. */
#define REG_CHAN_CNTRL_6               0x1105                    /*DAC Channel Control & Status (channel - 0) */
#define DAC_LB_ENB                     (1 << 1)                  /* RW, If set enables loopback of receive data
                                                                 (applicable only on shared interface). */
#define DAC_PN_ENB                     (1 << 0)                  /* RW, If set enables PN sequence (DATA_SEL[3:0]
                                                                 must be set to 0x1). */
#define REG_USR_CNTRL_3                0x1108                    /*DAC Channel Control & Status (channel - 0) */
#define USR_DATATYPE_BE                (1 << 25)                 /* RW, The user data type format- if set, indicates
                                                                 big endian (default is little endian).
                                                                 NOT-APPLICABLE if DAC_DP_DISABLE is set (0x1). */
#define USR_DATATYPE_SIGNED            (1 << 24)                 /* RW, The user data type format- if set, indicates
                                                                 signed (2's complement) data (default is
                                                                 unsigned). NOT-APPLICABLE if DAC_DP_DISABLE is
                                                                 set (0x1). */
#define USR_DATATYPE_SHIFT(x)          (((x) & 0xff) << 16)      /* RW, The user data type format- the amount of
                                                                 right shift for actual samples within the total
                                                                 number of bits. NOT-APPLICABLE if DAC_DP_DISABLE
                                                                 is set (0x1). */
#define USR_DATATYPE_TOTAL_BITS(x)     (((x) & 0xff) << 8)       /* RW, The user data type format- number of total
                                                                 bits used for a sample. The total number of bits
                                                                 must be an integer multiple of 8 (byte aligned).
                                                                 NOT-APPLICABLE if DAC_DP_DISABLE is set (0x1). */
#define USR_DATATYPE_BITS(x)           (((x) & 0xff) << 0)       /* RW, The user data type format- number of bits in
                                                                 a sample. This indicates the actual sample data
                                                                 bits. NOT-APPLICABLE if DAC_DP_DISABLE is set
                                                                 (0x1). */
#define REG_USR_CNTRL_4                0x1109                    /*DAC Channel Control & Status (channel - 0) */
#define USR_INTERPOLATION_M(x)         (((x) & 0xffff) << 16)    /* RW, This holds the user interpolation M value of
                                                                 the channel that is currently being selected on
                                                                 the multiplexer above. The toal interpolation
                                                                 factor is of the form M/N. NOT-APPLICABLE if
                                                                 DAC_DP_DISABLE is set (0x1). */
#define USR_INTERPOLATION_N(x)         (((x) & 0xffff) << 0)     /* RW, This holds the user interpolation N value of
                                                                 the channel that is currently being selected on
                                                                 the multiplexer above. The toal interpolation
                                                                 factor is of the form M/N. NOT-APPLICABLE if
                                                                 DAC_DP_DISABLE is set (0x1). */
#define REG_*                          0x1110                    /*Channel 1, similar to registers 0x100 to 0x10f. */
#define REG_*                          0x1120                    /*Channel 2, similar to registers 0x100 to 0x10f. */
#define REG_*                          0x11f0                    /*Channel 15, similar to registers 0x100 to 0x10f. */

