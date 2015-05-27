#ifndef _CUSTOM_ARDUINO_H_
#define _CUSTOM_ARDUINO_H_

#ifndef MATLAB_MEX_FILE
	#include "customArduinoWrapper.h"
#endif

void Serial_Read_Arduino(int port, unsigned char *outData, int *outStatus, int receiveBufferLength);

#endif