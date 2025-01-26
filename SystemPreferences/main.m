/* main.m
 *  
 * Copyright (C) 2005-2010 Free Software Foundation, Inc.
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
 * Foundation, Inc., 31 Milk Street #960789 Boston, MA 02196 USA.
 */


#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "SystemPreferences.h"

void createMenu();

int main(int argc, char **argv, char** env)
{
	CREATE_AUTORELEASE_POOL (pool);
	NSApplication *theApp = [NSApplication sharedApplication];  
	createMenu();  
	[theApp setDelegate: [SystemPreferences systemPreferences]];  
	[theApp run];	
	DESTROY (pool);
	return 0;
}

NSMenuItem *addItemToMenu(NSMenu *menu, NSString *str, 
																NSString *comm, NSString *sel, NSString *key)
{
	NSMenuItem *item = [menu addItemWithTitle: NSLocalizedString(str, comm)
												action: NSSelectorFromString(sel) keyEquivalent: key]; 
	return item;
}

void createMenu()
{
	NSMenu *mainmenu;
	NSMenu *menu;
	NSMenuItem *menuItem;
	
	// Main
	mainmenu = AUTORELEASE ([[NSMenu alloc] initWithTitle: @"System Preferences"]);
	
	// Info 	
	menuItem = addItemToMenu(mainmenu, @"Info", @"", nil, @"");
	menu = [NSMenu new];
	[mainmenu setSubmenu: menu forItem: menuItem];
	RELEASE (menu);
	addItemToMenu(menu, @"Info Panel...", @"", @"orderFrontStandardInfoPanel:", @"");
	addItemToMenu(menu, @"Help...", @"", nil, @"?"); 
  
	// Edit
	menuItem = addItemToMenu(mainmenu, @"Edit", @"", nil, @"");
	menu = [NSMenu new];
	[mainmenu setSubmenu: menu forItem: menuItem];	
	RELEASE (menu);
	addItemToMenu(menu, @"Cut", @"", @"cut:", @"x");
	addItemToMenu(menu, @"Copy", @"", @"copy:", @"c");
	addItemToMenu(menu, @"Paste", @"", @"paste:", @"v");
	addItemToMenu(menu, @"Select All", @"", @"selectAll:", @"a");
		
	// Windows
	menuItem = addItemToMenu(mainmenu, @"Windows", @"", nil, @"");
	menu = [NSMenu new];
	[mainmenu setSubmenu: menu forItem: menuItem];		
	RELEASE (menu);
	addItemToMenu(menu, @"Arrange in Front", @"", @"arrangeInFront:", @"");
	addItemToMenu(menu, @"Miniaturize Window", @"", @"performMiniaturize:", @"m");
	addItemToMenu(menu, @"Close Window", @"", @"performClose:", @"w");
  [[NSApplication sharedApplication] setWindowsMenu: menu];

	// Services 
	menuItem = addItemToMenu(mainmenu, @"Services", @"", nil, @"");
	menu = [NSMenu new];
	[mainmenu setSubmenu: menu forItem: menuItem];		
	RELEASE (menu);
	[[NSApplication sharedApplication] setServicesMenu: menu];

	// Hide
	addItemToMenu(mainmenu, @"Hide", @"", @"hide:", @"h");
	addItemToMenu(mainmenu, @"Hide Others", @"", @"hideOtherApplications:", @"H");
	addItemToMenu(mainmenu, @"Show All", @"", @"unhideAllApplications:", @"");
	
	// Quit
	addItemToMenu(mainmenu, @"Quit", @"", @"terminate:", @"q");

	[[NSApplication sharedApplication] setMainMenu: mainmenu];		
}
