
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include "lms2012.h"
#include "c_output.h"
#include "types.h"
#include "drvMotor.h"
#include "utils.h"


/* === Constants === */
const char MOTOR = 0x1;
const int SPEED = 50;
const int SPEED2 = 100;

/* === Globals === */


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