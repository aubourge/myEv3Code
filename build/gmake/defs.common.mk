#*****************************************************************
#*
#* Module : Definition Library 
#*
#* Purpose: Common rules for gmake build 
#*
#*****************************************************************


# All these variables should be defined:
#   SEQ_CHIP, SEQ_ARCH, SEQ_OS, SEQ_SIMULATION, SEQ_PLATFORM, SEQ_CUSTOM
#   SEQ_TARGET, SEQ_DIR
#



include $(SEQ_BUILD_ROOT)/arch/$(SEQ_ARCH)/defs.mk

BOARD_NAME = $(SEQ_CHIP)$(SEQ_CUSTOM)-$(SEQ_PLATFORM)
BOARD_DIR = $(SEQ_ROOT)/$(SEQ_BSP)/board/$(BOARD_NAME)/arch/$(SEQ_CPU)


#***************************************************************
# Mafefiles variables
#***************************************************************
# ----------------------------------------
# HAL interface mapping
# ----------------------------------------
HAL_CFG_FILE = $(BOARD_DIR)/hal.xml
HAL_MK_FILE = $(SEQ_OBJ)/hal_$(BOARD_NAME)_$(SEQ_CPU).mk

# ----------------------------------------
# ECOS BSP source file list
# ----------------------------------------

ifeq ($(SEQ_OS),eCos)
ECOS_CFG_FILE = $(BOARD_DIR)/ecos.ecc
ECOS_DB_FILE  = $(BOARD_DIR)/ecos.db
ECOS_SRC  = $(filter-out .svn, $(shell $(FIND) $(ECOS_BSP_DIR) -print -name .svn -prune ))
ECOS_SRC += $(ECOS_CFG_FILE) $(ECOS_DB_FILE)
endif

TARGET_OS=QTARGET_OS_LINUX
export TARGET_OS

#***************************************************************
# Compilation flags
#***************************************************************

# ----------------------------------------
# CPP Defines
# ----------------------------------------

SEQ_CHIP_UPPER     := $(call toUpper,$(SEQ_CHIP))
SEQ_ARCH_UPPER     := $(call toUpper,$(SEQ_ARCH))
SEQ_OS_UPPER       := $(call toUpper,$(SEQ_OS))
SEQ_PLATFORM_UPPER := $(call toUpper,$(SEQ_PLATFORM))
SEQ_CPU_UPPER      := $(call toUpper,$(SEQ_CPU))
SEQ_CUSTOM_UPPER   := $(call toUpper,$(SEQ_CUSTOM))

CPP_DEFINES  = -D_REENTRANT
CPP_DEFINES += $(EXTRA_DEFINES)

################################################################
# Default compiler options
################################################################

CPP_DEFINES += -g -Wall -fmessage-length=0

# Defines #####################################################################
CPP_DEFINES += -D_GNU_SOURCE

ifeq ($(SEQ_ANITE),1)
CPP_DEFINES += -DQLOCAL_USE_ANITE_UEAPI
endif

CPP_DEFINES += -DQLOCAL_ENABLE_VIRTUAL_TESTER
CPP_DEFINES += -DQLOCAL_ENABLE_TEST_HARNESS

CPP_DEFINES += -DEMM_NAS_HANDLE_NETWORK_MESSAGES
CPP_DEFINES += -DQLOCAL_ENABLE_BUFFERED_PDCP_RLC_IF

#CPP_DEFINES += -DQLOCAL_ENABLE_BYPASS_INTEGRITY

ifneq ($(SEQ_PLATFORM),)
CPP_DEFINES += -DSEQ_PLATFORM_$(subst -,_,$(SEQ_PLATFORM_UPPER))
endif

ifneq ($(SEQ_CPU),)
CPP_DEFINES += -DSEQ_CPU_$(subst -,_,$(SEQ_CPU_UPPER))
endif

ifneq ($(SEQ_CUSTOM),)
CPP_DEFINES += -DSEQ_CUSTOM_$(subst -,_,$(SEQ_CUSTOM_UPPER))
endif

