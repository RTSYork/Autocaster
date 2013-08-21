#ifndef __VDMA_H
#define __VDMA_H

int vdma_setup(XIntc controller);

int StartParking(int writeFrame, int readFrame, int output);
int StopParking(int output);

void EnableVDMAEthIntr(void);
void DisableVDMAEthIntr(void);
void EnableVDMAUARTIntr(void);

#endif
