/* Register Map Definitions */
/* Tue Nov 26 10:04:57 2013 */


/* JESD Receive */

#define REG_RSTN                       0x0010                    /*JESD General Control & Status */
#define DRP_RSTN                       (1 << 3)                  /* RW, DRP Reset Only. Reset, default is IN-RESET
                                                                 (0x0), software must write a 0x1 to bring up the
                                                                 interface. */
#define IP_RSTN                        (1 << 2)                  /* RW, IP Reset Only. Reset, default is IN-RESET
                                                                 (0x0), software must write a 0x1 to bring up the
                                                                 interface. */
#define IP_RSTN                        (1 << 1)                  /* RW, Core Reset Only (non-IP). Reset, default is
                                                                 IN-RESET (0x0), software must write a 0x1 to
                                                                 bring up the interface. */
#define GT_RSTN                        (1 << 0)                  /* RW, GT Reset Only (PLL, PMA and PCS -within the
                                                                 GTX). Reset, default is IN-RESET (0x0), software
                                                                 must write a 0x1 to bring up the interface. */
#define REG_SYSREF                     0x0011                    /*JESD General Control & Status */
#define IP_SYSREF                      (1 << 1)                  /* RW, A 0 to 1 transition generates a SYSREF pulse
                                                                 for the XIP. */
#define SYSREF                         (1 << 0)                  /* RW, A 0 to 1 transition generates a SYSREF pulse
                                                                 on the interface. */
#define REG_SYNC                       0x0012                    /*JESD General Control & Status */
#define SYNC                           (1 << 0)                  /* RW, The SYNC output is deasserted if this bit and
                                                                 hardware are both set. */
#define REG_RX_CNTRL_1                 0x0014                    /*JESD Receive Control & Status */
#define RX_LANESYNC_ENB                (1 << 18)                 /* RW, Receive lane synchronization enable. */
#define RX_DESCR_ENB                   (1 << 17)                 /* RW, Receive descrambler enable. */
#define RX_SYSREF_ENB                  (1 << 16)                 /* RW, Receive SYESREF enable. */
#define RX_MFRM_FRMCNT(x)              (((x) & 0xff) << 8)       /* RW, Receive mult-frame frame count, set to one
                                                                 less than the number of frames in a multi-frame. */
#define RX_FRM_BYTECNT(x)              (((x) & 0xff) << 0)       /* RW, Receive frame byte count, set to one less
                                                                 than the number of bytes in a frame. */
#define REG_RX_CNTRL_2                 0x0015                    /*JESD Receive Control & Status */
#define RX_ERRRPT_DISB                 (1 << 20)                 /* RW, Receive error reporting disable. */
#define RX_TESTMODE(x)                 (((x) & 0xf) << 16)       /* RW, Receive test mode. */
#define RX_BUFDELAY(x)                 (((x) & 0xffff) << 0)     /* RW, Receive buffer delay. */
#define REG_RX_LANESEL                 0x0017                    /*JESD, Lane Control & Status */
#define RX_LANESEL(x)                  (((x) & 0xff) << 0)       /* RW, Receive lane select, lane information, DRP
                                                                 access and eye scan are per lane and this
                                                                 register selects the lane. */
#define REG_RX_STATUS                  0x0018                    /*JESD, Lane Control & Status */
#define RX_STATUS                      (1 << 0)                  /* RO, Interface status, if set indicates no errors.
                                                                 If not set, there are errors, software may try
                                                                 resetting the cores. */
#define REG_RX_INIT_DATA_0             0x0019                    /*JESD, Lane Control & Status */
#define RX_INIT_DATA_0(x)              (((x) & 0xffffffff) << 0) /* RO, Receive lane information (collected during
                                                                 ILAS phase). */
#define REG_RX_INIT_DATA_1             0x001a                    /*JESD, Lane Control & Status */
#define RX_INIT_DATA_1(x)              (((x) & 0xffffffff) << 0) /* RO, Receive lane information (collected during
                                                                 ILAS phase). */
#define REG_RX_INIT_DATA_2             0x001b                    /*JESD, Lane Control & Status */
#define RX_INIT_DATA_2(x)              (((x) & 0xffffffff) << 0) /* RO, Receive lane information (collected during
                                                                 ILAS phase). */
#define REG_RX_INIT_DATA_2             0x001c                    /*JESD, Lane Control & Status */
#define RX_INIT_DATA_3(x)              (((x) & 0xffffffff) << 0) /* RO, Receive lane information (collected during
                                                                 ILAS phase). */
