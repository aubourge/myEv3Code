int getPortType(int port)
{
	if (port > PORTS || port < 0)
		return CONN_ERROR;
	return inConn.get(port)
}



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
Pointer pAnalog;
ByteBuffer inDcm;
ByteBuffer inConn;
ByteBuffer shortVals;



int _lms_analog_file;
u8 * _lms_analog_buffer;
int * _

void initDeviceIO()
{
	_lms_analog_file = open("/dev/lms_analog", O_RDWR, 0);
	_lms_analog_buffer = (u8*)mmap(0, ANALOG_SIZE, PROT_READ | PROT_WRITE, MAP_FILE | MAP_SHARED, _lms_analog_file, 0);

	pAnalog = dev.mmap(ANALOG_SIZE);
	inDcm = pAnalog.getByteBuffer(ANALOG_INDCM_OFF, PORTS);
	inConn = pAnalog.getByteBuffer(ANALOG_INCONN_OFF, PORTS);
	shortVals = pAnalog.getByteBuffer(0, ANALOG_BAT_V_OFF+2);
}

u8 getInConn(int port)
{
	return _lms_analog_buffer[ANALOG_INCONN_OFF+port];
}

u8 getInDcm(int port)
{
	return _lms_analog_buffer[ANALOG_INDCM_OFF+port];
}

u16 getShort(int offset)
{
	return _lms_analog_buffer[offset] + _lms_analog_buffer[offset+1] << 8;
}

u16 getPin1(int port)
{
	return getShort(ANALOG_PIN1_OFF + port*2);
}

u16 getPin6(int port)
{
	return getShort(ANALOG_PIN6_OFF + port*2);
}
   

bool setType(int type)
    {
        switch(type)
        {
        case TYPE_NO_SENSOR:
        case TYPE_SWITCH:
        case TYPE_TEMPERATURE:
        case TYPE_CUSTOM:
        case TYPE_ANGLE:
            setPinMode(CMD_FLOAT);
            break;
        case TYPE_LIGHT_ACTIVE:
        case TYPE_SOUND_DBA:            
        case TYPE_REFLECTION:
            setPinMode(CMD_SET|CMD_PIN5);
            break;
        case TYPE_LIGHT_INACTIVE:
        case TYPE_SOUND_DB: 
            setPinMode(CMD_SET);
            break;
        case TYPE_LOWSPEED:
            setPinMode(CMD_SET);
            break;
        case TYPE_LOWSPEED_9V:
            setPinMode(CMD_SET|CMD_PIN1);
            break;
        default:
            throw new UnsupportedOperationException("Unrecognised sensor type");
        }
        return true;
    }
