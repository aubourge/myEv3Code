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

