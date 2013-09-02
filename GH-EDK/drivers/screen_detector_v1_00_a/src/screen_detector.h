/*****************************************************************************
* Filename:          C:\Autocaster\GH-EDK/drivers/screen_detector_v1_00_a/src/screen_detector.h
* Version:           1.00.a
* Description:       screen_detector Driver Header File
* Date:              Mon Sep 02 10:38:39 2013 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#ifndef SCREEN_DETECTOR_H
#define SCREEN_DETECTOR_H

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
#define SCREEN_DETECTOR_USER_SLV_SPACE_OFFSET (0x00000000)
#define SCREEN_DETECTOR_SLV_REG0_OFFSET (SCREEN_DETECTOR_USER_SLV_SPACE_OFFSET + 0x00000000)
#define SCREEN_DETECTOR_SLV_REG1_OFFSET (SCREEN_DETECTOR_USER_SLV_SPACE_OFFSET + 0x00000004)

/**
 * Software Reset Space Register Offsets
 * -- RST : software reset register
 */
#define SCREEN_DETECTOR_SOFT_RST_SPACE_OFFSET (0x00000100)
#define SCREEN_DETECTOR_RST_REG_OFFSET (SCREEN_DETECTOR_SOFT_RST_SPACE_OFFSET + 0x00000000)

/**
 * Software Reset Masks
 * -- SOFT_RESET : software reset
 */
#define SOFT_RESET (0x0000000A)

/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a SCREEN_DETECTOR register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the SCREEN_DETECTOR device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void SCREEN_DETECTOR_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define SCREEN_DETECTOR_mWriteReg(BaseAddress, RegOffset, Data) \
 	Xil_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a SCREEN_DETECTOR register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the SCREEN_DETECTOR device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 SCREEN_DETECTOR_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define SCREEN_DETECTOR_mReadReg(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read 32 bit value to/from SCREEN_DETECTOR user logic slave registers.
 *
 * @param   BaseAddress is the base address of the SCREEN_DETECTOR device.
 * @param   RegOffset is the offset from the slave register to write to or read from.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	void SCREEN_DETECTOR_mWriteSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Value)
 * 	Xuint32 SCREEN_DETECTOR_mReadSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define SCREEN_DETECTOR_mWriteSlaveReg0(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (SCREEN_DETECTOR_SLV_REG0_OFFSET) + (RegOffset), (Xuint32)(Value))
#define SCREEN_DETECTOR_mWriteSlaveReg1(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (SCREEN_DETECTOR_SLV_REG1_OFFSET) + (RegOffset), (Xuint32)(Value))

#define SCREEN_DETECTOR_mReadSlaveReg0(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (SCREEN_DETECTOR_SLV_REG0_OFFSET) + (RegOffset))
#define SCREEN_DETECTOR_mReadSlaveReg1(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (SCREEN_DETECTOR_SLV_REG1_OFFSET) + (RegOffset))

/**
 *
 * Reset SCREEN_DETECTOR via software.
 *
 * @param   BaseAddress is the base address of the SCREEN_DETECTOR device.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void SCREEN_DETECTOR_mReset(Xuint32 BaseAddress)
 *
 */
#define SCREEN_DETECTOR_mReset(BaseAddress) \
 	Xil_Out32((BaseAddress)+(SCREEN_DETECTOR_RST_REG_OFFSET), SOFT_RESET)

/************************** Function Prototypes ****************************/

void screenDetector_SetEnabled(u32 baseAddress, u8 enabled);
u32 screenDetector_GetScreen(u32 baseAddress);

/**
*  Defines the number of registers available for read and write*/
#define TEST_AXI_LITE_USER_NUM_REG 2


#endif /** SCREEN_DETECTOR_H */
