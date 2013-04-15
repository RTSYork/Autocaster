#include "WProgram.h"

#ifdef USB_SERIAL
usb_serial_class Serial;
#endif

#ifdef USB_HID
usb_keyboard_class Keyboard;
usb_mouse_class Mouse;
usb_joystick_class Joystick;
uint8_t usb_joystick_class::manual_mode = 0;
usb_seremu_class Serial;
#endif

#ifdef USB_SERIAL_HID
usb_serial_class Serial;
usb_keyboard_class Keyboard;
usb_mouse_class Mouse;
usb_joystick_class Joystick;
uint8_t usb_joystick_class::manual_mode = 0;
#endif

#ifdef USB_MIDI
usb_midi_class usbMIDI;
usb_seremu_class Serial;
#endif

#ifdef USB_RAWHID
usb_rawhid_class RawHID;
usb_seremu_class Serial;
#endif

#ifdef USB_FLIGHTSIM
FlightSimClass FlightSim;
usb_seremu_class Serial;
#endif

#ifdef USB_GUITAR_RB
usb_guitar_rb_class Guitar;
uint8_t usb_guitar_rb_class::manual_mode = 0;
#endif

#ifdef USB_GUITAR_GH
usb_guitar_gh_class Guitar;
uint8_t usb_guitar_gh_class::manual_mode = 0;
#endif

#ifdef USB_GUITAR_RJ
usb_guitar_rj_class Guitar;
uint8_t usb_guitar_rj_class::manual_mode = 0;
#endif