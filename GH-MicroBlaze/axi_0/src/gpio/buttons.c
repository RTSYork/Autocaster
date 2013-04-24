#include "buttons.h"
#include <stdio.h>
#include "xintc.h"			//Interrupt Controller API functions
#include "xgpio.h"			//GPIO API functions
#include "xparameters.h"
#include "xil_io.h"
#include "bitops.h"
#include "../hdmi/vdma.h"
#include "xuartlite.h"
#include "xuartlite_l.h"

#define BTNS_BASEADDR XPAR_PUSH_BUTTONS_5BITS_BASEADDR
#define BTNS_DEVICE_ID XPAR_PUSH_BUTTONS_5BITS_DEVICE_ID
#define INTC_DEVICE_ID XPAR_INTC_0_DEVICE_ID
#define BTNS_IRPT_ID XPAR_INTC_0_GPIO_2_VEC_ID

static XGpio pshBtns;
volatile u32 lBtnStateOld;

XIntc btnIntCtrl;

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

// Positions of note detectors (x, y)
point gPos = {G_X, G_Y};
point rPos = {R_X, R_Y};
point yPos = {Y_X, Y_Y};
point bPos = {B_X, B_Y};
point oPos = {O_X, O_Y};
u8 delay = 4;

u8 playerEnable = 0;
u8 type = TYPE_OLD;
u8 strumValue = 1;


void initButtonInterrupt(XIntc controller) {
	btnIntCtrl = controller;

	xil_printf("\r\nInitialising button interrupts...");
	lBtnStateOld = 0x00000000;
	XGpio_Initialize(&pshBtns, BTNS_DEVICE_ID);
	XIntc_Connect(&controller, BTNS_IRPT_ID, PushBtnHandler, &pshBtns);
	XIntc_Enable(&controller, BTNS_IRPT_ID);
	microblaze_register_handler(XIntc_DeviceInterruptHandler, INTC_DEVICE_ID);
	microblaze_enable_interrupts();
	XIntc_Start(&controller, XIN_REAL_MODE);
	xil_printf("done\r\n");
}

void enableButtonInterrupt(void) {
	xil_printf("\r\nEnabling button interrupts...");
	XGpio_InterruptEnable(&pshBtns, lBtnChannel);
	XGpio_InterruptGlobalEnable(&pshBtns);
	xil_printf("done\r\n");
}

void disableButtonInterrupt(void) {
	xil_printf("\r\nDisabling button interrupts...");
	XGpio_InterruptDisable(&pshBtns, lBtnChannel);
	XGpio_InterruptGlobalDisable(&pshBtns);
	xil_printf("done\r\n");
}


int getButtons(void) {
	return Xil_In8(XPAR_PUSH_BUTTONS_5BITS_BASEADDR);
}

int getButton(int button) {
	int buttons = getButtons();

	return BITMASK_CHECK(buttons, button) ? BUTTON_ON : BUTTON_OFF;
}


/***	PushBtnHandler
**
**	Parameters:
**		CallBackRef - Pointer to the push button struct (pshBtns) initialized
**		in main.
**
**	Return Value:
**		None
**
**	Errors:
**		None
**
**	Description:
**		This function is connected to the interrupt handler such that it is
**		called whenever an interrupt is triggered by the push buttons. It
**		responds to button presses by either stopping/starting the input
**		feed, printing a test pattern, inverting the framebuffer, or outputting
**		the input frame dimensions over UART.
*/
void PushBtnHandler(void *CallBackRef) {
	XGpio *pPushBtn = (XGpio *)CallBackRef;
	u32 lBtnStateNew = XGpio_DiscreteRead(pPushBtn, lBtnChannel);
	u32 lBtnChanges = lBtnStateNew ^ lBtnStateOld;

	lBtnStateOld = lBtnStateNew;

	if ((lBtnChanges & BUTTON_UP) && (lBtnStateNew & BUTTON_UP))
	{
		// Up button pressed
		//xil_printf("U");

		delay--;

//		gPos.y = G_Y + offset;
//		rPos.y = R_Y + offset;
//		yPos.y = Y_Y + offset;
//		bPos.y = B_Y + offset;
//		oPos.y = O_Y + offset;
//
//		gPos.x = G_X - (offset/3);
//		rPos.x = R_X - (offset/6);
//		yPos.x = Y_X;
//		bPos.x = B_X + (offset/6);
//		oPos.x = O_X + (offset/3);

		xil_printf("Delay: %2d\r\n", delay);
		ghPlayer_SetControl(XPAR_GH_PLAYER_0_BASEADDR, strumValue, delay, type, playerEnable);

		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, gPos, FRET_GREEN);
		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, rPos, FRET_RED);
		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, yPos, FRET_YELLOW);
		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, bPos, FRET_BLUE);
		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, oPos, FRET_ORANGE);
	}

	if ((lBtnChanges & BUTTON_DOWN) && (lBtnStateNew & BUTTON_DOWN))
	{
		// Down button pressed
		//xil_printf("D");

		delay++;

//		gPos.y = G_Y + offset;
//		rPos.y = R_Y + offset;
//		yPos.y = Y_Y + offset;
//		bPos.y = B_Y + offset;
//		oPos.y = O_Y + offset;
//
//		gPos.x = G_X - (offset/3);
//		rPos.x = R_X - (offset/6);
//		yPos.x = Y_X;
//		bPos.x = B_X + (offset/6);
//		oPos.x = O_X + (offset/3);

		xil_printf("Delay: %2d\r\n", delay);
		ghPlayer_SetControl(XPAR_GH_PLAYER_0_BASEADDR, strumValue, delay, type, playerEnable);

//		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, gPos, FRET_GREEN);
//		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, rPos, FRET_RED);
//		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, yPos, FRET_YELLOW);
//		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, bPos, FRET_BLUE);
//		ghPlayer_SetPosition(XPAR_GH_PLAYER_0_BASEADDR, oPos, FRET_ORANGE);
	}

	if ((lBtnChanges & BUTTON_LEFT) && (lBtnStateNew & BUTTON_LEFT))
	{
		// Left button pressed
		//xil_printf("L");

		/* Output series of frames over UART */
		EnableFrmCntIntr();
	}

	if ((lBtnChanges & BUTTON_RIGHT) && (lBtnStateNew & BUTTON_RIGHT))
	{
		// Right button pressed
		//xil_printf("R");

		/* Output frame over UART */
		register int i;
		u8 r, g, b;
		register u32 *vbufptr = (u32 *)(XPAR_S6DDR_0_S0_AXI_BASEADDR + 0x01000000);
		for (i = 0; i < 1280 * 720 ; i++) {
			u32 pixel = vbufptr[i];
			b = (u8)pixel;
			g = (u8)(pixel >> 8);
			r = (u8)(pixel >> 16);
			XUartLite_SendByte(XPAR_UARTLITE_1_BASEADDR, r);
			XUartLite_SendByte(XPAR_UARTLITE_1_BASEADDR, g);
			XUartLite_SendByte(XPAR_UARTLITE_1_BASEADDR, b);
		}
	}

	if ((lBtnChanges & BUTTON_CENTRE) && (lBtnStateNew & BUTTON_CENTRE))
	{
		// Centre button pressed
		xil_printf("C");

		// Set up VDMA
		vdma_setup(btnIntCtrl);
	}

	XGpio_InterruptClear(pPushBtn, lBtnChannel); // Clear interrupt
}

