#ifndef __ETHERNETENERGIA_H
 #define ____ETHERNETENERGIA_H_H

#ifndef MATLAB_MEX_FILE
 #include <stdint.h>
 #include <stdbool.h>
 #include "io_wrappers.h"
#endif

void udpWriteEnergia(unsigned char *data, int dataSize, unsigned int localPort, unsigned int remotePort, unsigned char remoteIP1, unsigned char remoteIP2, unsigned char remoteIP3, unsigned char remoteIP4);
int udpReadEnergia(unsigned char *data, unsigned int localPort, unsigned short simVectorSize);
#endif
