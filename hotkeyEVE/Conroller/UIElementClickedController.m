//
//  UIElementClickedController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "UIElementClickedController.h"


@implementation UIElementClickedController

- (void) reveiceUIElementClick :(UIElement*) element {
  DDLogInfo(@"Received Click on UI Element: %@", [[element owner] appName]);
  DDLogInfo(@"Role: %@", [element role]);
  DDLogInfo(@"Role Description: %@", [element roleDescription]);
  DDLogInfo(@"Identifier: %@", [element uiElementIdentifier]);
  // Check App Status
  // Check App Active
  // Check App GUI Element Active
  // if all yes display shortcut
}

@end
