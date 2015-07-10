//Custom Wrapper for different IOs
//Example for UDP ...
#include <inttypes.h>
#include "Energia.h"
//#include "Servo.h"
//#include <SPI.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <HardwareSerial.h>
#define UDP_MAX_PACKET_SIZE 500

EthernetUDP Udp;
IPAddress localIpAddress(_RTT_Local_IP1, _RTT_Local_IP2, _RTT_Local_IP3, _RTT_Local_IP4);
byte mac[] = { _RTT_Local_MAC1, _RTT_Local_MAC2, _RTT_Local_MAC3, _RTT_Local_MAC4, _RTT_Local_MAC5, _RTT_Local_MAC6 };

// Create the Lin ID parity
#define BIT(data,shift) ((addr&(1<<shift))>>shift)
uint8_t addrParity(uint8_t addr)
{
  uint8_t p0 = BIT(addr,0) ^ BIT(addr,1) ^ BIT(addr,2) ^ BIT(addr,4);
  uint8_t p1 = ~(BIT(addr,1) ^ BIT(addr,3) ^ BIT(addr,4) ^ BIT(addr,5));
  return (p0 | (p1<<1)) << 6;
}

/* Lin defines its checksum as an inverted 8 bit sum with carry */
uint8_t dataChecksum(const uint8_t* message, char nBytes, uint16_t sum)
{
	while (nBytes-- > 0) 
	{
		sum += *(message++);
	}

    // Add the carry
    while(sum>>8) { // In case adding the carry causes another carry
      sum = (sum&255)+(sum>>8); 
	}

    return (~sum);
}

extern "C" void Serial_beginEnergia(int port, long r)
{
    switch(port) {
        case 0:
            Serial.begin(r);
            break;
        case 1:
            Serial1.begin(r);
            break;
        case 2:
            Serial2.begin(r);
            break;
        case 3:
            Serial3.begin(r);
			break;
		case 4:
			Serial4.begin(r);
			break;
		case 5:
			Serial5.begin(r);
			break;
		case 6:
			Serial6.begin(r);
			break;
		case 7:
			Serial7.begin(r);
            break;
    }
}

extern "C" void Serial_readEnergia(int port, unsigned char *outData, int *outStatus, int receiveBufferLength)
{
	int bytesReceived=0;

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
		case 4:
			while(Serial4.available()>0 && bytesReceived<receiveBufferLength) {
				outData[bytesReceived] = (unsigned char)Serial4.read();
				bytesReceived +=1;
			}
            break;
		case 5:
			while(Serial5.available()>0 && bytesReceived<receiveBufferLength) {
				outData[bytesReceived] = (unsigned char)Serial5.read();
				bytesReceived +=1;
			}
            break;
		case 6:
			while(Serial6.available()>0 && bytesReceived<receiveBufferLength) {
				outData[bytesReceived] = (unsigned char)Serial6.read();
				bytesReceived +=1;
			}
            break;
		case 7:
			while(Serial7.available()>0 && bytesReceived<receiveBufferLength) {
				outData[bytesReceived] = (unsigned char)Serial7.read();
				bytesReceived +=1;
			}
            break;	
    }

	*outStatus = bytesReceived;
	
	// Zero rest of buffer
	for(int i=bytesReceived;i<receiveBufferLength;i++){
		outData[i]=0;
	}	
	
}

extern "C" void getSerialPort(int port, HardwareSerial *serial) {
	switch(port){
		case 0:
			serial = &Serial;
			break;
		case 1:
			serial = &Serial1;
			break;
		case 2:
			serial = &Serial2;
			break;
		case 3:
			serial = &Serial3;
			break;
		case 4:
			serial = &Serial4;
			break;
		case 5:
			serial = &Serial5;
			break;
		case 6:
			serial = &Serial6;
			break;
		case 7:
			serial = &Serial7;
			break;
		default:
			serial = &Serial;
			break;
	}
}

