/*****************************************************************************
* Filename:          C:\Autocaster\GH-EDK/drivers/screen_detector_v1_00_a/src/screen_detector.c
* Version:           1.00.a
* Description:       screen_detector Driver Source File
* Date:              Mon Sep 02 10:38:39 2013 (by Create and Import Peripheral Wizard)
*****************************************************************************/


/***************************** Include Files *******************************/

#include "screen_detector.h"

/************************** Function Definitions ***************************/

void screenDetector_SetEnabled(u32 baseAddress, u8 enabled) {
	SCREEN_DETECTOR_mWriteSlaveReg0(baseAddress, 0, enabled & 0x01);
}

u32 screenDetector_GetScreen(u32 baseAddress) {
	return SCREEN_DETECTOR_mReadSlaveReg1(baseAddress, 0);
}
