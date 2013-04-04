#ifndef _usb_desc_h_
#define _usb_desc_h_

// This header is NOT meant to be included when compiling
// user sketches in Arduino.  The low-level functions
// provided by usb_dev.c are meant to be called only by
// code which provides higher-level interfaces to the user.

#include <stdint.h>
#include <stddef.h>

#define ENDPOINT_UNUSED			0x00
#define ENDPOINT_TRANSIMIT_ONLY		0x15
#define ENDPOINT_RECEIVE_ONLY		0x19
#define ENDPOINT_TRANSMIT_AND_RECEIVE	0x1D

/*
To modify a USB Type to have different interfaces, start in this
file.  Delete the XYZ_INTERFACE lines for any interfaces you
wish to remove, and copy them from another USB Type for any you
want to add.

Give each interface a unique number, and edit NUM_INTERFACE to
reflect the number of interfaces.

Within each interface, make sure it uses a unique set of endpoints.
Edit NUM_ENDPOINTS to be at least the largest endpoint number used.
Then edit the ENDPOINT*_CONFIG lines so each endpoint is configured
the proper way (transmit, receive, or both).

The CONFIG_DESC_SIZE and any XYZ_DESC_OFFSET numbers must be
edited to the correct sizes.  See usb_desc.c for the giant array
of bytes.  Someday these may be done automatically..... (but how?)

If you are using existing interfaces, the code in each file should
automatically adapt to the changes you specify.  If you need to
create a new type of interface, you'll need to write the code which
sends and receives packets, and presents an API to the user.

Finally, edit usb_inst.cpp, which creats instances of the C++
objects for each combination.

Some operating systems, especially Windows, may cache USB device
info.  Changes to the device name may not update on the same
computer unless the vendor or product ID numbers change, or the
"bcdDevice" revision code is increased.

If these instructions are missing steps or could be improved, please
let me know?  http://forum.pjrc.com/forums/4-Suggestions-amp-Bug-Reports
*/



#if defined(USB_SERIAL)
  #define VENDOR_ID		0x16C0
  #define PRODUCT_ID		0x0483
  #define DEVICE_CLASS		2	// 2 = Communication Class
  #define MANUFACTURER_NAME	{'T','e','e','n','s','y','d','u','i','n','o'}
  #define MANUFACTURER_NAME_LEN	11
  #define PRODUCT_NAME		{'U','S','B',' ','S','e','r','i','a','l'}
  #define PRODUCT_NAME_LEN	10
  #define EP0_SIZE		64
  #define NUM_ENDPOINTS		4
  #define NUM_USB_BUFFERS	12
  #define NUM_INTERFACE		2
  #define CDC_STATUS_INTERFACE	0
  #define CDC_DATA_INTERFACE	1
  #define CDC_ACM_ENDPOINT	2
  #define CDC_RX_ENDPOINT       3
  #define CDC_TX_ENDPOINT       4
  #define CDC_ACM_SIZE          16
  #define CDC_RX_SIZE           64
  #define CDC_TX_SIZE           64
  #define CONFIG_DESC_SIZE	(9+9+5+5+4+5+7+9+7+7)
  #define ENDPOINT2_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT3_CONFIG	ENDPOINT_RECEIVE_ONLY
  #define ENDPOINT4_CONFIG	ENDPOINT_TRANSIMIT_ONLY

