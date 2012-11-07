//
//  HandleClickedUIElement.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "HandleClickedUIElement.h"
#import "EVEMessages.h"
#import "MenuBarTableModel.h"
#import "ShortcutTableModel.h"
#import "DisableShortcutsModel.h"
#import "DisplayedShortcutsModel.h"
#import "GUIElementsTable.h"

@implementation HandleClickedUIElement

+ (void) handleMenuElement :(UIElement*) element {

  if ([[element shortcutString] length] ==  0) {
    element.shortcutString = [MenuBarTableModel selectShortcutString:element];
  }
  
  // Nothing found, try it with fts
  if ([[element shortcutString] length] ==  0) {
    NSArray *results = [MenuBarTableModel searchInMenuBarTable:element];
    if ([results count] == 1) {
      element.shortcutString = [[results objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL];
     [self showMessage:element];
    }  else if ([results count] > 1) {
      // Wes noch net wie ich das mach
    }
  }
  
 [self showMessage:element];
}

+ (void) handleGUIElement :(UIElement*) element {
  
  element.shortcutString = [GUIElementsTable selectShortcutString:element];
  
  [self showMessage:element];
}

+ (void) showMessage :(UIElement*) element {
  NSInteger shortcutID = 0;
  if ( [[element shortcutString] length] > 0) {
     shortcutID = [ShortcutTableModel getShortcutId:[element shortcutString]];
    if (![self shortcutDisabled :element :shortcutID]
        && [self timeIntevallOk :shortcutID]) {
      [EVEMessages displayShortcutMessage:element];
      [DisplayedShortcutsModel insertDisplayedShortcut:element];
    }
  }
}

+ (BOOL) shortcutDisabled :(UIElement*) element :(NSInteger) shortcutID {
  return [DisableShortcutsModel isShortcutDisabled :element :shortcutID];
}

+ (BOOL) timeIntevallOk :(NSInteger) shortcutID {
  return [DisplayedShortcutsModel checkShortcutTimeIntervall :shortcutID];
}


@end
