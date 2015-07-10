#ifndef __SERIALENERGIA_H
 #define __SERIALENERGIA_H

#ifndef MATLAB_MEX_FILE
 #include <stdint.h>
 #include <stdbool.h>
 #include "io_wrappers.h"
#endif

void serialInitializeEnergia(int port, long baud);
void serialWriteEnergia(int port, unsigned char *bytestream, int size);
void serialReceiveEnergia(int port, unsigned char outData[], int *outStatus, int receiveBufferLength);
void linSendEnergia(int port, long baud, unsigned char txPin, unsigned char *linFrame, unsigned char linFrameSize);
#endif
