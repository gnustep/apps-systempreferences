# Install into the system root by default
GNUSTEP_INSTALLATION_DOMAIN=SYSTEM
RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = Volumes
BUNDLE_EXTENSION = .prefPane

Volumes_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

Volumes_OBJC_FILES = \
Volumes.m 

Volumes_PRINCIPAL_CLASS = Volumes

Volumes_RESOURCE_FILES = \
Info.plist \
Volumes.tiff \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble
