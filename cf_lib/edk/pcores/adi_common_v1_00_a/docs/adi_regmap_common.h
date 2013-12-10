/* Register Map Definitions */
/* Tue Nov 26 10:04:57 2013 */


/* General */

#define REG_VERSION                    0x0000                    /*Version and Scratch Registers */
#define VERSION(x)                     (((x) & 0xffffffff) << 0) /* RO, Version number. */
#define REG_ID                         0x0001                    /*Version and Scratch Registers */
#define ID(x)                          (((x) & 0xffffffff) << 0) /* RO, Instance identifier number. */
#define REG_SCRATCH                    0x0002                    /*Version and Scratch Registers */
#define SCRATCH(x)                     (((x) & 0xffffffff) << 0) /* RW, Scratch register. */

