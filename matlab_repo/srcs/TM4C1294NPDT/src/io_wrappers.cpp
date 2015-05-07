//Custom Wrapper for different IOs
//Example for UDP ...
#include <inttypes.h>
#include "Energia.h"
//#include "Servo.h"
//#include <SPI.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#define UDP_MAX_PACKET_SIZE 500

EthernetUDP Udp;
IPAddress localIpAddress(_RTT_Local_IP1, _RTT_Local_IP2, _RTT_Local_IP3, _RTT_Local_IP4);
byte mac[] = { _RTT_Local_MAC1, _RTT_Local_MAC2, _RTT_Local_MAC3, _RTT_Local_MAC4, _RTT_Local_MAC5, _RTT_Local_MAC6 };

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
