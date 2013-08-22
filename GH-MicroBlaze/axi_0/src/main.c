/*
 * Copyright (c) 2009-2010 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

#include <stdio.h>

#include "xparameters.h"

#include "platform.h"
#include "platform_config.h"

#include "xgpio.h"	//GPIO API functions
#include "xintc.h"	//Interrupt Controller API functions
#include "xil_io.h"	//Contains the Xil_Out32 and Xil_In32 functions

#include "gh_player.h"
#include "image_filter.h"

#include "options.h"
#include "hdmi/vdma.h"		// VDMA functions
#include "hdmi/hdmi.h"		// HDMI functions
#include "hdmi/edid.h"		// Sets up and sends EDID
#include "gpio/leds.h"		// LED controls
#include "gpio/buttons.h"	// Push-button controls
#include "gpio/switches.h"	// Switch controls
#include "gpio/bitops.h"	// Bit operations
#include "interrupts.h"		// Interrupt control
//#include "timer.h"		// Timer
#include "ethernet.h"		// Ethernet

/* Frame size constants
 */
#define FRAME_HORIZONTAL_LEN  1280   /* 1280 pixels, each pixel 4 bytes */
#define FRAME_VERTICAL_LEN    720    /* 720 pixels */

// --- 1 Player ---
//#define G_X 476
//#define G_Y 581
//#define R_X 559
//#define R_Y 577
//#define Y_X 640
//#define Y_Y 575
//#define B_X 721
//#define B_Y 577
//#define O_X 804
//#define O_Y 581
// --- 2 Player ---
//#define G_X 218
//#define G_Y 593
//#define R_X 288
//#define R_Y 589
//#define Y_X 358
//#define Y_Y 588
//#define B_X 429
//#define B_Y 590
//#define O_X 499
//#define O_Y 594
// --- 3 Player ---
//#define G_X 109
//#define G_Y 607
//#define R_X 182
//#define R_Y 603
//#define Y_X 249
//#define Y_Y 602
//#define B_X 311
//#define B_Y 602
//#define O_X 371
//#define O_Y 605
// --- Filtered fret detector ---
//#define G_X 480
//#define G_Y 571
//#define R_X 558
//#define R_Y 566
//#define Y_X 640
//#define Y_Y 564
//#define B_X 722
//#define B_Y 566
//#define O_X 800
//#define O_Y 571
// --- Delayed fret detector ---
#if (GAME == RB)
// Rock Band
#define G_X 476+19+5+4
#define G_Y 581-45-15-15
#define R_X 559+8+2+3
#define R_Y 577-45-15-15
#define Y_X 640
#define Y_Y 575-45-15-15
#define B_X 721-8-2-3
#define B_Y 577-45-15-15
#define O_X 804-19-5-4
#define O_Y 581-45-15-15
#else
// Guitar Hero
#define G_X 495
#define G_Y 506
#define R_X 568
#define R_Y 502
#define Y_X 639
#define Y_Y 500
#define B_X 711
#define B_Y 502
#define O_X 783
#define O_Y 506
#endif

static XIntc intCtrl;

void drawCross(int xpos, int ypos, int size, int colour);
void drawDiagonalCross(int xpos, int ypos, int size, int colour);

