#ifndef __TIMER_H
#define __TIMER_H

#include "xintc.h"			//Interrupt Controller API functions

void initTimer(XIntc controller);

void startTimer(u8 TmrCtrNumber);
void stopTimer(u8 TmrCtrNumber);
u32 getTimerValue(u8 TmrCtrNumber);
u32 getTimerCaptureValue(u8 TmrCtrNumber);
void resetTimer(u8 TmrCtrNumber);

#endif
