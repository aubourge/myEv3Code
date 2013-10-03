#ifndef DRV_SENSOR_H
#define DRV_SENSOR_H

#include "types.h"
// Constants

const int PORTS = 4;

const int CONN_UNKNOWN    = 111;  //!< Connection is fake (test)
const int CONN_DAISYCHAIN = 117;  //!< Connection is daisy chained
const int CONN_NXT_COLOR  = 118;  //!< Connection type is NXT color sensor
const int CONN_NXT_DUMB   = 119;  //!< Connection type is NXT analog sensor
const int CONN_NXT_IIC    = 120;  //!< Connection type is NXT IIC sensor
const int CONN_INPUT_DUMB = 121;  //!< Connection type is LMS2012 input device with ID resistor
const int CONN_INPUT_UART = 122;  //!< Connection type is LMS2012 UART sensor
const int CONN_OUTPUT_DUMB= 123;  //!< Connection type is LMS2012 output device with ID resistor^
const int CONN_OUTPUT_INTELLIGENT= 124;  //!< Connection type is LMS2012 output device with communication
const int CONN_OUTPUT_TACHO = 125;  //!< Connection type is LMS2012 tacho motor with series ID resistance
const int CONN_NONE       = 126;  //!< Port empty or not available
const int CONN_ERROR      = 127;  //!< Port not empty and type is invalid^M

const int TYPE_NXT_TOUCH                =   1;  //!< Device is NXT touch sensor
const int TYPE_NXT_LIGHT                =   2;  //!< Device is NXT light sensor
const int TYPE_NXT_SOUND                =   3;  //!< Device is NXT sound sensor
const int TYPE_NXT_COLOR                =   4;  //!< Device is NXT color sensor
const int TYPE_TACHO                    =   7;  //!< Device is a tacho motor
const int TYPE_MINITACHO                =   8;  //!< Device is a mini tacho motor
const int TYPE_NEWTACHO                 =   9;  //!< Device is a new tacho motor
const int TYPE_THIRD_PARTY_START        =  50;
const int TYPE_THIRD_PARTY_END          =  99;
const int TYPE_IIC_UNKNOWN              = 100;
const int TYPE_NXT_TEST                 = 101;  //!< Device is a NXT ADC test sensor
const int TYPE_NXT_IIC                  = 123;  //!< Device is NXT IIC sensor
const int TYPE_TERMINAL                 = 124;  //!< Port is connected to a terminal
const int TYPE_UNKNOWN                  = 125;  //!< Port not empty but type has not been determined
const int TYPE_NONE                     = 126;  //!< Port empty or not available
const int TYPE_ERROR                    = 127;  //!< Port not empty and type is invalid


const int UART_MAX_MODES = 8;
const int MAX_DEVICE_DATALENGTH = 32;
const int IIC_DATA_LENGTH = 32;
const int OK = 0;
const int BUSY = 1;
const int FAIL = 2;
const int STOP = 4;

const u8 CMD_NONE = (u8)'-';
const u8 CMD_FLOAT = (u8)'f';
const u8 CMD_SET = (u8)'0';
const u8 CMD_COL_COL = 0xd;
const u8 CMD_COL_RED = 0xe;
const u8 CMD_COL_GRN = 0xf;
const u8 CMD_COL_BLU = 0x11;
const u8 CMD_COL_AMB = 0x12;
const u8 CMD_PIN1 = 0x1;
const u8 CMD_PIN5 = 0x2;

const int ADC_REF = 5000; // 5.0 Volts
const int ADC_RES = 4095;

#endif // DRV_SENSOR_H
