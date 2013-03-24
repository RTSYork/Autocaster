#include "edid.h"
#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"			//Contains the Xil_Out32 and Xil_In32 functions

#define IIC_BASEADDR XPAR_IIC_0_BASEADDR
#define INTC_DEVICE_ID XPAR_INTC_0_DEVICE_ID
#define IIC_IRPT_ID XPAR_INTC_0_IIC_0_VEC_ID

volatile int ibEdid;
volatile int eEdid;
volatile int aas;


void initEdid(XIntc controller) {
	xil_printf("\r\nInitialising EDID interrupts...");

    ibEdid = 0;
    eEdid = 0;
    aas = 0;

	/*
	 * Connect the function IicHandler to the interrupt controller so that
	 * it is called whenever the IIC core signals an interrupt.
	 */
	XIntc_Connect(&controller, IIC_IRPT_ID, IicHandler, NULL);

	/*
	 * Enable interrupts at the interrupt controller
	 */
	XIntc_Enable(&controller, IIC_IRPT_ID);

	/*
	 * Register the interrupt controller with the microblaze
	 * processor and then start the Interrupt controller so that it begins
	 * listening to the IIC core for triggers.
	 */
	microblaze_register_handler(XIntc_DeviceInterruptHandler, INTC_DEVICE_ID);
	microblaze_enable_interrupts();
	XIntc_Start(&controller, XIN_REAL_MODE);

	/*
	 * Enable the IIC core to begin sending interrupts to the
	 * interrupt controller.
	 */
	Xil_Out32(IIC_BASEADDR + bIicADR, 0x000000A1);  //Set slave address for E-DDC
	Xil_Out32(IIC_BASEADDR + bIicGIE, 0x80000000);  //Enable global interrupts
	Xil_Out32(IIC_BASEADDR + bIicCR, 0x00000002);   //Clear TX FIFO
	Xil_Out32(IIC_BASEADDR + bIicCR, 0x00000001);   //Enable IIC core

	xil_printf("done\n\r");
}


void enableEdidInterrupt(void) {
	xil_printf("\r\nEnabling EDID interrupts...");
	Xil_Out32(IIC_BASEADDR + bIicIER, 0x00000026);  //Enable AAS, TxFifo empty and Tx done interrupts
	xil_printf("done\n\r");
}


void disableEdidInterrupt(void) {
	xil_printf("\r\nDisabling EDID interrupts...");
	Xil_Out32(IIC_BASEADDR + bIicIER, 0x00000000);
	xil_printf("done\n\r");
}


/***	IicHandler
**
**	Parameters:
**		CallBackRef - Pointer to NULL
**
**	Return Value:
**		None
**
**	Errors:
**		None
**
**	Description:
**		This function is connected to the interrupt handler such that it is
**		called whenever an interrupt is triggered by the IIC core. It is
**		designed to behave like a monitor on an E-DDC interface. It outputs
**		the data held in rgbEdid as its EDID.
*/
void IicHandler(void *CallBackRef) {

	// If interrupt is Addressed-as-Slave
	if ((Xil_In32(IIC_BASEADDR + bIicISR) & bitAasFlag))
	{
		if (!(Xil_In32(IIC_BASEADDR + bIicSR) & 0x40)) {
			Xil_In32(IIC_BASEADDR + bIicRX);  // Clear the receive FIFO
		}
		aas = 1;
	}

	// If interrupt is Tx-Empty and addressed-as-slave
	if ((Xil_In32(IIC_BASEADDR + bIicISR) & bitTxEmptyFlag) && aas == 1)
	{
		// Output single byte of EDID
		Xil_Out32(IIC_BASEADDR + bIicTX, edid[eEdid % 2][ibEdid]);

		xil_printf(".");

		// Add in some delay (doesn't work if it sends data too fast)
		int i, j;
		for (i = 0; i < 1000; i++)
			j = i;
		i = j;

		ibEdid = (ibEdid + 1) % 128;
	}

	// If interrupt is Tx-Done
	if (Xil_In32(IIC_BASEADDR + bIicISR) & bitTxDoneFlag)
	{
		// Reset send byte counter
		ibEdid = 0;

		eEdid = (eEdid + 1) % 2;

		aas = 0;
	}

	/*
	 * Clear Interrupt Status Register in IIC core
	 */
	Xil_Out32(IIC_BASEADDR + bIicISR, Xil_In32(IIC_BASEADDR + bIicISR));
}
