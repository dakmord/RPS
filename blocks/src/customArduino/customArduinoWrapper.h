#include <inttypes.h>
#include <stdio.h> /* for size_t */

//void customSerial_Read(int port, int showOutStatus, uint8_t *outData, int *outStatus);
void customSerial_Read(int port, unsigned char *outData, int *outStatus, int receiveBufferLength);
