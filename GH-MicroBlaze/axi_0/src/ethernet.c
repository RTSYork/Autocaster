#include "ethernet.h"

static u8 LocalMacAddress[XEL_MAC_ADDR_SIZE] =
{
	0x00, 0x0A, 0x35, 0x01, 0x02, 0x03
};
static u8 LocalIpAddress[4] =
{
	169, 254, 0, 0
};

// Remote address is broadcast to 144.32.175.192/27 subnet
static u8 RemoteMacAddress[XEL_MAC_ADDR_SIZE] =
{
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
};
static u8 RemoteIpAddress[4] =
{
	0x90, 0x20, 0xAF, 0xDF
};

/*
 * Buffers used for Transmission and Reception of Packets
 */
u8 TxFrame[XEL_MAX_FRAME_SIZE];

static XEmacLite EmacLite;

int ethernetInit(void) {
	int Status;
	XEmacLite_Config *ConfigPtr;
	XEmacLite *InstancePtr = &EmacLite;

	/*
	 * Initialize the EmacLite device.
	 */
	ConfigPtr = XEmacLite_LookupConfig(XPAR_AXI_ETHERNETLITE_0_DEVICE_ID);
	if (ConfigPtr == NULL) {
		return XST_FAILURE;
	}
	Status = XEmacLite_CfgInitialize(InstancePtr,
			ConfigPtr,
			ConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Set the MAC address.
	 */
	XEmacLite_SetMacAddress(InstancePtr, LocalMacAddress);

	/*
	 * Empty any existing receive frames.
	 */
	XEmacLite_FlushReceive(InstancePtr);

	u32 PhyAddress = EmacLitePhyDetect();
	Status = EmacLiteSetupPhy(PhyAddress);

	return XST_SUCCESS;
}

int ethernetSendPayload(u32 payloadSize, u8* payload) {
	u8 *FramePtr = (u8 *)TxFrame;
	FramePtr += XEL_HEADER_SIZE + 28;

	// Copy payload into packet
	u32 i;
	for (i = 0; i < payloadSize; i++) {
		*FramePtr++ = payload[i];
	}

	// Add header and send packet
	return ethernetSend(payloadSize);
}


int ethernetSend(u32 payloadSize) {
	XEmacLite *InstancePtr = &EmacLite;
	u8 *FramePtr = (u8 *)TxFrame;


	/*
	 * Set up the destination address
	 */
	*FramePtr++ = RemoteMacAddress[0];
	*FramePtr++ = RemoteMacAddress[1];
	*FramePtr++ = RemoteMacAddress[2];
	*FramePtr++ = RemoteMacAddress[3];
	*FramePtr++ = RemoteMacAddress[4];
	*FramePtr++ = RemoteMacAddress[5];


	/*
	 * Fill in the source MAC address.
	 */
	*FramePtr++ = LocalMacAddress[0];
	*FramePtr++ = LocalMacAddress[1];
	*FramePtr++ = LocalMacAddress[2];
	*FramePtr++ = LocalMacAddress[3];
	*FramePtr++ = LocalMacAddress[4];
	*FramePtr++ = LocalMacAddress[5];

	/*
	 * Set up the type/length field - be sure its in network order.
	 */
	//*((u16 *)FramePtr) = Xil_Htons(PayloadSize);
	//FramePtr++;
	//FramePtr++;

	// IPv4 Ethertype
	*((u16 *)FramePtr) = Xil_Htons(0x0800);
	FramePtr++;
	FramePtr++;

	// IPv4 header Checksum
	u32 check1 = 0x4500 + (20 + 8 + payloadSize) + 0x1011
			+ ((LocalIpAddress[0] << 8) | LocalIpAddress[1]) + ((LocalIpAddress[2] << 8) | LocalIpAddress[3])
			+ ((RemoteIpAddress[0] << 8) | RemoteIpAddress[1]) + ((RemoteIpAddress[2] << 8) | RemoteIpAddress[3]);
	u32 check2 = ((check1 & 0xFFFF0000) >> 16) + (check1 & 0x0000FFFF);
	u16 check3 = ~check2 & 0xFFFF;

	// IPv4 Header
	*FramePtr++ = 0x45; // Version (4) and header length (5)
	*FramePtr++ = 0x00; // DSCP and ECN
	*((u16 *)FramePtr) = Xil_Htons(20 + 8 + payloadSize);  // Total length (IPv4 header + UDP header + UDP data)
	FramePtr++;
	FramePtr++;
	*((u16 *)FramePtr) = 0x0000;  // Identification
	FramePtr++;
	FramePtr++;
	*((u16 *)FramePtr) = 0x0000;  // Flags and Fragment Offset
	FramePtr++;
	FramePtr++;
	*FramePtr++ = 0x10; // Time To Live (16 hops)
	*FramePtr++ = 0x11; // Protocol (UDP)
	*((u16 *)FramePtr) = Xil_Htons(check3); // Checksum
	FramePtr++;
	FramePtr++;
	*FramePtr++ = LocalIpAddress[0]; // Source IP Address
	*FramePtr++ = LocalIpAddress[1];
	*FramePtr++ = LocalIpAddress[2];
	*FramePtr++ = LocalIpAddress[3];
	*FramePtr++ = RemoteIpAddress[0]; // Destination IP Address
	*FramePtr++ = RemoteIpAddress[1];
	*FramePtr++ = RemoteIpAddress[2];
	*FramePtr++ = RemoteIpAddress[3];

	// UDP Packet
	*((u16 *)FramePtr) = 0x0000; // Source port (not used)
	FramePtr++;
	FramePtr++;
	*((u16 *)FramePtr) = Xil_Htons(0xF00D); // Destination port (61453)
	FramePtr++;
	FramePtr++;
	*((u16 *)FramePtr) = Xil_Htons(8 + payloadSize); // Length (header + data)
	FramePtr++;
	FramePtr++;
	*((u16 *)FramePtr) = 0x0000; // Checksum (not used)
	FramePtr++;
	FramePtr++;

	//Wait for the HW to be ready
	u32 reg;
	do {
		reg = XEmacLite_GetTxStatus(XPAR_EMACLITE_0_BASEADDR);
	}
	while((reg & (XEL_TSR_XMIT_BUSY_MASK | XEL_TSR_XMIT_ACTIVE_MASK)) != 0);

	/*
	 * Now send the frame.
	 */
	return XEmacLite_Send(InstancePtr, (u8 *)TxFrame, payloadSize + XEL_HEADER_SIZE + 20 + 8);
}


/******************************************************************************/
/**
*
* This function detects the PHY address by looking for successful MII status
* register contents (PHY register 1). It looks for a PHY that supports
* auto-negotiation and 10Mbps full-duplex and half-duplex. So, this code
* won't work for PHYs that don't support those features, but it's a bit more
* general purpose than matching a specific PHY manufacturer ID.
*
* Note also that on some (older) Xilinx ML4xx boards, PHY address 0 does not
* properly respond to this query. But, since the default is 0 and assuming
* no other address responds, then it seems to work OK.
*
* @param	InstancePtr is the pointer to the instance of EmacLite driver.
*
* @return	The address of the PHY device detected (returns 0 if not
*		detected).
*
* @note
*		The bit mask (0x1808) of the MII status register
*		(PHY Register 1) used in this function are:
* 		0x1000: 10Mbps full duplex support.
* 		0x0800: 10Mbps half duplex support.
*  		0x0008: Auto-negotiation support.
*
******************************************************************************/
u32 EmacLitePhyDetect(void)
{
	XEmacLite *InstancePtr = &EmacLite;
	u16 PhyData;
	int PhyAddr;

	/*
	 * Verify all 32 MDIO ports.
	 */
	for (PhyAddr = 31; PhyAddr >= 0; PhyAddr--) {
		XEmacLite_PhyRead(InstancePtr, PhyAddr, PHY_REG1_OFFSET,
				 &PhyData);

		if (PhyData != 0xFFFF) {
			if ((PhyData & PHY_REG1_DETECT_MASK) ==
			PHY_REG1_DETECT_MASK) {
				return PhyAddr;	/* Found a valid PHY device */
			}
		}
	}
	/*
	 * Unable to detect PHY device returning the default address of 0.
	 */
	return 0;
}

/******************************************************************************/
/**
*
* This function enables the MAC loopback on the PHY.
*
* @param	InstancePtr is the pointer to the instance of EmacLite driver.
* @param	PhyAddress is the address of the Phy device.
*
* @return
*		- XST_SUCCESS if the loop back is enabled.
*		- XST_FAILURE if the loop back was not enabled.
*
* @note		None.
*
******************************************************************************/
int EmacLiteSetupPhy(u32 PhyAddress)
{
	XEmacLite *InstancePtr = &EmacLite;
	int Status;
	u16 PhyData = 0;

	/*
	 * Set the speed and put the PHY in reset.
	 */
	PhyData |= PHY_REG0_SPD_100_MASK;
	Status = XEmacLite_PhyWrite(InstancePtr, PhyAddress, PHY_REG0_OFFSET,
			PhyData | PHY_REG0_RESET_MASK);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Give sufficient delay for Phy Reset.
	 */
	EmacLitePhyDelay(EMACLITE_PHY_DELAY_SEC);

	/*
	 * Set the PHY in loop back.
	 */
	XEmacLite_PhyWrite(InstancePtr, PhyAddress, PHY_REG0_OFFSET,
			PhyData);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Give sufficient delay for Phy Loopback Enable.
	 */
	EmacLitePhyDelay(1);

	return XST_SUCCESS;
}


/******************************************************************************/
/**
*
* For Microblaze we use an assembly loop that
* is roughly the same regardless of optimization level, although caches and
* memory access time can make the delay vary.  Just keep in mind that after
* resetting or updating the PHY modes, the PHY typically needs time to recover.
*
* @return   None
*
* @note     None
*
******************************************************************************/
void EmacLitePhyDelay(unsigned int Seconds)
{
	static int WarningFlag = 0;

	/* If MB caches are disabled or do not exist, this delay loop could
	 * take minutes instead of seconds (e.g., 30x longer).  Print a warning
	 * message for the user (once).  If only MB had a built-in timer!
	 */
	if (((mfmsr() & 0x20) == 0) && (!WarningFlag)) {
#ifdef STDOUT_BASEADDRESS
		xil_printf("Warning: This example will take ");
		xil_printf("minutes to complete without I-cache enabled \r\n");
#endif
		WarningFlag = 1;
	}

#define ITERS_PER_SEC   (XPAR_CPU_CORE_CLOCK_FREQ_HZ / 6)
    asm volatile ("\n"
                  "1:               \n\t"
                  "addik r7, r0, %0 \n\t"
                  "2:               \n\t"
                  "addik r7, r7, -1 \n\t"
                  "bneid  r7, 2b    \n\t"
                  "or  r0, r0, r0   \n\t"
                  "bneid %1, 1b     \n\t"
                  "addik %1, %1, -1 \n\t"
                  :: "i"(ITERS_PER_SEC), "d" (Seconds));
}

