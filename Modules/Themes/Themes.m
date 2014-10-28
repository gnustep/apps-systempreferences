/* Themes.h
 *  
 * Copyright (C) 2009-2014 Free Software Foundation, Inc.
 *
 * Author: Riccardo Mottola <rmottola@users.sf.net>
 * Date: October 2009
 *
 * This file is part of the GNUstep ColorSchemes Themes Preference Pane
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

#import <GNUstepGUI/GSTheme.h>

#import "Themes.h"

@implementation Themes



- (void)mainViewDidLoad
{
  NSButtonCell	*proto;

  proto = [[NSButtonCell alloc] init];
  [proto setBordered: NO];
  [proto setAlignment: NSCenterTextAlignment];
  [proto setImagePosition: NSImageAbove];
  [proto setSelectable: NO];
  [proto setEditable: NO];

  [matrix setPrototype: proto];
  [proto release];
  [matrix renewRows:1 columns:1];
  [matrix setAutosizesCells: NO];
  [matrix setCellSize: NSMakeSize(72,72)];
  [matrix setIntercellSpacing: NSMakeSize(8,8)];
  [matrix setAutoresizingMask: NSViewNotSizable];
  [matrix setMode: NSRadioModeMatrix];
  [matrix setAction: @selector(changeSelection:)];
  [matrix setTarget: self];



  [self loadThemes:self];
}

/** standard to implement fot Preference Panes */
-(void) willUnselect
{

}

- (void) changeSelection: (id)sender
{
  NSButtonCell	*cell = [sender selectedCell];
  NSString	*name = [cell title];
  GSTheme       *selectedTheme;
  NSArray       *authors;
  NSString      *authorsString;
  NSString      *license;
  NSImage       *previewImage;
  NSString      *themeDetails;
  NSString	*previewPath;

  selectedTheme = [GSTheme loadThemeNamed: name];

  [nameField setStringValue: name];
  authors = [selectedTheme authors];

  authorsString = @"";
  if ([authors count] > 0)
    authorsString = [authors componentsJoinedByString: @"\n"];
  [authorsView setString: authorsString];
  [versionField setStringValue: [selectedTheme versionString]];
  license = [selectedTheme license];
  if (license == nil)
    license = @"";
  [licenseField setStringValue:license];

  themeDetails = [[[selectedTheme bundle] infoDictionary] objectForKey:@"GSThemeDetails"];
  if (themeDetails == nil)
    themeDetails = @"";
  [detailsView setString:themeDetails];

  if (YES == [[selectedTheme name] isEqualToString: @"GNUstep"])
    {
      previewPath = [[self bundle] pathForResource: @"gnustep_preview_128" ofType: @"tiff"];  
    }
  else
    {
      previewPath = [[selectedTheme infoDictionary]
	objectForKey: @"GSThemePreview"];
      if (nil != previewPath)
	{
          previewPath = [[selectedTheme bundle]
	    pathForResource: previewPath ofType: nil];  
	}
    }
  if (previewPath == nil)
    {
      previewPath = [[self bundle] pathForResource: @"no_preview" ofType: @"tiff"];  
    }
  previewImage = [[NSImage alloc] initWithContentsOfFile:previewPath];
  [previewImage autorelease];
  [previewView setImage: previewImage];
}

- (IBAction)apply:(id)sender
{
  [GSTheme setTheme: [GSTheme loadThemeNamed: [nameField stringValue]]];
}

- (IBAction)save:(id)sender
{
  NSUserDefaults      *defaults;
  NSMutableDictionary *domain;
  NSString            *themeName;

  defaults = [NSUserDefaults standardUserDefaults];
  domain = [NSMutableDictionary dictionaryWithDictionary: [defaults persistentDomainForName: NSGlobalDomain]];
  themeName = [nameField stringValue];

  if ([themeName isEqualToString:@"GNUstep"] == YES)
    [domain removeObjectForKey:@"GSTheme"];
  else
    [domain setObject:themeName
               forKey: @"GSTheme"];
  [defaults setPersistentDomain: domain forName: NSGlobalDomain];
}


- (void) loadThemes: (id)sender
{
  NSArray		*array;
  GSTheme		*theme = [GSTheme loadThemeNamed: @"GNUstep.theme"];

  /* Avoid [NSMutableSet set] that confuses GCC 3.3.3.  It seems to confuse
   * this static +(id)set method with the instance -(void)set, so it would
   * refuse to compile saying
   * GSTheme.m:1565: error: void value not ignored as it ought to be
   */
  NSMutableSet		*set = AUTORELEASE([NSMutableSet new]);

  NSString		*selected = RETAIN([[matrix selectedCell] title]);
  unsigned		existing = [[matrix cells] count];
  NSFileManager		*mgr = [NSFileManager defaultManager];
  NSEnumerator		*enumerator;
  NSString		*path;
  NSString		*name;
  NSButtonCell		*cell;
  unsigned		count = 0;

  /* Ensure the first cell contains the default theme.
   */
  cell = [matrix cellAtRow: 0 column: count++];
  [cell setImage: [theme icon]];
  [cell setTitle: [theme name]];

  /* Go through all the themes in the standard locations and find their names.
   */
  enumerator = [NSSearchPathForDirectoriesInDomains
    (NSAllLibrariesDirectory, NSAllDomainsMask, YES) objectEnumerator];
  while ((path = [enumerator nextObject]) != nil)
    {
      NSEnumerator	*files;
      NSString		*file;

      path = [path stringByAppendingPathComponent: @"Themes"];
      files = [[mgr directoryContentsAtPath: path] objectEnumerator];
      while ((file = [files nextObject]) != nil)
        {
	  NSString	*ext = [file pathExtension];

	  name = [file stringByDeletingPathExtension];
	  if ([ext isEqualToString: @"theme"] == YES
	    && [name isEqualToString: @"GNUstep"] == NO
	    && [[name pathExtension] isEqual: @"backup"] == NO)
	    {
	      [set addObject: name];
	    }
	}
    }

  /* Sort theme names alphabetically, and add each theme to the matrix.
   */
  array = [[set allObjects] sortedArrayUsingSelector:
    @selector(caseInsensitiveCompare:)];
  enumerator = [array objectEnumerator];
  while ((name = [enumerator nextObject]) != nil)
    {
      GSTheme	*loaded;

      loaded = [GSTheme loadThemeNamed: name];
      if (loaded != nil)
	{
	  if (count >= existing)
	    {
	      [matrix addColumn];
	      existing++;
	    }
	  cell = [matrix cellAtRow: 0 column: count];
	  [cell setImage: [loaded icon]];
	  [cell setTitle: [loaded name]];
	  count++;
	}
    }

  /* Empty any unused cells.
   */
  while (count < existing)
    {
      cell = [matrix cellAtRow: 0 column: count];
      [cell setImage: nil];
      [cell setTitle: @""];
      count++;
    }

  /* Restore the selected cell.
   */
  array = [matrix cells];
  count = [array count];
  while (count-- > 0)
    {
      cell = [matrix cellAtRow: 0 column: count];
      if ([[cell title] isEqual: selected])
        {
	  [matrix selectCellAtRow: 0 column: count];
	  break;
	}
    }
  RELEASE(selected);
  [matrix sizeToCells];
  [matrix setNeedsDisplay: YES];
}



@end
