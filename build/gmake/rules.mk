#*****************************************************************
#*
#* Module : Rules Library 
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


#*****************************************************************
# Default targets, build, clean and check
#*****************************************************************

KEEP :=
ifeq ($(origin MODULE_LIB),undefined)
ifdef MODULE_NAME
LIB=$(LIB_DIR)/lib$(MODULE_NAME).a
KEEP=$(KEEP_DIR)/keep_$(MODULE_NAME).mk
APP_DIR=$(TGT_OBJ)$(CUSTOM_SUFFIX)/fw
APP=$(APP_DIR)/$(MODULE_NAME).exe
else # ifdef MODULE_NAME
LIB=
APP=
endif # ifdef MODULE_NAME
else # ifeq ($(origin MODULE_LIB),undefined)
ifdef MODULE_LIB
LIB=$(LIB_DIR)/lib$(MODULE_LIB).a
else # ifdef MODULE_LIB
LIB=
endif # ifdef MODULE_LIB
endif # ifeq ($(origin MODULE_LIB),undefined)

# ----------------------------------------
# Module native C/CC files
# ----------------------------------------

SRC_C := $(foreach file,$(SRC_C),$(if $(findstring *, $(file)),$(notdir $(wildcard $(addprefix $(SRC_DIR)/,$(file)))),$(file)))
SRC_CC := $(foreach file,$(SRC_CC),$(if $(findstring *, $(file)),$(notdir $(wildcard $(addprefix $(SRC_DIR)/,$(file)))),$(file)))
SRC_S := $(foreach file,$(SRC_S),$(if $(findstring *, $(file)),$(notdir $(wildcard $(addprefix $(SRC_DIR)/,$(file)))),$(file)))
KEEP_C := $(foreach file,$(KEEP_C),$(if $(findstring *, $(file)),$(notdir $(wildcard $(addprefix $(SRC_DIR)/,$(file)))),$(file)))
KEEP_CC := $(foreach file,$(KEEP_CC),$(if $(findstring *, $(file)),$(notdir $(wildcard $(addprefix $(SRC_DIR)/,$(file)))),$(file)))

# Module C files
LIB_SRC_C = $(addprefix $(SRC_DIR)/, $(SRC_C) $(KEEP_C))

# Module CC files
LIB_SRC_CC = $(addprefix $(SRC_DIR)/, $(SRC_CC) $(KEEP_CC))

# Module S files
LIB_SRC_S = $(addprefix $(SRC_DIR)/, $(SRC_S))


# ----------------------------------------
# Module generated C/CC files
# ----------------------------------------

# Generated C files required for module construction
ifneq ($(SRC_C_GEN),)
SRC_C_GENERATED=$(addprefix $(OBJ_DIR_GENERATED)/, $(SRC_C_GEN))
endif # ifneq ($(SRC_C_GEN),)

# Generated CC files required for module construction
ifneq ($(SRC_CC_GEN),)
SRC_CC_GENERATED=$(addprefix $(OBJ_DIR_GENERATED)/, $(SRC_CC_GEN))
endif # ifneq ($(SRC_CC_GEN),)

ifneq ($(THP_SVR_CC_GENERATED),)
SRC_CC_GENERATED += $(filter %.cc,$(THP_SVR_CC_GENERATED))
SRC_C_GENERATED += $(filter %.c,$(THP_SVR_CC_GENERATED))
endif # ifneq ($(THP_SVR_CC_GENERATED),)

ifneq ($(THP_CLT_DC_H_GENERATED),)
SRC_CC_GENERATED += $(filter %.cc,$(THP_CLT_DC_H_GENERATED))
endif # ifneq ($(THP_CLT_DC_H_GENERATED),)

ifneq ($(THP_SVR_WO_DC_CC_GENERATED),)
SRC_CC_GENERATED += $(filter %.cc,$(THP_SVR_WO_DC_CC_GENERATED))
endif # ifneq ($(THP_SVR_WO_DC_CC_GENERATED),)

LIB_SRC_C  += $(SRC_C_GENERATED)
LIB_SRC_CC += $(SRC_CC_GENERATED)

# ----------------------------------------------
# Construction of objects to link in module lib
# ----------------------------------------------

KEEP_OBJS :=
LIB_OBJS  = $(patsubst $(OBJ_DIR_GENERATED)%,$(OBJ_DIR)%,$(SRC_C_GENERATED:.c=.o))
LIB_OBJS += $(patsubst $(OBJ_DIR_GENERATED)%,$(OBJ_DIR)%,$(SRC_CC_GENERATED:.cc=.o))

ifneq ($(SRC_S),)
LIB_OBJS += $(addprefix $(OBJ_DIR)/, $(SRC_S:.S=.o))
endif # ifneq ($(SRC_S),)

ifneq ($(SRC_C),)
LIB_OBJS += $(addprefix $(OBJ_DIR)/, $(SRC_C:.c=.o))
endif # ifneq ($(SRC_C),)

ifneq ($(SRC_CC),)
LIB_OBJS += $(addprefix $(OBJ_DIR)/, $(SRC_CC:.cc=.o))
endif # ifneq ($(SRC_CC),)

ifneq ($(SRC_OBJ),)
LIB_OBJS += $(SRC_OBJ)
endif # ifneq ($(SRC_OBJ),)

ifneq ($(KEEP_C),)
KEEP_OBJS += $(addprefix $(OBJ_DIR)/, $(KEEP_C:.c=.o))
endif # ifneq ($(SRC_C),)

ifneq ($(KEEP_CC),)
KEEP_OBJS += $(addprefix $(OBJ_DIR)/, $(KEEP_CC:.cc=.o))
endif # ifneq ($(KEEP_CC),)

LIB_OBJS += $(KEEP_OBJS)

# ----------------------------------------
# Module native C/CC files
# ----------------------------------------

LIB_TEST_C  = $(addprefix $(SRC_DIR)/, $(TEST_C))
LIB_TEST_CC = $(addprefix $(SRC_DIR)/, $(TEST_CC))


# ---------------------------------------------------
# Construction of objects to link in module test lib
# ---------------------------------------------------

TOBJS  = $(TEST_C:.c=.o)
TOBJS += $(TEST_CC:.cc=.o)
#TOBJS += $(addprefix $(OBJ_DIR)/, $(SRC_C:.c=.o))

ifneq ($(TOBJS),)
TEST_OBJS = $(addprefix $(OBJ_DIR)/, $(TEST_C:.c=.o))
TEST_OBJS = $(addprefix $(OBJ_DIR)/, $(TEST_CC:.cc=.o))
endif # ifneq ($(TOBJS),)


# ---------------------------------------------------
# Rules wrapper
# ---------------------------------------------------

.PHONY: build_app build_fw clean_app realclean_app check_app build_lib clean_lib build_thp build_test check_test clean_test realclean_test check_test_py 

ifneq ($(strip $(LIB_OBJS)),)
ifdef BUILD_APP
build::       build_app
fw::          build_fw
clean::       clean_app
realclean::   realclean_app
test::        build_app
#lazaro
check::	      check_app

else # ifdef BUILD_APP
build::       build_lib
clean::       clean_lib
realclean::   realclean_lib
test::        build_lib
check::	      build_lib
endif # ifdef BUILD_APP
thp::	      build_thp
endif # ifneq ($(strip $(LIB_OBJS)),)

ifneq ($(strip $(TEST_OBJS)),)
test::        build_test
check::       check_test
clean::       clean_test
realclean::   realclean_test
endif # ifneq ($(strip $(TEST_OBJS)),)

ifneq ($(strip $(TEST_PY)),)
build::
fullcheck:  check_test_py
endif # ($(strip $(TEST_PY)),)

