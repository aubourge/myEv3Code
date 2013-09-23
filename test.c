
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include "exp/lms2012.h"
#include "exp/c_output.h"
#include  <sys/mman.h>


/* === Typedefs === */
typedef unsigned char u8;
typedef signed char s8;
typedef unsigned int u32;

struct motorReadData {
	int tachoCnt;
	int speed;
	int tachoSensor;
};

/* === Constants === */
const char MOTOR = 0x1;
const int SPEED = 50;
const int SPEED2 = 100;

/* === Globals === */

/* Motor module pointers */
int _fileWr;
int _fileRd;

int *_ibuff;

void displayIntArray(char* name, int* data, int length) ;

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

void motorSetSpeed(char portMap, u8 speed)
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


struct motorReadData motorRead(port)
{
	//displayIntArray("Read", _ibuff, 12);
	return (struct motorReadData) {_ibuff[3*port], _ibuff[3*port+1], _ibuff[3*port+2]};
}

void displayCharArray(char* name, char* data, int length) 
{
	printf ("%s ", name);
	int i;
	for (i=0; i < length; i++) {
		printf("%x ", data[i]);
	}
	printf("\n");
}

void displayIntArray(char* name, int* data, int length) 
{
	printf ("%s ", name);
	int i;
	for (i=0; i < length; i++) {
		printf("%x ", data[i]);
	}
	printf("\n");
}


void test1() 
{
	motorStart(MOTOR);
	motorResetRef(MOTOR);
	//motorSetPower(MOTOR, 10);
	sleep(1);
	//motorSetPower(MOTOR, 20);
	sleep(1);
	motorStop(MOTOR, 0);

	//printf ("Type: %d\n", motorGetType(MOTOR));

	//char readData[10];

	//displayArray("Read: ", readData, 10);
	//printf("%#08x %#08x\n", *(u32*)_fileWr, *(u32*)_fileRd);
}


void test2()
{
	struct motorReadData data; 

	motorResetRef(MOTOR);
	motorStart(MOTOR);

	int timeOut = 100;

	while(--timeOut) {
		data = motorRead(0);
		printf ("speed: %d, count: %d, sensor %d\n", data.speed, data.tachoCnt, data.tachoSensor);
		//motorGetType(MOTOR);

		//motorSetPower(MOTOR, -(s8)data.tachoCnt);
		sleep(1);
		//motorSetSpeed(MOTOR, 10);
	}
	motorStop(MOTOR, 0);
}


void test3()
{
	motorStart(MOTOR);
	motorSetPower(MOTOR, 10);
	sleep(3);
	motorStop(MOTOR, 1);
	motorStop(MOTOR, 0);
}

void test4()
{

}

int main()
{
	if (init() == -1) return -1; 

	// test1();
	test2();

	//motorSetPower(MOTOR, 0);
	//motorStop(MOTOR, 0);

	finish();
	return 0;
}
