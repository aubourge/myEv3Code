#*****************************************************************
#*
#* Module : Definition Library 
#*
#* Purpose: Common rules for gmake build 
#*
#*****************************************************************

ifndef SEQ_ROOT
$(error "SEQ_ROOT is not defined. Aborting")
endif

SEQ_GMAKE_ROOT=$(SEQ_ROOT)/$(SEQ_BUILD)/
SEQ_BUILD_ROOT=$(SEQ_GMAKE_ROOT)/gmake

#***************************************************************
# Project configuration
#***************************************************************

TARGET_OS=QTARGET_OS_LINUX

# optimization level. Some warnings are only enabled when optimization
# is on (better code analysis), and gdb can still debug optimized code.
# So we optimize by default.
#OPTIM=2

## GCC XML enabled by default
#SEQ_GCCXML=1

## TCP/IP stack enabled by default
#SEQ_TCPIP=1

## Include configuration makefile
#include $(SEQ_BUILD_ROOT)/defs.cfg.mk

SEQ_CLI=1

#***************************************************************
# OS paths
#***************************************************************

## By default, environment is set automatically
SEQ_BUILD_ENV_ALREADY_SET=0

#***************************************************************
# Path definitions
#***************************************************************

include $(SEQ_BUILD_ROOT)/defs.path.mk

#***************************************************************
# Compilation chain definitions
#***************************************************************

include $(SEQ_BUILD_ROOT)/defs.common.mk


