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

- (void) update :(NSNotification *)notification {
  if ([[notification name] isEqualToString:ClickOnUIElementNotification]) {
    UIElement *lastCLickedUIElement =  [UIElement createUIElement:([[notification object] currentUIElement])];
    [[[EVEManager sharedEVEManager] uiElementClicked] reveiceUIElementClick:lastCLickedUIElement];
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
  [subscribedNotifications setValue:notificationName forKey:notificationName];
}

- (void) unsuscribeNotificiation :(NSString*) notificationName {
  [self removeNotificationObserver :(NSString*) notificationName];
  [subscribedNotifications removeObjectForKey:notificationName];
}

- (void) removeNotificationObserver :(NSString*) notificationName {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:notificationName
                                                object:nil];
}

@end
