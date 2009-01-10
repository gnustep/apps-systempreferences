/* SystemPreferences.m
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
#include "SystemPreferences.h"
#include "SPIconsView.h"
#include "SPIcon.h"

static NSString *nibName = @"SystemPreferences.gorm";

static SystemPreferences *systemPreferences = nil;

@implementation SystemPreferences

+ (id)systemPreferences
{
  if (systemPreferences == nil)
    {
      systemPreferences = [[SystemPreferences alloc] init];
    }	
  return systemPreferences;
}

- (void)dealloc
{
  [nc removeObserver: self];
  
  RELEASE (window);
  RELEASE (panes);
  RELEASE (iconsView);
    
  [super dealloc];
}

- (id)init
{
  self = [super init];
  
  if (self) {
    panes = [NSMutableArray new];
    currentPane = nil;
    
    fm = [NSFileManager defaultManager];
    nc = [NSNotificationCenter defaultCenter];

    [nc addObserver: self
	   selector: @selector(paneUnselectNotification:)
	       name: @"NSPreferencePaneDoUnselectNotification"
	     object: nil];

    [nc addObserver: self
	   selector: @selector(paneUnselectNotification:)
	       name: @"NSPreferencePaneCancelUnselectNotification"
	     object: nil];

    pendingAction = NULL;
  }
  
  return self;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
  unsigned int style = NSTitledWindowMask | NSMiniaturizableWindowMask;
  NSString *bundlesDir;
  
  if ([NSBundle loadNibNamed: nibName owner: self] == NO) {
    NSLog(@"failed to load %@!", nibName);
    [NSApp terminate: self];
  } 

  window = [[NSWindow alloc] initWithContentRect: NSMakeRect(200, 200, 592, 414)
                                       styleMask: style
                                         backing: NSBackingStoreRetained
                                           defer: NO];
  [window setContentView: [win contentView]];
  [window setTitle: [win title]]; 
  [window setDelegate: self];
  DESTROY (win);
    
  [prefsBox setAutoresizesSubviews: NO];  
  iconsView = [[SPIconsView alloc] initWithFrame: [[prefsBox contentView] frame]];
  [(NSBox *)prefsBox setContentView: iconsView];

  bundlesDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
  bundlesDir = [bundlesDir stringByAppendingPathComponent: @"Bundles"];
  [self addPanesFromDirectory: bundlesDir];

  bundlesDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSLocalDomainMask, YES) lastObject];
  bundlesDir = [bundlesDir stringByAppendingPathComponent: @"Bundles"];
  [self addPanesFromDirectory: bundlesDir];

  bundlesDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSSystemDomainMask, YES) lastObject];
  bundlesDir = [bundlesDir stringByAppendingPathComponent: @"Bundles"];
  [self addPanesFromDirectory: bundlesDir];
  
  [panes sortUsingSelector: @selector(comparePane:)];
  
  [showAllButt setEnabled: NO];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  unsigned i;
  
  [window setFrameUsingName: @"systemprefs"];
  [window makeKeyAndOrderFront: nil];
  
  for (i = 0; i < [panes count]; i++) {
    CREATE_AUTORELEASE_POOL (pool);
    NSPreferencePane *pane = [panes objectAtIndex: i];
    NSBundle *bundle = [pane bundle];
    NSDictionary *dict = [bundle infoDictionary];
    /* 
      All the following objects are guaranted to exist because they are 
      checked in the -initWithBundle: method of the NSPreferencePane class.    
    */
    NSString *iname = [dict objectForKey: @"GSPrefPaneIconFile"];
    NSString *ipath = [bundle pathForResource: iname ofType: nil];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile: ipath];
    NSString *lstr = [dict objectForKey: @"GSPrefPaneIconLabel"];
    SPIcon *icon;
    
    icon = [[SPIcon alloc] initForPane: pane iconImage: image labelString: lstr];
    [iconsView addIcon: icon];
    RELEASE (icon);
    RELEASE (image);
    RELEASE (pool);
  }

  [iconsView tile];
}

- (BOOL)applicationShouldTerminate:(NSApplication *)app 
{
  NSView *view = [prefsBox contentView];

  if (view != iconsView) {
    NSPreferencePaneUnselectReply reply = [currentPane shouldUnselect];
    
    if (reply == NSUnselectCancel) {
      return NO;
    } else if (reply == NSUnselectLater) {
      pendingAction = @selector(terminateAfterPaneUnselection);
      return NO;
    }
  }

  [self showAllButtAction: nil];
  [self updateDefaults];
	return YES;
}

