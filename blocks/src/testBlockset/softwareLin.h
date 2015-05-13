#ifndef LIN_H
#define LIN_H

void send(unsigned char* buffer, unsigned char addr, unsigned char* message,unsigned char nBytes,unsigned char proto);
// For Lin 1.X "start" should = 0, for Lin 2.X "start" should be the addr byte.
unsigned char dataChecksum(unsigned char* message, char nBytes,unsigned short start);
unsigned char addrParity(unsigned char addr);

#endif // LIN_H
