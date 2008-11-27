RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = Defaults
BUNDLE_EXTENSION = .prefPane

Defaults_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

Defaults_OBJC_FILES = Defaults.m 

Defaults_PRINCIPAL_CLASS = Defaults

Defaults_RESOURCE_FILES = \
Info.plist \
Defaults.tiff \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble

