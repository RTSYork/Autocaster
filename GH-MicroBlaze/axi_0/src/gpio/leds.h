#ifndef __LEDS_H
#define __LEDS_H

#define LED_OFF 0
#define LED_ON  1
#define LED0 0x01
#define LED1 0x02
#define LED2 0x04
#define LED3 0x08
#define LED4 0x10
#define LED5 0x20
#define LED6 0x40
#define LED7 0x80

void setLeds(int value);
int getLeds(void);

void setLed(int led, int value);
int getLed(int led);

#endif
