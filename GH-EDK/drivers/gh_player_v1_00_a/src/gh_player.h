/*****************************************************************************
* Filename:          C:\rj553\AXI/drivers/gh_player_v1_00_a/src/gh_player.h
* Version:           1.00.a
* Description:       gh_player Driver Header File
* Date:              Wed Jan 02 17:10:05 2013 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#ifndef GH_PLAYER_H
#define GH_PLAYER_H

/***************************** Include Files *******************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xil_io.h"

/************************** Constant Definitions ***************************/


/**
 * User Logic Slave Space Offsets
 * -- SLV_REG0 : user logic slave module register 0
 * -- SLV_REG1 : user logic slave module register 1
 */
#define GH_PLAYER_USER_SLV_SPACE_OFFSET (0x00000000)
#define GH_PLAYER_SLV_REG0_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000000)
#define GH_PLAYER_SLV_REG1_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000004)
#define GH_PLAYER_SLV_REG2_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000008)
#define GH_PLAYER_SLV_REG3_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x0000000C)
#define GH_PLAYER_SLV_REG4_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000010)
#define GH_PLAYER_SLV_REG5_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000014)
#define GH_PLAYER_SLV_REG6_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000018)
#define GH_PLAYER_SLV_REG7_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x0000001C)
#define GH_PLAYER_SLV_REG8_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000020)
#define GH_PLAYER_SLV_REG9_OFFSET  (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000024)
#define GH_PLAYER_SLV_REG10_OFFSET (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000028)
#define GH_PLAYER_SLV_REG11_OFFSET (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x0000002C)
#define GH_PLAYER_SLV_REG12_OFFSET (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000030)
#define GH_PLAYER_SLV_REG13_OFFSET (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000034)
#define GH_PLAYER_SLV_REG14_OFFSET (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000038)
#define GH_PLAYER_SLV_REG15_OFFSET (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x0000003C)
#define GH_PLAYER_SLV_REG16_OFFSET (GH_PLAYER_USER_SLV_SPACE_OFFSET + 0x00000040)

/**
 * Software Reset Space Register Offsets
 * -- RST : software reset register
 */
#define GH_PLAYER_SOFT_RST_SPACE_OFFSET (0x00000100)
#define GH_PLAYER_RST_REG_OFFSET (GH_PLAYER_SOFT_RST_SPACE_OFFSET + 0x00000000)

/**
 * Software Reset Masks
 * -- SOFT_RESET : software reset
 */
#define SOFT_RESET (0x0000000A)


#define FRET_GREEN	0
#define FRET_RED	1
#define FRET_YELLOW	2
#define FRET_BLUE	3
#define FRET_ORANGE	4

#define THRESHOLD_ON	0
#define THRESHOLD_OFF	1


/**************************** Type Definitions *****************************/

typedef struct {
	u16 x;
	u16 y;
} point;

typedef struct {
	u8 r;
	u8 g;
	u8 b;
} pixel;


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a GH_PLAYER register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the GH_PLAYER device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void GH_PLAYER_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define GH_PLAYER_mWriteReg(BaseAddress, RegOffset, Data) \
 	Xil_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a GH_PLAYER register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the GH_PLAYER device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 GH_PLAYER_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define GH_PLAYER_mReadReg(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read 32 bit value to/from GH_PLAYER user logic slave registers.
 *
 * @param   BaseAddress is the base address of the GH_PLAYER device.
 * @param   RegOffset is the offset from the slave register to write to or read from.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	void GH_PLAYER_mWriteSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Value)
 * 	Xuint32 GH_PLAYER_mReadSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define GH_PLAYER_mWriteSlaveReg0(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG0_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg1(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG1_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg2(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG2_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg3(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG3_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg4(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG4_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg5(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG5_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg6(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG6_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg7(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG7_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg8(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG8_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg9(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG9_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg10(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG10_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg11(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG11_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg12(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG12_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg13(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG13_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg14(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG14_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg15(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG15_OFFSET) + (RegOffset), (Xuint32)(Value))
#define GH_PLAYER_mWriteSlaveReg16(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (GH_PLAYER_SLV_REG16_OFFSET) + (RegOffset), (Xuint32)(Value))

#define GH_PLAYER_mReadSlaveReg0(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG0_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg1(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG1_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg2(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG2_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg3(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG3_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg4(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG4_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg5(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG5_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg6(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG6_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg7(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG7_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg8(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG8_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg9(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG9_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg10(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG10_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg11(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG11_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg12(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG12_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg13(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG13_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg14(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG14_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg15(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG15_OFFSET) + (RegOffset))
#define GH_PLAYER_mReadSlaveReg16(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (GH_PLAYER_SLV_REG16_OFFSET) + (RegOffset))

/**
 *
 * Reset GH_PLAYER via software.
 *
 * @param   BaseAddress is the base address of the GH_PLAYER device.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void GH_PLAYER_mReset(Xuint32 BaseAddress)
 *
 */
#define GH_PLAYER_mReset(BaseAddress) \
 	Xil_Out32((BaseAddress)+(GH_PLAYER_RST_REG_OFFSET), SOFT_RESET)

	
/************************** Function Prototypes ****************************/

void ghPlayer_SetPosition(u32 baseAddress, point position, u8 fret);
void ghPlayer_SetThreshold(u32 baseAddress, pixel value, u8 fret, u8 onOff);
void ghPlayer_SetControl(u32 baseAddress, u8 strumValue, u8 fretValue, u8 enable);

u32 ghPlayer_GetStatus(u32 baseAddress);

/**
*  Defines the number of registers available for read and write*/
#define TEST_AXI_LITE_USER_NUM_REG 2


#endif /** GH_PLAYER_H */