int main(void)
{
	xil_printf("\r\n\n****************************************\r\n");

	setLed(LED0, LED_ON);

	init_platform();

	// Set up HDMI output
	xil_printf("\r\nHDMI control register was %x\r\n", getHdmiOutputResolution());
	setHdmiOutputResolution(FRAME_HORIZONTAL_LEN, FRAME_VERTICAL_LEN);
	xil_printf("HDMI control register now %x\r\n", getHdmiOutputResolution());

	setLed(LED1, LED_ON);

	enableInterrupts(&intCtrl);

	setLed(LED2, LED_ON);

	initButtonInterrupt(intCtrl);
	enableButtonInterrupt();

	setLed(LED3, LED_ON);

	// Set up EDID
	initEdid(intCtrl);
	enableEdidInterrupt();

	setLed(LED4, LED_ON);

	// Set up VDMA
	vdma_setup(intCtrl);


	//initTimer(intCtrl);
	//startTimer(0);
	//startTimer(1);

	setLed(LED5, LED_ON);

	// Set up Ethernet
	ethernetInit();

	setLeds(0);


	int lasts0 = SWITCH_OFF;
	int lasts2 = SWITCH_OFF;
	int lasts3 = SWITCH_OFF;
	int lasts4 = SWITCH_OFF;
	int lasts5 = SWITCH_OFF;
	int lasts6 = SWITCH_OFF;
	int lasts7 = SWITCH_OFF;
	int s0, s1, s2, s3, s4, s5, s6, s7;

	// Positions of note detectors (x, y)
	point gPos = {G_X, G_Y};
	point rPos = {R_X, R_Y};
	point yPos = {Y_X, Y_Y};
	point bPos = {B_X, B_Y};
	point oPos = {O_X, O_Y};

	// Thresholds of note detectors
#if (GAME == RB)
	// Rock Band thresholds
	pixel gOn  = {0x02, 0x80, 0x02}; // pixel gOn  = {0x02, 0x68, 0x02};
	pixel gOff = {0x4E, 0x6B, 0x20}; // pixel gOff = {0x4C, 0x66, 0x19};
	pixel rOn  = {0x79, 0x21, 0x23}; // pixel rOn  = {0x66, 0x21, 0x23};
	pixel rOff = {0x67, 0x30, 0x30}; // pixel rOff = {0x5B, 0x26, 0x26};
	pixel yOn  = {0x6D, 0x6B, 0x05};
	pixel yOff = {0x7A, 0x6D, 0x4C};
	pixel bOn  = {0x1C, 0x33, 0x9B};
	pixel bOff = {0x30, 0x38, 0x72};
	pixel oOn  = {0x87, 0x3D, 0x02};
	pixel oOff = {0x7A, 0x3F, 0x19};
#else
	// Guitar Hero thresholds
	pixel gOn  = {0x00, 0x70, 0x00};
	pixel gOff = {0x40, 0x40, 0x40};
	pixel rOn  = {0x9A, 0x00, 0x00};
	pixel rOff = {0x4A, 0x4A, 0x4A};
	pixel yOn  = {0xBB, 0x60, 0x00};
	pixel yOff = {0x50, 0x50, 0x50};
	pixel bOn  = {0x00, 0x00, 0x9A};
	pixel bOff = {0x4A, 0x4A, 0x4A};
	pixel oOn  = {0xA0, 0x50, 0x00};
	pixel oOff = {0x40, 0x40, 0x40};
#endif

	// Control values
	//u8 delay = 2; //4;
	//u8 strumValue = 2;
	//u8 playerEnable = 0;

	// Status value
	u32 status = 0;

	// Reset GH Player core
	GH_PLAYER_mReset(XPAR_GH_PLAYER_0_BASEADDR);

	// Set initial register values
	ghPlayer_SetControl(XPAR_GH_PLAYER_0_BASEADDR, strumValue, delay, type, playerEnable);

	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, gOn,  FRET_GREEN,  THRESHOLD_ON);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, gOff, FRET_GREEN,  THRESHOLD_OFF);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, rOn,  FRET_RED,    THRESHOLD_ON);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, rOff, FRET_RED,    THRESHOLD_OFF);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, yOn,  FRET_YELLOW, THRESHOLD_ON);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, yOff, FRET_YELLOW, THRESHOLD_OFF);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, bOn,  FRET_BLUE,   THRESHOLD_ON);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, bOff, FRET_BLUE,   THRESHOLD_OFF);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, oOn,  FRET_ORANGE, THRESHOLD_ON);
	ghPlayer_SetThreshold(XPAR_GH_PLAYER_0_BASEADDR, oOff, FRET_ORANGE, THRESHOLD_OFF);

	ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, gPos, FRET_GREEN);
	ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, rPos, FRET_RED);
	ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, yPos, FRET_YELLOW);
	ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, bPos, FRET_BLUE);
	ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, oPos, FRET_ORANGE);


	// Reset Image Filter core, set threshold, enable
	u8 filtersEnable = FILTERS;
	IMAGE_FILTER_mReset(XPAR_IMAGE_FILTER_0_BASEADDR);
	imageFilter_SetThreshold(XPAR_IMAGE_FILTER_0_BASEADDR, 128);
	imageFilter_SetControl(XPAR_IMAGE_FILTER_0_BASEADDR, filtersEnable, FILTER_NONE);


	while (1) {
		// Loop forever

		// Use SW0 to freeze the image
		s0 = getSwitch(SWITCH0);
		if (s0 != lasts0) {
			if (s0 == SWITCH_ON) {
				StartParking(1, 0, 1);
				setLed(LED0, LED_ON);
			}
			else {
				StopParking(1);
				setLed(LED0, LED_OFF);
			}

			lasts0 = s0;
		}

		s1 = getSwitch(SWITCH1);
		if (s1 == SWITCH_ON) {
			// Draw a cross at each pixel test position
			drawCross(gPos.x, gPos.y, 16, 0x00FF00); // Green
			drawCross(rPos.x, rPos.y, 16, 0xFF0000); // Red
			drawCross(yPos.x, yPos.y, 16, 0xFFFF00); // Yellow
			drawCross(bPos.x, bPos.y, 16, 0x0000FF); // Blue
			drawCross(oPos.x, oPos.y, 16, 0xFF7F00); // Orange
		}

		s2 = getSwitch(SWITCH2);
		if (s2 != lasts2) {
			if (s2 == SWITCH_ON) {
				playerEnable = 1;
				setLed(LED2, LED_ON);
			}
			else {
				playerEnable = 0;
				setLed(LED2, LED_OFF);
			}
			ghPlayer_SetControl(XPAR_GH_PLAYER_0_BASEADDR, strumValue, delay, FILTERS, playerEnable);

			lasts2 = s2;
		}
#if (FILTERS == 0)
		s3 = getSwitch(SWITCH3);
		if (s3 == SWITCH_ON) {
			status = ghPlayer_GetStatus(XPAR_GH_PLAYER_0_BASEADDR);
			print("\x1b[H\n");
			print(" GRYBO  S | W | T %d %d %d\n");
			xil_printf(" %d%d%d%d%d  %d | %d | %d\n\n",
					BIT_CHECK(status, 0),
					BIT_CHECK(status, 1)  >> 1,
					BIT_CHECK(status, 2)  >> 2,
					BIT_CHECK(status, 3)  >> 3,
					BIT_CHECK(status, 4)  >> 4,
					BIT_CHECK(status, 5)  >> 5,
					BIT_CHECK(status, 13)  >> 13,
					BIT_CHECK(status, 14) >> 14);
		}

		s4 = getSwitch(SWITCH4);
		if (s4 != lasts4) {
			if (s4 == SWITCH_ON) {
				EnableVDMAEthIntr();
				setLed(LED4, LED_ON);
			}
			else {
				DisableVDMAEthIntr();
				setLed(LED4, LED_OFF);
			}
			lasts4 = s4;
		}
#else
		s3 = getSwitch(SWITCH3);
		s4 = getSwitch(SWITCH4);
		s5 = getSwitch(SWITCH5);
		s6 = getSwitch(SWITCH6);
		s7 = getSwitch(SWITCH7);
		if (s3 != lasts3 || s4 != lasts4 || s5 != lasts5 || s6 != lasts6 || s7 != lasts7) {
			if (s7 == SWITCH_ON && s6 == SWITCH_ON && s5 == SWITCH_ON && s4 == SWITCH_ON && s3 == SWITCH_ON) {
				imageFilter_SetControl(XPAR_IMAGE_FILTER_0_BASEADDR, filtersEnable, FILTER_MIX);
				setLed(LED3, LED_ON);
				setLed(LED4, LED_ON);
				setLed(LED5, LED_ON);
				setLed(LED6, LED_ON);
				setLed(LED7, LED_ON);
			}
			else if (s7 == SWITCH_ON) {
				imageFilter_SetControl(XPAR_IMAGE_FILTER_0_BASEADDR, filtersEnable, FILTER_EDGE);
				setLed(LED3, LED_OFF);
				setLed(LED4, LED_OFF);
				setLed(LED5, LED_OFF);
				setLed(LED6, LED_OFF);
				setLed(LED7, LED_ON);
			}
			else if (s6 == SWITCH_ON) {
				imageFilter_SetControl(XPAR_IMAGE_FILTER_0_BASEADDR, filtersEnable, FILTER_THRESH2);
				setLed(LED3, LED_OFF);
				setLed(LED4, LED_OFF);
				setLed(LED5, LED_OFF);
				setLed(LED6, LED_ON);
				setLed(LED7, LED_OFF);
			}
			else if (s5 == SWITCH_ON) {
				imageFilter_SetControl(XPAR_IMAGE_FILTER_0_BASEADDR, filtersEnable, FILTER_BLUR);
				setLed(LED3, LED_OFF);
				setLed(LED4, LED_OFF);
				setLed(LED5, LED_ON);
				setLed(LED6, LED_OFF);
				setLed(LED7, LED_OFF);
			}
			else if (s4 == SWITCH_ON) {
				imageFilter_SetControl(XPAR_IMAGE_FILTER_0_BASEADDR, filtersEnable, FILTER_THRESH1);
				setLed(LED3, LED_OFF);
				setLed(LED4, LED_ON);
				setLed(LED5, LED_OFF);
				setLed(LED6, LED_OFF);
				setLed(LED7, LED_OFF);
			}
			else if (s3 == SWITCH_ON) {
				imageFilter_SetControl(XPAR_IMAGE_FILTER_0_BASEADDR, filtersEnable, FILTER_GREY);
				setLed(LED3, LED_ON);
				setLed(LED4, LED_OFF);
				setLed(LED5, LED_OFF);
				setLed(LED6, LED_OFF);
				setLed(LED7, LED_OFF);
			}
			else {
				imageFilter_SetControl(XPAR_IMAGE_FILTER_0_BASEADDR, filtersEnable, FILTER_NONE);
				setLed(LED3, LED_OFF);
				setLed(LED4, LED_OFF);
				setLed(LED5, LED_OFF);
				setLed(LED6, LED_OFF);
				setLed(LED7, LED_OFF);
			}

			lasts3 = s3;
			lasts4 = s4;
			lasts5 = s5;
			lasts6 = s6;
			lasts7 = s7;
		}
#endif
	}

	/* never reached */
	setLeds(0xFF);
	cleanup_platform();

	return 0;
}

