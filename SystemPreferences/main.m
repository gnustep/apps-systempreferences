#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "SystemPreferences.h"

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
	addItemToMenu(menu, @"Info Panel...", @"", @"runInfoPanel:", @"");
	addItemToMenu(menu, @"Help...", @"", nil, @"?"); 
  
	// Edit
	menuItem = addItemToMenu(mainmenu, @"Edit", @"", nil, @"");
	menu = [NSMenu new];
	[mainmenu setSubmenu: menu forItem: menuItem];	
  RELEASE (menu);
	addItemToMenu(menu, @"Cut", @"", @"cut:", @"x");
	addItemToMenu(menu, @"Copy", @"", @"copy:", @"c");
	addItemToMenu(menu, @"Paste", @"", @"paste:", @"v");
		
	// Windows
	menuItem = addItemToMenu(mainmenu, @"Windows", @"", nil, @"");
	menu = [NSMenu new];
	[mainmenu setSubmenu: menu forItem: menuItem];		
  RELEASE (menu);
	addItemToMenu(menu, @"Arrange in Front", @"", nil, @"");
	addItemToMenu(menu, @"Miniaturize Window", @"", nil, @"");
	addItemToMenu(menu, @"Close Window", @"", @"closeMainWindow:", @"w");
  [[NSApplication sharedApplication] setWindowsMenu: menu];

	// Services 
	menuItem = addItemToMenu(mainmenu, @"Services", @"", nil, @"");
	menu = AUTORELEASE ([NSMenu new]);
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
