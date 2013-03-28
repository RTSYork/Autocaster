/*****************************************************************************
* Filename:          C:\rj553\AXI/drivers/image_filter_v1_00_a/src/image_filter.c
* Version:           1.00.a
* Description:       image_filter Driver Source File
*****************************************************************************/


/***************************** Include Files *******************************/

#include "image_filter.h"

/************************** Function Definitions ***************************/

void imageFilter_SetControl(u32 baseAddress, u8 coreEnable, u8 greyscaleEnable, u8 threshold1Enable, u8 blurEnable, u8 threshold2Enable, u8 edgeEnable, u8 mixImage) {
	IMAGE_FILTER_mWriteSlaveReg0(baseAddress, 0, (mixImage<<6) | (edgeEnable<<5) | (threshold2Enable<<4) | (blurEnable<<3) | (threshold1Enable<<2) | (greyscaleEnable<<1) | coreEnable);
}