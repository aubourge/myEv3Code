#include <fcntl.h>
#include "exp/lms2012.h"

// Motor power 0..100
const int SPEED = 50;
// The motor operations use a single bit (or a combination of them)
// to determine which motor(s) will be used
// A = 0×1, B = 0×2, C = 0×4, D = 0×8
// AC = 0×5
const char MOTOR = 0x1;

int main()
{
	char motor_command[5];
	int file;

	//Open the device file
	if((file = open(PWM_DEVICE_NAME, O_WRONLY)) == -1)
		return -1; //Failed to open device

	// For most operations, the second byte represent the motor(s)
	motor_command[1] = MOTOR;

	// Start the motor
	motor_command[0] = opOUTPUT_START;
	write(file,motor_command,2);

	// Set the motor power
	motor_command[0] = opOUTPUT_POWER;
	motor_command[2] = SPEED;
	write(file,motor_command,3);

	// Run the motor for a couple of seconds
	sleep(2);

	// Stops the motor
	motor_command[0] = opOUTPUT_STOP;
	motor_command[1] = MOTOR;
	write(file,motor_command,2);

	// Close the device file
	close(file);
return 0;
}
