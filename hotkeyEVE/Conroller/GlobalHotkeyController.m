//
//  GlobalHotkeyController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/23/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "GlobalHotkeyController.h"
#import "DDHotKeyCenter.h"

@implementation GlobalHotkeyController

- (void) registerGlobalHotkeys {
  DDLogInfo(@"GlobalHotkeyController -> registerGlobalHotkeys() :: get called ");
  
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	if (![c registerHotKeyWithKeyCode:1 modifierFlags:(NSCommandKeyMask | NSShiftKeyMask | NSControlKeyMask) target:self action:@selector(hotkeyEventOpenShortcutBrowser:) object:nil]) {
		DDLogError(@"GlobalHotkeyController -> registerGlobalHotkeys() :: unable to register hotkey ");
	} else {
    DDLogInfo(@"GlobalHotkeyController -> registerGlobalHotkeys() :: succesfully  hotkeyEventOpenShortcutBrowser ");
    DDLogInfo(@"GlobalHotkeyController -> registerGlobalHotkeys() :: %@ ", [NSString stringWithFormat:@"Registered: %@", [c registeredHotKeys]]);
	}
}

- (void) hotkeyEventOpenShortcutBrowser :(id) sender {
  DDLogInfo(@"GlobalHotkeyController -> hotkeyEventOpenShortcutBrowser(sender :%@:) :: get called ", sender);
  [[[EVEManager sharedEVEManager] mainMenuController] showShortcutsWindow:nil];
}

@end
