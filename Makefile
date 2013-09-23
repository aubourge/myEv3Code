#*****************************************************************
#*
#* Module : Top Level Makefile
#*
#* Purpose: Handle the coordination between the private and delivery
#*          parts of the tree. This is where the sequencing between
#*          private and delivery macro-actions is made.
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


# set some default directories
ifndef SEQ_BUILD
export SEQ_BUILD = build
endif

ifdef SEQ_ROOT
include $(SEQ_ROOT)/$(SEQ_BUILD)/gmake/defs.mk
else
abort:
	@ echo "SEQ_ROOT is not defined. Aborting"
endif


# Build: only build the main source (no test compilation)
build: 
	@ echo "[$(CPU)] Building modules..."
	$(MAKE) -f Private.mk build

fw:
	@ echo "Building firmware..."
	$(MAKE) -f Private.mk fw


.PHONY: clean realclean realclean_doxygen clean_doxygen tags ctags etags docs clean_os_lib

clean: clean_doxygen clean_tags
	$(MAKE) -f Private.mk clean

tags etags ctags cscope clean_tags:
	$(MAKE) -f Private.mk $@

