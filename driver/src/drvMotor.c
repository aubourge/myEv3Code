#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include "lms2012.h"
#include "c_output.h"
#include "types.h"
#include "utils.h"
#include "drvMotor.h"


/* === Globals === */

/* Motor module pointers */
int _fileWr;
int _fileRd;

int *_ibuff;

int init()
{
	// Open the device file for writing
	if((_fileWr = open(PWM_DEVICE_NAME, O_RDWR, 0)) == -1)
		return -1; //Failed to open device
	//
	// Open the device file for reading
	if((_fileRd = open(MOTOR_DEVICE_NAME, O_RDWR, 0)) == -1)
		return -1; //Failed to open device
	_ibuff = (int*)mmap(0, 96, PROT_READ | PROT_WRITE, MAP_FILE | MAP_SHARED, _fileRd, 0); 

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

void motorSetSpeed(char portMap, s8 speed)
{
	char cmd[3];
	cmd[0] = opOUTPUT_SPEED;
	cmd[1] = portMap;
	cmd[2] = speed;

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


#if O // Not working
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
#endif

struct motorReadData motorRead(int port)
{
	//displayIntArray("Read", _ibuff, 12);
	return (struct motorReadData) {_ibuff[3*port], _ibuff[3*port+1], _ibuff[3*port+2]};
}

