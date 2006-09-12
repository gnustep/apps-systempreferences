/* ColorSchemes.m
 *  
 * Copyright (C) 2006 Free Software Foundation, Inc.
 *
 * Author: Riccardo Mottola <riccardo@kaffe.org>
 * Date: September 2006
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

#import "ColorSchemes.h"
#import "NSColorStringMethods.h"

@implementation ColorSchemes

- (void) dealloc
{
    [dictSchemes release];
}


- (NSArray *) colorSchemeFilesInPath: (NSString *) path
{
	NSMutableArray	*fileList = [[NSMutableArray alloc] initWithCapacity: 5];
	NSEnumerator	*enumerator;
	NSFileManager	*fm = [NSFileManager defaultManager];
	NSString		*file;
	BOOL			isDir;

	// ensure path exists, and is a directory
	if (![fm fileExistsAtPath: path isDirectory: &isDir])
		return nil;

	if (!isDir)
		return nil;

	// scan for files matching the extension in the dir
	enumerator = [[fm directoryContentsAtPath: path] objectEnumerator];
	while ((file = [enumerator nextObject])) {
		NSString	*fullFileName = [path stringByAppendingPathComponent: file];

		// ensure file exists, and is NOT directory
		if (![fm fileExistsAtPath: fullFileName isDirectory: &isDir])
			continue;

		if (isDir)
			continue;

		if ([[file pathExtension] isEqualToString: @"colorScheme"])
			[fileList addObject: fullFileName];
	}
	return [NSArray arrayWithArray: [fileList autorelease]];
}


- (NSDictionary *)searchSchemes
{
    NSMutableDictionary *list;
    NSMutableArray *directories;
    NSEnumerator *enu;
    id           item;
    id           file;
    id           directory;

    
    list = [NSMutableDictionary dictionaryWithCapacity: 1];
    
    
    /* create a list of directories to look into */
    directories = [[NSMutableArray alloc] initWithCapacity: 3];
    enu = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask, YES) objectEnumerator];
    
    while ((item = [enu nextObject]))
    	[directories addObject: [item stringByAppendingPathComponent: @"Colors"]];


    enu = [directories objectEnumerator];
    while ((directory = [enu nextObject]))
    {
    	NSEnumerator *files;

	files = [[self colorSchemeFilesInPath: directory] objectEnumerator];
	while ((file = [files nextObject]))
	{
	    NSMutableDictionary	*scheme;
	    NSString		*name;
	    if ((scheme = [NSDictionary dictionaryWithContentsOfFile: file])
			&& (name = [scheme objectForKey: @"Name"])
			&& ![[list allKeys] containsObject: name])
	    	[list setObject: file forKey: name];
	}
    }
    
    return [NSDictionary dictionaryWithDictionary:list];
}



- (void)mainViewDidLoad
{
  if (loaded == NO)
  {
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       loaded = YES;
  }
  dictSchemes = [[self searchSchemes] retain];
  [style removeAllItems];
  [style addItemsWithTitles:[dictSchemes allKeys]];
  
  /* retrieve the current system colors */
  currColorList = [NSColorList colorListNamed: @"System"];
  [preview setColors:currColorList];
  
  /* set the first color well */
  [colorSettings selectItemAtIndex:0];
  [self settingsAction:self];
}


- (void)interpretColorScheme:(NSDictionary *)scheme
{
    NSEnumerator *keys;
    NSColorList  *currentColors;
    id            colorName;
    
    currentColors = [NSColorList colorListNamed: @"System"];
    if (!currentColors)
    	currentColors = [[NSColorList alloc] initWithName: @"System"];
		
    keys = [scheme keyEnumerator];
    while ((colorName = [keys nextObject]))
    {
    	if ([currentColors colorWithKey: colorName])
	{
	    NSColor *tempColor;
	    tempColor = [NSColor colorWithRGBStringRepresentation: [scheme objectForKey: colorName]];
	    if (tempColor)
	    {
		[currentColors setColor: tempColor forKey: colorName];
	    }
	}
    }
    if (currColorList != nil)
    	[currColorList release];
    currColorList = [currentColors retain];
    [preview setColors:currColorList];
}

- (IBAction)styleAction:(id)sender
{
    id schemeKey;
    
    schemeKey = [[style selectedItem] title];
    
    [currScheme release];
    currScheme = [NSDictionary dictionaryWithContentsOfFile: [dictSchemes objectForKey:schemeKey]];
    [currScheme retain];
    
    [self interpretColorScheme:currScheme];
}

