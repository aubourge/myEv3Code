


void drvUartInit(uartPort port)
{
	setMode(port, 0);
}

void setMode(uartPort port, u8 mode)
{
	ioctl(UARST_SET_CONN, devCon(port, CONN_INPUT_UART, 0, mode)
	_mode[port] = mode;
}

void ioctl()


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
