//
//  GrowlController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "GrowlController.h"
#import "DisableShortcutsModel.h"

@implementation GrowlController

// a Growl delegate method, called when a notification is clicked. Check the value of the clickContext argument to determine what to do
- (void) growlNotificationWasClicked:(id) clickedContext {
  if (clickedContext != nil) {
    if ([[clickedContext valueForKey:@"mesage_type"] isEqualToString:@"disable_shortcut"]) {
      NSString *appName = [clickedContext valueForKey:@"appName"];
      NSString *bundleIdentifier = [clickedContext valueForKey:@"BundleIdentifier"];
      NSString *shortcutString = [clickedContext valueForKey:@"ShortcutString"];
      NSString *user = [clickedContext valueForKey:@"User"];
      
      [DisableShortcutsModel disableShortcut :appName :bundleIdentifier :shortcutString :user];
    }
  }
}

@end
