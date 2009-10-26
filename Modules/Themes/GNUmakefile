RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = Themes
BUNDLE_EXTENSION = .prefPane

Themes_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

Themes_OBJC_FILES = Themes.m 

Themes_PRINCIPAL_CLASS = Themes

Themes_RESOURCE_FILES = \
Themes.tiff \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble

