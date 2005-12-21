/* NSPreferencePane.h
 *  
 * Copyright (C) 2005 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 * Date: December 2005
 *
 * This file is part of the GNUstep PreferencePanes framework
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

#ifndef NS_PREFERENCE_PANE_H
#define NS_PREFERENCE_PANE_H

#include <Foundation/Foundation.h>

typedef enum {
  NSUnselectCancel,	
  NSUnselectNow,	
  NSUnselectLater
} NSPreferencePaneUnselectReply;

@class NSBundle;
@class NSView;

@interface NSPreferencePane : NSObject 
{
  NSBundle *_bundle;
  NSDictionary *_info;
  
  IBOutlet id _window;
  NSView *_mainView;
  
  NSView *_firstKeyView;
  NSView *_initialKeyView;
  NSView *_lastKeyView;
  
  NSString *uniqueIdentifier;
}

//
// Initializing the preference pane
//
- (id)initWithBundle:(NSBundle *)bundle;

//
// Obtaining the preference pane bundle
//
- (NSBundle *)bundle;

//
// Setting up the main view
//
- (NSView *)assignMainView;

- (NSView *)loadMainView;

- (NSString *)mainNibName;

- (NSView *)mainView;

- (void)mainViewDidLoad;

- (void)setMainView:(NSView *)view;

//
// Handling keyboard focus
//
- (NSView *)firstKeyView;

- (NSView *)initialKeyView;

- (NSView *)lastKeyView;

- (void)setFirstKeyView:(NSView *)view;

- (void)setInitialKeyView:(NSView *)view;

- (void)setLastKeyView:(NSView *)view;

- (BOOL)autoSaveTextFields;
     
//
// Handling preference pane selection
//
- (BOOL)isSelected;

- (void)didSelect;

- (void)willSelect;

- (void)didUnselect;

- (void)replyToShouldUnselect:(BOOL)shouldUnselect;

- (NSPreferencePaneUnselectReply)shouldUnselect;

- (void)willUnselect;

// 
// Help Menu support
//
- (void)updateHelpMenuWithArray:(NSArray *)arrayOfMenuItems;

@end


@interface NSPreferencePane (GNUstepExtensions)

- (NSString *)iconLabel;

- (NSComparisonResult)comparePane:(id)other;

@end

#endif // NS_PREFERENCE_PANE_H

