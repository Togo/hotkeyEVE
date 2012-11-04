//
//  UIElementClickedController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "UIElementClickedController.h"
#import <UIElements/NullUIElement.h>
#import "HandleClickedUIElement.h"

@implementation UIElementClickedController

- (void) reveiceUIElementClick :(UIElement*) element {
  
  if (element.class != NullUIElement.class) {

    
    DDLogVerbose(@"Received Click on UI Element: %@", [[element owner] appName]);
    DDLogVerbose(@"Role: %@", [element role]);
    DDLogVerbose(@"Role Description: %@", [element roleDescription]);
    DDLogVerbose(@"Identifier: %@", [element uiElementIdentifier]);
    if([[element role] isEqualToString:(NSString*) kAXMenuItemRole]) {
      [HandleClickedUIElement handleMenuElement:element];
     }  else {
//      [HandleClickedUIElement handleGUIElement :element];
    }
  }
}

@end
