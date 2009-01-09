/* NSPreferencePane.m
 *
 * Copyright (C) 2005 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 * Date: December 2005
 *
 * This file is part of the GNUstep PreferencePanes framework
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02111 USA.
 */

#include <AppKit/AppKit.h>
#include "NSPreferencePane.h"

@interface NSPreferencePane (private)

- (NSDictionary *) checkDictionaryAtPath: (NSString *)path;

- (NSString *) uniqueIdentifier;

@end


@implementation NSPreferencePane (private)

- (NSDictionary *) checkDictionaryAtPath: (NSString *)path
{
#define CHECK_ENTRY(x) if ([dict objectForKey: x] == nil) return nil

  if (path)
    {
      NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

      if (dict)
	{
	  NSString *identstr = [dict objectForKey: @"GSBundleIdentifier"];

	  if (identstr)
	    {
	      NSArray		*components;
	      NSMutableString	*str;
	      unsigned		i;

	      components = [identstr componentsSeparatedByString: @"."];
	      str = [NSMutableString stringWithCapacity: 32];
	      for (i = 0; i < [components count]; i++)
		{
		  [str appendString:
		    [[components objectAtIndex: i] capitalizedString]];
		}
	      uniqueIdentifier = [[NSString alloc] initWithString: str];
	    }
	  else
	    {
	      return nil;
	    }

	  CHECK_ENTRY (@"GSPrefPaneIconFile");
	  CHECK_ENTRY (@"GSPrefPaneIconLabel");
	  CHECK_ENTRY (@"NSExecutable");
	  CHECK_ENTRY (@"NSMainNibFile");
	  CHECK_ENTRY (@"NSPrincipalClass");

	  return dict;
	}
    }
  return nil;
}

- (NSString *) uniqueIdentifier
{
  return uniqueIdentifier;
}

- (unsigned) hash
{
  return [uniqueIdentifier hash];
}

- (BOOL) isEqual: (id)other
{
  if (other == self)
    {
      return YES;
    }
  if ([other isKindOfClass: [NSPreferencePane class]])
    {
      return [uniqueIdentifier isEqual: [other uniqueIdentifier]];
    }
  return NO;
}

@end


@implementation NSPreferencePane

- (void) dealloc
{
  TEST_RELEASE (_bundle);
  TEST_RELEASE (_info);
  TEST_RELEASE (_mainView);
  TEST_RELEASE (uniqueIdentifier);
  [super dealloc];
}

//
// Initializing the preference pane
//
- (id) initWithBundle: (NSBundle *)bundle
{
  self = [super init];

  if (self)
    {
      NSString *path = [bundle pathForResource: @"Info" ofType: @"plist"];
      _info = [self checkDictionaryAtPath: path];
      if (_info == nil)
	{
	  // If the Info.plist doesn't work, then try to use the generated
	  // Info-gnustep.plist as a last resort.
	  path = [bundle pathForResource: @"Info-gnustep" ofType: @"plist"];
	  _info = [self checkDictionaryAtPath: path];
	  if(_info == nil)
	    {
	      [NSException raise: NSInternalInconsistencyException
			   format: @"Bad Info.plist dictionary!"];
	      DESTROY (self);
	      return self;
	    }
	}

      // if we got a valid dictionary...
      if(_info != nil)
	{
	  RETAIN (_info);
	  ASSIGN (_bundle, bundle);
	}
    }

  return self;
}

//
// Obtaining the preference pane bundle
//
- (NSBundle *) bundle
{
  return _bundle;
}

//
// Setting up the main view
//
- (NSView *) assignMainView
{
  NSView *view = [self mainView];

  if (view == nil)
    {
      if (_window == nil)
	{
	  [NSException raise: NSInternalInconsistencyException
	    format: @"The \"_window\" outlet doesn't exist in the nib!"];
	  return nil;
	}

      view = [_window contentView];
      [self setMainView: view];
      [view removeFromSuperview];

      if (_firstKeyView == nil)
	{
	  [self setFirstKeyView: view];
	}
      if (_initialKeyView == nil)
	{
	  [self setInitialKeyView: view];
	}
      if (_lastKeyView == nil)
	{
	  [self setLastKeyView: view];
	}

      DESTROY (_window);
    }

  return view;
}

- (NSView *) loadMainView
{
  NSView *view = [self mainView];

  if (view == nil)
    {
      if ([NSBundle loadNibNamed: [self mainNibName] owner: self] == NO)
	{
	  return nil;
	}

      view = [self assignMainView];
      [self mainViewDidLoad];
    }

  return view;
}

- (NSString *) mainNibName
{
  NSString *name = [_info objectForKey: @"NSMainNibFile"];

  if (name)
    {
      name = [name stringByDeletingPathExtension];
    }

  return ((name != nil) ? name : (NSString *)@"Main");
}

- (NSView *) mainView
{
  return _mainView;
}

- (void) mainViewDidLoad
{
  /*
    Override this method to initialize the main view
    with the current preference settings.
  */
}

- (void) setMainView:(NSView *)view
{
  ASSIGN (_mainView, view);
}

//
// Handling keyboard focus
//
- (NSView *) firstKeyView
{
  return _firstKeyView;
}

- (NSView *) initialKeyView
{
  return _initialKeyView;
}

- (NSView *) lastKeyView
{
  return _lastKeyView;
}

- (void) setFirstKeyView: (NSView *)view
{
  _firstKeyView = view;
}

- (void) setInitialKeyView: (NSView *)view
{
  _initialKeyView = view;
}

- (void) setLastKeyView: (NSView *)view
{
  _lastKeyView = view;
}

- (BOOL) autoSaveTextFields
{
  return YES;
}

//
// Handling preference pane selection
//
- (BOOL) isSelected
{
  return (_mainView && [_mainView superview]);
}

- (void) didSelect
{
}

- (void) willSelect
{
}

- (void) didUnselect
{
}

- (void) replyToShouldUnselect: (BOOL)shouldUnselect
{
  NSString *notifName;

  if (shouldUnselect)
    {
      notifName = @"NSPreferencePaneDoUnselectNotification";
    }
  else
    {
      notifName = @"NSPreferencePaneCancelUnselectNotification";
    }

  [[NSNotificationCenter defaultCenter] postNotificationName: notifName
                                                      object: self];
}

- (NSPreferencePaneUnselectReply) shouldUnselect
{
  return NSUnselectNow;
}

- (void) willUnselect
{
}

//
// Help Menu support
//
- (void) updateHelpMenuWithArray: (NSArray *)arrayOfMenuItems
{
}

@end


@implementation NSPreferencePane (GNUstepExtensions)

- (NSString *) iconLabel
{
  return [_info objectForKey: @"GSPrefPaneIconLabel"];
}

- (NSComparisonResult) comparePane:(id)other
{
  return [[self iconLabel] compare: [other iconLabel]];
}

@end


