//
//  DisableShortcutsModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisableShortcutsModel : NSObject

+ (void) disableShortcut :appName :bundleIdentifier :shortcutString :user;
+ (BOOL) isShortcutDisabled :(UIElement*) element :(NSInteger) shortcutID;

@end
