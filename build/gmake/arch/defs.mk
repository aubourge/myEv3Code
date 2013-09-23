#*****************************************************************
#*
#* Module : ARM
#* Purpose: Definitions
#*
#*****************************************************************
#*
#*  Copyright (c) 2009 SEQUANS Communications.
#*  All rights reserved.
#*  
#*  This is confidential and proprietary source code of SEQUANS
#*  Communications. The use of the present source code and all
#*  its derived forms is exclusively governed by the restricted
#*  terms and conditions set forth in the SEQUANS
#*  Communications' EARLY ADOPTER AGREEMENT and/or LICENCE
#*  AGREEMENT. The present source code and all its derived
#*  forms can ONLY and EXCLUSIVELY be used with SEQUANS
#*  Communications' products. The distribution/sale of the
#*  present source code and all its derived forms is EXCLUSIVELY
#*  RESERVED to regular LICENCE holder and otherwise STRICTLY
#*  PROHIBITED.
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
LD_FLAGS += $(foreach f,$(TEST_STUBS),-wrap $(f)) -EB
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


