#*****************************************************************
#*
#* Module : Rules Library 
#*
#* Purpose: Dependencies rules for gmake build 
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

# ---------------------------------------------------
# Dependencies construction parameters
# ---------------------------------------------------

TESTDEPS_TARGETS=test check
INCLUDE_TESTDEPS=$(strip $(filter $(TESTDEPS_TARGETS),$(MAKECMDGOALS)))

DEPEND_SOURCES:=$(strip $(notdir $(LIB_SRC_CC) $(LIB_SRC_C)))
ifeq ($(INCLUDE_TESTDEPS),)
DEPEND_SOURCES+=$(strip $(TEST_CC) $(TEST_C))
endif


# ----------------------------------
# Dependencies inclusion
#
# (This inclusion trigger the generation of
#  the included file if not already available)
# ----------------------------------

# don't build/include dependencies when cleaning
ifeq ($(findstring clean,$(MAKECMDGOALS)),clean)
NODEP=1
endif

# don't build/include dependencies when creating thp files
ifeq ($(findstring thp,$(MAKECMDGOALS)),thp)
NODEP=1
endif

# don't build/include dependencies when creating r6 files
ifeq ($(findstring r6,$(MAKECMDGOALS)),r6)
NODEP=1
endif

# don't build/include dependencies when printing debug variable
ifeq ($(findstring print-,$(MAKECMDGOALS)),print-)
NODEP=1
endif

# don't build/include dependencies when printing debug variable
ifeq ($(findstring debug,$(MAKECMDGOALS)),debug)
NODEP=1
endif

ifeq ($(DEPEND_SOURCES),)
NODEP=1
endif

ifeq ($(NODEP),)
DEP_FILES := $(addprefix $(OBJ_DIR)/,$(patsubst %.cpp,%.o.d,$(patsubst %.cc,%.o.d,$(DEPEND_SOURCES:.c=.o.d))))
-include $(DEP_FILES)
endif
