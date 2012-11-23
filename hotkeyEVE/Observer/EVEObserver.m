//
//  UIElementUpdatedObserver.m
//  eve-guireader
//
//  Created by Tobias Sommer on 10/24/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "EVEObserver.h"
#import <UIElements/ClickOnUIElementSubject.h>
#import <UIElements/UIElement.h>

@implementation EVEObserver

@synthesize subscribedNotifications;

- (id) init {
  self = [super init];
  
  subscribedNotifications = [NSMutableArray array];
  
  return self;
}

- (void) update :(NSNotification *) notification {
  DDLogInfo(@"EVEObserver -> update(notification :%@:) :: get called", [notification name]);
  if ([[notification name] isEqualToString:ClickOnUIElementNotification]) {
    UIElement *lastCLickedUIElement =  [UIElement createUIElement:([[notification object] currentUIElement])];
    DDLogInfo(@"EVEObserver -> update() :: create new UIElement :%@:", lastCLickedUIElement);
    [[[EVEManager sharedEVEManager] uiElementClicked] reveicedUIElementClick:lastCLickedUIElement];
    return;
  }

  if ( [[notification name] isEqualToString:NSWorkspaceDidLaunchApplicationNotification] )  {
   NSDictionary *dic = [notification userInfo];

   [[[EVEManager sharedEVEManager] appLaunched] newAppLaunched :[dic valueForKey:@"NSApplicationBundleIdentifier"]];
    return;
  }
}

- (void) dealloc {
  for (NSString *aNotification in subscribedNotifications) {
    [self removeNotificationObserver:aNotification];
  }
}

- (void) subscribeToNotificiation :(NSString*) notificationName {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(update:)
                                               name:notificationName object:nil];
//  [subscribedNotifications setValue:notificationName forKey:notificationName];
}

- (void) subscribeToGlobalNotificiation :(NSString*) notificationName {
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                           selector:@selector(update:)
                                               name:notificationName object:nil];
//  [subscribedNotifications setValue:notificationName forKey:notificationName];
}


- (void) unsuscribeNotificiation :(NSString*) notificationName {
  [self removeNotificationObserver :(NSString*) notificationName];
//  [subscribedNotifications removeObjectForKey:notificationName];
}

- (void) unsuscribeGlobalNotificiation :(NSString*) notificationName {
  [self removeGlobalNotificationObserver :(NSString*) notificationName];
//  [subscribedNotifications removeObjectForKey:notificationName];
}


- (void) removeNotificationObserver :(NSString*) notificationName {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:notificationName
                                                object:nil];
}

- (void) removeGlobalNotificationObserver :(NSString*) notificationName {
  [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
                                                  name:notificationName
                                              object:nil];
}


- (void) subscribeAllNotifications {
  [self subscribeToNotificiation:ClickOnUIElementNotification];
  DDLogInfo(@"Subscribed %@", ClickOnUIElementNotification);
  
  [self subscribeToGlobalNotificiation:NSWorkspaceDidLaunchApplicationNotification];
  DDLogInfo(@"Subscribed %@", NSWorkspaceDidLaunchApplicationNotification);
}

- (void) unSubscribeAllNotifications {
  [self unsuscribeNotificiation:ClickOnUIElementNotification];
  DDLogInfo(@"UnSubscribed %@", ClickOnUIElementNotification);
  
  [self unsuscribeGlobalNotificiation:NSWorkspaceDidLaunchApplicationNotification];
  DDLogInfo(@"UnSubscribed %@", NSWorkspaceDidLaunchApplicationNotification);
}

@end
