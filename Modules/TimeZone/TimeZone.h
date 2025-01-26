/* TimeZone.h
 *  
 * Copyright (C) 2005 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 * Date: December 2005
 *
 * This file is part of the GNUstep TimeZone Preference Pane
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 31 Milk Street #960789 Boston, MA 02196 USA.
 */

#ifndef TIME_ZONE_H
#define TIME_ZONE_H

#include <Foundation/Foundation.h>
#include "PreferencePanes.h"

@class NSBox;
@class MapView;
@class MapLocation;

@interface TimeZone : NSPreferencePane 
{
  IBOutlet NSBox *imageBox;
  MapView *mapView;
  IBOutlet id zoneField;
  IBOutlet id codeField;
  IBOutlet id commentsField;
  IBOutlet id setButt;
}

- (void)showInfoOfLocation:(MapLocation *)loc;

- (IBAction)setButtAction:(id)sender;

@end

#endif // TIME_ZONE_H