ifneq ($(strip $(TEST_LIGHT_PY)),)
build::
check::	check_test_light_py
endif # ($(strip $(TEST_LIGHT_PY)),)

ifneq ($(strip $(SUBDIRS)),)
build::       build_subdirs
fw::          fw_subdirs
clean::       clean_subdirs
realclean::   realclean_subdirs
check::       check_subdirs
thp::         thp_subdirs
test::        test_subdirs
endif # ifneq ($(strip $(SUBDIRS)),)

build::
fw::
check::
thp::
test::
clean::
realclean::


# ----------------------------------
# Rules to build recursively over subdirs
# ----------------------------------

RECURSIVE_TARGETS=build_subdirs check_subdirs \
                  thp_subdirs test_subdirs fw_subdirs
CLEAN_RECURSIVE_TARGETS=clean_subdirs realclean_subdirs

ifdef SUBDIRS
$(RECURSIVE_TARGETS):
	@set fnord $$MAKEFLAGS; mf=$$2; \
	for i in $(SUBDIRS); do \
		$(MAKE) -C $$i $(patsubst %_subdirs,%,$@) || case $$mf in \
		*=*) exit 1;; *k*) fail=yes;; *) exit 1;;   \
	esac; done; test -z "$$fail"

$(CLEAN_RECURSIVE_TARGETS):
	@for i in $(SUBDIRS); do \
		$(MAKE) -C $$i $(patsubst %_subdirs,%,$@); \
	done
else # ifdef SUBDIRS
$(RECURSIVE_TARGETS) $(CLEAN_RECURSIVE_TARGETS):
	echo "[$(CPU)] SUBDIRS is not defined. Aborting $(patsubst %_subdirs,%,$@)."
endif # ifdef SUBDIRS


# ----------------------------------
# Rules to compile C/CC files
# ----------------------------------

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@ $(MKDIR) -p $(OBJ_DIR)
	@ echo "[$(CPU)] Compiling $<"
	@ $(CC) -c $(CC_FLAGS) -MMD -MF $@.d -DSEQ_SHORT_FILE='"$(notdir $<)"' -o $@ $< 

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cc
	@ $(MKDIR) -p $(OBJ_DIR)
	@ echo "[$(CPU)] Compiling $<"
	@ $(CCC) -c $(CCC_FLAGS) -MMD -MF $@.d -DSEQ_SHORT_FILE='"$(notdir $<)"' -o $@ $< 

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	@ $(MKDIR) -p $(OBJ_DIR)
	@ echo "[$(CPU)] Compiling $<"
	@ $(CC) -c $(CC_FLAGS) -DSEQ_SHORT_FILE='"$(notdir $<)"' -o $@ $< 

# ----------------------------------
# Rules to compile generated C/CC files
# ----------------------------------

define generate_build_c_rules
$(patsubst $(OBJ_DIR_GENERATED)%,$(OBJ_DIR)%,$(1)).o: $(1).c
	@ $(MKDIR) -p $(OBJ_DIR)
	@ echo "[$(CPU)] Compiling Generated $$<"
	@ $(CC) -c $(CC_FLAGS) -MMD -MF $$@.d -o $$@ $$< 
endef

define generate_build_cc_rules
$(patsubst $(OBJ_DIR_GENERATED)%,$(OBJ_DIR)%,$(1)).o: $(1).cc
	@ $(MKDIR) -p $(OBJ_DIR)
	@ echo "[$(CPU)] Compiling Generated $$<"
	@ $(CCC) -c $(CCC_FLAGS) -MMD -MF $$@.d -o $$@ $$< 
endef

$(foreach f,$(SRC_C_GENERATED:.c=),$(eval $(call generate_build_c_rules,$(f))))

$(foreach f,$(SRC_CC_GENERATED:.cc=),$(eval $(call generate_build_cc_rules,$(f))))


