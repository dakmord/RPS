/*
 * Custom Arduino Wrapper:
 * 	- Custom Serial Receive Block 
 *
 */
#include "customArduino.h"
 
void Serial_Read_Arduino(int port, unsigned char outData[], int *outStatus, int receiveBufferLength)
{
#ifndef MATLAB_MEX_FILE
customSerial_Read(port, outData, outStatus, receiveBufferLength);
#endif

}
