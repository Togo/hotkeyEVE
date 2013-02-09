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

@implementation GrowlController

// a Growl delegate method, called when a notification is clicked. Check the value of the clickContext argument to determine what to do
- (void) growlNotificationWasClicked :(id) clickedContext {
  if (clickedContext != nil) {
    if ([[clickedContext valueForKey:@"mesage_type"] isEqualToString:@"disable_shortcut"]) {
      NSString *appName = [clickedContext valueForKey:APP_NAME_COL];
      NSString *bundleIdentifier = [clickedContext valueForKey:BUNDLE_IDEN_COL];
      NSString *shortcutString = [clickedContext valueForKey:SHORTCUT_STRING_COL];
      NSString *user = [clickedContext valueForKey:USER_NAME_COL];
      NSString *title = [clickedContext valueForKey:TITLE_COL];
      
      [DisabledShortcutsModel disableShortcutWithStrings :appName :bundleIdentifier :shortcutString :user :title];
      [GrowlNotifications displayShortcutDisabledNotification :clickedContext];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:SelectActiveApplication object:[EVEUtilities activeApplication]];
      [[NSNotificationCenter defaultCenter] postNotificationName:ShortcutsWindowApplicationDidChanged object:clickedContext];
      [[NSNotificationCenter defaultCenter] postNotificationName:SelectNotificationDisabledShortcutRow object:clickedContext];

      return;
    }
    
    if ([[clickedContext valueForKey:@"mesage_type"] isEqualToString:@"register_eve"]) {
      [EVEUtilities openWebShop];
      return;
    }
  }
}

@end
