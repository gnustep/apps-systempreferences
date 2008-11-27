RPM_DISABLE_RELOCATABLE=YES

include $(GNUSTEP_MAKEFILES)/common.make

BUNDLE_NAME = ColorSchemes
BUNDLE_EXTENSION = .prefPane

ColorSchemes_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

ColorSchemes_OBJC_FILES = NSColorStringMethods.m PreviewView.m ColorSchemes.m 

ColorSchemes_PRINCIPAL_CLASS = ColorSchemes

ColorSchemes_RESOURCE_FILES = \
Info.plist \
ColorSchemes.tiff \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.preamble
-include GNUmakefile.postamble