#$(foreach f,$(SRC_C_GENERATED:.c=),$(warning $(patsubst $(OBJ_DIR_GENERATED)%,$(OBJ_DIR)%,$(f)).o: $(f).c))


# ------------------------------------------
# Kept file tracking
# ------------------------------------------
$(KEEP): 
	@ $(MKDIR) -p $(KEEP_DIR)
	@ echo "KEEP_OBJ_$(MODULE_NAME) := $(KEEP_OBJS)" > $@

ifdef BUILD_APP
KEEP_MAKEFILES += $(foreach module,$(MODULE_DEP),$(KEEP_DIR)/keep_$(notdir $(module)).mk)
-include $(HAL_MK_FILE)
HAL_LIB_DEP_ += $(foreach hal,$(HAL_DEP),$(HAL_LIB_DEP_$(hal)))
KEEP_MAKEFILES += $(foreach module,$(HAL_LIB_DEP_),$(KEEP_DIR)/keep_$(notdir $(module)).mk)
-include $(KEEP_MAKEFILES)

KEEP_OBJ_DEP += $(foreach module,$(MODULE_DEP),$(KEEP_OBJ_$(notdir $(module))))
KEEP_OBJ_DEP += $(foreach module,$(HAL_LIB_DEP_),$(KEEP_OBJ_$(notdir $(module))))
endif

# ------------------------------------------
# Rules to build/clean a library
# ------------------------------------------

ifeq ($(SEQ_OS),eCos)
build_lib: build_ecos_lib $(LIB) $(KEEP)
else # ifeq ($(SEQ_OS),eCos)
build_lib: $(LIB) $(KEEP)
endif # ifeq ($(SEQ_OS),eCos)

$(OBJ_DIR):
	@ $(MKDIR) -p $(OBJ_DIR)

$(LIB)(%.o): %.o
	@ $(MKDIR) -p $(LIB_DIR)
	@ $(AR) rusc $@ $^

$(LIB): $(LIB)($(LIB_OBJS))
	@ echo "[$(CPU)] Linking lib $(LIB)"
	@ $(MKDIR) -p $(LIB_DIR)
	@ $(RANLIB) $@

clean_lib: 
	@ echo "[$(CPU)] Deleting lib $(LIB)"
	@ $(RM) $(LIB)
	@ for i in $(filter-out $(SRC_OBJ), $(LIB_OBJS)); do \
	    echo "[$(CPU)] Deleting obj $$i" ; \
            $(RM) $$i ; \
	  done

realclean_lib: clean_lib
	@ echo "[$(CPU)] Deleting dependencies $(DEPEND)" 
	@ $(RM) $(DEPEND)
	@ for i in $(SRC_C_GENERATED) \
		   $(SRC_CC_GENERATED) \
		   $(THP_MK) \
		   $(THP_SVR_CC_GENERATED) \
		   $(THP_SVR_WO_DC_CC_GENERATED) \
		   $(THP_CLT_WO_DC_PY_GENERATED) \
		   $(THP_CLT_DC_H_GENERATED) ; do \
	    echo "[$(CPU)] Deleting generated file $$i" ; \
            $(RM) $$i ; \
	  done

# ------------------------------------------
# Rules to build/clean an ECOS library
# ------------------------------------------

.PHONY: build_ecos_lib clean_ecos_lib

ECOS_HAL=$(ECOS_REPOSITORY)/hal
ECOS_DEVS=$(ECOS_REPOSITORY)/devs

SEQ_HAL_NAME=sqnwimax

build_ecos_lib: $(ECOS_MAK)

$(ECOS_MAK):
	@ echo "[$(CPU)] Building ECOS libraries..."
	@ echo "[$(CPU)] Copy package definition and configuration"
	@ $(MKDIR) -p $(ECOS_OBJ_DIR)
	@ $(CP) $(ECOS_CFG_FILE) $(ECOS_OBJ_DIR)/ecos.ecc
