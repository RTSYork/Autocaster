#ifndef __SWITCHES_H
#define __SWITCHES_H

#define SWITCH_OFF 0
#define SWITCH_ON  1
#define SWITCH0 0x01
#define SWITCH1 0x02
#define SWITCH2 0x04
#define SWITCH3 0x08
#define SWITCH4 0x10
#define SWITCH5 0x20
#define SWITCH6 0x40
#define SWITCH7 0x80

int getSwitches(void);
int getSwitch(int switchNumber);

#endif
