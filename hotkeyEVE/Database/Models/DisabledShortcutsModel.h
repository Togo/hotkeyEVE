//
//  DisableShortcutsModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisabledShortcutsModel : NSObject

+ (void) disableShortcut :appName :bundleIdentifier :shortcutString :user;
+ (void) disableShortcut :(NSInteger) shortcutID :(NSInteger) appID  :(NSInteger) userID;
+ (void) disableShortcutInAllApps :(NSInteger) shortcutID;

+ (void) enableShortcut :(NSInteger) shortcutID :(NSInteger) appID  :(NSInteger) userID;
+ (void) enableShortcutInAllApps :(NSInteger) shortcutID;

+ (BOOL) isShortcutDisabled :(UIElement*) element :(NSInteger) shortcutID;
+ (BOOL) isShortcutDisabled :(NSInteger) shortcutID :(NSInteger) appID  :(NSInteger) userID;
@end