ifeq ($(SEQ_ARCH), nios2)
	@ cd $(ECOS_OBJ_DIR) && nios2configgen --ptf=$(NIOS2_CONFIG_FILE) --cpu=cpu
endif # ($(SEQ_ARCH), nios2)

	@ echo "[$(CPU)] Generate ECOS makefiles"
	cd $(ECOS_OBJ_DIR) && ecosconfig tree && ecosconfig resolve

	@ echo "[$(CPU)] Compile ECOS libraries"
	@ $(MAKE) -C $(ECOS_OBJ_DIR)

	@ cd $(SEQ_ROOT)


clean_ecos_lib:
	@ echo "[$(CPU)] Erasing ECOS libraries..."
	@ $(RM) -rf $(ECOS_OBJ_DIR)					\
		$(ECOS_HAL)/$(SEQ_ARCH)/$(SEQ_HAL_NAME)			\
		$(ECOS_DEVS)/spi/$(SEQ_ARCH)/$(SEQ_HAL_NAME)		\
		$(ECOS_DEVS)/spi/$(SEQ_ARCH)/$(SEQ_HAL_NAME)_devices	\
		$(ECOS_DEVS)/serial/$(SEQ_ARCH)/$(SEQ_HAL_NAME)		\
		$(ECOS_DEVS)/flash/$(SEQ_ARCH)/$(SEQ_HAL_NAME)		\
		$(ECOS_DEVS)/eth/$(SEQ_ARCH)/$(SEQ_HAL_NAME)

# ------------------------------------------
# Rules to build/clean application
# ------------------------------------------

build_app: $(APP)

clean_app: clean_lib
	@ echo "[$(CPU)] Deleting application $(APP)"
	@ $(RM) $(APP)

realclean_app: clean_app realclean_lib


# ------------------------------------------
# Rules to build/run/clean library unit test
# ------------------------------------------

check_app : build_app
	@ echo "[$(CPU)] Checking $(APP)" 
	@ $(SEQ_ROOT)/$(SEQ_BUILD)/scripts/regress.py $(APP)

build_test: $(TESTAPP)


check_test: build_test
	@ echo "[$(CPU)] Checking $(TESTAPP)" 
	@ $(SEQ_ROOT)/$(SEQ_BUILD)/scripts/regress $(TESTAPP)

check_test_py:
	@set fnord $$MAKEFLAGS; mf=$$2; \
	for i in $(TEST_PY); do \
		echo "[$(CPU)] Checking $$i" ; \
		PATH=.:$$PATH $(SEQ_ROOT)/$(SEQ_BUILD)/regress-python \
			$$i || case $$mf in \
		*=*) exit 1;; *k*) fail=yes;; *) exit 1;;   \
	esac; done; test -z "$$fail"


check_test_light_py:
	@set fnord $$MAKEFLAGS; mf=$$2; \
	for i in $(TEST_LIGHT_PY); do \
		echo "[$(CPU)] Checking $$i" ; \
		PATH=.:$$PATH $(SEQ_ROOT)/$(SEQ_BUILD)/regress-python \
			$$i || case $$mf in \
		*=*) exit 1;; *k*) fail=yes;; *) exit 1;;   \
	esac; done; test -z "$$fail"

clean_test:
	@ echo "[$(CPU)] Deleting testapp $(TESTAPP)"
	@ $(RM) $(TESTAPP)
	@ for i in $(TEST_OBJS); do \
	    echo "[$(CPU)] Deleting $$i" ; \
	    $(RM) $$i ; \
	  done

realclean_test: clean_test
	@ echo "[$(CPU)] Deleting dependencies $(DEPEND)" 
	@ $(RM) $(DEPEND)


# ----------------------------------
# Rule to build the test application
# ----------------------------------

