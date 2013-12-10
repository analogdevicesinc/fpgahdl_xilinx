/* Register Map Definitions */
/* Tue Nov 26 10:04:57 2013 */


/* DDR Controller */

#define REG_RSTN                       0x0010                    /*DDR Interface Control & Status */
#define RSTN                           (1 << 0)                  /* RW, DDR controller reset, software must write 0x1
                                                                 to bring up the core. */
#define REG_STATUS                     0x0017                    /*DDR Interface Control & Status */
#define STATUS                         (1 << 0)                  /* RO, Interface status, if set indicates no errors.
                                                                 If not set, there are errors, software may try
                                                                 resetting the cores. */
#define REG_DDR_CNTRL                  0x0018                    /*DDR Write Control & Status */
#define DDR_STREAM                     (1 << 1)                  /* RW, If set, DDR write is in stream mode, data is
                                                                 continously passed to the DDR module, */
#define DDR_START                      (1 << 0)                  /* RW, A 0x0 to 0x1 transition on this bit initiates
                                                                 DDR writes. */
#define REG_DDR_COUNT                  0x0019                    /*DDR Write Control & Status */
#define DDR_COUNT(x)                   (((x) & 0xffffffff) << 0) /* RW, DDR data count, usually the final dma data
                                                                 count (see below) in number of bytes. The
                                                                 software could program the DDR controller with
                                                                 the same DMA settings. The count is based on
                                                                 bytes, however the value must be an integer
                                                                 multiple of the bus width. The value programmed
                                                                 is the actual number of bytes, hence zero is not
                                                                 valid. */
#define REG_DDR_STATUS                 0x001a                    /*DDR Write Control & Status */
#define DDR_OVF                        (1 << 2)                  /* RW1C, DDR write overflow. If set, indicates an
                                                                 overflow occured during data transfer. Software
                                                                 must write a 0x1 before starting another transfer
                                                                 to clear any left off status from a previous
                                                                 write. */
#define DDR_UNF                        (1 << 1)                  /* RW1C, DDR write underflow. If set, indicates an
                                                                 underflow occured during data transfer. Software
                                                                 must write a 0x1 before starting another transfer
                                                                 to clear any left off status from a previous
                                                                 write. */
#define DDR_STATUS                     (1 << 0)                  /* RW1C, DDR write status. If set, indicates access
                                                                 is pending and transfer is not complete. */
#define REG_DDR_BUSWIDTH               0x001b                    /*DDR Write Control & Status */
#define DDR_BUSWIDTH(x)                (((x) & 0xffffffff) << 0) /* RO, DDR data bus width in number of bytes (the
                                                                 DDR count must be an integer multiple of this bus
                                                                 width). */
#define REG_DMA_CNTRL                  0x0020                    /*DDR Read Control & Status */
#define DMA_STREAM                     (1 << 1)                  /* RW, If set, DMA is in stream mode, data is
                                                                 continously passed to the DMA module, with TLAST
                                                                 asserted every DMA count cycles on the data bus.
                                                                 The ADC interface does not do the actual DMA, so
                                                                 the success of a stream mode (bandwidth effects)
                                                                 depends mainly on the DMA module. */
#define DMA_START                      (1 << 0)                  /* RW, A 0x0 to 0x1 transition on this bit initiates
                                                                 DMA. */
#define REG_DMA_COUNT                  0x0021                    /*DDR Read Control & Status */
#define DMA_COUNT(x)                   (((x) & 0xffffffff) << 0) /* RW, DMA data count, mainly used to assert TLAST.
                                                                 Software must program the DMA controller with the
                                                                 same settings. The count is based on bytes (same
                                                                 as DMA setting), however the value must be an
                                                                 integer multiple of the bus width. In most cases
                                                                 the granularity is 4 bytes. The value programmed
                                                                 is the actual number of bytes, hence zero is not
                                                                 valid. */
#define REG_DMA_STATUS                 0x0022                    /*DDR Read Control & Status */
#define DMA_OVF                        (1 << 2)                  /* RW1C, DMA overflow. If set, indicates an overflow
                                                                 occured during data transfer. Software must write
                                                                 a 0x1 before starting another transfer to clear
                                                                 any left off status from a previous DMA. */
#define DMA_UNF                        (1 << 1)                  /* RW1C, DMA underflow. If set, indicates an
                                                                 underflow occured during data transfer. Software
                                                                 must write a 0x1 before starting another transfer
                                                                 to clear any left off status from a previous DMA. */
#define DMA_STATUS                     (1 << 0)                  /* RW1C, DMA status. If set, indicates access is
                                                                 pending and transfer is not complete. */
#define REG_DMA_BUSWIDTH               0x0023                    /*DDR Read Control & Status */
#define DMA_BUSWIDTH(x)                (((x) & 0xffffffff) << 0) /* RO, DMA data bus width in number of bytes (the
                                                                 DMA count must be an integer multiple of this bus
                                                                 width). */

