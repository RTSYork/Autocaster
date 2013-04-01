/*****************************************************************************
* Filename:          C:\rj553\AXI/drivers/gh_player_v1_00_a/src/gh_player.c
* Version:           1.00.a
* Description:       gh_player Driver Source File
* Date:              Wed Jan 02 17:10:05 2013 (by Create and Import Peripheral Wizard)
*****************************************************************************/


/***************************** Include Files *******************************/

#include "gh_player.h"

/************************** Function Definitions ***************************/

void ghPlayer_SetPosition(u32 baseAddress, point position, u8 fret) {
	GH_PLAYER_mWriteSlaveReg4(baseAddress, fret*3*4, (position.y<<12) | position.x);
}

void ghPlayer_SetThreshold(u32 baseAddress, pixel value, u8 fret, u8 onOff) {
	GH_PLAYER_mWriteSlaveReg2(baseAddress, ((fret*3) + onOff) * 4, (value.r<<16) | (value.g<<8) | value.b);
}

void ghPlayer_SetControl(u32 baseAddress, u8 strumValue, u8 fretValue, u8 type, u8 enable) {
	GH_PLAYER_mWriteSlaveReg0(baseAddress, 0, (strumValue<<6) | (fretValue<<2) | (type<<1) | enable);
}

u32 ghPlayer_GetStatus(u32 baseAddress) {
	return GH_PLAYER_mReadSlaveReg1(baseAddress, 0);
}