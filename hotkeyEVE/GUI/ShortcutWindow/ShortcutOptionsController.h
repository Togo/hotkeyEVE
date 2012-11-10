//
//  BoxController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortcutOptionsController : NSObject {
  @private
  __unsafe_unretained NSTextField *_enabledDisabledTextField;
  __unsafe_unretained NSButton *_enabledDisableButton;
  __unsafe_unretained NSButton *_enableAllAppsButton;
  __unsafe_unretained NSButton *_disabledAllAppsButton;
  __unsafe_unretained NSTextField *_shortcutStringTextField;
}

@property (unsafe_unretained) IBOutlet NSTextField *enabledDisabledTextField;
@property (unsafe_unretained) IBOutlet NSButton *enabledDisableButton;
@property (unsafe_unretained) IBOutlet NSButton *enableAllAppsButton;
@property (unsafe_unretained) IBOutlet NSButton *disabledAllAppsButton;

@property (strong) NSDictionary *selectedShortcut;

@property (unsafe_unretained) IBOutlet NSTextField *shortcutStringTextField;
@end
