ifndef SEQ_ROOT
abort:
	@ echo "SEQ_ROOT is not defined. Aborting"
endif

MODULE_ROOT = common
MODULE_PATH = src
MODULE_NAME = common

SRC_SIDL = $(wildcard ../api/*.sidl)
include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/defs.mk

MODULE_DEP += common/exp


SRC_S=*.S
SRC_C=*.c
SRC_CC=*.cc

include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/rules.mk
