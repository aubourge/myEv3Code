#*****************************************************************
#*
#* Module : Rules Library 
#*
#* Purpose: Dependencies rules for gmake build 
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
