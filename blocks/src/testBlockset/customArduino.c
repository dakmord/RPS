/*
 * Custom Arduino Wrapper:
 * 	- Custom Serial Receive Block 
 *
 */

#include "customArduino.h"

#include "Arduino.h"
#include <inttypes.h>

extern "C" void customSerial_Read(int port, int showOutStatus, unsigned char *outData, int *outStatus, unsigned int receiveBufferLength)
{
	uint8_t *udpBuffer = (uint8_t*) malloc(simPacketSize);
	unsigned char *buffer; 
    int libFcnOutput;
	int availableData = 0;
#ifdef _ROTH_MEGA2560_  /* Could do without this conditional */

    switch(port) {
        case 0:
			availableData = Serial.available();
			if(availableData>=receiveBufferLength) {
				*buffer = (unsigned char*) malloc(receiveBufferLength); 
				libFcnOutput = Serial.readBytes(buffer,receiveBufferLength);
			}
			else if(availableData>0) {
				*buffer = (unsigned char*) malloc(availableData); 
				libFcnOutput = Serial.readBytes(buffer,availableData);
			}
            break;
        case 1:
			availableData = Serial1.available();
			if(availableData>=receiveBufferLength) {
				*buffer = (unsigned char*) malloc(receiveBufferLength); 
				libFcnOutput = Serial1.readBytes(buffer,receiveBufferLength);
			}
			else if(availableData>0) {
				*buffer = (unsigned char*) malloc(availableData); 
				libFcnOutput = Serial1.readBytes(buffer,availableData);
			}
            break;
        case 2:
			availableData = Serial2.available();
			if(availableData>=receiveBufferLength) {
				*buffer = (unsigned char*) malloc(receiveBufferLength); 
				libFcnOutput = Serial2.readBytes(buffer,receiveBufferLength);
			}
			else if(availableData>0) {
				*buffer = (unsigned char*) malloc(availableData); 
				libFcnOutput = Serial2.readBytes(buffer,availableData);
			}
            break;
        case 3:
			availableData = Serial3.available();
			if(availableData>=receiveBufferLength) {
				*buffer = (unsigned char*) malloc(receiveBufferLength); 
				libFcnOutput = Serial3.readBytes(buffer,receiveBufferLength);
			}
			else if(availableData>0) {
				*buffer = (unsigned char*) malloc(availableData); 
				libFcnOutput = Serial3.readBytes(buffer,availableData);
			}
            break;
    }
#else
	availableData = Serial.available();
			if(availableData>=receiveBufferLength) {
				*buffer = (unsigned char*) malloc(receiveBufferLength); 
				libFcnOutput = Serial.readBytes(buffer,receiveBufferLength);
			}
			else if(availableData>0) {
				*buffer = (unsigned char*) malloc(availableData); 
				libFcnOutput = Serial.readBytes(buffer,availableData);
			}
#endif
    *outData = (unsigned char) buffer;
	if(availableData>=receiveBufferLength) {
		*outStatus = receiveBufferLength;
	}
	else {
		*outStatus = availableData;
	}
    
}