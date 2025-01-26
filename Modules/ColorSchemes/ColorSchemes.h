/* ColorSchemes.h
 *  
 * Copyright (C) 2006 Free Software Foundation, Inc.
 *
 * Author: Riccardo Mottola <riccardo@kaffe.org>
 * Date: September 2006
 *
 * Original idea from Preferences.app by Jeff Teunissen 
 * of the Backbone project
 *
 * This file is part of the GNUstep ColorSchemes Preference Pane
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

#ifndef COLORSCHEMES_H
#define COLORSCHEMES_H

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include "PreferencePanes.h"
#import "PreviewView.h"

@interface ColorSchemes : NSPreferencePane
{
    IBOutlet PreviewView   *preview;
    IBOutlet NSPopUpButton *colorSettings;
    IBOutlet NSPopUpButton *style;
    IBOutlet NSColorWell   *colorWell;

    NSDictionary *dictSchemes;
    NSDictionary *currScheme;
    NSColorList  *currColorList;
    BOOL         loaded;
}


- (IBAction)styleAction:(id)sender;
- (IBAction)settingsAction:(id)sender;
- (IBAction)apply:(id)sender;
- (IBAction)colorChanged:(id)sender;

@end

#endif	// COLORSCHEMES_H
