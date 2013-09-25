#*****************************************************************
#*
#* Module : ARM
#* Purpose: Definitions
#*
#*****************************************************************


#***************************************************************
# Makefile variables
#***************************************************************

#***************************************************************
# Compilation flags
#***************************************************************
CPP_OPT += -msoft-float

CC_FLAGS  += $(CPP_FLAGS) -Wall -Werror-implicit-function-declaration -Wno-unused 
CC_FLAGS += -mstructure-size-boundary=8
CC_FLAGS += -fgnu89-inline
CCC_FLAGS += $(CPP_FLAGS) -Wall -mstructure-size-boundary=8
LD_FLAGS += $(foreach f,$(TEST_STUBS),-wrap $(f))
CPP_OS+=-DSQN_BYTE_BIG_ENDIAN

#***************************************************************
# Paths to compilation chain tools
#***************************************************************
AR     = arm-none-linux-gnueabi-ar
RANLIB = arm-none-linux-gnueabi-ranlib
CC     = arm-none-linux-gnueabi-gcc
CCC    = arm-none-linux-gnueabi-g++
LD     = arm-none-linux-gnueabi-ld
NM     = arm-none-linux-gnueabi-nm
OBJDMP = arm-none-linux-gnueabi-objdump
OBJCPY = arm-none-linux-gnueabi-objcopy
STRIP  = arm-none-linux-gnueabi-strip


