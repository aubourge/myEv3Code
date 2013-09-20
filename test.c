
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include "exp/lms2012.h"
#include "exp/c_output.h"

/* === Typedefs === */
typedef unsigned char u8;
typedef signed char s8;
typedef unsigned int u32;


/* === Constants === */
const char MOTOR = 0x1;
const int SPEED = 50;
const int SPEED2 = 100;

/* === Globals === */

/* Motor module pointers */
int _fileWr;
int _fileRd;


int init()
{
	// Open the device file for writing
	if((_fileWr = open(PWM_DEVICE_NAME, O_WRONLY)) == -1)
		return -1; //Failed to open device
	//
	// Open the device file for reading
	if((_fileRd = open(MOTOR_DEVICE_NAME, O_RDWR)) == -1)
		return -1; //Failed to open device

	printf("Init SUCCESS: pointer Wr: %#08x Rd: %#08x\n", _fileWr, _fileRd);

	return 0;
}

void finish()
{
	close(_fileWr);
	close(_fileRd);
}

void motorStart(char portMap)
{
	char cmd[2];
	cmd[0] = opOUTPUT_START;
	cmd[1] = portMap;

	write(_fileWr, cmd, 2);
}


void motorResetRef(char portMap)
{
	char cmd[2];
	cmd[0] = opOUTPUT_RESET;
	cmd[1] = portMap;

	write(_fileWr, cmd, 2);
}


void motorSetPos(char portMap, int position)
{
	char cmd[6];
	cmd[0] = opOUTPUT_POSITION;
	cmd[1] = portMap;
	int i;

	for (i=0; i<4; i++) {
		cmd[i+2] = (char)(position>>8*i & 0xFF);
	}

	write(_fileWr, cmd, 6);
}

void motorSetPower(char portMap, s8 power)
{
	char cmd[3];
	cmd[0] = opOUTPUT_POWER;
	cmd[1] = portMap;
	cmd[2] = power;

	write(_fileWr, cmd, 3);
}

void motorStop(char portMap, u8 brake)
{
	char cmd[3];
	cmd[0] = opOUTPUT_STOP;
	cmd[1] = portMap;
	cmd[2] = brake;

	write(_fileWr, cmd, 3);
	motorSetPower(portMap, 0);
}


u8 motorGetType(char portMap)
{
	char cmd[2];
	char out;
	cmd[0] = opOUTPUT_GET_TYPE;
	cmd[1] = portMap;

	write(_fileWr, cmd, 2);
	read(_fileRd, out, 1);

	return out;

}


void motorRead(char portMap, char* readData)
{
	char cmd[2];
	cmd[0] = opOUTPUT_READ;
	cmd[1] = portMap;
	read(_fileRd, readData, 5);
}

void displayArray(char* name, char* data, int length) 
{
	printf ("%s ", name);
	int i;
	for (i=0; i < length; i++) {
		printf("%x ", data[i]);
	}
	printf("\n");
}


int main()
{
	printf ("Size of int: %d\n", sizeof(int));
	printf ("Size of ushort: %d\n", sizeof(unsigned short));
	printf ("Size of u8: %d\n", sizeof(u8));
	if (init() == -1) return -1; 

	motorStart(MOTOR);
	motorResetRef(MOTOR);
	//motorSetPower(MOTOR, 10);
	sleep(1);
	//motorSetPower(MOTOR, 20);
	sleep(1);
	motorStop(MOTOR, 0);

	printf ("Type: %d\n", motorGetType(MOTOR));

	char readData[10];

	displayArray("Read: ", readData, 10);
	printf("%#08x %#08x\n", *(u32*)_fileWr, *(u32*)_fileRd);

	finish();
	return 0;
}
