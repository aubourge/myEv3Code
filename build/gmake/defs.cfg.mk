#*****************************************************************
#*
#* Module : Definition Library 
#*
#* Purpose: Project configuration for gmake build 
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


#***************************************************************
# Usage & helpers
#***************************************************************

# ----------------------------------------------------------------------------
# Function:  Usage function
# Arguments: None
# Returns:   Display USAGE_FILE text on command line
# ----------------------------------------------------------------------------

USAGE_FILE:=$(SEQ_BUILD_ROOT)/defs.usage.txt
SPACE     := _XX_space_XX_

usage = $(foreach line,\
	  $(shell sed -e 's| |$$(SPACE)|g' $(USAGE_FILE)),\
	  $(warning $(subst $$(SPACE), , $(line))))

# ----------------------------------------------------------------------------
# Function:  Basic translation function
# Arguments: 1: The list of characters to translate from 
#            2: The list of characters to translate to
#            3: The text to translate
# Returns:   Returns the text after translating characters
# ----------------------------------------------------------------------------

tr = $(strip $(eval __sqn_tmp := $3)                                      \
     $(foreach c,                                                         \
         $(join $(addsuffix :,$1),$2),                                    \
         $(eval __sqn_tmp :=                                              \
             $(subst $(word 1,$(subst :, ,$c)),$(word 2,$(subst :, ,$c)), \
                 $(__sqn_tmp))))$(__sqn_tmp))

# Common character classes for use with the tr function.
[A-Z] := A B C D E F G H I J K L M N O P Q R S T U V W X Y Z #
[a-z] := a b c d e f g h i j k l m n o p q r s t u v w x y z #

# ----------------------------------------------------------------------------
# Function:  Case conversion functions
# Arguments: 1: Text to upper/lower case
# ----------------------------------------------------------------------------
toUpper = $(call tr,$([a-z]),$([A-Z]),$1)
toLower = $(call tr,$([A-Z]),$([a-z]),$1)

# ----------------------------------------------------------------------------
# Function:  Convert first letter of the first word in upper case
# Arguments: 1: list of word of the sentence
# Returns:   Returns first word with a capital first letter
# ----------------------------------------------------------------------------
setBigCapOnWord = $(strip\
    $(eval __sqn_first_word := $(firstword $1))\
    $(foreach c,\
        $(join $(addsuffix :,$([a-z])),$([A-Z])),\
        $(eval __sqn_first_word  :=\
            $(if $(filter $(word 1,$(subst :, ,$c))%,$(__sqn_first_word)),\
                $(patsubst $(word 1,$(subst :, ,$c))%,$(word 2,$(subst :, ,$c))%,$(__sqn_first_word)),\
                $(__sqn_first_word))))\
    $(__sqn_first_word))

setBigCapOnWords = $(strip $(foreach w,$1,$(call setBigCapOnWord,$w)))

setBigCapOnSentence = \
    $(strip $(call setBigCapOnWord,$(firstword $1)) $(wordlist 2,$(words $1),$1))


# ----------------------------------------------------------------------------
# Function:  Conditional file inclusion
# Arguments: 1: Makefile to include if exists
# ----------------------------------------------------------------------------
includeIfFileExists = $(if $(strip $(wildcard $1)), include $1)

# ----------------------------------------------------------------------------
# Function:  Find best match
# Arguments: 1: String to search
#            2: List of strings
# Returns:   Returns best match or a list of candidates
# ----------------------------------------------------------------------------
match = $(strip $(eval _str_upper := $(call toUpper, $(strip $1)))  \
	$(if $(filter $(_str_upper),$2),$(_str_upper),$(filter $(_str_upper)%,$2)))

