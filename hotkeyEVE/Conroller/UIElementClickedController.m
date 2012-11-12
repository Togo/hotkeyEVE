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
#import "GUISupportTableModel.h"
#import "DisplayedShortcutsModel.h"
#import "EVEMessages.h"

@implementation UIElementClickedController

@synthesize messageCount;
@synthesize lastActiveApp;

- (void) reveicedUIElementClick :(UIElement*) element {
  // Update Status Icon
  if( ![[[element owner] bundleIdentifier] isEqualToString:[lastActiveApp bundleIdentifier]] ) {
   BOOL appWithGUISupport = [GUISupportTableModel hasGUISupport:[[element owner] bundleIdentifier]];
    [[[EVEManager sharedEVEManager] mainMenuController] updateStatusIcon:appWithGUISupport];
    lastActiveApp = [element owner];
    lastActiveApp.guiSupport = appWithGUISupport;
  }
  
  if (element.class != NullUIElement.class) {
    BOOL messageDisplayed = NO;
    DDLogVerbose(@"Received Click on UI Element: %@", [[element owner] appName]);
    DDLogVerbose(@"Role: %@", [element role]);
    DDLogVerbose(@"Role Description: %@", [element roleDescription]);
    DDLogVerbose(@"Identifier: %@", [element uiElementIdentifier]);
    if([[element role] isEqualToString:(NSString*) kAXMenuItemRole]) {
      messageDisplayed = [HandleClickedUIElement handleMenuElement:element];
     }  else if ([lastActiveApp guiSupport] == YES) {
       // check gui support
      messageDisplayed = [HandleClickedUIElement handleGUIElement :element];
    }
    
    if (messageDisplayed) {
      messageCount++;
      if (messageCount >= 10
          && ![[[EVEManager sharedEVEManager] licence] isValid]) {
        messageCount = 0;
        [EVEMessages showGrowRegistrationMessage];
      }
    }
  }
}

@end
