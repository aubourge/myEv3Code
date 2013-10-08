#if 0
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
	motorSetPower(MOTOR, 10);
	sleep(1);
	motorSetPower(MOTOR, 20);
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

	int timeOut = 200;

	while(1) {
		motorStart(MOTOR);
	
		data = motorRead(0);
		
		printf ("timeout: %d \tspeed: %d, count: %d, sensor: %d\n", timeOut, data.speed, data.tachoCnt, data.tachoSensor);

		if (data.tachoSensor < -5) {
			motorSetPower(MOTOR, -data.tachoSensor*2);
		} else if (data.tachoSensor > 5) {
			motorSetPower(MOTOR, -data.tachoSensor*2);
		} else {
			motorStop(MOTOR, 0);
		}

		usleep(10000);
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
	sleep(3);
	motorStop(MOTOR, 0);
}

void test4()
{
	// sensor read test

	int _fileRd;
	int *_ibuff;
	int timeOut = 200;

	if((_fileRd = open(ANALOG_DEVICE_NAME, O_RDWR, 0)) == -1)
		return; //Failed to open device
	_ibuff = (int*)mmap(0, 96, PROT_READ | PROT_WRITE, MAP_FILE | MAP_SHARED, _fileRd, 0); 

	while (timeOut--) {
		displayIntArray("Read", _ibuff, 12);
		usleep(100000);
	}
}

int main()
{
	if (init() == -1) return -1; 

int _fileRd;
	//test1();
	//test2();
	//test3();
	test4();

	//motorSetPower(MOTOR, 0);
	//motorStop(MOTOR, 0);

	finish();
	return 0;
}
#else

#include <fcntl.h>
#include <stdio.h>
#include <sys/mman.h>
//#include <sys/os.h>
#include "lms2012.h"
//The ports are designated as PORT_NUMBER-1
const char PORT = 0x0;
const int MAX_SAMPLES  = 100;

int main()
{
	int file;
	UART     *pUart;
	int i;
	//Open the device file
	if((file = open(UART_DEVICE_NAME, O_RDWR | O_SYNC)) == -1) {
		printf("Failed to open device\n");
		return -1;
	}

	pUart  =  (UART*)mmap(0, sizeof(UART), PROT_READ | PROT_WRITE, MAP_FILE | MAP_SHARED, file, 0);
	printf("Device is ready\n");

	if (pUart == MAP_FAILED) {
		printf("Failed to map device\n");
		return -1;
	}

	for(i = 0;i<MAX_SAMPLES;i++) {
		printf("UART Value: %c\n", (char)pUart->Raw[(int)PORT][(int)pUart->Actual[(int)PORT]][0]);
		sleep(1);
	}

	// Close the device file
	printf("Clossing device\n");
	close(file);
	return 0;
}
#endif
