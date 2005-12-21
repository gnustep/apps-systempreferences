/* SystemPreferences.h
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

#ifndef SYSTEM_PREFERENCES_H
#define SYSTEM_PREFERENCES_H

#include <Foundation/Foundation.h>
#ifdef __APPLE__
  #include <GSPreferencePanes/PreferencePanes.h>
#else
  #include <PreferencePanes/PreferencePanes.h>
#endif

@class NSWindow;
@class SPIconsView;

@interface SystemPreferences : NSObject
{
  NSWindow *window;
  
  IBOutlet id win;
  IBOutlet id controlsBox;
  IBOutlet id showAllButt;
  IBOutlet id prefsBox;
  
  NSMutableArray *panes;
  id currentPane;
  SPIconsView *iconsView;
    
  SEL pendingAction;
    
  NSFileManager *fm;
  NSNotificationCenter *nc;
}

+ (id)systemPreferences;

- (void)addPanesFromDirectory:(NSString *)dir;

- (void)clickOnIconOfPane:(id)pane;

- (IBAction)showAllButtAction:(id)sender;

- (void)showIconsView;

- (void)paneUnselectNotification:(NSNotification *)notif;

- (void)terminateAfterPaneUnselection;

- (void)updateDefaults;

- (void)closeMainWindow:(id)sender;

- (void)runInfoPanel:(id)sender;
		 
@end

#endif // SYSTEM_PREFERENCES_H
