RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = SystemPreferences
APP_NAME = SystemPreferences
VERSION = 1.2.1
SystemPreferences_PRINCIPAL_CLASS = SystemPreferences
SystemPreferences_APPLICATION_ICON = SystemPreferences.png
SystemPreferences_HAS_RESOURCE_BUNDLE = yes

SystemPreferences_RESOURCE_FILES = Resources/Images/* \
Resources/English.lproj  

# The Objective-C source files to be compiled

SystemPreferences_OBJC_FILES = main.m \
		  SystemPreferences.m \
                  SPIconsView.m \
                  SPIcon.m

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

-include GNUmakefile.preamble

-include GNUmakefile.local

include $(GNUSTEP_MAKEFILES)/application.make

-include GNUmakefile.postamble
