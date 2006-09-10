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
    NSLog(@"searching for schemes directories");
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
NSLog(@"examining dir %@", file);
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
       NSLog(@"mainViewDidLoad");
       loaded = YES;
  }
  dictSchemes = [[self searchSchemes] retain];
  [style removeAllItems];
  [style addItemsWithTitles:[dictSchemes allKeys]];
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
//    [currentColors writeToFile: nil];
}

- (IBAction)styleAction:(id)sender
{
    id schemeKey;
    
    schemeKey = [[style selectedItem] title];
    NSLog(@"selected %@", [dictSchemes objectForKey:schemeKey]);
    
    [currScheme release];
    currScheme = [NSDictionary dictionaryWithContentsOfFile: [dictSchemes objectForKey:schemeKey]];
    [currScheme retain];
    
    [self interpretColorScheme:currScheme];
}

- (IBAction)settingsAction:(id)sender
{
    switch([colorSettings indexOfSelectedItem])
    {
    case 0:
    	NSLog(@"0");
    	break;
    case 1:
    	NSLog(@"1");
	break;
    case 2:
    	break;
    case 3:
    	break;
    default:
    	break;
    }
}

@end
