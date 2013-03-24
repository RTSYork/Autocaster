#include "leds.h"
#include "xparameters.h"
#include "xil_io.h"
#include "bitops.h"

static int ledValues = 0;

void setLeds(int value) {
	if (value < 0 || value > 0xFF)
		return;

	ledValues = value;

	Xil_Out8(XPAR_LEDS_8BITS_BASEADDR, value);
}

int getLeds(void) {
	return ledValues;
	//return Xil_In8(XPAR_LEDS_8BITS_BASEADDR);
}

void setLed(int led, int value) {
	int leds = getLeds();

	if (value == LED_ON)
		BITMASK_SET(leds, led);
	else
		BITMASK_CLEAR(leds, led);

	ledValues = leds;

	Xil_Out8(XPAR_LEDS_8BITS_BASEADDR, leds);
}

int getLed(int led) {
	int leds = getLeds();

	return BITMASK_CHECK(leds, led) ? LED_ON : LED_OFF;
}
