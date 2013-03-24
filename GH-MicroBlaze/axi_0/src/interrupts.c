#include "interrupts.h"
#include "xparameters.h"

void enableInterrupts(XIntc *intCtrl) {
	xil_printf("\r\nEnabling interrupts...");
	XIntc_Initialize(intCtrl, XPAR_INTC_0_DEVICE_ID);
	xil_printf("done\r\n");
}
