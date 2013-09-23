#*****************************************************************
#*
#* Module : Rules Library 
#* Purpose: Module database
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

