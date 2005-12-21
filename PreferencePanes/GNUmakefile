
GNUSTEP_INSTALLATION_DIR = $(GNUSTEP_SYSTEM_ROOT)

include $(GNUSTEP_MAKEFILES)/common.make
include Version

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  FRAMEWORK_NAME = GSPreferencePanes
else
  FRAMEWORK_NAME = PreferencePanes
endif

$(FRAMEWORK_NAME)_OBJC_FILES = \
NSPreferencePane.m 
                
$(FRAMEWORK_NAME)_HEADER_FILES = \
PreferencePanes.h \
NSPreferencePane.h 
        
$(FRAMEWORK_NAME)_HAS_RESOURCE_BUNDLE = yes                                          
        
$(FRAMEWORK_NAME)_RESOURCE_FILES = \
    Resources/English.lproj 

$(FRAMEWORK_NAME)_LANGUAGES = Resources/English 

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/framework.make

include $(GNUSTEP_MAKEFILES)/aggregate.make

-include GNUmakefile.postamble