extern "C" void linSendEnergiaWrapper(int port, long baud, unsigned char txPin, unsigned char *linFrame, unsigned char linFrameSize)
{
	// Check if Should be sent!
	if(linFrameSize > 1)
	{
		// Get Serial Address...
		HardwareSerial *serial;
		switch(port){
		case 0:
			serial = &Serial;
			break;
		case 1:
			serial = &Serial1;
			break;
		case 2:
			serial = &Serial2;
			break;
		case 3:
			serial = &Serial3;
			break;
		case 4:
			serial = &Serial4;
			break;
		case 5:
			serial = &Serial5;
			break;
		case 6:
			serial = &Serial6;
			break;
		case 7:
			serial = &Serial7;
			break;
		default:
			serial = &Serial;
			break;
		}
		
		// Disable Serial
		serial->end();
		
		// Generate Break Delimiter
		pinMode(txPin, OUTPUT);
		digitalWrite(txPin, LOW);  // Send BREAK
		delayMicroseconds((1000000UL/((unsigned long int) baud)) * 15);
		digitalWrite(txPin, HIGH);  // BREAK delimiter
		delayMicroseconds(1000000UL/((unsigned long int) baud));
		
		// Begin Serial and Send Data
		serial->begin(baud);
		
		// Send Data
		serial->write(linFrame, linFrameSize);	
	}
}

extern "C" void Serial_writeEnergia(int port, unsigned char *c, int s)
{
    switch(port) {
        case 0:
            Serial.write(c, s);
            break;
        case 1:
            Serial1.write(c, s);
            break;
        case 2:
            Serial2.write(c, s);
            break;
        case 3:
            Serial3.write(c, s);
            break;
		case 4:
            Serial4.write(c, s);
            break;
		case 5:
            Serial5.write(c, s);
            break;
		case 6:
            Serial6.write(c, s);
            break;
		case 7:
            Serial7.write(c, s);
            break;	
		default:
			break;
    }
}



// Ethernet Begin
extern "C" void MW_EthernetBegin(void)
{
    static int only_one_ethernet_begin;
    if (only_one_ethernet_begin==0)
    {
        Ethernet.begin(mac, localIpAddress);
        only_one_ethernet_begin++;
    }  
}

// UDP Begin
extern "C" uint8_t MW_UDPBegin(uint32_t localPort)
{
    return (Udp.begin(localPort));
}

// UDP Send
extern "C" int MW_UDPFinalWrite(uint8_t *data, uint32_t dataSize, uint8_t remoteIPOctect1,uint8_t remoteIPOctect2,uint8_t remoteIPOctect3,uint8_t remoteIPOctect4, uint32_t remoteport)
{
    IPAddress remoteIpAddress(remoteIPOctect1,remoteIPOctect2, remoteIPOctect3, remoteIPOctect4);
    Udp.beginPacket(remoteIpAddress, remoteport);
    Udp.write(data, dataSize);
    return(Udp.endPacket());
}

//UDP Read
extern "C" int MW_UDPFinalRead(uint8_t *data, uint16_t simPacketSize)
{
	
	// Parse Packets...
	int packetSize = Udp.parsePacket();
    if(packetSize)
    {
		// Create dynamic buffer depending on Simulink Vector size
		uint8_t *udpBuffer = (uint8_t*) malloc(simPacketSize);
		
        packetSize = Udp.read(udpBuffer,simPacketSize);
        *data = (uint8_t)*udpBuffer;
		free(udpBuffer);
		return packetSize;
    }
    else {
		return 0;
	}
}

// TCP Begin
extern "C" void MW_TCPServerBegin(uint32_t serverport)
{
    static int only_one_tcp_server_begin;
    if (only_one_tcp_server_begin==0)
    {
        EthernetServer server(serverport);
        server.begin();
        only_one_tcp_server_begin ++;
    }
}

// TCP Read
extern "C" void MW_TCPFinalread(uint8_t *data, uint32_t serverport, int *outStatus)
{
    EthernetServer server(serverport); //declared again to gain access to the server port
    int libFcnOutput;
    EthernetClient client = server.available();
    if (client == true) {
        libFcnOutput = client.read();
        *data = (uint8_t) libFcnOutput;
        *outStatus = (libFcnOutput != -1);
    }
}

// TCP Send
extern "C" void MW_TCPFinalWrite(uint8_t data, uint32_t serverport)
{
    EthernetServer server(serverport);
    server.write(data);
}
