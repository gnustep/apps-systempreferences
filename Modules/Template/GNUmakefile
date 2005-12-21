
include $(GNUSTEP_MAKEFILES)/common.make
GNUSTEP_INSTALLATION_DIR = $(GNUSTEP_SYSTEM_ROOT)

BUNDLE_NAME = TemplateModule
BUNDLE_EXTENSION = .prefPane

TemplateModule_HAS_RESOURCE_BUNDLE = yes

OBJCFLAGS += -Wall

TemplateModule_OBJC_FILES = TemplateModule.m 

TemplateModule_PRINCIPAL_CLASS = TemplateModule

TemplateModule_RESOURCE_FILES = \
Info.plist \
TemplateModule.tiff \
Resources/English.lproj 

ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
  ADDITIONAL_GUI_LIBS += -lGSPreferencePanes
else
  ADDITIONAL_GUI_LIBS += -lPreferencePanes
endif

include $(GNUSTEP_MAKEFILES)/bundle.make

