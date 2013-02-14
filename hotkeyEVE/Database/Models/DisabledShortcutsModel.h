//
//  DisableShortcutsModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisabledShortcutsModel : NSObject

+ (void) disableShortcutWithStrings :(NSString*) appName :(NSString*) bundleIdentifier :(NSString*)shortcutString :(NSString*) user :(NSString*) elementTitle;
+ (void) disableShortcutWithEventDictionary :(NSDictionary*) eventShortcutDictionary;

+ (void) disableShortcut :(NSInteger) shortcutID :(NSInteger) appID :(NSString*) elementTitle;
+ (void) disableShortcutInAllApps :(NSInteger) shortcutID :(NSString*) title;
+ (void) disableShortcutsInNewApp :(Application*) app;

+ (void) enableShortcut :(NSInteger) shortcutID :(NSInteger) appID :(NSString*) title;
+ (void) enableShortcutInAllApps :(NSInteger) shortcutID :(NSString*) title;

+ (BOOL) isShortcutDisabled :(NSDictionary*) eventShortcutDic;
+ (BOOL) isShortcutDisabled :(UIElement*) element :(NSInteger) shortcutID;
+ (BOOL) isShortcutDisabled :(NSInteger) shortcutID :(NSInteger) appID  :(NSInteger) userID :(NSString*) title;
@end
