#include "softwareLin.h"

#ifndef _LIN_C
#define _LIN_C
/* Lin defines its checksum as an inverted 8 bit sum with carry */
unsigned char dataChecksumLin(unsigned char* message, char nBytes,unsigned short sum)
{
    while (nBytes-- > 0) sum += *(message++);
    // Add the carry
    while(sum>>8)  // In case adding the carry causes another carry
      sum = (sum&255)+(sum>>8);
    return (~sum);
}

/* Create the Lin ID parity */
#define BIT(data,shift) ((addr&(1<<shift))>>shift)
unsigned char addrParityLin(unsigned char addr)
{
  unsigned char p0 = BIT(addr,0) ^ BIT(addr,1) ^ BIT(addr,2) ^ BIT(addr,4);
  unsigned char p1 = ~(BIT(addr,1) ^ BIT(addr,3) ^ BIT(addr,4) ^ BIT(addr,5));
  return (p0 | (p1<<1))<<6;
}

/* Send a message across the Lin bus */
void linSend(unsigned char* buffer, unsigned char addr, unsigned char* message, unsigned char nBytes,unsigned char proto)
{
  //unsigned char bytestream[13];
  unsigned char addrbyte = (addr&0x3f) | addrParity(addr);
  unsigned char cksum = dataChecksumLin(message,nBytes,addrbyte); //(proto==1) ? 0:
  short p = 0;
  
  buffer[0] = 0x00;    // BREAK delimiter
  buffer[1] = 0x01;
  buffer[2] = 0x55;
  buffer[3] = addrbyte; // ID byte
  for(p = 0; p < nBytes; p++)
  {
    buffer[p+4] = message[p];
  }
  buffer[nBytes+4] = cksum; // checksum
  //return buffer;
}

unsigned char linReceive(unsigned char addr, unsigned char* message, unsigned char messageSize, unsigned char protocol, )
{
	// local variables
	unsigned char bytesReceived = 0;
	unsigned int timeoutCount = 0;
	unsigned char addrbyte = (addr&0x3f) | addrParity(addr);
	
	buffer[0] = 0x00;    // BREAK delimiter
	buffer[1] = 0x01;
	buffer[2] = 0x55;
	buffer[3] = addrbyte; // ID byte
	
	return bytesReceived;
}

#endif


