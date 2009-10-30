/* SystemPreferences.h
 *  
 * Copyright (C) 2005-2009 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 *         Riccardo Mottola
 *
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

#import <Foundation/Foundation.h>
#import "PreferencePanes.h"

@class NSWindow;
@class NSBox;
@class SPIconsView;

@interface SystemPreferences : NSObject
{
  NSWindow *window;
  
  IBOutlet NSWindow *win;
  IBOutlet NSBox *controlsBox;
  IBOutlet id showAllButt;
  IBOutlet NSBox *prefsBox;
  
  NSMutableArray *panes;
  id currentPane;
  SPIconsView *iconsView;
    
  SEL pendingAction;
    
  NSFileManager *fm;
  NSNotificationCenter *nc;
}

+ (id)systemPreferences;

- (void)addPanesFromDirectory:(NSString *)dir;

- (void) changeFont: (id)sender;

- (void)clickOnIconOfPane:(id)pane;

- (IBAction)showAllButtAction:(id)sender;

- (void)showIconsView;

- (void)paneUnselectNotification:(NSNotification *)notif;

- (void)terminateAfterPaneUnselection;

- (void)updateDefaults;

- (void)closeMainWindow:(id)sender;

@end

#endif // SYSTEM_PREFERENCES_H
