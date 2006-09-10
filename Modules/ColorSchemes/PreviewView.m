/* PreviewView.m
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
 
#import "PreviewView.h"

@implementation PreviewView

- (void) setColors: (NSColorList *) col
{
    [col retain];
    [colors release];
    colors = col;
}

- (void) drawTextfield: (NSRect) border : (NSRect) clip
{
    /* these are role names only */
    NSColor *black;
    NSColor *dark;
    NSColor *light;
    NSColor *white;
    NSColor *bgd;
    NSColor *colrs[8];
    
    NSRectEdge up_sides[] = {NSMaxYEdge, NSMaxXEdge, NSMinYEdge, NSMinXEdge,
                             NSMaxYEdge, NSMaxXEdge, NSMinYEdge, NSMinXEdge};
    NSRectEdge dn_sides[] = {NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge,
                             NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge};
    NSRect frame;

	
    black = [colors colorWithKey: @"controlDarkShadowColor"];
    dark = [colors colorWithKey: @"controlShadowColor"];
    light = [colors colorWithKey: @"controlColor"];
    white = [colors colorWithKey: @"controlLightHighlightColor"];
    bgd = [colors colorWithKey: @"textBackgroundColor"];
    colrs[0] = dark;
    colrs[1] = white;
    colrs[2] = white;
    colrs[3] = dark;
    colrs[4] = black;
    colrs[5] = light;
    colrs[6] = light;
    colrs[7] = black;

    if ([[NSView focusView] isFlipped] == YES)
    {
    	frame = NSDrawColorTiledRects(border, clip, dn_sides, colrs, 8);
    } else
    {
    	frame = NSDrawColorTiledRects(border, clip, up_sides, colrs, 8);
    }

    [bgd set];
    NSRectFill (frame);
} 

- (void) drawButton: (NSRect) border : (NSRect) clip
{
    NSColor *black;
    NSColor *dark;
    NSColor *white;
    NSColor *bgd;
    NSColor *colrs[6];

    NSRectEdge up_sides[] = {NSMaxXEdge, NSMinYEdge, NSMinXEdge,
                            NSMaxYEdge, NSMaxXEdge, NSMinYEdge};
    NSRectEdge dn_sides[] = {NSMaxXEdge, NSMaxYEdge, NSMinXEdge,
                             NSMinYEdge, NSMaxXEdge, NSMaxYEdge};
    NSRect frame;
    
    black = [colors colorWithKey: @"controlDarkShadowColor"];
    dark = [colors colorWithKey: @"controlShadowColor"];
    white = [colors colorWithKey: @"controlLightHighlightColor"];
    bgd = [colors colorWithKey: @"controlBackgroundColor"];
    colrs[0] = black;
    colrs[1] = black;
    colrs[2] = white;
    colrs[3] = white;
    colrs[4] = dark;
    colrs[5] = dark;
    
    if ([[NSView focusView] isFlipped] == YES)
    {
    	frame = NSDrawColorTiledRects(border, clip, dn_sides, colrs, 6);
    } else
    {
    	frame = NSDrawColorTiledRects(border, clip, up_sides, colrs, 6);
    }

    [bgd set];
    NSRectFill (frame);
}

- (void) drawSlider: (NSRect)border : (NSRect)clip
{
    NSColor *black = [colors colorWithKey: @"controlShadowColor"];
    NSColor *bgd = [colors colorWithKey: @"scrollBarColor"];

    NSRect frame =  NSInsetRect (border, 2, 2);

    [black set];
    NSFrameRect (border);

    [bgd set];
    NSRectFill (frame);
}

- (void) drawRect: (NSRect)rect
{
    NSRect  slider = NSMakeRect (rect.origin.x, rect.origin.y,
                                22, rect.size.height);
    NSRect  text = NSMakeRect (rect.origin.x + 30, rect.origin.y + 40,
                               rect.size.width - 38, 24);
    NSRect  button = NSMakeRect ((rect.origin.x + rect.size.width) - (64+8), 8,
                                 64, 24);

    [[colors colorWithKey: @"windowBackgroundColor"] set];

    NSRectFill (rect);

    [self drawTextfield: text : rect];
    [self drawSlider: slider : rect];
    [self drawButton: button : rect];
}

@end
