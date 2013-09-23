ifndef SEQ_ROOT
abort:
	@ echo "SEQ_ROOT is not defined. Aborting"
endif

BUILD_APP=1

MODULE_ROOT = app
MODULE_PATH = src
MODULE_NAME = app

SRC_SIDL = $(wildcard ../api/*.sidl)
include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/defs.mk

MODULE_DEP += common driver

SRC_S=*.S
SRC_C=*.c
SRC_CC=*.cc

include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/defs.mk
include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/rules.mk
