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

@implementation HandleClickedUIElement

+ (void) handleMenuElement :(UIElement*) element {
  
  if ([[element shortcutString] length] ==  0)
    [MenuBarTableModel selectShortcutString:element];
  
    [self showMessage:element];
}


+ (void) showMessage :(UIElement*) element {
  NSInteger shortcutID = [ShortcutTableModel getShortcutId:[element shortcutString]];
  if ( (shortcutID != 0 )
      && ![self shortcutDisabled :element :shortcutID] ) {
    [EVEMessages displayShortcutMessage:element];
  }
}

+ (BOOL) shortcutDisabled :(UIElement*) element :(NSInteger) shortcutID {
  return [DisableShortcutsModel isShortcutDisabled :element :shortcutID];
}

@end
