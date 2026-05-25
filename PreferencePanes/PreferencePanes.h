/* PreferencePanes.h
 *  
 * Copyright (C) 2005 Free Software Foundation, Inc.
 *
 * Authors: Enrico Sersale
 *          Riccardo Mottola <rm@gnu.org>
 * Date: December 2005
 *
 * This file is part of the GNUstep PreferencePanes framework
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 31 Milk Street #960789 Boston, MA 02196 USA.
 */

#ifndef PREFERENCE_PANES_H
#define PREFERENCE_PANES_H

#import "NSPreferencePane.h"

// macro to load localization in bundle
#define _b(k) \
    [[NSBundle bundleForClass:[self class]] localizedStringForKey:k value:@"" table:nil]

#endif // PREFERENCE_PANES_H

