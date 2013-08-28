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
#include "../ethernet.h"
#include "../options.h"

#define BTNS_BASEADDR XPAR_PUSH_BUTTONS_5BITS_BASEADDR
#define BTNS_DEVICE_ID XPAR_PUSH_BUTTONS_5BITS_DEVICE_ID
#define INTC_DEVICE_ID XPAR_INTC_0_DEVICE_ID
#define BTNS_IRPT_ID XPAR_INTC_0_GPIO_2_VEC_ID

static XGpio pshBtns;
volatile u32 lBtnStateOld;

XIntc btnIntCtrl;

// --- Delayed fret detector ---
#if (GAME == RB)
// Rock Band
#define DELAY 4
#else
// Guitar Hero
#define DELAY 5
#endif

// Note detector
u8 delay = DELAY;

u8 playerEnable = 0;
#if (FILTERS == 0)
u8 type = 0;
#else
u8 type = 1;
#endif
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

		delay++;

		xil_printf("Delay: %2d\r\n", delay);
		ghPlayer_SetControl(XPAR_GH_PLAYER_0_BASEADDR, strumValue, delay, type, playerEnable);
	}

	if ((lBtnChanges & BUTTON_DOWN) && (lBtnStateNew & BUTTON_DOWN))
	{
		// Down button pressed
		//xil_printf("D");

		delay--;

		xil_printf("Delay: %2d\r\n", delay);
		ghPlayer_SetControl(XPAR_GH_PLAYER_0_BASEADDR, strumValue, delay, type, playerEnable);
	}

	if ((lBtnChanges & BUTTON_LEFT) && (lBtnStateNew & BUTTON_LEFT))
	{
		// Left button pressed
		//xil_printf("L");

		/* Output series of frames over UART */
		EnableVDMAUARTIntr();
	}

	if ((lBtnChanges & BUTTON_RIGHT) && (lBtnStateNew & BUTTON_RIGHT))
	{
		// Right button pressed
		//xil_printf("R");

		/* Output frame over UART *//*
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
		*/
		/* Output frame over Ethernet */
		register int i;
		register u32 *vbufptr = (u32 *)(XPAR_S6DDR_0_S0_AXI_BASEADDR + 0x01000000);
		for (i = 0; i < 1280 * 720 ; i += 320) {
			ethernetSendPayload(1280, (u8*)(vbufptr + i));
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

