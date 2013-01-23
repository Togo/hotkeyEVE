//
//  EVEMessages.m
//  EVE
//
//  Created by Tobias Sommer on 10/8/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "GrowlNotifications.h"
#import <Growl/Growl.h>

@implementation GrowlNotifications

+ (id<IUserNotifications>) growNotifications {
  return [[GrowlNotifications alloc] init];
}

+ (void) maxEnabledAppsReachedInWindow :(NSWindow*) window {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"Buy EVE"];
  [alert addButtonWithTitle:@"Cancel"];
  [alert setMessageText:@"You are running the Lite Version."];
  [alert setInformativeText:@"Buy the Full Version to enable more Apps"];
  [alert setAlertStyle:0];
  
  NSInteger answer = [alert runModal];
  
  if (answer == 1000) {
    NSURL *url = [[NSURL alloc] initWithString:@"http://store.kagi.com/cgi-bin/store.cgi?storeID=6FJKK_LIVE"];
    [[NSWorkspace sharedWorkspace] openURL:url];
  }
}

+ (void) displayShortcutHintNotification :(UIElement*) element {
  DDLogInfo(@"EVEMessages -> displayShortcutMessage(element => :%@:) :: get called", element);

  NSMutableString *description = [[NSMutableString alloc] init];
  if ([[element help] length] > 0) {
    [description appendFormat:@"%@\n", [element help]];
    
  } else {
    [description appendFormat:@"%@\n", [element title]];
  }
  
//  [description appendFormat:@"(click show shortcut browser)"];
  
  NSMutableDictionary *clickContextDic = [[NSMutableDictionary alloc] init];
  [clickContextDic setValue:@"disable_shortcut" forKey:@"mesage_type"];
  [clickContextDic setValue:[[element owner] appName] forKey:APP_NAME_COL];
  [clickContextDic setValue:[[element owner] bundleIdentifier] forKey:BUNDLE_IDEN_COL];
  [clickContextDic setValue:[NSNumber numberWithInteger:[[element owner] appID]] forKey:ID_COL];
  [clickContextDic setValue:[element shortcutString] forKey:SHORTCUT_STRING_COL];
  [clickContextDic setValue:[element user] forKey:USER_NAME_COL];
  [clickContextDic setValue:[element title] forKey:TITLE_COL];
  
  DDLogInfo(@"EVEMessages -> displayShortcutMessage :: show growl message");
  DDLogInfo(@"EVEMessages -> displayShortcutMessage :: Message title => :%@:", [element shortcutString]);
  DDLogInfo(@"EVEMessages -> displayShortcutMessage :: Message description => :%@:", description);
  DDLogInfo(@"EVEMessages -> displayShortcutMessage :: clickContext => :%@:", clickContextDic);
  [GrowlApplicationBridge notifyWithTitle:[element shortcutString] description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:clickContextDic];
}

+ (void) displayGrowRegistrationNotification {
  NSMutableDictionary *clickContextDic = [[NSMutableDictionary alloc] init];
  [clickContextDic setValue:@"register_eve" forKey:@"mesage_type"];

  [GrowlApplicationBridge notifyWithTitle:@"Register EVE" description:@"to disable this message!" notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:clickContextDic];

}

+ (void) displayMultipleMatchesNotification :(NSString*) description {
  DDLogInfo(@"EVEMessages -> displayShortcutMessage(description => :%@:) :: get called", description);
  DDLogInfo(@"EVEMessages -> displayShortcutMessage:: show growl message");
  DDLogInfo(@"EVEMessages -> displayShortcutMessage :: clickContext => :%@:", nil);
  [GrowlApplicationBridge notifyWithTitle:@"Multiple Match" description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:nil];
}

+ (void) displayShortcutDisabledNotification :(NSDictionary*) clickContext {
  NSString* appName  = [clickContext  valueForKey:APP_NAME_COL];
  NSString* shortcut = [clickContext  valueForKey:SHORTCUT_STRING_COL];
  NSString* title    = [clickContext  valueForKey:TITLE_COL];
  
  NSMutableString *description = [NSMutableString string];
  [description appendFormat:@"%@ -> %@  \nin %@", title, shortcut, appName];

  [GrowlApplicationBridge notifyWithTitle:@"Shortcut Disabled!" description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:nil];
}

- (void) displayAppInstalledNotification :(NSString*) appName :(NSString*) user {
  NSString *title = [NSString stringWithFormat:@"%@ Install Succeeded", appName];
  NSString *description = [NSString stringWithFormat:@"I add the GUIElements from \"%@\" to HotkeyEVE!", user];
  [self display:title :description :nil];
}

- (void) display :(NSString*) title :(NSString*) description :(NSDictionary*) clickContext {
  [GrowlApplicationBridge notifyWithTitle:title description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:clickContext];
}

@end
