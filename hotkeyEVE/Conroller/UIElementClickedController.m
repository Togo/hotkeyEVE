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
#import "ApplicationsTableModel.h"

@implementation UIElementClickedController

@synthesize messageCount;

- (void) reveicedUIElementClick :(UIElement*) element {
  DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick(element => :%@:) :: get called ", element);
  Application *lastActiveApp =  [[EVEManager sharedEVEManager] lastActiveApp];
  // Update Status Icon
  if( ![[[element owner] bundleIdentifier] isEqualToString:[lastActiveApp bundleIdentifier]] ) {
   BOOL appWithGUISupport = [GUISupportTableModel hasGUISupport:[[element owner] bundleIdentifier]];
    [[[EVEManager sharedEVEManager] mainMenuController] updateStatusIcon:appWithGUISupport];
    Application *activeApp = [element owner];
    activeApp.guiSupport = appWithGUISupport;
    activeApp.appID = [ApplicationsTableModel getApplicationID:[activeApp appName] :[activeApp bundleIdentifier]];
    lastActiveApp = activeApp;
    [[EVEManager sharedEVEManager] setLastActiveApp:lastActiveApp];
  }
  
  DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick :: guiSupport :%i:", [lastActiveApp guiSupport]);
  
  DDLogInfo(@"********************************************************");
  DDLogInfo(@"Role => %@", [element role]);
  DDLogInfo(@"Role Description => %@", [element roleDescription]);
  DDLogInfo(@"Title => %@", [element title]);
  DDLogInfo(@"ParentTitle => %@", [element parentTitle]);
  DDLogInfo(@"Identifier => %@", [element uiElementIdentifier]);
  DDLogInfo(@"*********************************************************");
  
  if (element.class != NullUIElement.class) {
    BOOL messageDisplayed = NO;
    DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick :: receive click with element => :%@:", element);
    if([[element role] isEqualToString:(NSString*) kAXMenuItemRole]) {
      messageDisplayed = [HandleClickedUIElement handleMenuElement:element];
     }  else if ([lastActiveApp guiSupport] == YES) {
       // check gui support
      messageDisplayed = [HandleClickedUIElement handleGUIElement :element];
    }
    
    if (messageDisplayed) {
      messageCount++;
      if (messageCount >= 7
          && ![[[EVEManager sharedEVEManager] licence] isValid]) {
        messageCount = 0;
        [EVEMessages showGrowRegistrationMessage];
      }
    }
  }
}

@end
