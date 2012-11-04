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

@implementation HandleClickedUIElement

+ (void) handleMenuElement :(UIElement*) element {
  if ([[element shortcutString] length] ==  0)
    [MenuBarTableModel selectShortcutString:element];
  
  if([[element shortcutString] length] > 0)
    [EVEMessages displayShortcutMessage:element];
}

@end
