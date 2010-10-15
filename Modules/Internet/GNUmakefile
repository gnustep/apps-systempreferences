RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = InternetModule
BUNDLE_EXTENSION = .prefPane

InternetModule_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

InternetModule_OBJC_FILES = InternetModule.m 

InternetModule_PRINCIPAL_CLASS = InternetModule

InternetModule_RESOURCE_FILES = \
InternetModule.tiff \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble
