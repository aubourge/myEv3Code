#ifndef DRV_MOTOR_H
#define DRV_MOTOR_H

#include "types.h"

enum motorId {
	MOTOR_A = 0x1,
	MOTOR_B = 0x2,
	MOTOR_C = 0x4,
	MOTOR_D = 0x8,
};

struct motorReadData {
	int tachoCnt;
	int speed;
	int tachoSensor;
};

int init();
void finish();
void motorStart(char portMap);
void motorResetRef(char portMap);
void motorSetPos(char portMap, int position);
void motorSetPower(char portMap, s8 power);
void motorSetSpeed(char portMap, s8 speed);
void motorStop(char portMap, u8 brake);
u8 motorGetType(char portMap);
struct motorReadData motorRead(int port);


#endif //DRV_MOTOR_H
