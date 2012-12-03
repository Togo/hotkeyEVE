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
#import "StringUtilities.h"
#import "EVEUtilities.h"

@implementation UIElementClickedController

@synthesize messageCount;

- (void) reveicedUIElementClick :(UIElement*) element {
  DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick(element => :%@:) :: get called ", element);
  DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick() :: guiSupport? => :%i: ", [[EVEUtilities activeApplication] guiSupport]);
  
  DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick :: \n%@", [StringUtilities printUIElement:element]);
  
  DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick :: ");
  if (element.class != NullUIElement.class) {
    BOOL messageDisplayed = NO;
    element.owner.appID = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];
    DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick :: receive click with element => :%@:", element);
    if([[element role] isEqualToString:(NSString*) kAXMenuItemRole]) {
      messageDisplayed = [HandleClickedUIElement handleMenuElement:element];
     }  else if ([[EVEUtilities activeApplication] guiSupport] == YES) {
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
  DDLogInfo(@"UIElementClickedController -> reveicedUIElementClick :: end method");
}

@end
