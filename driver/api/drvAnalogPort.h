#ifndef DRV_ANALOG_PORT_H
#define DRV_ANALOG_PORT_H

#include "types.h"


void initDeviceIO();


u8 getInConn(int port);
u8 getInDcm(int port);
u16 getShort(int offset);
u16 getPin1(int port);
u16 getPin6(int port);
void setPinMode(int port, int mode);
int getPortType(int port);
int getAnalogSensorType(int port);
bool_t setType(int port, int type);

#endif //DRV_ANALOG_PORT_H
