#include "hdmi.h"
#include "xparameters.h"
#include "xil_io.h"

void setHdmiOutputResolution(int horizontal, int vertical) {
	xil_printf("\r\nSetting HDMI output to 720p...");
	Xil_Out32(XPAR_AXI_HDMI_0_BASEADDR, horizontal * vertical);
	xil_printf("done");
}

int getHdmiOutputResolution(void) {
	return Xil_In32(XPAR_AXI_HDMI_0_BASEADDR);
}
