RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = TimeZone
BUNDLE_EXTENSION = .prefPane

TimeZone_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

TimeZone_OBJC_FILES = \
TimeZone.m \
MapView.m

TimeZone_PRINCIPAL_CLASS = TimeZone

TimeZone_RESOURCE_FILES = \
Info.plist \
TimeZone.tiff \
Resources/English.lproj \
Resources/zones.db \
Resources/map.tiff 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble
