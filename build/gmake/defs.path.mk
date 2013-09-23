#***************************************************************
# Release specific include and paths
#***************************************************************

# ----------------------------------------
# Path definitions
# ----------------------------------------

ifeq ($(SEQ_OBJ),)
SEQ_OBJ=$(SEQ_ROOT)/obj
endif

TGT_OBJ=$(SEQ_OBJ)/$(SEQ_DIR)

EXP_DIR  =$(SEQ_ROOT)/$(MODULE_ROOT)/api 
EXP_DIR +=$(SEQ_ROOT)/$(MODULE_ROOT)/_output/include
EXP_DIR_OBJ=$(TGT_OBJ)/$(MODULE_ROOT)/api

SRC_DIR=$(SEQ_ROOT)/$(MODULE_ROOT)/$(MODULE_PATH)
OBJ_DIR=$(TGT_OBJ)/$(MODULE_ROOT)/$(MODULE_PATH)$(PLA_SUFFIX)$(CUSTOM_SUFFIX)
OBJ_DIR_GENERATED=$(SEQ_OBJ)/$(SEQ_DIR_GENERATED)/$(MODULE_ROOT)/$(MODULE_PATH)$(PLA_SUFFIX)$(CUSTOM_SUFFIX)
#OBJ_DIR_GENERATED=$(SEQ_OBJ)/$(SEQ_DIR_GENERATED)/$(MODULE_ROOT)/$(MODULE_PATH)

# Required to make the .def file work in delivery space (typically in devkit)
LIB_DIR=$(TGT_OBJ)/lib$(PLA_SUFFIX)$(CUSTOM_SUFFIX)
KEEP_DIR=$(TGT_OBJ)/keep$(PLA_SUFFIX)$(CUSTOM_SUFFIX)
SEQ_LIBS=$(TGT_OBJ)/lib/$(SEQ_CPU)
SEQ_PLA_LIBS=$(SEQ_LIBS)

# library paths
ifdef SEQ_CUSTOM
LIBPATH  = $(SEQ_LIBS)$(CUSTOM_SUFFIX) $(SEQ_PLA_LIBS)$(CUSTOM_SUFFIX)
endif
LIBPATH += $(SEQ_LIBS) $(SEQ_PLA_LIBS)

ifeq ($(SEQ_OS), eCos)
LIBPATH += $(ECOS_OBJ_DIR)/install/lib
endif

# Test directories
TEST_OBJ_DIR = $(OBJ_DIR)
TESTAPP	= $(OBJ_DIR)/test$(MODULE_NAME)$(TEST_NAME)

# For automatically generated documentation using Doxygen
DOXYGEN_DIR = $(SEQ_OBJ)/doxydocs/core/api
DOXYGEN_THP_DIR = $(SEQ_OBJ)/doxydocs/core/thp

# X509 Certificates repository
SEQ_CERTS=$(SEQ_ROOT)/common/certs

# Packages
PACKAGE_DIR  = $(SEQ_ROOT)/$(SEQ_BUILD)/package
PACKAGE_TOOL = $(PACKAGE_DIR)/package.py

# Make delivery configuration visible to the delivery Makefile
export SEQ_LIBS

# ----------------------------------------------------------------------------
# SIDL generated file lists construction functions
# ----------------------------------------------------------------------------

# Get list of generated msg header from THP file
getThpMsgHeaderFiles = $(strip \
    $(eval _Api := $(basename $1)) \
    $(addsuffix Msg.h,$(_Api)))
#    $(addsuffix Msg.sniff,$(_Api)))

# Get list of generated server CC files from THP file
getTsCcFiles = $(strip \
    $(eval _Api := $(basename $1)) \
    $(addsuffix _test.h,$(_Api)) \
    $(addsuffix _test.c,$(_Api)))

# Get list of generated DC H files
getLocalDcsFiles = $(strip \
    $(eval _Api := $(basename $1)) \
    $(addsuffix Svr.h,$(_Api)) \
    $(addsuffix Svr.cc,$(_Api)))


THP_DEPEND_GCC = 

# THP generated files location
THP_SVR_CC_OBJ=$(OBJ_DIR_GENERATED)

# List of THP interface (API) to compile
THP_API_LIST :=
THP_SVR_LIST :=
THP_WO_DC_API_LIST :=
TS_SCRIPT_LIST :=

# Temporary variables to workaround a make 3.80 bug(s)
THP_SVR_CC_GEN_TMP :=
THP_CLT_CC_GEN_TMP :=
THP_SVR_CC_DEP_TMP :=
THP_CLT_CC_DEP_TMP :=

TS_WO_CC_GEN_TMP :=
THP_CLT_WO_DC_CC_GEN_TMP :=
TS_WO_CC_DEP_TMP :=
THP_CLT_WO_DC_CC_DEP_TMP :=

THP_CLT_DC_H_GEN_TMP :=
THP_CLT_DC_H_DEP_TMP :=

declareThpGeneratedFiles = \
    $(eval _api := $(basename $(notdir $1))) \
    $(eval THP_API_LIST		:= $(THP_API_LIST) $1) \
    $(eval THP_SVR_CC_$(_api) 	:= $(addprefix $(THP_SVR_CC_OBJ)/,$(call getThpMsgHeaderFiles, $(_api)))) \
    $(eval THP_SVR_CC_GEN_TMP 	:= $(THP_SVR_CC_GEN_TMP) $(THP_SVR_CC_$(_api))) \
    $(eval THP_SVR_CC_DEP_$(_api) := $(firstword $(THP_SVR_CC_$(_api)))) \
    $(eval THP_SVR_CC_DEP_TMP 	:= $(THP_SVR_CC_DEP_TMP) $(THP_SVR_CC_DEP_$(_api)))

declareTsGeneratedFiles = \
    $(eval _api := $(basename $1)) \
    $(eval TS_SCRIPT_LIST 	:= $(TS_SCRIPT_LIST) $(_api)) \
    $(eval TS_WO_CC_$(_api) 	:= $(addprefix $(THP_SVR_CC_OBJ)/,$(call getTsCcFiles, $(_api)))) \
    $(eval TS_WO_CC_GEN_TMP 	:= $(TS_WO_CC_GEN_TMP) $(TS_WO_CC_$(_api))) \
    $(eval TS_WO_CC_DEP_$(_api) := $(firstword $(TS_WO_CC_$(_api)))) \
    $(eval TS_WO_CC_DEP_TMP 	:= $(TS_WO_CC_DEP_TMP) $(TS_WO_CC_DEP_$(_api)))

declareServerGeneratedFiles = \
    $(eval _api := $(basename $(notdir $1))) \
    $(eval THP_SVR_LIST       	:= $(THP_SVR_LIST) $1) \
    $(eval THP_CLT_DC_H_$(_api) := $(addprefix $(THP_SVR_CC_OBJ)/,$(call getLocalDcsFiles, $(_api)))) \
    $(eval THP_CLT_DC_H_GEN_TMP := $(THP_CLT_DC_H_GEN_TMP) $(THP_CLT_DC_H_$(_api))) \
    $(eval THP_CLT_DC_H_DEP_$(_api) := $(firstword $(THP_CLT_DC_H_$(_api)))) \
    $(eval THP_CLT_DC_H_DEP_TMP := $(THP_CLT_DC_H_DEP_TMP) $(THP_CLT_DC_H_DEP_$(_api)))

$(foreach sidl, $(SRC_SIDL),     $(call declareThpGeneratedFiles, $(sidl)))
$(foreach sidl, $(SRC_SVR_SIDL), $(call declareServerGeneratedFiles, $(sidl)))
$(foreach sidl, $(SRC_SVR_SIDL), $(call declareClientPyGeneratedFiles, $(sidl)))
$(foreach api, $(SRC_TS),       $(call declareTsGeneratedFiles, $(api)))

ifneq ($(SRC_SIDL),)
THP_SVR_CC_GENERATED := $(THP_SVR_CC_GEN_TMP)
THP_CLT_CC_GENERATED := $(THP_CLT_CC_GEN_TMP)


