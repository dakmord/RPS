#include "gpioEnergia.h"

void digitalWriteEnergia(unsigned char pin, unsigned char val)
{
#ifndef MATLAB_MEX_FILE
	pinMode(pin, OUTPUT);
	digitalWrite(pin, val);
#endif
}

unsigned char digitalReadEnergia(unsigned char pin, unsigned char mode)
{
#ifndef MATLAB_MEX_FILE
		switch(mode){
				case 1:
					pinMode(pin, INPUT);
					break;
				case 2:
					pinMode(pin, INPUT_PULLDOWN);
					break;
				case 3:
					pinMode(pin, INPUT_PULLUP);
					break;
				default:
					pinMode(pin, INPUT);
					break;
		}
	return digitalRead(pin);
#endif
	
}

unsigned short analogReadEnergia(unsigned char pin)
{
#ifndef MATLAB_MEX_FILE
	return analogRead(pin);
#endif
}

void analogWriteEnergia(unsigned char pin, unsigned char value)
{
#ifndef MATLAB_MEX_FILE
	pinMode(pin, OUTPUT);
	analogWrite(pin, value);
#endif
}
