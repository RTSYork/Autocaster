#ifndef ETHERNET_H_
#define ETHERNET_H_

#include "xemaclite.h"

#define PHY_REG0_OFFSET		0 /* Register 0 of PHY device */
#define PHY_REG1_OFFSET 	1 /* Register 1 of PHY device */

#define PHY_REG0_RESET_MASK	0x8000  /* Reset Phy device */
#define PHY_REG0_LOOPBACK_MASK	0x4000  /* Loopback Enable in Phy */
#define PHY_REG0_SPD_100_MASK	0x2000  /* Speed of 100Mbps for Phy */

#define PHY_REG1_DETECT_MASK	0x1808	/* Mask to detect PHY device */

#define EMACLITE_PHY_DELAY_SEC	4	/* Amount of time to delay waiting on PHY to reset. */

extern u8 TxFrame[XEL_MAX_FRAME_SIZE];

int ethernetInit(void);
int ethernetSendPayload(u32 payloadSize, u8* payload);
int ethernetSend(u32 payloadSize);
u32 EmacLitePhyDetect(void);
int EmacLiteSetupPhy(u32 PhyAddress);
void EmacLitePhyDelay(unsigned int Seconds);

#endif /* ETHERNET_H_ */
