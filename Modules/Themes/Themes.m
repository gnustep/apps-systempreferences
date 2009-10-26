/* Themes.h
 *  
 * Copyright (C) 2009 Free Software Foundation, Inc.
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
  if (loaded == NO)
  {
       [NSUserDefaults standardUserDefaults];
       loaded = YES;
  }
#if 0
  dictSchemes = [[self searchSchemes] retain];
  [style removeAllItems];
  [style addItemsWithTitles:[dictSchemes allKeys]];
  
  /* retrieve the current system colors */
  currColorList = [NSColorList colorListNamed: @"System"];
  [preview setColors:currColorList];
  
  /* set the first color well */
  [colorSettings selectItemAtIndex:0];
#endif

  [self settingsAction:self];
}

-(void) willUnselect
{

}


- (void) update: (id)sender
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
  cell = [matrix cellAtRow: count++ column: 0];
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
	      [matrix addRow];
	      existing++;
	    }
	  cell = [matrix cellAtRow: count column: 0];
	  [cell setImage: [loaded icon]];
	  [cell setTitle: [loaded name]];
	  count++;
	}
    }

  /* Empty any unused cells.
   */
  while (count < existing)
    {
      cell = [matrix cellAtRow: count column: 0];
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
      cell = [matrix cellAtRow: count column: 0];
      if ([[cell title] isEqual: selected])
        {
	  [matrix selectCellAtRow: count column: 0];
	  break;
	}
    }
  RELEASE(selected);
  [matrix sizeToCells];
  [matrix setNeedsDisplay: YES];
}



@end
