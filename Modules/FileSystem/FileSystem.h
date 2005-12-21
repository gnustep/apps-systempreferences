/* FileSystem.h
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

#ifndef FILE_SYSTEM_H
#define FILE_SYSTEM_H

#include <Foundation/Foundation.h>
#ifdef __APPLE__
  #include <GSPreferencePanes/PreferencePanes.h>
#else
  #include <PreferencePanes/PreferencePanes.h>
#endif

enum {
  ONE_K,
  BYTES_512
};

@interface FileSystem : NSPreferencePane 
{
  IBOutlet id spaceTitle;
  IBOutlet id spaceLabel1;
  IBOutlet id spaceLabel2;
  IBOutlet id spaceLabel3;
  IBOutlet id spacePopup;
  
  IBOutlet id dotsTitle;
  IBOutlet id dotsLabel1;
  IBOutlet id dotsLabel2;
  IBOutlet id dotsLabel3;
  IBOutlet id dotsCheck;
  
  BOOL loaded;
}

- (IBAction)spacePopupAction:(id)sender;

- (IBAction)dotsCheckAction:(id)sender;

@end

#endif // FILE_SYSTEM_H

