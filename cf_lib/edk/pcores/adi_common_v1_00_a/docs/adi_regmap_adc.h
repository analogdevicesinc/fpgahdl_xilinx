/* Register Map Definitions */
/* Tue Nov 26 10:04:57 2013 */


/* ADC Common */

#define REG_RSTN                       0x0010                    /*ADC Interface Control & Status */
#define MMCM_RSTN                      (1 << 1)                  /* RW, MMCM reset only (required for DRP access).
                                                                 Reset, default is IN-RESET (0x0), software must
                                                                 write 0x1 to bring up the core. */
#define RSTN                           (1 << 0)                  /* RW, Reset, default is IN-RESET (0x0), software
                                                                 must write 0x1 to bring up the core. */
#define REG_CNTRL                      0x0011                    /*ADC Interface Control & Status */
#define R1_MODE                        (1 << 2)                  /* RW, Select number of RF channels 1 (0x1) or 2
                                                                 (0x0). */
#define DDR_EDGESEL                    (1 << 1)                  /* RW, Select rising edge (0x0) or falling edge
                                                                 (0x1) for the first part of a sample (if
                                                                 applicable) followed by the successive edges for
                                                                 the remaining parts. This only controls how the
                                                                 sample is delineated from the incoming data post
                                                                 DDR registers. */
#define PIN_MODE                       (1 << 0)                  /* RW, Select interface pin mode to be clock
                                                                 multiplexed (0x1) or pin multiplexed (0x0). In
                                                                 clock multiplexed mode, samples are received on
                                                                 alternative clock edges. In pin multiplexed mode,
                                                                 samples are interleaved or grouped on the pins at
                                                                 the same clock edge. */
#define REG_CLK_FREQ                   0x0015                    /*ADC Interface Control & Status */
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
#define REG_CLK_RATIO                  0x0016                    /*ADC Interface Control & Status */
#define CLK_RATIO(x)                   (((x) & 0xffffffff) << 0) /* RO, Interface clock ratio - as a factor actual
                                                                 received clock. This is implementation specific
                                                                 and depends on any serial to parallel conversion
                                                                 and interface type (ddr/sdr/qdr). */
#define REG_STATUS                     0x0017                    /*ADC Interface Control & Status */
#define PN_ERR                         (1 << 3)                  /* RO, If set, indicates pn error in one or more
                                                                 channels. */
#define PN_OOS                         (1 << 2)                  /* RO, If set, indicates pn oos in one or more
                                                                 channels. */
#define OVER_RANGE                     (1 << 1)                  /* RO, If set, indicates over range in one or more
                                                                 channels. */
#define STATUS                         (1 << 0)                  /* RO, Interface status, if set indicates no errors.
                                                                 If not set, there are errors, software may try
                                                                 resetting the cores. */
#define REG_DELAY_CNTRL                0x0018                    /*ADC Interface Control & Status */
#define DELAY_SEL                      (1 << 17)                 /* RW, Delay select, a 0x0 to 0x1 transition in this
                                                                 register initiates a delay access controlled by
                                                                 the registers below. */
#define DELAY_RWN                      (1 << 16)                 /* RW, Delay read (0x1) or write (0x0), the delay is
                                                                 accessed directly (no increment or decrement)
                                                                 with an address corresponding to each pin, and
                                                                 data corresponding to the total delay. */
#define DELAY_ADDRESS(x)               (((x) & 0xff) << 8)       /* RW, Delay address, the range depends on the
                                                                 interface pins, data pins are usually at the
                                                                 lower range. */
#define DELAY_WDATA(x)                 (((x) & 0x1f) << 0)       /* RW, Delay write data, a value of 1 corresponds to
                                                                 (1/200)ns for most devices. */
#define REG_DELAY_STATUS               0x0019                    /*ADC Interface Control & Status */
#define DELAY_LOCKED                   (1 << 9)                  /* RO, Indicates delay locked (0x1) state. If this
                                                                 bit is read 0x0, delay control has failed to
                                                                 calibrate the elements. */
#define DELAY_STATUS                   (1 << 8)                  /* RO, If set, indicates busy status (access
                                                                 pending). The read data may not be valid if this
                                                                 bit is set. */
#define DELAY_RDATA(x)                 (((x) & 0x1f) << 0)       /* RO, Delay read data, current delay value in the
                                                                 elements */
#define REG_DRP_CNTRL                  0x001c                    /*ADC Interface Control & Status */
#define DRP_RWN                        (1 << 28)                 /* RW, DRP read (0x1) or write (0x0) select (does
                                                                 not include GTX lanes). */
#define DRP_ADDRESS(x)                 (((x) & 0xfff) << 16)     /* RW, DRP address, designs that contain more than
                                                                 one DRP accessible primitives have selects based
                                                                 on the most significant bits (does not include
                                                                 GTX lanes). */