#elif defined(USB_HID)
  #define VENDOR_ID		0x16C0
  #define PRODUCT_ID		0x0482
  #define MANUFACTURER_NAME	{'T','e','e','n','s','y','d','u','i','n','o'}
  #define MANUFACTURER_NAME_LEN	11
  #define PRODUCT_NAME		{'K','e','y','b','o','a','r','d','/','M','o','u','s','e','/','J','o','y','s','t','i','c','k'}
  #define PRODUCT_NAME_LEN	23
  #define EP0_SIZE		64
  #define NUM_ENDPOINTS         5
  #define NUM_USB_BUFFERS	24
  #define NUM_INTERFACE		4
  #define SEREMU_INTERFACE      2	// Serial emulation
  #define SEREMU_TX_ENDPOINT    1
  #define SEREMU_TX_SIZE        64
  #define SEREMU_TX_INTERVAL    1
  #define SEREMU_RX_ENDPOINT    2
  #define SEREMU_RX_SIZE        32
  #define SEREMU_RX_INTERVAL    2
  #define KEYBOARD_INTERFACE    0	// Keyboard
  #define KEYBOARD_ENDPOINT     3
  #define KEYBOARD_SIZE         8
  #define KEYBOARD_INTERVAL     1
  #define MOUSE_INTERFACE       1	// Mouse
  #define MOUSE_ENDPOINT        5
  #define MOUSE_SIZE            8
  #define MOUSE_INTERVAL        1
  #define JOYSTICK_INTERFACE    3	// Joystick
  #define JOYSTICK_ENDPOINT     4
  #define JOYSTICK_SIZE         16
  #define JOYSTICK_INTERVAL     2
  #define KEYBOARD_DESC_OFFSET	(9 + 9)
  #define MOUSE_DESC_OFFSET	(9 + 9+9+7 + 9)
  #define SEREMU_DESC_OFFSET	(9 + 9+9+7 + 9+9+7 + 9)
  #define JOYSTICK_DESC_OFFSET	(9 + 9+9+7 + 9+9+7 + 9+9+7+7 + 9)
  #define CONFIG_DESC_SIZE	(9 + 9+9+7 + 9+9+7 + 9+9+7+7 + 9+9+7)
  #define ENDPOINT1_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT2_CONFIG	ENDPOINT_RECEIVE_ONLY
  #define ENDPOINT3_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT4_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT5_CONFIG	ENDPOINT_TRANSIMIT_ONLY

#elif defined(USB_SERIAL_HID)
  #define VENDOR_ID		0x16C0
  #define PRODUCT_ID		0x0487
  #define DEVICE_CLASS		0xEF
  #define DEVICE_SUBCLASS	0x02
  #define DEVICE_PROTOCOL	0x01
  #define MANUFACTURER_NAME	{'T','e','e','n','s','y','d','u','i','n','o'}
  #define MANUFACTURER_NAME_LEN	11
  #define PRODUCT_NAME		{'S','e','r','i','a','l','/','K','e','y','b','o','a','r','d','/','M','o','u','s','e','/','J','o','y','s','t','i','c','k'}
  #define PRODUCT_NAME_LEN	30
  #define EP0_SIZE		64
  #define NUM_ENDPOINTS		6
  #define NUM_USB_BUFFERS	30
  #define NUM_INTERFACE		5
  #define CDC_IAD_DESCRIPTOR	1
  #define CDC_STATUS_INTERFACE	0
  #define CDC_DATA_INTERFACE	1	// Serial
  #define CDC_ACM_ENDPOINT	2
  #define CDC_RX_ENDPOINT       3
  #define CDC_TX_ENDPOINT       4
  #define CDC_ACM_SIZE          16
  #define CDC_RX_SIZE           64
  #define CDC_TX_SIZE           64
  #define KEYBOARD_INTERFACE    2	// Keyboard
  #define KEYBOARD_ENDPOINT     1
  #define KEYBOARD_SIZE         8
  #define KEYBOARD_INTERVAL     1
  #define MOUSE_INTERFACE       3	// Mouse
  #define MOUSE_ENDPOINT        5
  #define MOUSE_SIZE            8
  #define MOUSE_INTERVAL        2
  #define JOYSTICK_INTERFACE    4	// Joystick
  #define JOYSTICK_ENDPOINT     6
  #define JOYSTICK_SIZE         16
  #define JOYSTICK_INTERVAL     1
  #define KEYBOARD_DESC_OFFSET	(9+8 + 9+5+5+4+5+7+9+7+7 + 9)
  #define MOUSE_DESC_OFFSET	(9+8 + 9+5+5+4+5+7+9+7+7 + 9+9+7 + 9)
  #define JOYSTICK_DESC_OFFSET	(9+8 + 9+5+5+4+5+7+9+7+7 + 9+9+7 + 9+9+7 + 9)
  #define CONFIG_DESC_SIZE	(9+8 + 9+5+5+4+5+7+9+7+7 + 9+9+7 + 9+9+7 + 9+9+7)
  #define ENDPOINT1_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT2_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT3_CONFIG	ENDPOINT_RECEIVE_ONLY
  #define ENDPOINT4_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT5_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT6_CONFIG	ENDPOINT_TRANSIMIT_ONLY

