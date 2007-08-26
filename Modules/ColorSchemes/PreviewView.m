/* PreviewView.m
 *  
 * Copyright (C) 2006 Free Software Foundation, Inc.
 *
 * Author: Riccardo Mottola <riccardo@kaffe.org>
 * Date: September 2006
 *
 * Original idea from Preferences.app by Jeff Teunissen 
 * of the Backbone project
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
    NSRectEdge edgesFlipUp[] = { NSMaxYEdge, NSMaxXEdge, NSMinYEdge, NSMinXEdge,
                             NSMaxYEdge, NSMaxXEdge, NSMinYEdge, NSMinXEdge };
    NSRectEdge edgesFlipDown[] = { NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge,
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
    	frame = NSDrawColorTiledRects(border, clip, edgesFlipDown, colrs, 8);
    } else
    {
    	frame = NSDrawColorTiledRects(border, clip, edgesFlipUp, colrs, 8);
    }

    [bgd set];
    NSRectFill (frame);
    
    text = @"NSTextField";
    attrs = [NSDictionary dictionaryWithObject:[colors colorWithKey: @"controlTextColor"] forKey:NSForegroundColorAttributeName];
    textRect = NSInsetRect(frame, 3, (NSHeight(frame) - [text sizeWithAttributes:attrs].height) / 2);
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
    
    NSRectEdge edgesFlipUp[] = { NSMaxXEdge, NSMinYEdge, NSMinXEdge,
                            NSMaxYEdge, NSMaxXEdge, NSMinYEdge };
    NSRectEdge edgesFlipDown[] = { NSMaxXEdge, NSMaxYEdge, NSMinXEdge,
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
    	frame = NSDrawColorTiledRects(border, clip, edgesFlipDown, colrs, 6);
    } else
    {
    	frame = NSDrawColorTiledRects(border, clip, edgesFlipUp, colrs, 6);
    }

    [background set];
    NSRectFill (frame);
    
    text = @"NSButton";
    attrs = [NSDictionary dictionaryWithObject:[colors colorWithKey: @"controlTextColor"] forKey:NSForegroundColorAttributeName];
    textRect = NSInsetRect(frame, (NSWidth(frame) - [text sizeWithAttributes:attrs].width) / 2, (NSHeight(frame) - [text sizeWithAttributes:attrs].height) / 2);
    [text drawInRect:textRect withAttributes:attrs];
}

- (void) drawRadio: (NSRect) border : (NSRect) clip
{
    NSColor *background;
    NSString *text;
    NSDictionary *attrs;
    NSRect frame;
    NSRect textRect;
    NSImage *radioImage;
    NSPoint radioPoint;

    background = [colors colorWithKey: @"controlBackgroundColor"];

    frame = NSMakeRect(border.origin.x, border.origin.y, border.size.width, border.size.height);;
    
    [background set];
    NSRectFill (frame);
    
    radioImage = [NSImage imageNamed:@"common_RadioOn"];
    radioPoint = NSMakePoint(
	frame.origin.x,
	frame.origin.y + (NSHeight(frame) - [radioImage size].height) / 2
	);
    [radioImage compositeToPoint:radioPoint operation:NSCompositeSourceOver];

    text = @"Radio";
    attrs = [NSDictionary dictionaryWithObject:[colors colorWithKey: @"controlTextColor"] forKey:NSForegroundColorAttributeName];
    textRect = NSInsetRect(NSMakeRect(frame.origin.x + [radioImage size].width + 5, frame.origin.y, frame.size.width - [radioImage size].width - 5, frame.size.height), 0, (NSHeight(frame) - [text sizeWithAttributes:attrs].height)/ 2);
    [text drawInRect:textRect withAttributes:attrs];
}

- (void) drawSlider: (NSRect)border : (NSRect)clip
{
    NSColor *colrs[6];
    NSColor *shadow;
    NSColor *bgd;
    NSColor *knobColor;
    NSRectEdge edgesFlipUp[] = { NSMaxXEdge, NSMinYEdge, NSMinXEdge,
                            NSMaxYEdge, NSMaxXEdge, NSMinYEdge };
    NSRectEdge edgesFlipDown[] = { NSMaxXEdge, NSMaxYEdge, NSMinXEdge,
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
    	knobFrame = NSDrawColorTiledRects(knobFrame, clip, edgesFlipDown, colrs, 6);
    } else
    {
    	knobFrame = NSDrawColorTiledRects(knobFrame, clip, edgesFlipUp, colrs, 6);
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
    nsTextField = NSMakeRect (rect.origin.x + 30, rect.size.height - 30,
                       rect.size.width - 38, 24);
    nsButton = NSMakeRect (rect.origin.x + 30, rect.size.height - 60,
                         64, 24);
    nsRadio = NSMakeRect (rect.origin.x + 30, rect.size.height - 90,
                         64, 24);
    [[colors colorWithKey: @"windowBackgroundColor"] set];

    NSRectFill (rect);

    [self drawTextfield: nsTextField : rect];
    [self drawSlider: nsSlider : rect];
    [self drawButton: nsButton : rect];
    [self drawRadio: nsRadio : rect];
}

@end
