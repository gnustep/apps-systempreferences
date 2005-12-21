/* SPIcon.h
 *  
 * Copyright (C) 2005 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 * Date: December 2005
 *
 * This file is part of the GNUstep SystemPreferences application
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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02111 USA.
 */

#ifndef SP_ICON_H
#define SP_ICON_H

#include <Foundation/Foundation.h>
#include <AppKit/NSView.h>

@class NSImage;
@class NSTextFieldCell;

@interface SPIcon : NSView
{
  NSImage *icon;
  NSImage *selicon;
  NSImage *drawicon;
  NSSize icnSize;
  NSPoint icnPoint;
  
  NSTextFieldCell *label[2];  
  NSRect labelRect[2];
  
  id pane;
  id prefapp;
}

- (id)initForPane:(id)apane
        iconImage:(NSImage *)img
      labelString:(NSString *)labstr;

- (void)tile;
		 
@end

#endif // SP_ICON_H
