# Install into the system root by default
GNUSTEP_INSTALLATION_DOMAIN=SYSTEM
RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = FileSystem
BUNDLE_EXTENSION = .prefPane

FileSystem_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

FileSystem_OBJC_FILES = FileSystem.m 

FileSystem_PRINCIPAL_CLASS = FileSystem

FileSystem_RESOURCE_FILES = \
Info.plist \
FileSystem.tiff \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble

