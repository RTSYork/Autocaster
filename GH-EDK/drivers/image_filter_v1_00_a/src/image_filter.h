/*****************************************************************************
* Filename:          C:\rj553\AXI/drivers/image_filter_v1_00_a/src/image_filter.h
* Version:           1.00.a
* Description:       image_filter Driver Header File
*****************************************************************************/

#ifndef IMAGE_FILTER_H
#define IMAGE_FILTER_H

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
#define IMAGE_FILTER_USER_SLV_SPACE_OFFSET (0x00000000)
#define IMAGE_FILTER_SLV_REG0_OFFSET  (IMAGE_FILTER_USER_SLV_SPACE_OFFSET + 0x00000000)
#define IMAGE_FILTER_SLV_REG1_OFFSET  (IMAGE_FILTER_USER_SLV_SPACE_OFFSET + 0x00000004)

/**
 * Software Reset Space Register Offsets
 * -- RST : software reset register
 */
#define IMAGE_FILTER_SOFT_RST_SPACE_OFFSET (0x00000100)
#define IMAGE_FILTER_RST_REG_OFFSET (IMAGE_FILTER_SOFT_RST_SPACE_OFFSET + 0x00000000)

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



/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a IMAGE_FILTER register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the IMAGE_FILTER device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void IMAGE_FILTER_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define IMAGE_FILTER_mWriteReg(BaseAddress, RegOffset, Data) \
 	Xil_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a IMAGE_FILTER register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the IMAGE_FILTER device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 IMAGE_FILTER_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define IMAGE_FILTER_mReadReg(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read 32 bit value to/from IMAGE_FILTER user logic slave registers.
 *
 * @param   BaseAddress is the base address of the IMAGE_FILTER device.
 * @param   RegOffset is the offset from the slave register to write to or read from.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	void IMAGE_FILTER_mWriteSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Value)
 * 	Xuint32 IMAGE_FILTER_mReadSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define IMAGE_FILTER_mWriteSlaveReg0(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (IMAGE_FILTER_SLV_REG0_OFFSET) + (RegOffset), (Xuint32)(Value))
#define IMAGE_FILTER_mWriteSlaveReg1(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (IMAGE_FILTER_SLV_REG1_OFFSET) + (RegOffset), (Xuint32)(Value))

#define IMAGE_FILTER_mReadSlaveReg0(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (IMAGE_FILTER_SLV_REG0_OFFSET) + (RegOffset))
#define IMAGE_FILTER_mReadSlaveReg1(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (IMAGE_FILTER_SLV_REG1_OFFSET) + (RegOffset))
	

/**
 *
 * Reset IMAGE_FILTER via software.
 *
 * @param   BaseAddress is the base address of the IMAGE_FILTER device.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void IMAGE_FILTER_mReset(Xuint32 BaseAddress)
 *
 */
#define IMAGE_FILTER_mReset(BaseAddress) \
 	Xil_Out32((BaseAddress)+(IMAGE_FILTER_RST_REG_OFFSET), SOFT_RESET)

	
/************************** Function Prototypes ****************************/

void imageFilter_SetControl(u32 baseAddress, u8 coreEnable, u8 greyscaleEnable, u8 threshold1Enable, u8 blurEnable, u8 threshold2Enable, u8 edgeEnable, u8 mixImage);

/**
*  Defines the number of registers available for read and write*/
#define TEST_AXI_LITE_USER_NUM_REG 2


#endif /** IMAGE_FILTER_H */
