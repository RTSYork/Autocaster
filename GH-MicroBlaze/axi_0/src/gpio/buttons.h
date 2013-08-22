#ifndef __BUTTONS_H
#define __BUTTONS_H

#include "xintc.h"			//Interrupt Controller API functions
#include "gh_player.h"

#define BUTTON_OFF 0
#define BUTTON_ON  1

#define BUTTON_UP     0x01
#define BUTTON_LEFT   0x02
#define BUTTON_DOWN   0x04
#define BUTTON_RIGHT  0x08
#define BUTTON_CENTRE 0x10

#define lBtnChannel	1	//GPIO channel of the push buttons

extern u8 delay;

extern u8 playerEnable;
extern u8 type;
extern u8 strumValue;

void initButtonInterrupt(XIntc controller);
void enableButtonInterrupt(void);
void disableButtonInterrupt(void);

int getButtons(void);
int getButton(int button);

void PushBtnHandler(void *CallBackRef);

#endif
