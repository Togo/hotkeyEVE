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
#import "EVEMessages.h"

@implementation GrowlController

// a Growl delegate method, called when a notification is clicked. Check the value of the clickContext argument to determine what to do
- (void) growlNotificationWasClicked:(id) clickedContext {
  if (clickedContext != nil) {
    if ([[clickedContext valueForKey:@"mesage_type"] isEqualToString:@"disable_shortcut"]) {
      NSString *appName = [clickedContext valueForKey:@"appName"];
      NSString *bundleIdentifier = [clickedContext valueForKey:@"BundleIdentifier"];
      NSString *shortcutString = [clickedContext valueForKey:@"ShortcutString"];
      NSString *user = [clickedContext valueForKey:@"User"];
      NSString *title = [clickedContext valueForKey:@"element_title"];
      
      [DisabledShortcutsModel disableShortcutWithStrings :appName :bundleIdentifier :shortcutString :user :title];
      [EVEMessages showShortcutDisabledMessage :clickedContext];
      return;
    }
    
    if ([[clickedContext valueForKey:@"mesage_type"] isEqualToString:@"register_eve"]) {
      [EVEUtilities openWebShop];
      return;
    }
  }
}

@end
