/* SPIcon.m
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
#include <math.h>
#include "SPIcon.h"
#include "SystemPreferences.h"

static unsigned char darkerLUT[256] = { 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 
  4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 
  9, 9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 14, 15, 15, 
  16, 16, 17, 17, 18, 19, 19, 20, 20, 21, 21, 22, 23, 23, 24, 24, 
  25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 32, 33, 34, 35, 35, 
  36, 37, 38, 38, 39, 40, 41, 42, 42, 43, 44, 45, 46, 47, 47, 48, 
  49, 50, 51, 52, 53, 54, 55, 56, 56, 57, 58, 59, 60, 61, 62, 63, 
  64, 65, 66, 67, 68, 69, 70, 71, 73, 74, 75, 76, 77, 78, 79, 80, 
  81, 82, 84, 85, 86, 87, 88, 89, 91, 92, 93, 94, 95, 97, 98, 99, 
  100, 102, 103, 104, 105, 107, 108, 109, 111, 112, 113, 115, 116, 117, 119, 120, 
  121, 123, 124, 126, 127, 128, 130, 131, 133, 134, 136, 137, 138, 140, 141, 143, 
  144, 146, 147, 149, 151, 152, 154, 155, 157, 158, 160, 161, 163, 165, 166, 168, 
  169, 171, 173, 174, 176, 178, 179, 181, 183, 184, 186, 188, 190, 191, 193, 195, 
  196, 198, 200, 202, 204, 205, 207, 209, 211, 213, 214, 216, 218, 220, 222, 224, 
  225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255
  };

NSImage *darkerIcon(NSImage *icon)
{
  CREATE_AUTORELEASE_POOL(arp);
  NSData *tiffdata = [icon TIFFRepresentation];
  NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData: tiffdata];
  int samplesPerPixel = [rep samplesPerPixel];
  int bitsPerPixel = [rep bitsPerPixel];
  NSImage *newIcon;

	if (((samplesPerPixel == 3) && (bitsPerPixel == 24)) 
              || ((samplesPerPixel == 4) && (bitsPerPixel == 32))) {
    int pixelsWide = [rep pixelsWide];
    int pixelsHigh = [rep pixelsHigh];
    int bytesPerRow = [rep bytesPerRow];
    NSBitmapImageRep *newrep;
    unsigned char *srcData;
    unsigned char *dstData;
    unsigned char *psrc;
    unsigned char *pdst;
    unsigned char *limit;

    newIcon = [[NSImage alloc] initWithSize: NSMakeSize(pixelsWide, pixelsHigh)];

    newrep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: NULL
                                pixelsWide: pixelsWide
                                pixelsHigh: pixelsHigh
                                bitsPerSample: 8
                                samplesPerPixel: 4
                                hasAlpha: YES
                                isPlanar: NO
                                colorSpaceName: NSDeviceRGBColorSpace
                                bytesPerRow: 0
                                bitsPerPixel: 0];

    [newIcon addRepresentation: newrep];
    RELEASE (newrep); 

    srcData = [rep bitmapData];
    dstData = [newrep bitmapData];
    psrc = srcData;
    pdst = dstData;

    limit = srcData + pixelsHigh * bytesPerRow;

    while (psrc < limit) {
      *pdst++ = darkerLUT[*(psrc+0)];  
      *pdst++ = darkerLUT[*(psrc+1)];  
      *pdst++ = darkerLUT[*(psrc+2)];  
      *pdst++ = (bitsPerPixel == 32) ? *(psrc+3) : 255;
      psrc += (bitsPerPixel == 32) ? 4 : 3;
    }

  } else {
    newIcon = [icon copy];
  }

  RELEASE (arp);

  return [newIcon autorelease];  
}

double myrintf(double a)
{
	return (floor(a + 0.5));         
}

static NSDictionary *fontAttr = nil;


@implementation SPIcon

- (void)dealloc
{
  RELEASE (icon);
  RELEASE (selicon);
  RELEASE (label[0]);
  TEST_RELEASE (label[1]);

	[super dealloc];
}

+ (void)initialize
{
  static BOOL initialized = NO;

  if (initialized == NO) {
    NSFont *font = [NSFont systemFontOfSize: 12];

    ASSIGN (fontAttr, [NSDictionary dictionaryWithObject: font
                                                  forKey: NSFontAttributeName]);  
    initialized = YES;
  }
}

- (id)initForPane:(id)apane
        iconImage:(NSImage *)img
      labelString:(NSString *)labstr
{
  self = [super init];

  if (self) {
    NSArray *components = [labstr componentsSeparatedByString: @"\n"];
    NSString *labelStr;
    
    labelRect[0] = NSZeroRect;
    labelRect[1] = NSZeroRect;
    
    labelStr = [components objectAtIndex: 0];
    labelRect[0].size = [labelStr sizeWithAttributes: fontAttr];
    label[0] = [NSTextFieldCell new];
    [label[0] setStringValue: labelStr];
    
    if ([components count] > 1) {
      labelStr = [components objectAtIndex: 1];
      labelRect[1].size = [labelStr sizeWithAttributes: fontAttr];
      label[1] = [NSTextFieldCell new];
      [label[1] setStringValue: labelStr];
    } else {
      label[1] = nil;
    }
    
    ASSIGN (icon, img);
    drawicon = icon;
    ASSIGN (selicon, darkerIcon(icon));
    icnSize = [icon size];
    icnPoint = NSZeroPoint;
    
    pane = apane;
    prefapp = [SystemPreferences systemPreferences];
  }
  
  return self;
}

- (void)tile
{
  NSRect rect = [self frame];
  float yspace = 4.0;
  
  icnPoint.x = myrintf((rect.size.width - icnSize.width) / 2);
  icnPoint.y = myrintf(rect.size.height - icnSize.height);

  if (labelRect[0].size.width >= rect.size.width) {
    labelRect[0].origin.x = 0;
  } else {
    labelRect[0].origin.x = (rect.size.width - labelRect[0].size.width) / 2;
  }
  
  labelRect[0].origin.y = icnPoint.y - labelRect[0].size.height - yspace;
  labelRect[0] = NSIntegralRect(labelRect[0]);
  
  if (label[1] != nil) {  
    if (labelRect[1].size.width >= rect.size.width) {
      labelRect[1].origin.x = 0;
    } else {
      labelRect[1].origin.x = (rect.size.width - labelRect[1].size.width) / 2;
    }
    
    labelRect[1].origin.y = labelRect[0].origin.y - labelRect[1].size.height;
    labelRect[1] = NSIntegralRect(labelRect[1]);
  }
         
  [self setNeedsDisplay: YES]; 
}

- (void)mouseDown:(NSEvent *)theEvent
{
  drawicon = selicon;
  [self setNeedsDisplay: YES];  
}

- (void)mouseUp:(NSEvent *)theEvent
{
  drawicon = icon;
  [self setNeedsDisplay: YES];  
  [prefapp clickOnIconOfPane: pane];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
  return YES;
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
  [drawicon compositeToPoint: icnPoint operation: NSCompositeSourceOver];

  [label[0] drawWithFrame: labelRect[0] inView: self];
  
  if (label[1] != nil) {
    [label[1] drawWithFrame: labelRect[1] inView: self];
  }
}

@end
































