#include "serialEnergia.h"


void serialInitializeEnergia(int port, long baud)
{
#ifndef MATLAB_MEX_FILE	
	Serial_beginEnergia(port, baud);
#endif
}

void serialWriteEnergia(int port, unsigned char *bytestream, int size)
{
#ifndef MATLAB_MEX_FILE	
	Serial_writeEnergia(port, bytestream, size);
#endif	
}

void serialReceiveEnergia(int port, unsigned char outData[], int *outStatus, int receiveBufferLength)
{
#ifndef MATLAB_MEX_FILE	
	Serial_readEnergia(port, outData, outStatus, receiveBufferLength);
#endif	
}

void linSendEnergia(int port, long baud, unsigned char txPin, unsigned char *linFrame, unsigned char linFrameSize)
{
#ifndef MATLAB_MEX_FILE
	linSendEnergiaWrapper(port, baud, txPin, linFrame, linFrameSize);
#endif
}
