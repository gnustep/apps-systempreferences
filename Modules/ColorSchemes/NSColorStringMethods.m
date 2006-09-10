/* NSColorStringMethods.m
 *  
 * Copyright (C) 2006 Free Software Foundation, Inc.
 *
 * Author: Riccardo Mottola <riccardo@kaffe.org>
 * Date: September 2006
 *
 * Original idea from Prefereces.app of the Backbone project
 *
 * This file is part of the GNUstep ColorSchemes Preference Pane
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
 
#import <Foundation/NSScanner.h>
#import <Foundation/NSString.h>
#import <AppKit/NSColor.h>

#import "NSColorStringMethods.h"

@implementation NSColor (StringMethods)

+ (NSColor *) colorWithRGBStringRepresentation: (NSString *) aString
{
    NSColor	*color;
    float	r;
    float	g;
    float	b;

    color = [NSColor clearColor];
    if (aString != nil)
    {
    	NSScanner	*scanner = [NSScanner scannerWithString: aString];

	[scanner scanFloat: &r];
	[scanner scanFloat: &g];
	[scanner scanFloat: &b];
	color = [NSColor colorWithCalibratedRed: r green: g blue: b alpha: 1.0];	
    }

    return color;
}

@end 
