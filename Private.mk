#*****************************************************************
#*
#* This makefile handles the SEQUANS private part of the source
#* tree only. In other words, it handles everything but the
#* content of the "delivery" directory.
#*
#*****************************************************************
#*
#*  Copyright (c) 2004 SEQUANS Communications.
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

ifdef SEQ_ROOT
include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/defs.mk
else
abort:
	@ echo "SEQ_ROOT is not defined. Aborting"
endif

SUBDIRS  = common driver app

include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/rules.mk

