//
//  UserNotifications.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/23/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIElements/UIElement.h>

/* Notification Methods starts with displayXXXXNotification */

@protocol IUserNotifications <NSObject>

+ (void) displayShortcutHintNotification :(UIElement*) element;
+ (void) displayMultipleMatchesNotification :(NSString*) description;

+ (void) displayShortcutDisabledNotification :(NSDictionary*) clickContext;

+ (void) displayGrowRegistrationNotification;

- (void) displayAppInstalledNotification :(NSString*) appName :(NSString*) user;
- (void) displayAppRemovedNotification :(NSString*) appName :(NSString*) user;
- (void) showTheNotification :(NSString*) title :(NSString*) description :(NSDictionary*) clickContext;

@end
