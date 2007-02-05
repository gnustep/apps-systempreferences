/* Volumes.h
 *  
 * Copyright (C) 2005 Free Software Foundation, Inc.
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

#ifndef VOLUMES_H
#define VOLUMES_H

#include <Foundation/Foundation.h>
#include "PreferencePanes.h"

@class NSMatrix;

@interface Volumes : NSPreferencePane 
{
  IBOutlet id mtypeTitle;
  IBOutlet id mtypeLabel1;
  IBOutlet id mtypeLabel2;
  IBOutlet id mtypeScroll;
  NSMatrix *mtypeMatrix;
  IBOutlet id mtypeField;
  IBOutlet id mtypeAdd;
  IBOutlet id mtypeRemove;
  IBOutlet id mtypeRevert;
  IBOutlet id mtypeSet;
  NSMutableArray *reservedNames;
  
  IBOutlet id mpointTitle;
  IBOutlet id mpointLabel1;
  IBOutlet id mpointLabel2;
  IBOutlet id mpointScroll;
  NSMatrix *mpointMatrix;
  IBOutlet id mpointField;
  IBOutlet id mpointAdd;
  IBOutlet id mpointRemove;
  IBOutlet id mpointRevert;
  IBOutlet id mpointSet;
  NSMutableArray *removablePaths;
  
  IBOutlet id mtabTitle;
  IBOutlet id mtabLabel1;
  IBOutlet id mtabLabel2;
  IBOutlet id mtabLabel3;
  IBOutlet id mtabField;
  IBOutlet id mtabSet;
  
  BOOL loaded;
  
  NSFileManager *fm;
}

- (IBAction)mtypeButtAction:(id)sender;

- (void)mtypeMatrixAction:(id)sender;

- (IBAction)mpointButtAction:(id)sender;

- (void)mpointMatrixAction:(id)sender;

- (IBAction)mtabButtAction:(id)sender;

- (NSArray *)reservedMountNames;

- (NSArray *)removableMediaPaths;

- (NSString *)mtabPath;

@end

#endif // VOLUMES_H

