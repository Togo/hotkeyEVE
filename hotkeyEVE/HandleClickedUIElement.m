//
//  HandleClickedUIElement.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "HandleClickedUIElement.h"
#import "GrowlNotifications.h"
#import "MenuBarTableModel.h"
#import "ShortcutTableModel.h"
#import "DisabledShortcutsModel.h"
#import "DisplayedShortcutsModel.h"
#import "GUIElementsTableModel.h"

@implementation HandleClickedUIElement

+ (BOOL) handleMenuElement :(UIElement*) element {
  DDLogInfo(@"HandleClickedUIElement -> handleMenuElement(element => :%@: :: get called.", element);
  BOOL messageDisplayed = NO;
  
  if ([[element shortcutString] length] ==  0) {
    DDLogInfo(@"HandleClickedUIElement -> handleMenuElement :: no shortcutString in element found");
    DDLogInfo(@"HandleClickedUIElement -> handleMenuElement :: try to select a shortcut string in the %@ ", MENU_BAR_ITEMS_TABLE);
    element.shortcutString = [MenuBarTableModel selectShortcutString:element];
  
    // Nothing found, try it with fts
    if ([[element shortcutString] length] ==  0) {
      DDLogInfo(@"HandleClickedUIElement -> handleMenuElement :: search with the identifier in the %@ Table", MENU_BAR_SEARCH_TABLE);
      NSArray *results = [MenuBarTableModel searchInMenuBarTable:element];
      if ([results count] == 1) {
        element.shortcutString = [[results objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL];
      }  else if ([results count] > 1) {
        messageDisplayed = [self showMultipleMatchMessage :results];
      }
    }
  }
  
  // check maybe it's a multiple message try to show message
  if (!messageDisplayed) {
    messageDisplayed = [self showMessage:element];
  }
  
  DDLogInfo(@"HandleClickedUIElement -> handleMenuElement :: Finished UIElement => %@", element);
 return messageDisplayed;
}

+ (BOOL) handleGUIElement :(UIElement*) element {
  DDLogInfo(@"HandleClickedUIElement -> handleGUIElement(element => :%@: :: get called", element);
  
  [GUIElementsTableModel editGUIElement:element];
  
  return [self showMessage:element];
}

+ (BOOL) showMessage :(UIElement*) element {
  DDLogInfo(@"HandleClickedUIElement -> showMessage(element => :%@:) :: getCalled", element);
  NSInteger shortcutID = 0;
  if ( [[element shortcutString] length] > 0) {
     shortcutID = [ShortcutTableModel getShortcutId:[element shortcutString]];
    if (![self shortcutDisabled :element :shortcutID]
        && [self timeIntevallOk :shortcutID]) {
      [GrowlNotifications displayShortcutHintNotification:element];
      [DisplayedShortcutsModel insertDisplayedShortcut :element :shortcutID];
      return YES;
    }
  }
  return NO;
}

+ (BOOL) showMultipleMatchMessage :(NSArray*) results {
  DDLogInfo(@"HandleClickedUIElement -> showMultipleMatchMessage(results => :%@:) :: getCalled", results);
  NSMutableString *content = [NSMutableString string];
  for (id aRow in results) {
    NSString *shortcutString = [ShortcutTableModel getShortcutString:[[aRow valueForKey:SHORTCUT_ID_COL] intValue]];
    NSString *title = [aRow valueForKey:TITLE_COL];
    [content appendFormat:@"%@ - %@ \n", title, shortcutString];
//    [content appendFormat:@"%@ - %@ - %@ \n", parentTitle, title, shortcutString];
  }
  
  [GrowlNotifications displayMultipleMatchesNotification :content];
  
  return YES;
}

+ (BOOL) shortcutDisabled :(UIElement*) element :(NSInteger) shortcutID {
  return [DisabledShortcutsModel isShortcutDisabled :element :shortcutID];
}

+ (BOOL) timeIntevallOk :(NSInteger) shortcutID {
  return [DisplayedShortcutsModel checkShortcutTimeIntervall :shortcutID];
}


@end
