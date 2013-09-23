ifdef SEQ_ROOT
include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/defs.mk
else
abort:
	@ echo "SEQ_ROOT is not defined. Aborting"
endif

SUBDIRS  = common driver app

include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/rules.mk