# ----------------------------------------------------------------------------
# Functions: Return the list of the non empty subdirectories
# Arguments: 1: Parent directory
# ----------------------------------------------------------------------------
getSubdirs = $(foreach f, $(notdir $(wildcard $1/*)),$(if $(wildcard $1/$f/*),$f))

# ----------------------------------------------------------------------------
# Function:  Declare a new product
# Arguments: 1: Product name
#            2: Chip name
# Returns:   Returns best match or a list of candidates
# ----------------------------------------------------------------------------
PRODUCT_LIST :=
declareProduct = $(eval _pdt_upper := $(call toUpper,$(strip $1)))     \
		 $(eval PRODUCT_LIST := $(PRODUCT_LIST) $(_pdt_upper)) \
		 $(eval SEQ_CHIP_$(_pdt_upper) := $(strip $2))         

# ----------------------------------------------------------------------------
# Function:  Set product specific definition
# Arguments: 1: Product name
# ----------------------------------------------------------------------------
setProductDefs = $(eval _pdt_upper := $(call toUpper,$(strip $1)))  \
		 $(eval SEQ_CHIP := $(SEQ_CHIP_$(_pdt_upper)))      

# ----------------------------------------------------------------------------
# Function:  Declare a new cpu
# Arguments: 1: Cpu name
#            2: CPU architecture
#            3: Operating system
# Returns:   Returns best match or a list of candidates
# ----------------------------------------------------------------------------
CPU_LIST :=
declareCpu = $(eval _cpu_upper := $(call toUpper,$(strip $1)))     \
		 $(eval CPU_LIST := $(CPU_LIST) $(_cpu_upper)) \
		 $(eval SEQ_ARCH_$(_cpu_upper) := $(strip $2))         \
		 $(eval SEQ_OS_$(_cpu_upper)   := $(strip $3)) \
		 $(eval SEQ_CPU_$(_cpu_upper)   := $(strip $1))

# ----------------------------------------------------------------------------
# Function:  Set product specific definition
# Arguments: 1: Product name
# ----------------------------------------------------------------------------
setCpuDefs = $(eval _cpu_upper := $(call toUpper,$(strip $1)))  \
		 $(eval SEQ_ARCH := $(SEQ_ARCH_$(_cpu_upper)))      \
		 $(eval SEQ_OS   := $(SEQ_OS_$(_cpu_upper)))  \
		 $(eval SEQ_CPU  := $(SEQ_CPU_$(_cpu_upper)))

# ----------------------------------------------------------------------------
# Function:  Declare a new platform
# Arguments: 1: Platform name
#            2: Platform define
# Returns:   Returns best match or a list of candidates
# ----------------------------------------------------------------------------
PLATFORM_LIST :=
declarePlatform = $(eval _pla_upper := $(call toUpper,$(strip $1)))        \
		  $(eval PLATFORM_LIST := $(PLATFORM_LIST) $(_pla_upper))  \
		  $(eval SEQ_PLATFORM_$(_pla_upper) := $(strip $2))

# ----------------------------------------------------------------------------
# Function:  Set platform specific definition
# Arguments: 1: Platform name
# ----------------------------------------------------------------------------
setPlatformDefs = $(eval _pla_upper := $(call toUpper,$(strip $1)))      \
		  $(eval SEQ_PLATFORM := $(SEQ_PLATFORM_$(_pla_upper)))


#***************************************************************
# Project chip, architecture, os and paltform definition
#***************************************************************

# ----------------------------------------
# Deprecated variable definition detection
# ----------------------------------------

ifndef SEQ_TOP_MAKEFILE
export SEQ_TOP_MAKEFILE := 1
endif

# ----------------------------------------
# Product definition
# ----------------------------------------

# Supported product list

$(call declareProduct, SQN31X0,			sqn31x0)
$(call declareProduct, SQN32X0,			sqn32x0)

# Make the product definition case non sensitive
PRODUCT_UPPER := $(call match,$(PRODUCT),$(PRODUCT_LIST))

# Check for deprecated targets
PDT_UPPER := $(call toUpper,$(strip $(PRODUCT)))

# Check platform found
ifneq ($(words $(PRODUCT_UPPER)),1)
ifeq  ($(words $(PRODUCT_UPPER)),0)
$(usage)$(error "PRODUCT ('$(PRODUCT)') badly defined. Possible values are: $(PRODUCT_LIST)")
else
$(usage)$(error "Possible matches for PRODUCT ($(PRODUCT)) are: $(PRODUCT_UPPER)")
endif
endif

# Set product specific definitions
$(call setProductDefs, $(PRODUCT_UPPER))

# ----------------------------------------
# Platform definition
# ----------------------------------------

# Supported product list
$(call declarePlatform, sqn,	  sqn)
$(call declarePlatform, zi,		  zi)
$(call declarePlatform, drf,	  drf)
$(call declarePlatform, sim,	  sim)

PLATFORM_UPPER := $(call match,$(PLATFORM),$(PLATFORM_LIST))

# Check platform found
ifdef PLATFORM
ifneq ($(words $(PLATFORM_UPPER)),1)
ifeq  ($(words $(PLATFORM_UPPER)),0)
$(usage)$(error "PLATFORM ('$(PLATFORM)') badly defined. Possible values are: $(PLATFORM_LIST)")
else
$(usage)$(error "Possible matches for PLATFORM ($(PLATFORM)) are: $(PLATFORM_UPPER)")
endif
endif
endif

# Set platform specific definitions
$(call setPlatformDefs, $(PLATFORM_UPPER))

# ----------------------------------------
# CPU definition
# ----------------------------------------

ifeq ($(PDT_UPPER), SQN31X0)
$(call declareCpu, psp,  	  mips,    eCos)
$(call declareCpu, l1p		, mico32, none)
$(call declareCpu, spupotdet, mico32, none)
endif

ifeq ($(PDT_UPPER), SQN32X0)
$(call declareCpu, psp,  	  mips,    eCos)
$(call declareCpu, l1p		, mico32, none)
$(call declareCpu, spupotdet, mico32, none)
endif

ifeq ($(PLATFORM_UPPER), SIM)
$(call declareCpu, sim,       i386,  linuxDes)
$(call declareCpu, psp,  	  i386,  linuxDes)
$(call declareCpu, l1p,       i386,  linuxDes)
endif


# default built cpu is PSP wich is toplevel CPU
ifeq ($(CPU), )
CPU = psp
endif

CPU_UPPER := $(call match,$(CPU),$(CPU_LIST))

# Check cpu found
ifneq ($(words $(CPU_UPPER)),1)
ifeq  ($(words $(CPU_UPPER)),0)
$(usage)$(error "CPU ('$(CPU)') badly defined. Possible values are: $(CPU_LIST)")
else
$(usage)$(error "Possible matches for CPU ($(CPU)) are: $(CPU_UPPER)")
endif
endif

# Set cpu specific definitions
$(call setCpuDefs, $(CPU_UPPER))

# ----------------------------------------
# Simulation case ?
# ----------------------------------------

ifeq ($(findstring Des,$(SEQ_OS)),Des)
SEQ_SIMULATION := 1
else
SEQ_SIMULATION := 0
endif

# In this case, enforce PLATFORM...
ifeq ($(SEQ_SIMULATION),1)
ifndef PLATFORM
PLATFORM=RD
endif
endif


# ----------------------------------------
# Custom definition
# ----------------------------------------

# Do no call directly call function inside next block since
# it does not work with old versions of make (make bug?)
SEQ_CUSTOM_TMP := $(call toLower,$(strip $(CUSTOM)))

# If build application is customized, set custom definition
ifdef CUSTOM
SEQ_CUSTOM := $(SEQ_CUSTOM_TMP)
endif


# ----------------------------------------
# Few definitions & constraints
# ----------------------------------------

SEQ_HOST := $(shell uname)
ifeq ($(findstring CYGWIN,$(SEQ_HOST)),CYGWIN)
SEQ_HOST=windows32
endif
ifeq ($(findstring MINGW,$(SEQ_HOST)),MINGW)
SEQ_HOST=windows32
endif
ifeq ($(findstring Windows,$(SEQ_HOST)),Windows)
SEQ_HOST=windows32
endif

SEQ_TARGET        = $(SEQ_ARCH)-$(SEQ_OS)
SEQ_DIR           = $(SEQ_CHIP)-$(SEQ_PLATFORM)/$(SEQ_TARGET)
SEQ_DIR_GENERATED = generated

# Check simulation environment compatibility with host type
ifeq ($(SEQ_SIMULATION),1)
ifeq ($(findstring $(SEQ_HOST),SunOS windows32),$(SEQ_HOST))
$(error "Simulation is not available for $(SEQ_HOST) host")
endif
endif

# ----------------------------------------
# Few checks
# ----------------------------------------

# On simulation, PLA services are linked with application but only 1 platform
# is supported => PLATFORM definition is NOT mantatory
ifeq ($(SEQ_SIMULATION),1)
MODULE_DEPENDS_ON_PLATFORM:=0
endif

ifeq ($(MODULE_DEPENDS_ON_PLATFORM),1)

# PLATFORM should be defined
ifndef PLATFORM
$(usage)$(error "PLATFORM should be defined to build the application")
endif

endif

# ----------------------------------------
# Make delivery configuration visible to the delivery Makefile
# ----------------------------------------

export SEQ_CHIP
export SEQ_ARCH
export SEQ_OS
export SEQ_SIMULATION
export SEQ_PLATFORM
export SEQ_CPU
export SEQ_CUSTOM
export SEQ_TARGET
export SEQ_DIR