#elif defined(USB_MIDI)
  #define VENDOR_ID		0x16C0
  #define PRODUCT_ID		0x0485
  #define MANUFACTURER_NAME	{'T','e','e','n','s','y','d','u','i','n','o'}
  #define MANUFACTURER_NAME_LEN	11
  #define PRODUCT_NAME		{'T','e','e','n','s','y',' ','M','I','D','I'}
  #define PRODUCT_NAME_LEN	11
  #define EP0_SIZE		64
  #define NUM_ENDPOINTS         4
  #define NUM_USB_BUFFERS	16
  #define NUM_INTERFACE		2
  #define SEREMU_INTERFACE      1	// Serial emulation
  #define SEREMU_TX_ENDPOINT    1
  #define SEREMU_TX_SIZE        64
  #define SEREMU_TX_INTERVAL    1
  #define SEREMU_RX_ENDPOINT    2
  #define SEREMU_RX_SIZE        32
  #define SEREMU_RX_INTERVAL    2
  #define MIDI_INTERFACE        0	// MIDI
  #define MIDI_TX_ENDPOINT      3
  #define MIDI_TX_SIZE          64
  #define MIDI_RX_ENDPOINT      4
  #define MIDI_RX_SIZE          64
  #define SEREMU_DESC_OFFSET	(9 + 9+7+6+6+9+9+9+5+9+5 + 9)
  #define CONFIG_DESC_SIZE	(9 + 9+7+6+6+9+9+9+5+9+5 + 9+9+7+7)
  #define ENDPOINT1_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT2_CONFIG	ENDPOINT_RECEIVE_ONLY
  #define ENDPOINT3_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT4_CONFIG	ENDPOINT_RECEIVE_ONLY

#elif defined(USB_RAWHID)
  #define VENDOR_ID		0x16C0
  #define PRODUCT_ID		0x0486
  #define RAWHID_USAGE_PAGE	0xFFAB  // recommended: 0xFF00 to 0xFFFF
  #define RAWHID_USAGE		0x0200  // recommended: 0x0100 to 0xFFFF
  #define MANUFACTURER_NAME	{'T','e','e','n','s','y','d','u','i','n','o'}
  #define MANUFACTURER_NAME_LEN	11
  #define PRODUCT_NAME		{'T','e','e','n','s','y','d','u','i','n','o',' ','R','a','w','H','I','D'}
  #define PRODUCT_NAME_LEN	18
  #define EP0_SIZE		64
  #define NUM_ENDPOINTS         6
  #define NUM_USB_BUFFERS	12
  #define NUM_INTERFACE		2
  #define RAWHID_INTERFACE      0	// RawHID
  #define RAWHID_TX_ENDPOINT    3
  #define RAWHID_TX_SIZE        64
  #define RAWHID_TX_INTERVAL    1
  #define RAWHID_RX_ENDPOINT    4
  #define RAWHID_RX_SIZE        64
  #define RAWHID_RX_INTERVAL    1
  #define SEREMU_INTERFACE      1	// Serial emulation
  #define SEREMU_TX_ENDPOINT    1
  #define SEREMU_TX_SIZE        64
  #define SEREMU_TX_INTERVAL    1
  #define SEREMU_RX_ENDPOINT    2
  #define SEREMU_RX_SIZE        32
  #define SEREMU_RX_INTERVAL    2
  #define RAWHID_DESC_OFFSET	(9 + 9)
  #define SEREMU_DESC_OFFSET	(9 + 9+9+7+7 + 9)
  #define CONFIG_DESC_SIZE	(9 + 9+9+7+7 + 9+9+7+7)
  #define ENDPOINT1_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT2_CONFIG	ENDPOINT_RECEIVE_ONLY
  #define ENDPOINT3_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT4_CONFIG	ENDPOINT_RECEIVE_ONLY