ifeq ($(SEQ_THP),1)
CPP_DEFINES += -DSQN_THP=1
endif

ifeq ($(SEQ_CLI),1)
CPP_DEFINES += -DSQN_CLI=1
endif

ifeq ($(DEBUG),1)
# SQN_DEBUG turns off inlining, and may have other effects
CPP_DEFINES += -DSQN_DEBUG=1
endif

# SEQ_INTEGRATION allows to comment out piece of codes during integration
# without affecting the nightly build on linux
ifneq ($(SEQ_INTEGRATION),)
CPP_DEFINES += -DSQN_INTEGRATION=1
endif

# Add command line to toggle use of zsp for fast scanning (else spu is used)
ifeq ($(USE_ZSP_FASTSCAN),1)
CPP_DEFINES += -DSQN_USE_ZSP_FASTSCAN
endif

# Add command line to toggle use of rohc
#ifeq ($(USE_ROHC),1)
CPP_DEFINES += -DSQN_USE_ROHC
#endif

# Add command line to toggle use of rohc
ifeq ($(USE_USE_SCANTOOL),1)
CPP_DEFINES += -DSQN_USE_SCANTOOL
endif


# NOT SIMULATION -------------------------
ifneq ($(SEQ_SIMULATION), 1)
CPP_DEFINES += -DSQN_NEW_IRQ_SCHEME
endif

# SIMULATION -----------------------------
ifeq ($(SEQ_SIMULATION), 1)
CPP_DEFINES += -DSQN_SIMULATION=1
CPP_DEFINES += -DQTARGET_OS_LINUX=1
CPP_DEFINES += -DSIM_USER_TASKS
CPP_DEFINES += -DSMS_NAS_HANDLE_NETWORK_MESSAGES
CPP_DEFINES += -DQLOCAL_ENABLE_VT_IP_ADDR
CPP_DEFINES += -DQLOCAL_ENABLE_EXTERNAL_TIMER_CONTROL
ifeq ($(USE_ANITE_R10), 1)
CPP_DEFINES += -DSQN_ANITE_R10
endif

	# ACCURATE SIMULATION --------------------
ifeq ($(ACCURATE_SIM), 1)
CPP_DEFINES += -DUSE_ACCURATE_SIMULATOR
endif

	# NOT ACCURATE SIMULATION ----------------
ifneq ($(ACCURATE_SIM), 1)
CPP_DEFINES += -DQVT_USE_QKI_DEBUG
CPP_DEFINES += -DSPU_SYNCHRO=1
endif
endif

# CPU=SIM --------------------------------
ifeq ($(SEQ_CPU), sim)
CPP_DEFINES += -DQTARGET_SIM_MAIN=1
endif # end sim

# CPU=PSP --------------------------------
ifeq ($(SEQ_CPU), psp)
CPP_DEFINES += -DQTARGET_PPS=1
endif # end psp

# CPU=L1P --------------------------------
ifeq ($(SEQ_CPU), l1p) 
CPP_DEFINES += -DQTARGET_L1_RPU=1
CPP_DEFINES += -DSPU_SYNCHRO
endif # end l1p

# CPU=SPU --------------------------------
ifeq ($(SEQ_CPU), spupotdet)
CPP_DEFINES +=-DQTARTGET_SPUPOTDET=1
CPP_DEFINES +=-DMICROCODE=1
endif
# ----------------------------------------
# Compilation options
# ----------------------------------------

CPP_OPT ?=
CC_FLAGS += --std=gnu99

# Optimization
CPP_OPT += -O$(OPTIM)

ifeq ($(SEQ_SIMULATION),1)

# Force debug mode in simulation unless it is no required by user
ifneq ($(DEBUG),0)
CPP_OPT += -g
endif

else

# Release compilation: never put debug information into a release
ifeq ($(DEBUG),1)
ifndef RELEASE
ifndef SEQ_LIB_NO_DEBUG
CPP_OPT += -g
endif
endif
endif

endif

