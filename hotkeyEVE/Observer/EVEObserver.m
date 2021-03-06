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
#import "TGEVE_MouseEventHandler.h"
#import <UIElements/UIElementUtilities_org.h>

@implementation EVEObserver

@synthesize subscribedNotifications;

- (id) init {
  self = [super init];
  
  subscribedNotifications = [NSMutableDictionary dictionary];
  
  return self;
}

- (void) update :(NSNotification *) notification {
  DDLogInfo(@"EVEObserver -> update(notification :%@:) :: get called", [notification name]);

if([[notification name] isEqualToString :ClickOnUIElementNotification]) {
    AXUIElementRef elementRef = [[notification object] currentUIElement];
    if(     elementRef != NULL
        && ![self isInWebArea :elementRef] ) {
      
    UIElement *lastCLickedUIElement =  [UIElement createUIElement:elementRef];
    DDLogInfo(@"EVEObserver -> update() :: create new UIElement :%@:", lastCLickedUIElement);
    
    id eventHandler = [[TGEVE_MouseEventHandler alloc] init];
    [eventHandler handleEVEEvent:lastCLickedUIElement];
    
    }
  return;
  }

  if ( [[notification name] isEqualToString:NSWorkspaceDidLaunchApplicationNotification] )  {
   NSDictionary *dic = [notification userInfo];

   [[[EVEManager sharedEVEManager] appLaunched] newAppLaunched :[dic valueForKey:@"NSApplicationBundleIdentifier"]];
    return;
  }
  
  if ( [[notification name] isEqualToString:NSWorkspaceDidActivateApplicationNotification] )  {
    NSDictionary *dic = [notification userInfo];
    NSString *bundleIdentifier = [[dic valueForKey:@"NSWorkspaceApplicationKey"] bundleIdentifier];
    [[[EVEManager sharedEVEManager] appChangedController] appFrontChanged :bundleIdentifier];
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
  DDLogInfo(@"EVEObserver -> subscribeAllNotifications() :: get called");

  [self subscribeToNotificiation:ClickOnUIElementNotification];
  DDLogInfo(@"EVEObserver -> subscribeAllNotifications() :: get subscribed => :%@:", ClickOnUIElementNotification);
  
  [self subscribeToGlobalNotificiation:NSWorkspaceDidLaunchApplicationNotification];
  DDLogInfo(@"EVEObserver -> subscribeAllNotifications() :: get subscribed => :%@:", NSWorkspaceDidLaunchApplicationNotification);


  [self subscribeToGlobalNotificiation:NSWorkspaceDidActivateApplicationNotification];
  DDLogInfo(@"Subscribed %@", NSWorkspaceDidActivateApplicationNotification);
}

- (void) unSubscribeAllNotifications {
  [self unsuscribeNotificiation:ClickOnUIElementNotification];
  DDLogInfo(@"UnSubscribed %@", ClickOnUIElementNotification);
  
  [self unsuscribeGlobalNotificiation:NSWorkspaceDidLaunchApplicationNotification];
  DDLogInfo(@"UnSubscribed %@", NSWorkspaceDidLaunchApplicationNotification);
}

- (BOOL) isInWebArea :(AXUIElementRef) elementRef {
    NSString *uiElementTree = [UIElementUtilities_org lineageDescriptionOfUIElement:elementRef];
  if ([uiElementTree rangeOfString:@"AXWebArea" options:NSCaseInsensitiveSearch].location == NSNotFound) {
    return NO;
  } else {
    DDLogInfo(@"EVEObserver -> isInWebArea() ::is InWebArea skip this click");
    return YES;
  }
}

@end
