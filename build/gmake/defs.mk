#*****************************************************************
#*
#* Module : Definition Library 
#*
#* Purpose: Common rules for gmake build 
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


