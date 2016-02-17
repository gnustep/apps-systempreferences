/* Volumes.m
 *  
 * Copyright (C) 2005-2016 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 * Date: December 2005
 *
 * This file is part of the GNUstep Volumes Preference Pane
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
#include "Volumes.h"

@implementation Volumes

- (void)dealloc
{
  RELEASE (reservedNames);
  RELEASE (removablePaths);
  
	[super dealloc];
}

- (void)mainViewDidLoad
{
  if (loaded == NO) {
    NSString *mtab = [self mtabPath];
    id cell;
    float fonth;
    NSUInteger i;

    reservedNames = [NSMutableArray new];
    [reservedNames addObjectsFromArray: [self reservedMountNames]];
      
    [mtypeScroll setBorderType: NSBezelBorder];
    [mtypeScroll setHasHorizontalScroller: NO];
    [mtypeScroll setHasVerticalScroller: YES]; 
    
    cell = [NSBrowserCell new];
    fonth = [[cell font] defaultLineHeightForFont];
      
    mtypeMatrix = [[NSMatrix alloc] initWithFrame: NSMakeRect(0, 0, 100, 100)
				            	              mode: NSRadioModeMatrix 
                               prototype: cell
			       							  numberOfRows: 0 
                         numberOfColumns: 0];
    RELEASE (cell);                     
    [mtypeMatrix setIntercellSpacing: NSZeroSize];
    [mtypeMatrix setCellSize: NSMakeSize([mtypeScroll contentSize].width, fonth)];
    [mtypeMatrix setAutoscroll: YES];
	  [mtypeMatrix setAllowsEmptySelection: YES];
	  [mtypeScroll setDocumentView: mtypeMatrix];	
    RELEASE (mtypeMatrix);
      
    for (i = 0; i < [reservedNames count]; i++) {
      NSString *name = [reservedNames objectAtIndex: i];
      int count = [[mtypeMatrix cells] count];

      [mtypeMatrix insertRow: count];
      cell = [mtypeMatrix cellAtRow: count column: 0];   
      [cell setStringValue: name];
      [cell setLeaf: YES];  
    }
    
    [mtypeMatrix sizeToCells]; 
    [mtypeMatrix setTarget: self]; 
    [mtypeMatrix setAction: @selector(mtypeMatrixAction:)]; 
    [mtypeField setDelegate: self];

    [mtypeAdd setEnabled: NO];
    [mtypeRemove setEnabled: NO];
    [mtypeRevert setEnabled: NO];
    [mtypeSet setEnabled: NO];

    removablePaths = [NSMutableArray new];
    [removablePaths addObjectsFromArray: [self removableMediaPaths]];

    [mpointScroll setBorderType: NSBezelBorder];
    [mpointScroll setHasHorizontalScroller: NO];
    [mpointScroll setHasVerticalScroller: YES]; 
    
    mpointMatrix = [[NSMatrix alloc] initWithFrame: NSMakeRect(0, 0, 100, 100)
				            	              mode: NSRadioModeMatrix 
                               prototype: [[NSBrowserCell new] autorelease]
			       							  numberOfRows: 0 
                         numberOfColumns: 0];
    [mpointMatrix setIntercellSpacing: NSZeroSize];
    [mpointMatrix setCellSize: NSMakeSize([mpointScroll contentSize].width, fonth)];
    [mpointMatrix setAutoscroll: YES];
	  [mpointMatrix setAllowsEmptySelection: YES];
	  [mpointScroll setDocumentView: mpointMatrix];	
    RELEASE (mpointMatrix);
      
    for (i = 0; i < [removablePaths count]; i++) {
      NSString *path = [removablePaths objectAtIndex: i];
      NSUInteger count = [[mpointMatrix cells] count];

      [mpointMatrix insertRow: count];
      cell = [mpointMatrix cellAtRow: count column: 0];   
      [cell setStringValue: path];
      [cell setLeaf: YES];  
    }
    
    [mpointMatrix sizeToCells]; 
    [mpointMatrix setTarget: self]; 
    [mpointMatrix setAction: @selector(mpointMatrixAction:)]; 
    [mpointField setDelegate: self];

    [mpointAdd setEnabled: NO];
    [mpointRemove setEnabled: NO];
    [mpointRevert setEnabled: NO];
    [mpointSet setEnabled: NO];

    if (mtab != nil) {
      [mtabField setStringValue: mtab];
    } else {
      [mtabField setSelectable: NO];
      [mtabSet setEnabled: NO];
    }
    
    fm = [NSFileManager defaultManager];
    
    loaded = YES;
  }
}

- (IBAction)mtypeButtAction:(id)sender
{
  NSArray *cells = [mtypeMatrix cells];
  NSUInteger count = [cells count];
  id cell;
  NSUInteger i;

  if (sender == mtypeAdd) {
    NSString *mtype = [mtypeField stringValue];

    if ([mtype length] == 0) {
      [mtypeAdd setEnabled: NO];
      [mtypeField setStringValue: @""];
      return;
    }

    for (i = 0; i < count; i++) {
      if ([[[cells objectAtIndex: i] stringValue] isEqual: mtype]) {
        [mtypeAdd setEnabled: NO];
        [mtypeField setStringValue: @""];
        return;
      }
    }

    [mtypeMatrix insertRow: count];
    cell = [mtypeMatrix cellAtRow: count column: 0];   
    [cell setStringValue: mtype];
    [cell setLeaf: YES];  
    [mtypeMatrix sizeToCells]; 
    [mtypeMatrix selectCellAtRow: count column: 0]; 

    [mtypeAdd setEnabled: NO];
    [mtypeRemove setEnabled: YES];
    [mtypeRevert setEnabled: YES];
    [mtypeSet setEnabled: YES];
    
    [mtypeMatrix sendAction];
    
  } else if (sender == mtypeRemove) {
    NSInteger row, col;
  
    cell = [mtypeMatrix selectedCell];  
    [mtypeMatrix getRow: &row column: &col ofCell: cell];
    [mtypeMatrix removeRow: row];
    [mtypeMatrix sizeToCells]; 
  
    [mtypeAdd setEnabled: NO];
    [mtypeRemove setEnabled: YES];
    [mtypeRevert setEnabled: YES];
    [mtypeSet setEnabled: YES];
    
    [mtypeMatrix sendAction];
    
  } else if (sender == mtypeRevert) {
    for (i = 0; i < count; i++) {
      [mtypeMatrix removeRow: 0];
    }
  
    for (i = 0; i < [reservedNames count]; i++) {
      NSString *name = [reservedNames objectAtIndex: i];
      
      count = [[mtypeMatrix cells] count];
      [mtypeMatrix insertRow: count];
      cell = [mtypeMatrix cellAtRow: count column: 0];   
      [cell setStringValue: name];
      [cell setLeaf: YES];  
    }
    
    [mtypeMatrix sizeToCells]; 
    [mtypeMatrix setNeedsDisplay: YES]; 

    [mtypeAdd setEnabled: NO];
    [mtypeRemove setEnabled: NO];
    [mtypeRevert setEnabled: NO];
    [mtypeSet setEnabled: NO];
    
    [mtypeField setStringValue: @""];    

  } else if (sender == mtypeSet) {
    CREATE_AUTORELEASE_POOL(arp);
    NSUserDefaults *defaults;
    NSMutableDictionary *domain;

    defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    domain = [[defaults persistentDomainForName: NSGlobalDomain] mutableCopy];
  
    [reservedNames removeAllObjects];
  
    for (i = 0; i < count; i++) {
      NSString *mname = [[mtypeMatrix cellAtRow: i column: 0] stringValue];
      [reservedNames addObject: mname];
    }  
  
    [domain setObject: reservedNames forKey: @"GSReservedMountNames"];  

    [defaults setPersistentDomain: domain forName: NSGlobalDomain];
    [defaults synchronize];
    RELEASE (domain);  
  
    [mtypeAdd setEnabled: NO];
    [mtypeRemove setEnabled: NO];
    [mtypeRevert setEnabled: NO];
    [mtypeSet setEnabled: NO];
      
    [mtypeField setStringValue: @""];        
    
    RELEASE (arp);   
    
	  [[NSDistributedNotificationCenter defaultCenter] 
          postNotificationName: @"GSReservedMountNamesDidChangeNotification"
	 								      object: nil 
                      userInfo: nil];
  }
}

- (void)mtypeMatrixAction:(id)sender
{
  [mtypeField setStringValue: @""];
  [mtypeAdd setEnabled: NO];
  [mtypeRemove setEnabled: ([[mtypeMatrix cells] count] > 0)];  
}

- (IBAction)mpointButtAction:(id)sender
{
  NSArray *cells = [mpointMatrix cells];
  NSUInteger count = [cells count];
  id cell;
  NSUInteger i;

  if (sender == mpointAdd) {
    NSString *mpoint = [mpointField stringValue];
    BOOL isdir;

    if ([mpoint length] == 0) {
      [mpointAdd setEnabled: NO];
      [mpointField setStringValue: @""];
      return;
    }
    if ([mpoint isAbsolutePath] == NO) {
      [mpointAdd setEnabled: NO];
      [mpointField setStringValue: @""];
      return;
    }
    if (([fm fileExistsAtPath: mpoint isDirectory: &isdir] && isdir) == NO) {
      [mpointAdd setEnabled: NO];
      [mpointField setStringValue: @""];
      return;
    }

    for (i = 0; i < count; i++) {
      if ([[[cells objectAtIndex: i] stringValue] isEqual: mpoint]) {
        [mpointAdd setEnabled: NO];
        [mpointField setStringValue: @""];
        return;
      }
    }

    [mpointMatrix insertRow: count];
    cell = [mpointMatrix cellAtRow: count column: 0];   
    [cell setStringValue: mpoint];
    [cell setLeaf: YES];  
    [mpointMatrix sizeToCells]; 
    [mpointMatrix selectCellAtRow: count column: 0]; 

    [mpointAdd setEnabled: NO];
    [mpointRemove setEnabled: YES];
    [mpointRevert setEnabled: YES];
    [mpointSet setEnabled: YES];
    
    [mpointMatrix sendAction];
    
  } else if (sender == mpointRemove) {
    NSInteger row, col;
  
    cell = [mpointMatrix selectedCell];  
    [mpointMatrix getRow: &row column: &col ofCell: cell];
    [mpointMatrix removeRow: row];
    [mpointMatrix sizeToCells]; 
  
    [mpointAdd setEnabled: NO];
    [mpointRemove setEnabled: YES];
    [mpointRevert setEnabled: YES];
    [mpointSet setEnabled: YES];
    
    [mpointMatrix sendAction];
    
  } else if (sender == mpointRevert) {
    for (i = 0; i < count; i++) {
      [mpointMatrix removeRow: 0];
    }
  
    for (i = 0; i < [removablePaths count]; i++) {
      NSString *name = [removablePaths objectAtIndex: i];
      
      count = [[mpointMatrix cells] count];
      [mpointMatrix insertRow: count];
      cell = [mpointMatrix cellAtRow: count column: 0];   
      [cell setStringValue: name];
      [cell setLeaf: YES];  
    }
    
    [mpointMatrix sizeToCells]; 
    [mpointMatrix setNeedsDisplay: YES]; 

    [mpointAdd setEnabled: NO];
    [mpointRemove setEnabled: NO];
    [mpointRevert setEnabled: NO];
    [mpointSet setEnabled: NO];
    
    [mpointField setStringValue: @""];    

  } else if (sender == mpointSet) {
    CREATE_AUTORELEASE_POOL(arp);
    NSUserDefaults *defaults;
    NSMutableDictionary *domain;

    defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    domain = [[defaults persistentDomainForName: NSGlobalDomain] mutableCopy];
  
    [removablePaths removeAllObjects];
  
    for (i = 0; i < count; i++) {
      NSString *mname = [[mpointMatrix cellAtRow: i column: 0] stringValue];
      [removablePaths addObject: mname];
    }  
  
    [domain setObject: removablePaths forKey: @"GSRemovableMediaPaths"];  

    [defaults setPersistentDomain: domain forName: NSGlobalDomain];
    [defaults synchronize];
    RELEASE (domain);  
  
    [mpointAdd setEnabled: NO];
    [mpointRemove setEnabled: NO];
    [mpointRevert setEnabled: NO];
    [mpointSet setEnabled: NO];
    
    [mpointField setStringValue: @""];
    
    RELEASE (arp); 
    
	  [[NSDistributedNotificationCenter defaultCenter] 
          postNotificationName: @"GSRemovableMediaPathsDidChangeNotification"
	 								      object: nil 
                      userInfo: nil];
  }
}

- (void)mpointMatrixAction:(id)sender
{
  [mpointField setStringValue: @""];
  [mpointAdd setEnabled: NO];
  [mpointRemove setEnabled: ([[mpointMatrix cells] count] > 0)];  
}

- (IBAction)mtabButtAction:(id)sender
{
  NSString *path = [mtabField stringValue];
  NSString *mtab = [self mtabPath];
  BOOL isdir;  
  
  if ([path length] && [path isAbsolutePath]) {
    if ([fm fileExistsAtPath: path isDirectory: &isdir] && (isdir == NO)) {
      CREATE_AUTORELEASE_POOL(arp);
      NSUserDefaults *defaults;
      NSMutableDictionary *domain;

      defaults = [NSUserDefaults standardUserDefaults];
      [defaults synchronize];
      domain = [[defaults persistentDomainForName: NSGlobalDomain] mutableCopy];

      [domain setObject: path forKey: @"GSMtabPath"];  
      [defaults setPersistentDomain: domain forName: NSGlobalDomain];
      [defaults synchronize];
      RELEASE (domain);  
      RELEASE (arp);
      
    } else {
      [mtabField setStringValue: mtab];
    }

  } else {
    [mtabField setStringValue: mtab];
  }
}

- (void)controlTextDidChange:(NSNotification *)notif
{
  NSText *text = [[notif userInfo] objectForKey:@"NSFieldEditor"];
  if ([notif object] == mtypeField) {
    [mtypeAdd setEnabled: ([[text string] length] > 0)];
    [mtypeRemove setEnabled: NO]; 
  } else if ([notif object] == mpointField) {
    [mpointAdd setEnabled: ([[text string] length] > 0)];
    [mpointRemove setEnabled: NO]; 
  }
}

- (NSArray *)reservedMountNames
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSArray *reserved = [defaults arrayForKey: @"GSReservedMountNames"];

  if (reserved == nil) {
    unsigned int systype = [[NSProcessInfo processInfo] operatingSystem];
  
    switch(systype) {
      case NSGNULinuxOperatingSystem:
        reserved = [NSArray arrayWithObjects: @"proc", @"devpts", @"shm", 
                                                    @"usbdevfs", @"devpts", 
                                                    @"sysfs", @"tmpfs", nil];
        break;

      case NSBSDOperatingSystem:
        reserved = [NSArray arrayWithObjects: @"devfs", nil];
        break;

      case NSMACHOperatingSystem:
        reserved = [NSArray arrayWithObjects: @"devfs", @"fdesc", 
                                                    @"<volfs>", nil];
        break;
    
      default:
        break;
    }
  }

  return reserved;
}

- (NSArray *)removableMediaPaths
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSArray *removables = [defaults arrayForKey: @"GSRemovableMediaPaths"];

  if (removables == nil) {
    unsigned int systype = [[NSProcessInfo processInfo] operatingSystem];
  
    switch(systype) {
      case NSGNULinuxOperatingSystem:
        removables = [NSArray arrayWithObjects: @"/mnt/floppy", @"/mnt/cdrom", nil];
        break;

      case NSBSDOperatingSystem:
        removables = [NSArray arrayWithObjects: @"/cdrom", nil];
        break;
    
      default:
        break;
    }
  }

  return removables;
}

- (NSString *)mtabPath
{
  NSUInteger systype = [[NSProcessInfo processInfo] operatingSystem];

  if (systype == NSGNULinuxOperatingSystem) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mtabpath = [defaults stringForKey: @"GSMtabPath"];
      
    if (mtabpath == nil) {
      mtabpath = @"/etc/mtab";
    }
    
    return mtabpath;
  }
  
  return nil;
}

@end