ifeq ($(SEQ_SIMULATION),1)
$(TESTAPP): $(TEST_OBJ_DIR) $(TEST_OBJS) $(MODULE_LIB_DEP) $(LIB)
ifndef NO_BINARY_GEN
	@ echo "[$(CPU)] Building $(TESTAPP)"
	@ $(LD) $(LD_FLAGS) $(LD_PATH) -o $(TESTAPP) $(TEST_OBJS) \
	  $(LIB) $(TGT_MODULE_LIBS) $(TGT_DEFAULT_EXTERNAL_LIBS)
endif # ifndef NO_BINARY_GEN
else # ifeq ($(SEQ_SIMULATION),1)
$(TESTAPP): $(TEST_OBJ_DIR) $(TEST_OBJS) $(LIB) $(TGT_MODULE_LIBS)
	@ echo "[$(CPU)]Building loadable test object $(TESTAPP) [part I]"
	@ $(LD)  $(LD_FLAGS) -r $(LD_PATH) -o $(TESTAPP).partial \
	  $(TEST_OBJS) $(LIB) $(TGT_MODULE_LIBS) $(TGT_EPS_LIB) $(TGT_DEFAULT_EXTERNAL_LIBS) 
	@ echo "[$(CPU)] Munching C++ constructor/destructors in  $(TESTAPP)"
	@ $(NM) $(TESTAPP).partial | $(MUNCH) -asm > $(OBJ_DIR)/ctdt.c
	@ $(CC) $(CC_FLAGS) -fdollars-in-identifiers -c -o $(OBJ_DIR)/ctdt.o $(OBJ_DIR)/ctdt.c
	@ echo "[$(CPU)] Building loadable test object $(TESTAPP) [part II]"
	@ $(LD) $(LD_FLAGS) -r $(LD_PATH) -o $(TESTAPP) $(TESTAPP).partial $(OBJ_DIR)/ctdt.o
endif # ifeq ($(SEQ_SIMULATION),1)


# ----------------------------------
# Rules to build a loadable application
# ----------------------------------

ifeq ($(SEQ_BUILD_LOADBLE_OBJECT),1)

$(APP): $(LIB_OBJS) $(MODULE_LIB_DEP)
	@ echo "[$(CPU)] Building loadable object $(APP)"
	@ $(MKDIR) -p $(APP_DIR)
	@ $(LD) $(LD_FLAGS)  $(LD_PATH) -o $(APP) --start-group $(LIB_OBJS) $(KEEP_OBJ_DEP) \
	  $(TGT_MODULE_LIBS) $(TGT_DEFAULT_EXTERNAL_LIBS) --end-group
ifeq ($(DEBUG), 1)
	@ echo "[$(CPU)] DEBUG : NOT stripping loadable object $(APP)"
else
	@ echo "[$(CPU)] Stripping loadable object $(APP)"
	@ $(STRIP) -gx $(APP)
endif
	@ $(MKDIR) -p $(OBJ_DIR)
	@ echo KEEP_OBJ_DEP := $(KEEP_OBJ_DEP) >| $(OBJ_DIR)/keep.mk

else # ifeq ($(SEQ_BUILD_LOADBLE_OBJECT),1)


$(APP): $(LIB_OBJS) $(MODULE_LIB_DEP)
	@ echo "[$(CPU)] Building application $(APP)"
	@ $(MKDIR) -p $(APP_DIR)
	@ $(CC) $(LD_FLAGS) $(LD_PATH) -o $@ -Wl,--start-group $(KEEP_OBJ_DEP) $(LIB_OBJS) \
	  $(TGT_MODULE_LIBS) $(TGT_DEFAULT_EXTERNAL_LIBS) -Wl,--end-group
	@ $(MKDIR) -p $(OBJ_DIR)
	@ echo KEEP_OBJ_DEP := $(KEEP_OBJ_DEP) >| $(OBJ_DIR)/keep.mk

endif # ifeq ($(SEQ_BUILD_LOADBLE_OBJECT),1)


