#ifndef __GPIOENERGIA_H
 #define __GPIOENERGIA_H

#ifndef MATLAB_MEX_FILE
 #include <stdint.h>
 #include <stdbool.h>
 #include "Energia.h"
#endif

void digitalWriteEnergia(unsigned char pin, unsigned char val);
unsigned char digitalReadEnergia(unsigned char pin, unsigned char mod);
unsigned short analogReadEnergia(unsigned char pin);
void analogWriteEnergia(unsigned char pin, unsigned char value);
#endif
