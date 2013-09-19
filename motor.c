#include <fcntl.h>
#include <stdio.h>
#include "exp/lms2012.h"

// Motor power 0..100
const int SPEED = 50;
const int SPEED2 = 100;
// The motor operations use a single bit (or a combination of them)
// to determine which motor(s) will be used
// A = 0×1, B = 0×2, C = 0×4, D = 0×8
// AC = 0×5
const char MOTOR = 0x1;

void displayArray(char* name, char* data, int length) 
{
	printf ("%s ", name);
	int i;
	for (i=0; i < length; i++) {
		printf("%x", data[i]);
	}
	printf("\n");
}

int main()
{
	char motor_command[6];
	char motor_readBack[6];
	int file;
	int file2;

	//Open the device file
	if((file = open(PWM_DEVICE_NAME, O_RDWR)) == -1)
		return -1; //Failed to open device


	// For most operations, the second byte represent the motor(s)
	motor_command[1] = MOTOR;

	// Start the motor
	printf("command: opOUTPUT_START\n");
	motor_command[0] = opOUTPUT_START;
	write(file,motor_command,2);

	sleep(2);

	// Attempt to read motor parameters
	printf("command: opOUTPUT_READ\n");
	motor_command[0] = opOUTPUT_READ;
	motor_command[1] = MOTOR;
	write(file, motor_command, 2);
	read(file, motor_readBack, 6);
	
	displayArray("Read", motor_readBack, 6);

	sleep(2);


	// Set the motor power
	printf("command: opOUTPUT_POWER\n");
	motor_command[0] = opOUTPUT_POWER;
	motor_command[2] = SPEED;
	write(file, motor_command, 3);
	read(file, motor_readBack, 6);

	displayArray("Write", motor_command, 6);
	displayArray("Read", motor_readBack, 6);

	sleep(2);

	// Set the motor power
	printf("command: opOUTPUT_POWER\n");
	motor_command[0] = opOUTPUT_POWER;
	motor_command[2] = SPEED2;
	write(file, motor_command, 3);
	read(file, motor_readBack, 6);

	displayArray("Write", motor_command, 6);
	displayArray("Read", motor_readBack, 6);

	sleep(2);

	// Stops the motor
	printf("command: opOUTPUT_STOP\n");
	motor_command[0] = opOUTPUT_STOP;
	motor_command[1] = MOTOR;
	write(file,motor_command,2);

	displayArray("Write", motor_command, 6);
	// Close the device file
	close(file);
return 0;
}