#define REG_RX_BUFCNT                  0x001d                    /*JESD, Lane Control & Status */
#define RX_BUFCNT(x)                   (((x) & 0xff) << 0)       /* RO, Receive lane alignment buffer count. */
#define REG_RX_TEST_MFCNT              0x001e                    /*JESD, Lane Control & Status */
#define RX_TEST_MFCNT(x)               (((x) & 0xffffffff) << 0) /* RO, Receive test multi-frame count. */
#define REG_RX_TEST_ILACNT             0x001f                    /*JESD, Lane Control & Status */
#define RX_TEST_ILACNT(x)              (((x) & 0xffffffff) << 0) /* RO, Receive test ILAS count. */
#define REG_RX_TEST_ERRCNT             0x0020                    /*JESD, Lane Control & Status */
#define RX_TEST_ERRCNT(x)              (((x) & 0xffffffff) << 0) /* RO, Receive test error count. */
#define REG_DRP_CNTRL                  0x0024                    /*JESD, GT DRP Control & Status */
#define DRP_RWN                        (1 << 28)                 /* RW, DRP read (0x1) or write (0x0) select. */
#define DRP_ADDRESS(x)                 (((x) & 0xfff) << 16)     /* RW, DRP address. */
#define DRP_WDATA(x)                   (((x) & 0xffff) << 0)     /* RW, DRP write data. */
#define REG_DRP_STATUS                 0x0025                    /*JESD, Lane Control & Status */
#define DRP_STATUS                     (1 << 16)                 /* RO, If set indicates busy (access pending). The
                                                                 read data may not be valid if this bit is set. */
#define DRP_RDATA(x)                   (((x) & 0xffff) << 0)     /* RO, DRP read data. */
#define REG_EYESCAN_CNTRL              0x0028                    /*JESD, GT Eye Scan Control & Status */
#define EYESCAN_INIT                   (1 << 2)                  /* RW, Eye scan init - if set, enables
                                                                 initialization of GT. It can be disabled on
                                                                 successive eye scan. */
#define EYESCAN_STOP                   (1 << 1)                  /* RW, Eye scan stop- a 0x0 to 0x1 transition
                                                                 terminates eye scan on the selected lane. */
#define EYESCAN_START                  (1 << 0)                  /* RW, Eye scan start- a 0x0 to 0x1 transition
                                                                 initiates eye scan on the selected lane. The scan
                                                                 might take a while, software must monitor the
                                                                 status. */
#define REG_EYESCAN_PRESCALE           0x0029                    /*JESD, Lane Control & Status */
#define EYESCAN_PRESCALE(x)            (((x) & 0x1f) << 0)       /* RW, Eye scan prescale, refer to the Xilinx
                                                                 documentation for details - the counters are
                                                                 prescaled to 2<sup>(n+1)</sup>. */
#define REG_EYESCAN_VOFFSET            0x002a                    /*JESD, Lane Control & Status */
#define EYESCAN_VOFFSET_STEP(x)        (((x) & 0xff) << 16)      /* RW, Eye scan vertical offset step. The value must
                                                                 be set in 2's complement, refer to the Xilinx
                                                                 documentation for details. */
#define EYESCAN_VOFFSET_MAX(x)         (((x) & 0xff) << 8)       /* RW, Eye scan vertical offset maximum (+128). The
                                                                 value must be set in 2's complement, refer to the
                                                                 Xilinx documentation for details. */
#define EYESCAN_VOFFSET_MIN(x)         (((x) & 0xff) << 0)       /* RW, Eye scan vertical offset minimum (-128). The
                                                                 value must be set in 2's complement, refer to the
                                                                 Xilinx documentation for details. */
#define REG_EYESCAN_HOFFSET_1          0x002b                    /*JESD, Lane Control & Status */
#define EYESCAN_HOFFSET_MAX(x)         (((x) & 0xfff) << 16)     /* RW, Eye scan horizontal offset maximum. The value
                                                                 depends on the clock divider, as the eye scan is
                                                                 post CDR and comparison happens on parallel bus.
                                                                 The value must be set in 2's complement, refer to
                                                                 the Xilinx documentation for details. */
#define EYESCAN_HOFFSET_MIN(x)         (((x) & 0xfff) << 0)      /* RW, Eye scan horizontal offset minimum. The value
                                                                 depends on the clock divider, as the eye scan is
                                                                 post CDR and comparison happens on parallel bus.
                                                                 The value must be set in 2's complement, refer to
                                                                 the Xilinx documentation for details. */
