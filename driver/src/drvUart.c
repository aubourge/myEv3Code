#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include "drvSensor.h"
#include "drvAnalogPort.h"
#include "types.h"
#include "lms2012.h"

int _mode[PORTS];
u8 _devConnection[3*PORTS];
bool_t drvUartInit = LEGO_FALSE;

void drvUartInit()
{
	memset(_devConnection, 0, PORTS*sizeof(u8)):
	_drvUartInitialized = LEGO_TRUE;
}

void setMode(int port, u8 mode)
{
	if (_drvUartInitialized == LEGO_FALSE) {
		printf("Errror: UART driver not iniitalized\n");
		return;
	}

	devCon(port, CONN_INPUT_UART, 0, mode);	
	ioctl(UART_SET_CONN, _devConnection);
	// cache modes
	_mode[port] = mode;
}


void drvUartInit(int port)
{
	setMode(port, 0);
}


#if 0
void initSensor()
{
	// Set pin configuration and power for standard i2c sensor.
	DeviceManager.getLocalDeviceManager().setPortMode(port, CMD_FLOAT);
	reset();
	usleep(100000);
	i2c.ioctl(IIC_SET_CONN, devCon(port, CONN_NXT_IIC, typ, mode));        
	usleep(100000);
	i2c.ioctl(IIC_SET_CONN, devCon(port, CONN_NXT_IIC, typ, mode));        
	usleep(100000);
}

_devFile = new NativeDevice("/dev/lms_dcm");


void setPortMode(int port, int mode)
{
	u8 modes[PORTS];
	for(int i = 0; i < LENGTH; i++)
		modes[i] = (byte)'-';
	modes[port] = (byte)mode;
	write(_devFile, modes, modes.length);
}
#endif