# ---------------------------------------------
# Rules to build tags
# ---------------------------------------------

.PHONY: tags ctags etags generic_tags clean_tags cscope
ctags: TAGS_FILE=$(SEQ_ROOT)/tags
ctags: TAGS_COMMAND=ctags-exuberant -f $(TAGS_FILE)
ctags: generic_tags
ctags:
	@ $(SED) -i -e 's|$(SEQ_ROOT)/||' $(TAGS_FILE)
tags:  etags
etags: TAGS_FILE=$(SEQ_ROOT)/TAGS
etags: TAGS_COMMAND=ctags-exuberant -e -f $(TAGS_FILE)
etags: generic_tags
generic_tags:
	@ echo "Force $(TAGS_FILE) file rebuild"
	@ find $(SEQ_ROOT) -type f \( -regex '.*\.\(h\|c\|cc\|cpp\|inline\|ts\|py\)$$' \) | \
		$(TAGS_COMMAND) -L '-' \
		--extra=+qf \
		-I 'SQN_STRUCT=struct,SQN_ENUM=enum,SQN_UNION=struct,STK_NEW=new,STK_NEW_ADV=new' \
		-I 'SQN,SQNC,UNIT_TEST,UNIT_TEST_DECLARE,SQN_UNION_BEGIN,SQN_UNION_END,SQN_UNION_CASE,SQN_BITMAP_BIT,SQN_BITMAP_DEF' \
		--regex-C++='/SQNC\(([^()]+)\)/SQN_\1/v/e' \
		--regex-C++='/SQN_INFO\(([^()]+)\)/sqn\1Info/v/e' \
		--regex-C++='/SQN_DESCR\(([^()]+)\)/sqn\1Descr/v/e' \
		--regex-C++='/SQN\(([^()]+)\)[[:space:]]*\{/sqn\1/v/e' \
		--regex-C++='/typedef.+SQN\(([^()]+)\)(\[[^[:space:]]*\]|)[[:space:]]*;/sqn\1/v/e' \
		--regex-C++='/UNIT_TEST\(([^,]+)\)/runTest/v/e' \
		--regex-C++='/UNIT_TEST\(([^,]+)\)/\1::runTest/v/e' \
		--regex-C++='/UNIT_TEST_DECLARE\(([^,]+),/\1/v/e' \
		--regex-C++='/SQN_(UNION_BEGIN|BITMAP_DEF)\(SQN\(([^()]+)\),/sqn\2/v/e' \
		--regex-C++='/SQN_(UNION_BEGIN|BITMAP_DEF)\(SQN\(([^()]+)\),/\2/v/e' \
		--regex-C++='/SQN_UNION_BEGIN\(SQN\(([^()]+)\),/sqn\1::d/v/e' \
		--regex-C++='/SQN_UNION_BEGIN/d/v/e' \
		--regex-C++='/SQN_UNION_END/v/v/e' \
		--regex-C++='/SQN_BITMAP_BIT\([^,]+,[[:space:]]*([^,]+)[[:space:]]*,/SQN_\1/v/e' \
		--langmap=C++:+.inline

clean_tags:
	rm -f $(SEQ_ROOT)/tags $(SEQ_ROOT)/TAGS ${SEQ_ROOT}/cscope.out

cscope:
	@ find $(SEQ_ROOT) -type f \( -regex '.*\.\(h\|c\|cc\|cpp\|inline\)$$' \) | \
		cscope -b -f ${SEQ_ROOT}/cscope.out -i '-'



# ---------------------------------------------
# Dependencies
# ---------------------------------------------

# WARNING: include order is important (include dependencies are resolved in LIFO order)
# In consequence DEPENDENCIES should appear before THP inclusion

include $(SEQ_BUILD_ROOT)/rules.depend.mk

# ---------------------------------------------
# Module database
# ---------------------------------------------
include $(SEQ_BUILD_ROOT)/rules.db.mk