#define DRP_WDATA(x)                   (((x) & 0xffff) << 0)     /* RW, DRP write data (does not include GTX lanes). */
#define REG_DRP_STATUS                 0x001d                    /*ADC Interface Control & Status */
#define DRP_STATUS                     (1 << 16)                 /* RO, If set indicates busy (access pending). The
                                                                 read data may not be valid if this bit is set
                                                                 (does not include GTX lanes). */
#define DRP_RDATA(x)                   (((x) & 0xffff) << 0)     /* RO, DRP read data (does not include GTX lanes). */
#define REG_UI_STATUS                  0x0022                    /*User Interface Status */
#define UI_OVF                         (1 << 2)                  /* RW1C, User Interface overflow. If set, indicates
                                                                 an overflow occured during data transfer at the
                                                                 user interface (FIFO interface). Software must
                                                                 write a 0x1 to clear this register bit. */
#define UI_UNF                         (1 << 1)                  /* RW1C, User Interface underflow. If set, indicates
                                                                 an underflow occured during data transfer at the
                                                                 user interface (FIFO interface). Software must
                                                                 write a 0x1 to clear this register bit. */
#define UI_RESERVED                    (1 << 0)                  /* RW1C, Reserved for backward compatibility. */
#define REG_USR_CNTRL_1                0x0028                    /*ADC Interface Control & Status */
#define USR_CHANMAX(x)                 (((x) & 0xff) << 0)       /* RW, This indicates the maximum number of inputs
                                                                 for the channel data multiplexers. User may add
                                                                 different processing modules post data capture as
                                                                 another input to this common multiplexer.
                                                                 NOT-APPLICABLE if ADC_DP_DISABLE is set (0x1). */
#define REG_USR_CNTRL_1                0x0030                    /*ADC Interface Control & Status */
#define ADC_DP_DISABLE                 (1 << 0)                  /* RO, This indicates the data path disable setting
                                                                 of this pcore. If disabled, most of the HDL data
                                                                 path modules are disabled allowing an external
                                                                 core full access to the raw ADC data. */

/* ADC Channel */

#define REG_CHAN_CNTRL                 0x0100                    /*ADC Interface Control & Status */
#define PN_SEL                         (1 << 10)                 /* RW, if set, enables an additional PN sequence
                                                                 monitor (shares same status signals). */
#define IQCOR_ENB                      (1 << 9)                  /* RW, if set, enables IQ correction. NOT-APPLICABLE
                                                                 if ADC_DP_DISABLE is set (0x1). */
#define DCFILT_ENB                     (1 << 8)                  /* RW, if set, enables DC filter (to disable DC
                                                                 offset, set offset value to 0x0). NOT-APPLICABLE
                                                                 if ADC_DP_DISABLE is set (0x1). */
#define FORMAT_SIGNEXT                 (1 << 6)                  /* RW, if set, enables sign extension (applicable
                                                                 only in 2's complement mode). The data is always
                                                                 sign extended to the nearest byte boundary.
                                                                 NOT-APPLICABLE if ADC_DP_DISABLE is set (0x1). */
#define FORMAT_TYPE                    (1 << 5)                  /* RW, Select offset binary (0x1) or 2's complement
                                                                 (0x0) data type. This sets the incoming data type
                                                                 and is required by the post processing modules
                                                                 for any data conversion. NOT-APPLICABLE if
                                                                 ADC_DP_DISABLE is set (0x1). */
#define FORMAT_ENABLE                  (1 << 4)                  /* RW, Enable data format conversion (see register
                                                                 bits above). NOT-APPLICABLE if ADC_DP_DISABLE is
                                                                 set (0x1). */
#define PN_TYPE                        (1 << 1)                  /* RW, Selects PN type PN9 (0x0) or PN23 (0x1). If
                                                                 software is changing this bit, the OOS/ERR
                                                                 registers must be cleared before checking status
                                                                 again. */
#define ENABLE                         (1 << 0)                  /* RW, If set, enables channel. A 0x0 to 0x1
                                                                 transition transfers all the control signals to
                                                                 the respective channel processing module. If a
                                                                 channel is part of a complex signal (I/Q), even
                                                                 channel is the master and the odd channel is the
                                                                 slave. Though a single control is used, both must
                                                                 be individually selected. NOT-APPLICABLE if
                                                                 ADC_DP_DISABLE is set (0x1). */
#define REG_CHAN_STATUS                0x0101                    /*ADC Interface Control & Status */
#define PN_ERR                         (1 << 2)                  /* RW1C, PN errors. If set, indicates spurious
                                                                 mismatches in sync state. This bit is cleared if
                                                                 OOS is set and is only indicates errors when OOS
                                                                 is cleared. */
#define PN_OOS                         (1 << 1)                  /* RW1C, PN Out Of Sync. If set, indicates an OOS
                                                                 status. OOS is set, if 64 consecutive patterns
                                                                 mismatch from the expected pattern. It is
                                                                 cleared, when 16 consecutive patterns match the
                                                                 expected pattern. */