void drawCross(int xpos, int ypos, int size, int colour) {
	int x;
	int y;
	int z;
	int pFrame;
	u32 *vbufptr = (u32 *)(XPAR_S6DDR_0_S0_AXI_BASEADDR + 0x01000000);
	int i;
	int lineStride = 1280;

	for (z = 0; z < 2; z++) {
		pFrame = z * 1280 * 720;
		for (x = -size/2; x <= size/2; x++) {
			// Set pixel value
			i = pFrame + (ypos)*(lineStride) + (xpos+x);
			vbufptr[i] = colour;
		}

		for (y = -size/2; y <= size/2; y++) {
			// Set pixel value
			i = pFrame + (ypos+y)*(lineStride) + (xpos);
			vbufptr[i] = colour;
		}
	}
}

void drawDiagonalCross(int xpos, int ypos, int size, int colour) {
	int x;
	int y;
	int z;
	u32 *vbufptr = (u32 *)(XPAR_S6DDR_0_S0_AXI_BASEADDR + 0x01000000);
	int i;
	int lineStride = 1280;
	for (z = 0; z < 2; z++) {
		int pFrame = z * 1280 * 720;
		for (x = -size/2; x < size/2; x++) {
			for (y = -size/2; y < size/2; y++) {
				// Set pixel value
				i = pFrame + (ypos+y)*(lineStride) + (xpos+y);
				vbufptr[i] = colour;
				i = pFrame + ((ypos - size)+(size-y))*(lineStride) + (xpos+y);
				vbufptr[i] = colour;
			}
		}
	}
}
