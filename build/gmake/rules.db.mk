#*****************************************************************
#*
#* Module : Rules Library 
#* Purpose: Module database
#*
#*****************************************************************

# -------------------------------------------------// HAL dependency mapping /___________________
ifneq ($(HAL_DEP)$(DB_IMPLEMENTS_HAL),)
ifneq ($(NODEP),1)
$(HAL_MK_FILE): $(HAL_CFG_FILE) 
	@$(MKDIR) -p $(dir $@)
	@$(SEQ_GMAKE_ROOT)/scripts/halgen.py $(HAL_CFG_FILE) $(HAL_MK_FILE)

-include $(HAL_MK_FILE)

HAL_LIB_DEP += $(foreach hal,$(HAL_DEP),$(HAL_LIB_DEP_$(hal)))
HAL_API_DEP += $(foreach hal,$(HAL_DEP),$(HAL_API_DEP_$(hal)))
endif
endif

ifdef DB_IMPLEMENTS_HAL
HAL_API_DEP += $(foreach hal,$(DB_IMPLEMENTS_HAL),$(HAL_API_DEP_$(hal)))
endif

ifdef BUILD_APP
$(APP): $(MODULE_LIB_DEP)
endif