- (void)addPanesFromDirectory:(NSString *)dir
{
  NSArray *bnames = [fm directoryContentsAtPath: dir];
  unsigned i;

  for (i = 0; i < [bnames count]; i++) {
    NSString *bname = [bnames objectAtIndex: i];

    if ([[bname pathExtension] isEqual: @"prefPane"]) {
      CREATE_AUTORELEASE_POOL (pool);
      NSString *bpath = [dir stringByAppendingPathComponent: bname];
      NSBundle *bundle = [NSBundle bundleWithPath: bpath]; 
      
      if (bundle) {
        Class principalClass = [bundle principalClass];
        NSPreferencePane *pane;
      
        NS_DURING
          {
            pane = [[principalClass alloc] initWithBundle: bundle];
            
            if ([panes containsObject: pane] == NO) {     
              [panes addObject: pane];
            }
            
            RELEASE (pane);
          }
        NS_HANDLER
          {
            NSRunAlertPanel(nil, 
                [NSString stringWithFormat: @"Bad pane bundle at: %@!", bpath], 
                            @"OK", 
                            nil, 
                            nil);  
          }
        NS_ENDHANDLER
      }
      
      RELEASE (pool);
    }
  }
}

/*
 * Forward changeFont: messages from the FontPanel to the current
 * Pane.
 */
- (void) changeFont: (id)sender
{
  if ([currentPane respondsToSelector: @selector(changeFont:)])
    {
      [currentPane changeFont: sender];
    }
}

- (void)clickOnIconOfPane:(id)pane
{
  NSView *view = [pane loadMainView];
  float diffh = [view frame].size.height - [iconsView frame].size.height;
  NSRect wr = [window frame];
  
  wr.size.height += diffh;
  wr.origin.y -= diffh;
  
  currentPane = pane;
  [currentPane willSelect];
  [(NSBox *)prefsBox setContentView: view];
  [currentPane didSelect];
    
  [window setFrame: wr display: YES];
  
  [showAllButt setEnabled: YES];
}

- (IBAction)showAllButtAction:(id)sender
{
  NSView *view = [prefsBox contentView];

  if (view != iconsView) {
    NSPreferencePaneUnselectReply reply = [currentPane shouldUnselect];
    
    if (reply == NSUnselectNow) {
      [self showIconsView];
    } else if (reply == NSUnselectLater) {
      pendingAction = @selector(showIconsView);
    }
  }
}

- (void)showIconsView
{
  NSView *view = [prefsBox contentView];
  
  if (view != iconsView) {  
    float diffh = [iconsView frame].size.height - [view frame].size.height;
    NSRect wr = [window frame];

    wr.size.height += diffh;
    wr.origin.y -= diffh;

    [currentPane willUnselect];
    [(NSBox *)prefsBox setContentView: iconsView];
    [currentPane didUnselect];

    [window setFrame: wr display: YES];

    currentPane = nil;
    [showAllButt setEnabled: NO];
  }
}

- (void)paneUnselectNotification:(NSNotification *)notif
{
  if ([[notif name] isEqual: @"NSPreferencePaneDoUnselectNotification"]) {
    [self performSelector: pendingAction];
    pendingAction = NULL;
  }  
}

- (void)terminateAfterPaneUnselection
{
  [NSApp terminate: self];
}

- (void)updateDefaults
{
  [window saveFrameUsingName: @"systemprefs"];
}

- (void)closeMainWindow:(id)sender
{
  [[[NSApplication sharedApplication] keyWindow] performClose: sender];
}

- (void)runInfoPanel:(id)sender
{
  NSMutableDictionary *d;

  d = AUTORELEASE ([NSMutableDictionary new]);
  [d setObject: @"System Preferences" forKey: @"ApplicationName"];
  [d setObject: @"GNUstep System Preferences" 
     forKey: @"ApplicationDescription"];
  [d setObject: @"SystemPreferences 1.0.2" forKey: @"ApplicationRelease"];
  [d setObject: @"01 2008" forKey: @"FullVersionID"];
  [d setObject: [NSArray arrayWithObject: @"Enrico Sersale <enrico@dtedu.net>"]
     forKey: @"Authors"];
  [d setObject: @"See http://www.dtedu.net/systempreferences" forKey: @"URL"];
  [d setObject: @"Copyright (C) 2005-2008 Free Software Foundation, Inc."
        forKey: @"Copyright"];
  [d setObject: @"Released under the GNU General Public License 2.0"
     forKey: @"CopyrightDescription"];
  
  [NSApp orderFrontStandardInfoPanelWithOptions:d];
}

- (BOOL)windowShouldClose:(id)sender
{
  [self updateDefaults];
  return YES;
}

@end