# Variables to workaround a make 3.80 bug(s)
THP_SVR_CC_DEP := $(THP_SVR_CC_DEP_TMP)
THP_CLT_CC_DEP := $(THP_CLT_CC_DEP_TMP)
endif

ifneq ($(SRC_TS),)
TS_WO_CC_GENERATED := $(TS_WO_CC_GEN_TMP)
# Variables to workaround a make 3.80 bug(s)
TS_WO_CC_DEP := $(TS_WO_CC_DEP_TMP)
endif

ifneq ($(SRC_SVR_SIDL),)
THP_CLT_DC_H_GENERATED 	:= $(THP_CLT_DC_H_GEN_TMP)

# Variables to workaround a make 3.80 bug(s)
THP_CLT_DC_H_DEP := $(THP_CLT_DC_H_DEP_TMP)
endif

# ----------------------------------------
# Modules libraries
# ----------------------------------------

TMP_MODULE_DEP         = $(filter-out %bsp,$(MODULE_DEP) $(HAL_LIB_DEP)) 
TMP_MODULE_PLA_LIB     = $(notdir $(filter $(SEQ_BSP)/%,$(TMP_MODULE_DEP)))
TMP_MODULE_COMMON_LIB  = $(notdir $(filter-out $(SEQ_BSP)/%,$(filter-out $(SEQ_APP)/%,$(TMP_MODULE_DEP))))

# Module librarie dependencies (From X/Y to libY.a)
MODULE_LIB_DEP = $(patsubst %, $(SEQ_LIBS)$(CUSTOM_SUFFIX)/lib%.a,$(TMP_MODULE_COMMON_LIB)) \
	 	 $(patsubst %, $(SEQ_PLA_LIBS)/lib%.a,$(TMP_MODULE_PLA_LIB))

# Module libraries for link command
TGT_MODULE_LIBS = $(patsubst %, -l%,$(TMP_MODULE_COMMON_LIB)) \
		  $(patsubst %, -l%,$(TMP_MODULE_PLA_LIB))

ifeq ($(ZLIB_ADD),1)
TGT_MODULE_LIBS += /usr/lib/libz.a
endif

#**********************************************************************
# Compilation Flags
#**********************************************************************

# ----------------------------------------
# Include path
# ----------------------------------------

CPP_INC =

CPP_INC += -I$(SEQ_ROOT)/base/api
CPP_INC += -I$(SEQ_ROOT)/fwbase/api
CPP_INC += -I$(SEQ_ROOT)/infra/sys/api 
CPP_INC += -I$(SEQ_ROOT)/infra/qki/api 
CPP_INC += -I$(SEQ_ROOT)/infra/fsm/api 
CPP_INC += -I$(SEQ_ROOT)/$(SEQ_EPS)/api
CPP_INC += -I$(SEQ_ROOT)/$(SEQ_BSP)/api

CPP_INC += $(patsubst %,-I$(SEQ_ROOT)/%/api,$(MODULE_ROOT))
CPP_INC += $(patsubst %,-I$(SEQ_ROOT)/%/api,$(MODULE_DEP) $(HAL_API_DEP) $(MODULE_DEP_HEADER))
CPP_INC += $(patsubst %,-I$(SEQ_ROOT)/%/current/include,$(MODULE_DEP_ECOS))
ifneq ($(UNIT_TESTED_MODULE),)
CPP_INC += $(addprefix -I$(SEQ_ROOT)/,$(UNIT_TESTED_MODULE)/src)
CPP_INC += $(patsubst %,-I$(SEQ_ROOT)/%,$(MODULE_DEP_PRIVATE))
endif

# These private dependencies will be removed after HP and TA modules will be completely split
ifeq ($(MODULE_NAME), ta)
CPP_INC += $(patsubst %,-I$(SEQ_ROOT)/%,$(MODULE_DEP_PRIVATE))
endif
ifeq ($(MODULE_NAME), hp)
CPP_INC += $(patsubst %,-I$(SEQ_ROOT)/%,$(MODULE_DEP_PRIVATE))
endif


CPP_INC += -I$(SEQ_ROOT)/$(MODULE_ROOT)/$(MODULE_PATH)

