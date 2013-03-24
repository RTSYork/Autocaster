#include "timer.h"
#include <stdio.h>
#include "xintc.h"			//Interrupt Controller API functions
#include "xparameters.h"
#include "xil_io.h"
#include "xtmrctr.h"

XIntc timerIntCtrl;
XTmrCtr timer;

int count = 0;

#define CAPTURES 240
u8 timers[CAPTURES];
u32 times[CAPTURES];

static void TimerInterrupt(void *CallBackRef, u8 TmrCtrNumber);


void initTimer(XIntc controller) {
	timerIntCtrl = controller;

	XTmrCtr_Initialize(&timer, XPAR_TMRCTR_0_DEVICE_ID);

	XTmrCtr_SetOptions(&timer, 0, XTC_CAPTURE_MODE_OPTION | XTC_INT_MODE_OPTION);
	XTmrCtr_SetOptions(&timer, 1, XTC_ENABLE_ALL_OPTION | XTC_CAPTURE_MODE_OPTION | XTC_INT_MODE_OPTION);

	XTmrCtr_SetHandler(&timer, TimerInterrupt, (void *)&timer);
	XIntc_Connect(&timerIntCtrl, XPAR_INTC_0_TMRCTR_0_VEC_ID, XTmrCtr_InterruptHandler, &timer);
	XIntc_Enable(&timerIntCtrl, XPAR_INTC_0_TMRCTR_0_VEC_ID);
}

static void TimerInterrupt(void *CallBackRef, u8 TmrCtrNumber) {
	timers[count] = TmrCtrNumber;
	times[count] = getTimerCaptureValue(TmrCtrNumber);

	count++;
	if (count == CAPTURES) {
		XIntc_Disable(&timerIntCtrl, XPAR_INTC_0_TMRCTR_0_VEC_ID);
		stopTimer(0);
		stopTimer(1);

		int x;
		for (x = 0; x < count; x++)
			xil_printf("\r\n%d %d", timers[x], times[x]);
	}

}

void startTimer(u8 TmrCtrNumber) {
	XTmrCtr_Start(&timer, TmrCtrNumber);
}

void stopTimer(u8 TmrCtrNumber) {
	XTmrCtr_Stop(&timer, TmrCtrNumber);
}

u32 getTimerValue(u8 TmrCtrNumber) {
	return XTmrCtr_GetValue(&timer, TmrCtrNumber);
}

u32 getTimerCaptureValue(u8 TmrCtrNumber) {
	return XTmrCtr_GetCaptureValue(&timer, TmrCtrNumber);
}

void resetTimer(u8 TmrCtrNumber) {
	XTmrCtr_Reset(&timer, TmrCtrNumber);
}
