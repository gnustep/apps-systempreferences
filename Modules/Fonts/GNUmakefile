# Install into the system root by default
GNUSTEP_INSTALLATION_DOMAIN=SYSTEM
RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = FontModule
BUNDLE_EXTENSION = .prefPane

FontModule_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

FontModule_OBJC_FILES = FontModule.m 

FontModule_PRINCIPAL_CLASS = FontModule

FontModule_RESOURCE_FILES = \
FontModule.tiff \
Info.plist \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble
