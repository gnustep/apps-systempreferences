/* PreviewView.m
 *  
 * Copyright (C) 2006 Free Software Foundation, Inc.
 *
 * Author: Riccardo Mottola <riccardo@kaffe.org>
 * Date: September 2006
 *
 * Original idea from Preferences.app of the Backbone project
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
#import <AppKit/NSStringDrawing.h>

@implementation PreviewView

- (void) setColors: (NSColorList *) col
{
    [col retain];
    [colors release];
    colors = col;
}

- (void) drawTextfield: (NSRect) border : (NSRect) clip
{
    NSColor *bgd;
    NSColor *colrs[8];
    NSString *text;
    NSDictionary *attrs;
    NSRect frame;
    NSRect textRect;    
    NSRectEdge up_sides[] = { NSMaxYEdge, NSMaxXEdge, NSMinYEdge, NSMinXEdge,
                             NSMaxYEdge, NSMaxXEdge, NSMinYEdge, NSMinXEdge };
    NSRectEdge dn_sides[] = { NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge,
                             NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge };

	
    bgd = [colors colorWithKey: @"textBackgroundColor"];
    colrs[0] = [colors colorWithKey: @"controlShadowColor"];
    colrs[1] = [colors colorWithKey: @"controlLightHighlightColor"];
    colrs[2] = [colors colorWithKey: @"controlLightHighlightColor"];
    colrs[3] = [colors colorWithKey: @"controlShadowColor"];
    colrs[4] = [colors colorWithKey: @"controlDarkShadowColor"];
    colrs[5] = [colors colorWithKey: @"controlColor"];
    colrs[6] = [colors colorWithKey: @"controlColor"];
    colrs[7] = [colors colorWithKey: @"controlDarkShadowColor"];

    if ([[NSView focusView] isFlipped] == YES)
    {
    	frame = NSDrawColorTiledRects(border, clip, dn_sides, colrs, 8);
    } else
    {
    	frame = NSDrawColorTiledRects(border, clip, up_sides, colrs, 8);
    }

    [bgd set];
    NSRectFill (frame);
    
    text = @"NSTextField";
    textRect = NSInsetRect(frame, 3, 0);
    attrs = [NSDictionary dictionaryWithObject:[colors colorWithKey: @"controlTextColor"] forKey:NSForegroundColorAttributeName];
    [text drawInRect:textRect withAttributes:attrs];
} 

- (void) drawButton: (NSRect) border : (NSRect) clip
{
    NSColor *background;
    NSColor *colrs[6];
    NSString *text;
    NSDictionary *attrs;
    NSRect frame;
    NSRect textRect;
    
    NSRectEdge up_sides[] = { NSMaxXEdge, NSMinYEdge, NSMinXEdge,
                            NSMaxYEdge, NSMaxXEdge, NSMinYEdge };
    NSRectEdge dn_sides[] = { NSMaxXEdge, NSMaxYEdge, NSMinXEdge,
                             NSMinYEdge, NSMaxXEdge, NSMaxYEdge };

    background = [colors colorWithKey: @"controlBackgroundColor"];
    colrs[0] = [colors colorWithKey: @"controlDarkShadowColor"];
    colrs[1] = [colors colorWithKey: @"controlDarkShadowColor"];
    colrs[2] = [colors colorWithKey: @"controlLightHighlightColor"];
    colrs[3] = [colors colorWithKey: @"controlLightHighlightColor"];
    colrs[4] = [colors colorWithKey: @"controlShadowColor"];
    colrs[5] = [colors colorWithKey: @"controlShadowColor"];
    
    if ([[NSView focusView] isFlipped] == YES)
    {
    	frame = NSDrawColorTiledRects(border, clip, dn_sides, colrs, 6);
    } else
    {
    	frame = NSDrawColorTiledRects(border, clip, up_sides, colrs, 6);
    }

    [background set];
    NSRectFill (frame);
    
    text = @"NSButton";
    attrs = [NSDictionary dictionaryWithObject:[colors colorWithKey: @"controlTextColor"] forKey:NSForegroundColorAttributeName];
    textRect = NSInsetRect(frame, (NSWidth(frame) - [text sizeWithAttributes:attrs].width) / 2, 0);
    [text drawInRect:textRect withAttributes:attrs];
}

- (void) drawSlider: (NSRect)border : (NSRect)clip
{
    NSColor *colrs[6];
    NSColor *shadow;
    NSColor *bgd;
    NSColor *knobColor;
    NSRectEdge up_sides[] = { NSMaxXEdge, NSMinYEdge, NSMinXEdge,
                            NSMaxYEdge, NSMaxXEdge, NSMinYEdge };
    NSRectEdge dn_sides[] = { NSMaxXEdge, NSMaxYEdge, NSMinXEdge,
                             NSMinYEdge, NSMaxXEdge, NSMaxYEdge };
    NSRect frame;
    NSRect knobFrame;
    NSImage *dimpleImage;
    NSPoint dimplePoint;

    shadow = [colors colorWithKey: @"controlShadowColor"];
    bgd = [colors colorWithKey: @"scrollBarColor"];
    knobColor = [colors colorWithKey: @"knobColor"];
    
    colrs[0] = [colors colorWithKey: @"controlDarkShadowColor"];
    colrs[1] = [colors colorWithKey: @"controlDarkShadowColor"];
    colrs[2] = [colors colorWithKey: @"controlLightHighlightColor"];
    colrs[3] = [colors colorWithKey: @"controlLightHighlightColor"];
    colrs[4] = [colors colorWithKey: @"controlShadowColor"];
    colrs[5] = [colors colorWithKey: @"controlShadowColor"];

    frame =  NSInsetRect (border, 2, 2);

    [shadow set];
    NSFrameRect (border);

    [bgd set];
    NSRectFill (frame);
    
    knobFrame = NSInsetRect(frame, 0, NSHeight(frame) / 4);
    
    // draw the knob
    if ([[NSView focusView] isFlipped] == YES)
    {
    	knobFrame = NSDrawColorTiledRects(knobFrame, clip, dn_sides, colrs, 6);
    } else
    {
    	knobFrame = NSDrawColorTiledRects(knobFrame, clip, up_sides, colrs, 6);
    }
    [knobColor set];
    NSRectFill (knobFrame);
    
    dimpleImage = [NSImage imageNamed:@"common_Dimple"];
    dimplePoint = NSMakePoint(
    	NSMidX(knobFrame) - [dimpleImage size].width / 2,
    	NSMidY(knobFrame) - [dimpleImage size].height / 2
	);
    [dimpleImage compositeToPoint:dimplePoint operation:NSCompositeSourceOver];
}

- (void) drawRect: (NSRect)rect
{
    nsSlider = NSMakeRect (rect.origin.x, rect.origin.y,
                         22, rect.size.height);
    nsTextField = NSMakeRect (rect.origin.x + 30, rect.origin.y + 40,
                       rect.size.width - 38, 24);
    nsButton = NSMakeRect ((rect.origin.x + rect.size.width) - (64+8), 8,
                         64, 24);
    [[colors colorWithKey: @"windowBackgroundColor"] set];

    NSRectFill (rect);

    [self drawTextfield: nsTextField : rect];
    [self drawSlider: nsSlider : rect];
    [self drawButton: nsButton : rect];
}

@end
