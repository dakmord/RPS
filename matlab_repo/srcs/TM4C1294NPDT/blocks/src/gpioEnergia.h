#ifndef __GPIOENERGIA_H
 #define __GPIOENERGIA_H

#ifndef MATLAB_MEX_FILE
 #include <stdint.h>
 #include <stdbool.h>
 #include "Energia.h"
#endif

void digitalWriteEnergia(unsigned char pin, unsigned char value);
unsigned char digitalReadEnergia(unsigned char pin);
void digitalModeInitialize(unsigned char pin, unsigned char mode);
int analogReadEnergia(unsigned char pin);
void analogWriteEnergia(unsigned char pin, unsigned char value);
#endif
