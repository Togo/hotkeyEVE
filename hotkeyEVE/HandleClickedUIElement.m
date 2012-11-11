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
#import "DisabledShortcutsModel.h"
#import "DisplayedShortcutsModel.h"
#import "GUIElementsTable.h"

@implementation HandleClickedUIElement

+ (BOOL) handleMenuElement :(UIElement*) element {
  BOOL messageDisplayed = NO;
  if ([[element shortcutString] length] ==  0) {
    element.shortcutString = [MenuBarTableModel selectShortcutString:element];
  
    // Nothing found, try it with fts
    if ([[element shortcutString] length] ==  0) {
      NSArray *results = [MenuBarTableModel searchInMenuBarTable:element];
      if ([results count] == 1) {
        element.shortcutString = [[results objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL];
      messageDisplayed = [self showMessage:element];
      }  else if ([results count] > 1) {
      messageDisplayed = [self showMultipleMatchMessage :results];
      }
    }
  } else {
      messageDisplayed = [self showMessage:element];
  }
  
 return messageDisplayed;
}

+ (BOOL) handleGUIElement :(UIElement*) element {
  
  [GUIElementsTable editGUIElement:element];
  
  return [self showMessage:element];
}

+ (BOOL) showMessage :(UIElement*) element {
  NSInteger shortcutID = 0;
  if ( [[element shortcutString] length] > 0) {
     shortcutID = [ShortcutTableModel getShortcutId:[element shortcutString]];
    if (![self shortcutDisabled :element :shortcutID]
        && [self timeIntevallOk :shortcutID]) {
      [EVEMessages displayShortcutMessage:element];
      [DisplayedShortcutsModel insertDisplayedShortcut:element];
      return YES;
    }
  }
  return NO;
}

+ (BOOL) showMultipleMatchMessage :(NSArray*) results {
  NSMutableString *content = [NSMutableString string];
  for (id aRow in results) {
    NSString *shortcutString = [ShortcutTableModel getShortcutString:[[aRow valueForKey:SHORTCUT_ID_COL] intValue]];
    NSString *title = [aRow valueForKey:TITLE_COL];
    NSString *parentTitle = [aRow valueForKey:PARENT_TITLE_COL];
    [content appendFormat:@"%@ - %@ - %@ \n", parentTitle, title, shortcutString];
  }
  
  [EVEMessages displayMultipleMatchesMessage :content];
  
  return YES;
}

+ (BOOL) shortcutDisabled :(UIElement*) element :(NSInteger) shortcutID {
  return [DisabledShortcutsModel isShortcutDisabled :element :shortcutID];
}

+ (BOOL) timeIntevallOk :(NSInteger) shortcutID {
  return [DisplayedShortcutsModel checkShortcutTimeIntervall :shortcutID];
}


@end