#define OVER_RANGE                     (1 << 0)                  /* RW1C, If set, indicates over range. Note that
                                                                 over range is independent of the data path, it
                                                                 indicates an over range over a data transfer
                                                                 period. Software must first clear this bit before
                                                                 initiating a transfer and monitor afterwards. */
#define REG_CHAN_CNTRL_1               0x0104                    /*ADC Interface Control & Status */
#define DCFILT_OFFSET(x)               (((x) & 0xffff) << 16)    /* RW, DC removal (if equipped) offset. This is a
                                                                 2's complement number added to the incoming data
                                                                 to remove a known DC offset. NOT-APPLICABLE if
                                                                 ADC_DP_DISABLE is set (0x1). */
#define DCFILT_COEFF(x)                (((x) & 0xffff) << 0)     /* RW, DC removal filter (if equipped) coefficient.
                                                                 The format is 1.1.14 (sign, integer and
                                                                 fractional bits). NOT-APPLICABLE if
                                                                 ADC_DP_DISABLE is set (0x1). */
#define REG_CHAN_CNTRL_2               0x0105                    /*ADC Interface Control & Status */
#define IQCOR_COEFF_1(x)               (((x) & 0xffff) << 16)    /* RW, IQ correction (if equipped) coefficient. If
                                                                 scale & offset is implemented, this is the scale
                                                                 value and the format is 1.1.14 (sign, integer and
                                                                 fractional bits). If matrix multiplication is
                                                                 used, this is the channel I coefficient and the
                                                                 format is 1.1.14 (sign, integer and fractional
                                                                 bits). NOT-APPLICABLE if ADC_DP_DISABLE is set
                                                                 (0x1). */
#define IQCOR_COEFF_2(x)               (((x) & 0xffff) << 0)     /* RW, IQ correction (if equipped) coefficient. If
                                                                 scale & offset is implemented, this is the offset
                                                                 value and the format is 2's complement. If matrix
                                                                 multiplication is used, this is the channel Q
                                                                 coefficient and the format is 1.1.14 (sign,
                                                                 integer and fractional bits). NOT-APPLICABLE if
                                                                 ADC_DP_DISABLE is set (0x1). */
#define REG_CHAN_USR_CNTRL_1           0x0108                    /*ADC Interface Control & Status */
#define USR_DATATYPE_BE                (1 << 25)                 /* RW, The user data type format- if set, indicates
                                                                 big endian (default is little endian).
                                                                 NOT-APPLICABLE if ADC_DP_DISABLE is set (0x1). */
#define USR_DATATYPE_SIGNED            (1 << 24)                 /* RW, The user data type format- if set, indicates
                                                                 signed (2's complement) data (default is
                                                                 unsigned). NOT-APPLICABLE if ADC_DP_DISABLE is
                                                                 set (0x1). */
#define USR_DATATYPE_SHIFT(x)          (((x) & 0xff) << 16)      /* RW, The user data type format- the amount of
                                                                 right shift for actual samples within the total
                                                                 number of bits. NOT-APPLICABLE if ADC_DP_DISABLE
                                                                 is set (0x1). */
#define USR_DATATYPE_TOTAL_BITS(x)     (((x) & 0xff) << 8)       /* RW, The user data type format- number of total
                                                                 bits used for a sample. The total number of bits
                                                                 must be an integer multiple of 8 (byte aligned).
                                                                 NOT-APPLICABLE if ADC_DP_DISABLE is set (0x1). */
#define USR_DATATYPE_BITS(x)           (((x) & 0xff) << 0)       /* RW, The user data type format- number of bits in
                                                                 a sample. This indicates the actual sample data
                                                                 bits. NOT-APPLICABLE if ADC_DP_DISABLE is set
                                                                 (0x1). */
#define REG_CHAN_USR_CNTRL_2           0x0109                    /*ADC Interface Control & Status */
#define USR_DECIMATION_M(x)            (((x) & 0xffff) << 16)    /* RW, This holds the user decimation M value of the
                                                                 channel that is currently being selected on the
                                                                 multiplexer above. The toal decimation factor is
                                                                 of the form M/N. NOT-APPLICABLE if ADC_DP_DISABLE
                                                                 is set (0x1). */
#define USR_DECIMATION_N(x)            (((x) & 0xffff) << 0)     /* RW, This holds the user decimation N value of the
                                                                 channel that is currently being selected on the
                                                                 multiplexer above. The toal decimation factor is
                                                                 of the form M/N. NOT-APPLICABLE if ADC_DP_DISABLE
                                                                 is set (0x1). */
#define REG_*                          0x0110                    /*Channel 1, similar to register 0x100 to 0x10f. */
#define REG_*                          0x0120                    /*Channel 2, similar to register 0x100 to 0x10f. */
#define REG_*                          0x01f0                    /*Channel 15, similar to register 0x100 to 0x10f. */

