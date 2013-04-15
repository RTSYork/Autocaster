#ifndef USBguitarrj_h_
#define USBguitarrj_h_

#if defined(USB_GUITAR_RJ)

#include <inttypes.h>

// C language implementation
#ifdef __cplusplus
extern "C" {
#endif
int usb_guitar_send(void);
extern uint32_t usb_guitar_data[2];
#ifdef __cplusplus
}
#endif

// C++ interface
#ifdef __cplusplus

#define RED	3
#define GREEN	2
#define YELLOW	1
#define BLUE	4
#define ORANGE	5
#define TILT	6
#define SOLO	7
#define START	10
#define SELECT	9
#define PS	13

class usb_guitar_rj_class
{
        public:
        void begin(void) { }
        void end(void) { }
	void button(uint8_t button, bool val) {
		if (--button >= 13) return;
		if (val) usb_guitar_data[0] |= (1 << button);
		else usb_guitar_data[0] &= ~(1 << button);
		if (!manual_mode) usb_guitar_send();
	}
	inline void fret(uint8_t fret, bool val) {
		button(fret, val);
	}
	inline void tilt(bool val) {
		button(TILT, val);
	}
	void strum(bool on) {
                uint32_t val = (on ? 0x00000000 : 0x000F0000);
		usb_guitar_data[0] = (usb_guitar_data[0] & 0xFF00FFFF) | val;
                if (!manual_mode) usb_guitar_send();
        }
	void position(unsigned int x, unsigned int y) {
		if (x > 255) x = 255;
		if (y > 255) y = 255;
		usb_guitar_data[0] = (usb_guitar_data[0] & 0x00FFFFFF) | (x << 24);
		usb_guitar_data[1] = (usb_guitar_data[1] & 0xFFFFFF00) | y;
		if (!manual_mode) usb_guitar_send();
	}
	void whammy(unsigned int val) {
		if (val > 255) val = 255;
		usb_guitar_data[1] = (usb_guitar_data[1] & 0xFFFF00FF) | (val << 8);
		if (!manual_mode) usb_guitar_send();
	}
	void Zrotate(unsigned int val) {
		if (val > 255) val = 255;
		usb_guitar_data[1] = (usb_guitar_data[1] & 0xFF00FFFF) | (val << 16);
		if (!manual_mode) usb_guitar_send();
	}
        inline void hat(int dir) {
                uint32_t val;
                if (dir < 0) val = 15;
                else if (dir < 23) val = 0;
                else if (dir < 68) val = 1;
                else if (dir < 113) val = 2;
                else if (dir < 158) val = 3;
                else if (dir < 203) val = 4;
                else if (dir < 245) val = 5;
                else if (dir < 293) val = 6;
                else if (dir < 338) val = 7;
		usb_guitar_data[0] = (usb_guitar_data[0] & 0xFF00FFFF) | (val << 16);
                if (!manual_mode) usb_guitar_send();
        }
	void useManualSend(bool mode) {
		manual_mode = mode;
	}
	void send_now(void) {
		usb_guitar_send();
	}
	void setExtras(void) {
		usb_guitar_data[2] = 0x00000000;
		usb_guitar_data[3] = 0x00000000;
		usb_guitar_data[4] = 0xF9000000;
		usb_guitar_data[5] = 0x00027901;
		usb_guitar_data[6] = 0x00020002;
                if (!manual_mode) usb_guitar_send();
        }
	private:
	static uint8_t manual_mode;
};
extern usb_guitar_rj_class Guitar;

#endif // __cplusplus

#endif // USB_GUITAR_RJ
#endif // USBguitarrj_h_