- (NSString *)decodeSettingName:(int)setting
{
    NSString *key;
    
    key = nil;
    switch(setting)
    {
    case 0:
    	key = @"controlLightHighlightColor";
    	break;
    case 1:
    	key = @"controlHighlightColor";
	break;
    case 2:
    	key = @"controlShadowColor";
    	break;
    case 3:
    	key = @"controlDarkShadowColor";
    	break;
    case 4:
    	key = @"controlBackgroundColor";
    	break;
    case 5:
    	key = @"controlTextColor";
    	break;
    case 6:
    	key = @"textColor";
    	break;
    case 7:
    	key = @"textBackgroundColor";
    	break;
    case 8:
    	key = @"disabledControlTextColor";
    	break;
    case 9:
    	key = @"keyboardFocusIndicatorColor";
	break;
    case 10:
    	key = @"scrollBarColor";
    	break;
    case 11:
    	key = @"knobColor";
    	break;
    case 12:
    	key = @"selectedControlColor";
    	break;
    case 13:
    	key = @"selectedControlTextColor";
    	break;
    case 14:
    	key = @"selectedMenuItemColor";
    	break;
    case 15:
	key = @"selectedMenuItemTextColor";
	break;
    case 16:
    	key = @"selectedKnobColor";
    	break;
    case 17:
    	key = @"selectedTextColor";
	break;
    case 18:
    	key = @"selectedTextBackgroundColor";
    	break;
    case 19:
    	key = @"gridColor";
    	break;
    case 20:
    	key = @"headerColor";
	break;
    case 21:
    	key = @"headerTextColor";
	break;
    case 22:
    	key = @"windowBackgroundColor";
    	break;
    case 23:
    	key = @"windowFrameColor";
    	break;
    case 24:
    	key = @"windowFrameTextColor";
    	break;
    default:
    	break;
    }
    return key;
}

- (void)writeColorInScheme:(int)setting :(NSColor*)color
{
    switch(setting)
    {
    case 0:
    	[currColorList setColor: color forKey: @"controlLightHighlightColor"];
	[currColorList setColor: color forKey: @"highlightColor"];
    	break;
    case 1:
    	[currColorList setColor: color forKey: @"controlHighlightColor"];
	break;
    case 2:
    	[currColorList setColor: color forKey: @"controlShadowColor"];
    	break;
    case 3:
    	[currColorList setColor: color forKey: @"controlDarkShadowColor"];
	[currColorList setColor: color forKey: @"shadowColor"];
    	break;
    case 4:
    	[currColorList setColor: color forKey: @"controlBackgroundColor"];
	[currColorList setColor: color forKey: @"controlColor"];
    	break;
    case 5:
    	[currColorList setColor: color forKey: @"controlTextColor"];
    	break;
    case 6:
        [currColorList setColor: color forKey: @"textColor"];
    	break;
    case 7:
    	[currColorList setColor: color forKey: @"textBackgroundColor"];
	break;
    case 8:
    	[currColorList setColor: color forKey: @"disabledControlTextColor"];
    	break;
    case 9:
    	[currColorList setColor: color forKey: @"keyboardFocusIndicatorColor"];
    	break;
    case 10:
    	[currColorList setColor: color forKey: @"scrollBarColor"];
	break;
    case 11:
    	[currColorList setColor: color forKey: @"knobColor"];
	break;
    case 12:
    	[currColorList setColor: color forKey: @"selectedControlColor"];
    	break;
    case 13:
    	[currColorList setColor: color forKey: @"selectedControlTextColor"];
    	break;
    case 14:
    	[currColorList setColor: color forKey: @"selectedMenuItemColor"];
	break;
    case 15:
    	[currColorList setColor: color forKey: @"selectedMenuItemTextColor"];
	break;
    case 16:
    	[currColorList setColor: color forKey: @"selectedKnobColor"];
	break;
    case 17:
    	[currColorList setColor: color forKey: @"selectedTextColor"];
    	break;
    case 18:
    	[currColorList setColor: color forKey: @"selectedTextBackgroundColor"];
    	break;
    case 19:
    	[currColorList setColor: color forKey: @"gridColor"];
    	break;
    case 20:
    	[currColorList setColor: color forKey: @"headerColor"];
	break;
    case 21:
    	[currColorList setColor: color forKey: @"headerTextColor"];
	break;
    case 22:
    	[currColorList setColor: color forKey: @"windowBackgroundColor"];
    	break;
    case 23:
    	[currColorList setColor: color forKey: @"windowFrameColor"];
    	break;
    case 24:
    	[currColorList setColor: color forKey: @"windowFrameTextColor"];
    	break;
    default:
    	break;
    }
}

- (IBAction)settingsAction:(id)sender
{
    NSColor *colorOfSetting;
    NSString *colorKey;

    colorKey = [self decodeSettingName:[colorSettings indexOfSelectedItem]];
    colorOfSetting = [currColorList colorWithKey:colorKey];
    if (colorOfSetting != nil)
    {
        [colorWell setColor:colorOfSetting];
	
    } else
    	NSLog(@"Color of that setting not encoded");
}

- (IBAction)apply:(id)sender
{
    [currColorList writeToFile: nil];
}

- (IBAction)colorChanged:(id)sender
{
    [self writeColorInScheme: [colorSettings indexOfSelectedItem] :[colorWell color]];
    [preview setColors:currColorList];
}

@end
