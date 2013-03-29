#include "hdmi.h"
#include "xparameters.h"
#include "xil_io.h"

void setHdmiOutputResolution(int horizontal, int vertical) {
	Xil_Out32(XPAR_AXI_HDMI_0_BASEADDR, horizontal * vertical);
}

int getHdmiOutputResolution(void) {
	return Xil_In32(XPAR_AXI_HDMI_0_BASEADDR);
}
