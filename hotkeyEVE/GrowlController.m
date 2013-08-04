//
//  GrowlController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "GrowlController.h"
#import "DisabledShortcutsModel.h"
#import "EVEUtilities.h"
#import "GrowlNotifications.h"
#import "NSDictionary+TGEVE_EventDictionary.h"

@implementation GrowlController

// a Growl delegate method, called when a notification is clicked. Check the value of the clickContext argument to determine what to do
- (void) growlNotificationWasClicked :(id) clickedContext {
  DDLogInfo(@"GrowlController -> growlNotificationWasClicked(clickContext :%@:) :: get called", clickedContext);
  if (clickedContext != nil) {
    if ([[clickedContext valueForKey:@"mesage_type"] isEqualToString:@"disable_shortcut"]) {

      [DisabledShortcutsModel disableShortcutWithEventDictionary:[clickedContext valueForKey:@"clickContextDic"]];
      [GrowlNotifications displayShortcutDisabledNotification :[clickedContext valueForKey:@"clickContextDic"]];

      return;
    }
    
    if ([[clickedContext valueForKey:@"mesage_type"] isEqualToString:TGEVE_GROWL_MULTIPLE_MATCH] ) {
      [[[EVEManager sharedEVEManager] mainMenuController] showShortcutsWindow:nil];
    }
    
    if ([[clickedContext valueForKey:@"mesage_type"] isEqualToString:@"register_eve"]) {
      [EVEUtilities openWebShop];
      return;
    }
  }
}

@end