# ----------------------------------------
# OS dependent defines
# ----------------------------------------
# eCos
ifeq ($(SEQ_OS),eCos)
CCC_FLAGS += -fweak
CCC_FLAGS += -D_CLOCK_T_='unsigned long' # workaround
CPP_INC   += -I$(ECOS_OBJ_DIR)/install/include 

ifdef BUILD_APP
include $(ECOS_OBJ_DIR)/install/include/pkgconf/ecos.mak
endif
endif

# ----------------------------------------
# Platform dependant includes
# ----------------------------------------

CPP_INC   += -I$(SEQ_ROOT)/$(SEQ_BSP)/board/arch/$(SEQ_CPU)/$(SEQ_CHIP)$(SEQ_CUSTOM)-$(SEQ_PLATFORM)/

# ----------------------------------------
# Compilation flags
# ----------------------------------------

CPP_CPU ?=
CPP_FLAGS  = $(CPP_INC) $(CPP_CPU) $(CPP_OS) $(CPP_DEFINES) $(CPP_OPT)


CC_FLAGS  += $(CPP_FLAGS) -Wall -Werror-implicit-function-declaration -Wno-unused 
CCC_FLAGS += $(CPP_FLAGS) -Wall 

ifeq ($(SEQ_OS),eCos)
# use of -include to simply ignore absence of ecos.mak before eCos was built
-include $(ECOS_MAK)
CC_FLAGS += $(filter-out -Woverloaded-virtual, $(filter-out -fno-rtti, $(ECOS_GLOBAL_CFLAGS)))
CCC_FLAGS += $(filter-out -Wstrict-prototypes, $(ECOS_GLOBAL_CFLAGS))
endif

# ----------------------------------------
# Link flags
# ----------------------------------------

# Include path for libraries
LD_PATH = $(patsubst %,-L%,$(LIBPATH))

LD_FLAGS ?=
ifeq ($(SEQ_OS),eCos)
LD_FLAGS += $(ECOS_GLOBAL_LDFLAGS)
endif

ifneq ($(SEQ_LINKERSCRIPT),)
LD_FLAGS += -T$(SEQ_LINKERSCRIPT)
endif

# Define loadable state of the build application
ifeq ($(findstring $(SEQ_OS),linuxDes cygwinDes eCos),$(SEQ_OS))
SEQ_BUILD_LOADBLE_OBJECT = 0
else
SEQ_BUILD_LOADBLE_OBJECT = 1
endif

#***************************************************************
# External Libraries
#***************************************************************

TGT_DEFAULT_EXTERNAL_LIBS ?=

# ----------------------------------------
# THP
# ----------------------------------------

ifneq ($(THP_SVR_CC_OBJ),) 
CPP_INC += -I$(THP_SVR_CC_OBJ)
endif

ifeq ($(SEQ_GCCXML), 1)
THP_GCCXML_DEFINES = $(CPP_DEFINES) -D__arm__ -D __i386__
endif


#***************************************************************
# Paths to compilation chain tools
#***************************************************************

DOXYGEN = doxygen
MKDIR   = mkdir
LN      = ln
MV      = mv
ENV     = env
CP      = cp
MUNCH   = munch
FIND    = find
SED     = sed

ifeq ($(SEQ_HOST),windows32)
MUNCH  = munch.bat
FIND   = find.exe
SED    = sed.exe
endif

# SIDL Compiler Kit
SIDL_CK = $(SEQ_ROOT)/etc/tools/sidlck.py

#***************************************************************
# Make related definitions
#***************************************************************

# Reset suffix rules to strictly match those we do use 
.SUFFIXES:            
#.SUFFIXES: .cc .c .o .h .idl 

# Mark internal rules as such
.PHONY: build test check fullcheck clean realclean
.PHONY: build_lib build_subdirs test_subdirs chech_subdirs realclean_subdirs
.PHONY: build_test check_test clean_test realclean_test
.PHONY: build_lib

# Resetting built-in rules
%   : %,v
%   : RCS/%
%   : RCS/%,v
%   : s.%
%   : SCCS/s.%
%.o : %.cc
%.o : %.c
%.o : %.w

