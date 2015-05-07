/* 
 * Wrappers to make I/O functions available with C linkage. This allows C++
 * methods to be called from C code.
 *
 * Copyright 2011-2013 The MathWorks, Inc. */

#include <inttypes.h>
#include <stdio.h>


void MW_EthernetBegin(void);

uint8_t MW_UDPBegin(uint32_t localPort);
int MW_UDPFinalWrite(uint8_t *data, uint32_t dataSize, uint8_t remoteIPOctect1,uint8_t remoteIPOctect2,uint8_t remoteIPOctect3,uint8_t remoteIPOctect4, uint32_t remoteport);
int MW_UDPFinalRead(uint8_t *data, uint16_t simPacketSize);

void MW_TCPServerBegin(uint32_t serverport);
void MW_TCPFinalread(uint8_t *data, uint32_t serverport, int *outStatus);
void MW_TCPFinalWrite(uint8_t data, uint32_t serverport);