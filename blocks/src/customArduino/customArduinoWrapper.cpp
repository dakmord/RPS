/*
 * Custom Arduino Wrapper:
 * 	- Custom Serial Receive Block 
 *
 */

#include <inttypes.h>
#include "Arduino.h"
#include "Servo.h"
#include <SPI.h>
#include <Ethernet.h>
#include <EthernetUdp.h>

extern "C" {
    void __cxa_pure_virtual(void);
}

extern "C" void customSerial_Read(int port, unsigned char *outData, int *outStatus, int receiveBufferLength)
{
	int bytesReceived=0;

#ifdef _ROTH_MEGA2560_  /* Could do without this conditional */

    switch(port) {
        case 0:
			while(Serial.available()>0 && bytesReceived<receiveBufferLength) {
				outData[bytesReceived] = (unsigned char)Serial.read();
				bytesReceived = bytesReceived + 1;
			}
            break;
        case 1:
			while(Serial1.available()>0 && bytesReceived<receiveBufferLength) {
				outData[bytesReceived] = (unsigned char)Serial1.read();
				bytesReceived +=1;
			}
            break;
        case 2:
			while(Serial2.available()>0 && bytesReceived<receiveBufferLength) {
				outData[bytesReceived] = (unsigned char)Serial2.read();
				bytesReceived +=1;
			}
            break;
        case 3:
			while(Serial3.available()>0 && bytesReceived<receiveBufferLength) {
				outData[bytesReceived] = (unsigned char)Serial3.read();
				bytesReceived +=1;
			}
            break;
    }
#else
	while(Serial.available()>0 && bytesReceived<receiveBufferLength) {
		outData[bytesReceived] = (unsigned char) Serial.read();
		bytesReceived +=1;
	}
#endif
	*outStatus = bytesReceived;
	
	// Zero rest of buffer
	for(int i=bytesReceived;i<receiveBufferLength;i++){
		outData[i]=0;
	}	
	
}