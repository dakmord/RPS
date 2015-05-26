#ifndef _CUSTOM_ARDUINO_H_
#define _CUSTOM_ARDUINO_H_

#include <inttypes.h>
#include <stdio.h> /* for size_t */

//void customSerial_Read(int port, int showOutStatus, uint8_t *outData, int *outStatus);
void customSerial_Read(int port, int showOutStatus, unsigned char *outData, int *outStatus, unsigned int receiveBufferLength, );

#endif