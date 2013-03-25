#include "switches.h"
#include "xparameters.h"
#include "xil_io.h"
#include "bitops.h"

int getSwitches(void) {
	return Xil_In8(XPAR_DIP_SWITCHES_8BITS_BASEADDR);
}

int getSwitch(int switchNumber) {
	int switches = getSwitches();

	return BITMASK_CHECK(switches, switchNumber) ? SWITCH_ON : SWITCH_OFF;
}
