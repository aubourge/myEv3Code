#ifndef DRV_SENSOR_CST_H
#define DRV_SENSOR_CST_H

	/**
     * Colors used as the output value when in full mode. Values are
     * compatible with LEGO firmware.
     */
enum sensorColor {
    BLACK = 1,
    BLUE = 2,
    GREEN = 3,
    YELLOW = 4,
    RED = 5,
    WHITE = 6,
};

enum sensorRawColorIdx {
    /** Color sensor data RED value index. */
    RED_INDEX = 0,
    /** Color sensor data GREEN value index. */
    GREEN_INDEX = 1,
    /** Color sensor data BLUE value index. */
    BLUE_INDEX = 2,
    /** Color sensor data BLANK/Background value index. */
    BLANK_INDEX = 3,
};
	
enum sensorType{
	TYPE_NO_SENSOR = 0,
	TYPE_SWITCH = 1,
	TYPE_TEMPERATURE = 2,
	TYPE_REFLECTION = 3,
	TYPE_ANGLE = 4,
	TYPE_LIGHT_ACTIVE = 5,
	TYPE_LIGHT_INACTIVE = 6,
	TYPE_SOUND_DB = 7,
	TYPE_SOUND_DBA = 8,
	TYPE_CUSTOM = 9,
	TYPE_LOWSPEED = 10,
	TYPE_LOWSPEED_9V = 11,
    TYPE_HISPEED = 12,
    TYPE_COLORFULL = 13,
    TYPE_COLORRED = 14,
    TYPE_COLORGREEN = 15,
    TYPE_COLORBLUE = 16,
    TYPE_COLORNONE = 17,
    
    MIN_TYPE = 0,
    MAX_TYPE = 17,
};

enum sensorMode{
	MODE_RAW = 0x00,
	MODE_BOOLEAN = 0x20,
	MODE_TRANSITIONCNT = 0x40,
	MODE_PERIODCOUNTER = 0x60,
	MODE_PCTFULLSCALE = 0x80,
	MODE_CELSIUS = 0xA0,
	MODE_FARENHEIT = 0xC0,
	MODE_ANGLESTEP = 0xE0,
};

/** MAX value returned as a RAW sensor reading for standard A/D sensors */
const int MAX_AD_RAW = 1023;

#endif //DRV_SENSOR_CST_H
