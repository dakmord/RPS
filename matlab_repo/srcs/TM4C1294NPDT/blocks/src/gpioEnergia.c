/*********************************************************************/
// 		C-Wrapper Methos for use within S-Functions
//		21.06.2015, Daniel Schneider, "Added pin initialize method"
//

#include "gpioEnergia.h"

void digitalWriteEnergia(unsigned char pin, unsigned char value)
{
#ifndef MATLAB_MEX_FILE
	digitalWrite(pin, value);
#endif
}

unsigned char digitalReadEnergia(unsigned char pin)
{
#ifndef MATLAB_MEX_FILE
	return digitalRead(pin);
#endif
	
}

void digitalModeInitialize(unsigned char pin, unsigned char mode)
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
				case 4:
					pinMode(pin, OUTPUT);
					break;
				default:
					pinMode(pin, INPUT);
					break;
		}
#endif
}

int analogReadEnergia(unsigned char pin)
{
#ifndef MATLAB_MEX_FILE
int selectedPin = A0;
switch(pin)
{
	case 2:
		selectedPin = A9;
		break;
	case 6:
		selectedPin = A8;
		break;
	case 7:
		selectedPin = A12;
		break;
	case 14:
		selectedPin = A15;
		break;
	case 15:
		selectedPin = A14;
		break;
	case 23:
		selectedPin = A3;
		break;
	case 24:
		selectedPin = A2;
		break;
	case 25:
		selectedPin = A1;
		break;
	case 26:
		selectedPin = A0;
		break;
	case 27:
		selectedPin = A4;
		break;
	case 42:
		selectedPin = A13;
		break;
	case 45:
		selectedPin = A7;
		break;
	case 46:
		selectedPin = A6;
		break;
	case 63:
		selectedPin = A10;
		break;
	case 64:
		selectedPin = A11;
		break;
	case 65:
		selectedPin = A16;
		break;
	case 66:
		selectedPin = A17;
		break;
	case 67:
		selectedPin = A18;
		break;
	case 68:
		selectedPin = A19;
		break;
	case 87:
		selectedPin = A5;
		break;
}
	return analogRead(selectedPin);
#endif
}

void analogWriteEnergia(unsigned char pin, unsigned char value)
{
#ifndef MATLAB_MEX_FILE
	analogWrite(pin, value);
#endif
}
