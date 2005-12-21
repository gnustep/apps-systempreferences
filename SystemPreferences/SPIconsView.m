/* SPIconsView.m
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

#include <AppKit/AppKit.h>
#include "SPIconsView.h"
#include "SPIcon.h"

#define ICONW 80
#define ICONH 87
#define MARGIN 8

@implementation SPIconsView

- (void)dealloc
{
  RELEASE (icons);
  
	[super dealloc];
}

- (id)initWithFrame:(NSRect)rect
{
  self = [super initWithFrame: rect];

  if (self) {
    icons = [NSMutableArray new];
  }
  
  return self;
}

- (void)addIcon:(SPIcon *)icon
{
  [icons addObject: icon];
  [self addSubview: icon];
}

- (void)tile
{
  NSRect rect = [self frame];
  int xpos = 0;
  int ypos = rect.size.height - ICONH - MARGIN;
  unsigned i;

  for (i = 0; i < [icons count]; i++) {
    NSRect r = NSMakeRect(xpos, ypos, ICONW, ICONH);
  
    [[icons objectAtIndex: i] setFrame: r];
    
    xpos += ICONW;
    
    if (xpos > (rect.size.width - ICONW)) {
      xpos = 0;
      ypos -= ICONH;
    }
  }
         
  [self setNeedsDisplay: YES]; 
}

- (void)setFrame:(NSRect)frameRect
{
  [super setFrame: frameRect];
  
  if ([self superview]) {
    [self tile];
  }
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldBoundsSize
{
  [self tile];
}

- (void)drawRect:(NSRect)rect
{	
  [super drawRect: rect];

//  [[NSColor controlHighlightColor] set];  
//  NSRectFill(rect);
}

@end
































