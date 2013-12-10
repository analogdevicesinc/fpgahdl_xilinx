/* Register Map Definitions */
/* Tue Nov 26 10:04:57 2013 */


/* AXIS Receive */

#define REG_RSTN                       0x0010                    /*AXIS Interface Control & Status */
#define RSTN                           (1 << 0)                  /* RW, Reset, default is IN-RESET (0x0), software
                                                                 must write 0x1 to bring up the core. */
#define REG_DMA_CNTRL                  0x0020                    /*AXIS Interface Control & Status */
#define DMA_STREAM                     (1 << 1)                  /* RW, If set, DMA is in stream mode, data is
                                                                 continously passed to the DMA module, with TLAST
                                                                 asserted every DMA count cycles on the data bus.
                                                                 The ADC interface does not do the actual DMA, so
                                                                 the success of a stream mode (bandwidth effects)
                                                                 depends mainly on the DMA module. */
#define DMA_START                      (1 << 0)                  /* RW, A 0x0 to 0x1 transition on this bit initiates
                                                                 DMA. */
#define REG_DMA_COUNT                  0x0021                    /*AXIS Interface Control & Status */
#define DMA_COUNT(x)                   (((x) & 0xffffffff) << 0) /* RW, DMA data count, mainly used to assert TLAST.
                                                                 Software must program the DMA controller with the
                                                                 same settings. The count is based on bytes (same
                                                                 as DMA setting), however the value must be an
                                                                 integer multiple of the bus width. In most cases
                                                                 the granularity is 4 bytes. The value programmed
                                                                 is the actual number of bytes, hence zero is not
                                                                 valid. */
#define REG_DMA_STATUS                 0x0022                    /*AXIS Interface Control & Status */
#define DMA_OVF                        (1 << 2)                  /* RW1C, DMA overflow. If set, indicates an overflow
                                                                 occured during data transfer. Software must write
                                                                 a 0x1 before starting another transfer to clear
                                                                 any left off status from a previous DMA. */
#define DMA_STATUS                     (1 << 0)                  /* RO, DMA status. If set, indicates access is
                                                                 pending and transfer is not complete.
                                                                 NOT-APPLICABLE (Moved to new AXIS pcore). */
#define REG_DMA_BUSWIDTH               0x0023                    /*AXIS Interface Control & Status */
#define DMA_BUSWIDTH(x)                (((x) & 0xffffffff) << 0) /* RO, DMA data bus width in number of bytes (the
                                                                 DMA count must be an integer multiple of this bus
                                                                 width). */

/* AXIS Transmit */

#define REG_RSTN                       0x1010                    /*AXIS Interface Control & Status */
#define RSTN                           (1 << 0)                  /* RW, Reset, default is IN-RESET (0x0), software
                                                                 must write 0x1 to bring up the core. */
#define REG_VDMA_FRMCNT                0x1021                    /*VDMA Control & Status */
#define VDMA_FRMCNT(x)                 (((x) & 0xffffffff) << 0) /* RW, This register controls the frame sync
                                                                 assertion to VDMA. This can be set to any count
                                                                 greater than the actual frame length (in bytes). */
#define REG_VDMA_STATUS                0x1022                    /*VDMA Interface Control & Status */
#define VDMA_OVF                       (1 << 1)                  /* RW1C, VDMA overflow. If set, indicates an
                                                                 overflow occured during data transfer. Software
                                                                 must write a 0x1 before starting another transfer
                                                                 to clear any left off status from a previous
                                                                 VDMA. */
#define VDMA_UNF                       (1 << 0)                  /* RW1C, VDMA underflow. If set, indicates an
                                                                 underflow occured during data transfer. Software
                                                                 must write a 0x1 before starting another transfer
                                                                 to clear any left off status from a previous
                                                                 VDMA. */