#elif defined(USB_FLIGHTSIM)
  #define VENDOR_ID		0x16C0
  #define PRODUCT_ID		0x0488
  #define MANUFACTURER_NAME	{'T','e','e','n','s','y','d','u','i','n','o'}
  #define MANUFACTURER_NAME_LEN	11
  #define PRODUCT_NAME		{'T','e','e','n','s','y',' ','F','l','i','g','h','t',' ','S','i','m',' ','C','o','n','t','r','o','l','s'}
  #define PRODUCT_NAME_LEN	26
  #define EP0_SIZE		64
  #define NUM_ENDPOINTS         4
  #define NUM_USB_BUFFERS	20
  #define NUM_INTERFACE		2
  #define FLIGHTSIM_INTERFACE	0	// Flight Sim Control
  #define FLIGHTSIM_TX_ENDPOINT	3
  #define FLIGHTSIM_TX_SIZE	64
  #define FLIGHTSIM_TX_INTERVAL	1
  #define FLIGHTSIM_RX_ENDPOINT	4
  #define FLIGHTSIM_RX_SIZE	64
  #define FLIGHTSIM_RX_INTERVAL	1
  #define SEREMU_INTERFACE      1	// Serial emulation
  #define SEREMU_TX_ENDPOINT    1
  #define SEREMU_TX_SIZE        64
  #define SEREMU_TX_INTERVAL    1
  #define SEREMU_RX_ENDPOINT    2
  #define SEREMU_RX_SIZE        32
  #define SEREMU_RX_INTERVAL    2
  #define FLIGHTSIM_DESC_OFFSET	(9 + 9)
  #define SEREMU_DESC_OFFSET	(9 + 9+9+7+7 + 9)
  #define CONFIG_DESC_SIZE	(9 + 9+9+7+7 + 9+9+7+7)
  #define ENDPOINT1_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT2_CONFIG	ENDPOINT_RECEIVE_ONLY
  #define ENDPOINT3_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  #define ENDPOINT4_CONFIG	ENDPOINT_RECEIVE_ONLY

#elif defined(USB_GUITAR)
  #define VENDOR_ID		0x12BA // 0x12BA
  #define PRODUCT_ID		0x0200 // 0x0200
  #define MANUFACTURER_NAME	{'L','i','c','e','n','s','e','d',' ','b','y',' ','S','o','n','y',' ','C','o','m','p','u','t','e','r',' ','E','n','t','e','r','t','a','i','n','m','e','n','t',' ','A','m','e','r','i','c','a'}
  #define MANUFACTURER_NAME_LEN	47
 #define PRODUCT_NAME		{'H','a','r','m','o','n','i','x',' ','G','u','i','t','a','r',' ','f','o','r',' ','P','l','a','y','S','t','a','t','i','o','n',0xAE,'3'} // 0xAE = '�'
  #define PRODUCT_NAME_LEN	33
  #define EP0_SIZE		8
  #define NUM_ENDPOINTS         1//2
  #define NUM_USB_BUFFERS	16
  #define NUM_INTERFACE		1
  #define GUITAR_INTERFACE	0	// Guitar
  #define GUITAR_ENDPOINT1	1
  //#define GUITAR_ENDPOINT2	2
  #define GUITAR_SIZE		64
  #define GUITAR_INTERVAL1	10
  //#define GUITAR_INTERVAL2	1
  #define GUITAR_DESC_OFFSET	(9 + 9)
  #define CONFIG_DESC_SIZE	(9 + 9+9+7)// 0x0029
  #define ENDPOINT1_CONFIG	ENDPOINT_TRANSIMIT_ONLY
  //#define ENDPOINT2_CONFIG	ENDPOINT_TRANSIMIT_ONLY

#endif

// NUM_ENDPOINTS = number of non-zero endpoints (0 to 15)
extern const uint8_t usb_endpoint_config_table[NUM_ENDPOINTS];

typedef struct {
	uint16_t	wValue;
	uint16_t	wIndex;
	const uint8_t	*addr;
	uint16_t	length;
} usb_descriptor_list_t;

extern const usb_descriptor_list_t usb_descriptor_list[];


#endif
