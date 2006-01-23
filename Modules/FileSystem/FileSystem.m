/* FileSystem.m
 *  
 * Copyright (C) 2005 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 * Date: December 2005
 *
 * This file is part of the GNUstep "File System" Preference Pane
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
#include "FileSystem.h"

@implementation FileSystem

- (void)dealloc
{
	[super dealloc];
}

- (void)mainViewDidLoad
{
  if (loaded == NO) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id entry;

    entry = [defaults objectForKey: @"GSDiskSpaceUnits"];

    if (entry) {
      [spacePopup selectItemAtIndex: [entry intValue]];
    } else {
      [spacePopup selectItemAtIndex: ONE_K];
    }

    entry = [defaults objectForKey: @"GSFileBrowserHideDotFiles"];
    
    if (entry) {
      [dotsCheck setState: ([entry boolValue] ? NSOnState : NSOffState)];
    } else {
      [dotsCheck setState: NSOffState];
    }

    loaded = YES;
  }
}

- (IBAction)spacePopupAction:(id)sender
{
  CREATE_AUTORELEASE_POOL(arp);
  NSUserDefaults *defaults;
  NSMutableDictionary *domain;
  NSNumber *index;

  defaults = [NSUserDefaults standardUserDefaults];
  [defaults synchronize];
  domain = [[defaults persistentDomainForName: NSGlobalDomain] mutableCopy];

  index = [NSNumber numberWithInt: [spacePopup indexOfSelectedItem]];

  [domain setObject: index forKey: @"GSDiskSpaceUnits"];  

  [defaults setPersistentDomain: domain forName: NSGlobalDomain];
  [defaults synchronize];
  RELEASE (domain);  
  RELEASE (arp);
}

- (IBAction)dotsCheckAction:(id)sender
{
  CREATE_AUTORELEASE_POOL(arp);
  NSUserDefaults *defaults;
  NSMutableDictionary *domain;
  NSNumber *hide;
  NSDictionary *info;

  defaults = [NSUserDefaults standardUserDefaults];
  [defaults synchronize];
  domain = [[defaults persistentDomainForName: NSGlobalDomain] mutableCopy];

  hide = [NSNumber numberWithBool: ([dotsCheck state] == NSOnState)];
  info = [NSDictionary dictionaryWithObject: hide forKey: @"hide"];
  
  [domain setObject: hide forKey: @"GSFileBrowserHideDotFiles"];  

  [defaults setPersistentDomain: domain forName: NSGlobalDomain];
  [defaults synchronize];
  RELEASE (domain); 
    
	[[NSDistributedNotificationCenter defaultCenter] 
        postNotificationName: @"GSHideDotFilesDidChangeNotification"
	 								    object: nil 
                    userInfo: info];
   
  RELEASE (arp);
}

@end







