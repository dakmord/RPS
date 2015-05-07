#include "ethernetEnergia.h"

void udpWriteEnergia(unsigned char *data, int dataSize, unsigned int localPort, unsigned int remotePort, unsigned char remoteIP1, unsigned char remoteIP2, unsigned char remoteIP3, unsigned char remoteIP4)
{
#ifndef MATLAB_MEX_FILE
	static int only_one_ethernet_begin;
    if (only_one_ethernet_begin==0)
    {
		MW_UDPBegin(localPort);
		only_one_ethernet_begin++;
	}
	MW_UDPFinalWrite(data, dataSize, remoteIP1,remoteIP2,remoteIP3,remoteIP4, remotePort);
#endif
}

int udpReadEnergia(unsigned char *data, unsigned int localPort, unsigned short simVectorSize)
{
#ifndef MATLAB_MEX_FILE
	static int only_one_ethernet_begin;
    if (only_one_ethernet_begin==0)
    {
		MW_UDPBegin(localPort);
		only_one_ethernet_begin++;
	}
	return MW_UDPFinalRead(data,simVectorSize);
#endif
}
