#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include "types.h"
#include "utils.h"
#include "drvSensor.h"
#include "drvSensorCst.h"
#include "drvAnalogPort.h"

const int ANALOG_SIZE = 5172;
const int ANALOG_PIN1_OFF = 0;
const int ANALOG_PIN6_OFF = 8;
const int ANALOG_PIN5_OFF = 16;
const int ANALOG_BAT_TEMP_OFF = 24;
const int ANALOG_MOTOR_CUR_OFF = 26;
const int ANALOG_BAT_CUR_OFF = 28;
const int ANALOG_BAT_V_OFF = 30;
const int ANALOG_INDCM_OFF = 5156;
const int ANALOG_INCONN_OFF = 5160;
 // Pointer pAnalog;
 // ByteBuffer inDcm;
 // ByteBuffer inConn;
 // ByteBuffer shortVals;


/* Handlers */
int _lms_analog_file;
u8 * _lms_analog_buffer;
int _lms_dcm_file;

void initDeviceIO()
{
	/* LMS_ANALOG */
	_lms_analog_file = open("/dev/lms_analog", O_RDWR, 0);
	_lms_analog_buffer = (u8*)mmap(0, ANALOG_SIZE, PROT_READ | PROT_WRITE, MAP_FILE | MAP_SHARED, _lms_analog_file, 0);

	/*
	pAnalog = dev.mmap(ANALOG_SIZE);
	inDcm = pAnalog.getByteBuffer(ANALOG_INDCM_OFF, PORTS);
	inConn = pAnalog.getByteBuffer(ANALOG_INCONN_OFF, PORTS);
	shortVals = pAnalog.getByteBuffer(0, ANALOG_BAT_V_OFF+2);
*/
	/* LMS_DCM */
	_lms_dcm_file = open("/dev/lms_dcm", O_RDWR, 0);
}

u8 getInConn(int port)
{
	return _lms_analog_buffer[ANALOG_INCONN_OFF+port];
}

u8 getInDcm(int port)
{
	return (u8)(_lms_analog_buffer[ANALOG_INDCM_OFF+port]);
}

u16 getShort(int offset)
{
	return (u16)(_lms_analog_buffer[offset] + (_lms_analog_buffer[offset+1] << 8));
}

u16 getPin1(int port)
{
	return getShort(ANALOG_PIN1_OFF + port*2);
}

u16 getPin6(int port)
{
	return getShort(ANALOG_PIN6_OFF + port*2);
}
   
void setPinMode(int port, int mode)
{
	u8 modes[PORTS];
	for (int i=0; i < PORTS; i++) {
		modes[i] = (u8)('-');
	}
	modes[port] = (u8)mode;
	write(_lms_dcm_file, modes, PORTS);
}

int getPortType(int port)
{
	if (port > PORTS || port < 0)
		return CONN_ERROR;
	return (int)getInConn(port);
}

int getAnalogSensorType(int port)
{
	if (port > PORTS || port < 0)
		return CONN_ERROR;
	return (int)getInDcm(port);
}

bool_t setType(int port, int type)
    {
        switch(type)
        {
        case TYPE_NO_SENSOR:
        case TYPE_SWITCH:
        case TYPE_TEMPERATURE:
        case TYPE_CUSTOM:
        case TYPE_ANGLE:
            setPinMode(port, CMD_FLOAT);
            break;
        case TYPE_LIGHT_ACTIVE:
        case TYPE_SOUND_DBA:            
        case TYPE_REFLECTION:
            setPinMode(port, CMD_SET|CMD_PIN5);
            break;
        case TYPE_LIGHT_INACTIVE:
        case TYPE_SOUND_DB: 
            setPinMode(port, CMD_SET);
            break;
        case TYPE_LOWSPEED:
            setPinMode(port, CMD_SET);
            break;
        case TYPE_LOWSPEED_9V:
            setPinMode(port, CMD_SET|CMD_PIN1);
            break;
        default:
			return FALSE;
        }
        return TRUE;
    }
