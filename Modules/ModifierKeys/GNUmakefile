# Install into the system root by default
GNUSTEP_INSTALLATION_DOMAIN=SYSTEM
RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = ModifierKeys
BUNDLE_EXTENSION = .prefPane

ModifierKeys_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

ModifierKeys_OBJC_FILES = ModifierKeys.m 

ModifierKeys_PRINCIPAL_CLASS = ModifierKeys

ModifierKeys_RESOURCE_FILES = \
Info.plist \
ModifierKeys.tiff \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble

