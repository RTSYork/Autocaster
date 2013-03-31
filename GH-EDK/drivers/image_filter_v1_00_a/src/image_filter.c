/*****************************************************************************
* Filename:          C:\rj553\AXI/drivers/image_filter_v1_00_a/src/image_filter.c
* Version:           1.00.a
* Description:       image_filter Driver Source File
*****************************************************************************/


/***************************** Include Files *******************************/

#include "image_filter.h"

/************************** Function Definitions ***************************/

void imageFilter_SetControl(u32 baseAddress, u8 coreEnable, u8 displayFilter) {
	IMAGE_FILTER_mWriteSlaveReg0(baseAddress, 0, (displayFilter<<1) | coreEnable);
}

void imageFilter_SetThreshold(u32 baseAddress, u8 threshold) {
	IMAGE_FILTER_mWriteSlaveReg1(baseAddress, 0, threshold);
}