#define REG_EYESCAN_HOFFSET_2          0x002c                    /*JESD, Lane Control & Status */
#define EYESCAN_HOFFSET_STEP(x)        (((x) & 0xfff) << 0)      /* RW, Eye scan horizontal offset step. The value
                                                                 must be set in 2's complement, refer to the
                                                                 Xilinx documentation for details. */
#define REG_EYESCAN_DMA_STARTADDR      0x002d                    /*JESD, Lane Control & Status */
#define EYESCAN_DMA_STARTADDR(x)       (((x) & 0xffffffff) << 0) /* RW, Eye scan DMA start address. The AXI master
                                                                 interface writes eye scan data starting at this
                                                                 address. The first data written corresponds to
                                                                 the minimum of horizontal and vertical offsets
                                                                 (UT = 0). */
#define REG_EYESCAN_SDATA_1_0          0x002e                    /*JESD, Lane Control & Status */
#define EYESCAN_SDATA1(x)              (((x) & 0xffff) << 16)    /* RW, Eye scan sample data mask word (1) (80bits =
                                                                 {4, 3, 2, 1, 0}) */
#define EYESCAN_SDATA0(x)              (((x) & 0xffff) << 0)     /* RW, Eye scan sample data mask word (0) (80bits =
                                                                 {4, 3, 2, 1, 0}) */
#define REG_EYESCAN_SDATA_3_2          0x002f                    /*JESD, Lane Control & Status */
#define EYESCAN_SDATA3(x)              (((x) & 0xffff) << 16)    /* RW, Eye scan sample data mask word (3) (80bits =
                                                                 {4, 3, 2, 1, 0}) */
#define EYESCAN_SDATA2(x)              (((x) & 0xffff) << 0)     /* RW, Eye scan sample data mask word (2) (80bits =
                                                                 {4, 3, 2, 1, 0}) */
#define REG_EYESCAN_SDATA_4            0x0030                    /*JESD, Lane Control & Status */
#define EYESCAN_SDATA4(x)              (((x) & 0xffff) << 0)     /* RW, Eye scan sample data mask word (0) (80bits =
                                                                 {4, 3, 2, 1, 0}) */
#define REG_EYESCAN_QDATA_1_0          0x0031                    /*JESD, Lane Control & Status */
#define EYESCAN_QDATA1(x)              (((x) & 0xffff) << 16)    /* RW, Eye scan qualifier data mask word (1) (80bits
                                                                 = {4, 3, 2, 1, 0}) */
#define EYESCAN_QDATA0(x)              (((x) & 0xffff) << 0)     /* RW, Eye scan qualifier data mask word (0) (80bits
                                                                 = {4, 3, 2, 1, 0}) */
#define REG_EYESCAN_QDATA_3_2          0x0032                    /*JESD, Lane Control & Status */
#define EYESCAN_QDATA3(x)              (((x) & 0xffff) << 16)    /* RW, Eye scan qualifier data mask word (3) (80bits
                                                                 = {4, 3, 2, 1, 0}) */
#define EYESCAN_QDATA2(x)              (((x) & 0xffff) << 0)     /* RW, Eye scan qualifier data mask word (2) (80bits
                                                                 = {4, 3, 2, 1, 0}) */
#define REG_EYESCAN_QDATA_4            0x0033                    /*JESD, Lane Control & Status */
#define EYESCAN_QDATA4(x)              (((x) & 0xffff) << 0)     /* RW, Eye scan qualifier data mask word (0) (80bits
                                                                 = {4, 3, 2, 1, 0}) */
#define REG_EYESCAN_STATUS             0x0038                    /*JESD, Lane Control & Status */
#define EYESCAN_DMAERR                 (1 << 1)                  /* RW1C, Eye scan DMA error. If set, indicates a
                                                                 target error on AXI bus. */
#define EYESCAN_STATUS                 (1 << 0)                  /* RO, Eye scan status. If set, indicates the eye
                                                                 scan is running. Software may still access the
                                                                 data at the destination, but it may not be
                                                                 complete until this bit is cleared by hardware. */
#define REG_EYESCAN_RATE               0x0039                    /*JESD, Lane Control & Status */
#define EYESCAN_RATE                   (1 << 1)                  /* RO, Indicates eye scan rate - 0x1 (-32 to +32),
                                                                 0x2 (-64 to +64), 0x4 (-128 to +128), 0x8 (-256
                                                                 to +256), 0x10 (-512 to +512). */

