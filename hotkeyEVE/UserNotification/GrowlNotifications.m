//
//  EVEMessages.m
//  EVE
//
//  Created by Tobias Sommer on 10/8/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "GrowlNotifications.h"
#import <Growl/Growl.h>
#import "NSDictionary+TGEVE_EventDictionary.h"

NSString * const TGEVE_GROWL_MULTIPLE_MATCH = @"MultipleMatchClickContext";

@implementation GrowlNotifications

+ (id<IUserNotifications>) growlNotifications {
  return [[GrowlNotifications alloc] init];
}

- (void) displaySingleShortcutHintNotification :(NSDictionary*) eventDictionary {
  DDLogInfo(@"EVEMessages -> displayShortcutMessage(dictionary => :%@:) :: get called", eventDictionary);
  
  NSString *notificationTitle = [eventDictionary valueForKey:TGEVE_KEY_SHORTCUT_STRING];
  
  NSMutableString *description = [[NSMutableString alloc] init];
  NSString *helpString = [eventDictionary valueForKey:TGEVE_KEY_HELP_STRING];
  if ( [helpString length] > 0 )
    [description appendFormat:@"%@\n", helpString];
  else
    [description appendString:[eventDictionary valueForKey:TGEVE_KEY_TITLE_STRING]];
  

  NSMutableDictionary *clickContextDic = [[NSMutableDictionary alloc] init];
  [clickContextDic setValue:@"disable_shortcut" forKey:@"mesage_type"];
  [clickContextDic setValue:eventDictionary  forKey:@"clickContextDic"];

  [GrowlApplicationBridge notifyWithTitle:notificationTitle description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:clickContextDic];
}


- (void) displayMultipleMatchesNotification :(NSArray*) eventShortcutList {
  NSMutableString *description = [NSMutableString string];
  for (id aShortcutHint in eventShortcutList) {
    [description appendFormat:@"%@ %@ - > %@\n",[aShortcutHint valueForKey:TGEVE_KEY_PARENT_TITLE_STRING], [aShortcutHint valueForKey:TGEVE_KEY_TITLE_STRING], [aShortcutHint valueForKey:TGEVE_KEY_SHORTCUT_STRING]];
  }
  NSMutableDictionary *clickContextDic = [[NSMutableDictionary alloc] init];
  [clickContextDic setValue:TGEVE_GROWL_MULTIPLE_MATCH forKey:@"mesage_type"];
  
  [GrowlApplicationBridge notifyWithTitle:@"Multiple Match" description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:clickContextDic];
}

- (void) displayRegisterEVEWithCallbackNotification :(NSString*) title :(NSString*) informativeText {
  NSMutableDictionary *clickContextDic = [[NSMutableDictionary alloc] init];
  [clickContextDic setValue:@"register_eve" forKey:@"mesage_type"];

  [GrowlApplicationBridge notifyWithTitle:title description:informativeText notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:clickContextDic];
}

+ (void) displayShortcutDisabledNotification :(NSDictionary*) clickContext {
  NSString* shortcut = [clickContext  valueForKey:TGEVE_KEY_SHORTCUT_STRING];
  NSString* title    = [clickContext  valueForKey:TGEVE_KEY_TITLE_STRING];
  
  NSMutableString *description = [NSMutableString string];
  [description appendFormat:@"%@ -> %@", title, shortcut];

  [GrowlApplicationBridge notifyWithTitle:@"Shortcut Disabled!" description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:nil];
}

- (void) displayAppInstalledNotification :(NSString*) appName :(NSString*) lang {
  NSString *title = [NSString stringWithFormat:@"%@ installed", appName];
  NSString *description = [NSString stringWithFormat:@"GUI support for %@ (%@) was sucessfully installed!", appName, lang];
  [self showTheNotification:title :description :nil];
}

- (void) displayAppRemovedNotification :(NSString*) appName :(NSString*) lang {
  NSString *title = [NSString stringWithFormat:@"%@ removed", appName];
  NSString *description = [NSString stringWithFormat:@"GUI support for %@ (%@) was removed", appName, lang];
  [self showTheNotification:title :description :nil];
}

- (void) showTheNotification :(NSString*) title :(NSString*) description :(NSDictionary*) clickContext {
  [GrowlApplicationBridge notifyWithTitle:title description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:clickContext];
}

@end
