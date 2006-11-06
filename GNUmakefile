#
#  Main Makefile for system preference framework and application
#  
#  Copyright (C) 2006 Free Software Foundation, Inc.
#
#  Written by:	Richard Frith-Macdonald <rfm@gnu.org>
#
#  This framework is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public
#  License along with this library; if not, write to the Free
#  Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
#  Boston, MA 02111 USA
#

VERSION = 1.0.1
PACKAGE_NAME = SystemPreferences 

# Install into the system root by default
GNUSTEP_INSTALLATION_DOMAIN=SYSTEM
RPM_DISABLE_RELOCATABLE=YES

# This usually happens when you source GNUstep.sh, then run ./configure,
# then log out, then log in again and try to compile
ifeq ($(GNUSTEP_MAKEFILES),)
  $(error You need to run the GNUstep configuration script before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# The list of subproject directories
#
SUBPROJECTS = PreferencePanes SystemPreferences Modules

-include Makefile.preamble

-include GNUmakefile.local

include $(GNUSTEP_MAKEFILES)/aggregate.make

-include Makefile.postamble

