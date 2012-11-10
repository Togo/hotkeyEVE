//
//  BoxController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ShortcutOptionsController.h"
#import "DisabledShortcutsModel.h"
#import "UserDataTableModel.h"

@implementation ShortcutOptionsController

@synthesize selectedShortcut;

- (id) init {
  self = [super init];
  
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shortcutChanged:)
                                                 name:ShortcutWindowShortcutSelectionChanged object:nil];
  }
  
  return self;
}

- (void) awakeFromNib {
  _enabledDisabledTextField.stringValue = @"";
  _enabledDisabledTextField.drawsBackground = YES;
  
  _shortcutStringTextField.stringValue = @"";
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) shortcutChanged :(id) aNotification {
  selectedShortcut = [aNotification object];
  if (selectedShortcut) {
    NSInteger shortcutID = [[selectedShortcut valueForKey:SHORTCUT_ID_COL] intValue];
    NSInteger appID = [[selectedShortcut valueForKey:APPLICATION_ID_COL] intValue];
    NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
    
    BOOL shortcutDisabled = [DisabledShortcutsModel isShortcutDisabled:shortcutID :appID :userID];
    
    [self updateBox :shortcutDisabled];
  } else {
    [self cleanBox];
  }
}

- (void) updateBox :(BOOL) shortcutDisabled {
  _shortcutStringTextField.stringValue = [selectedShortcut valueForKey:SHORTCUT_STRING_COL];
  
  if (shortcutDisabled) {
    _enabledDisabledTextField.stringValue = @"Disabled";
    _enabledDisabledTextField.backgroundColor = [NSColor redColor];
    
    [_enabledDisableButton setTitle:@"Enable Shortcut"];
  } else {
    _enabledDisabledTextField.stringValue = @"Enabled";
    _enabledDisabledTextField.backgroundColor = [NSColor greenColor];
    
    [_enabledDisableButton setTitle:@"Disable Shortcut"];
  }
}

- (IBAction)enableDisableShortcutInOneApp :(id)sender {
  NSLog(@"%@", [_enabledDisabledTextField stringValue]);
  if (selectedShortcut) {
    NSInteger shortcutID = [[selectedShortcut valueForKey:SHORTCUT_ID_COL] intValue];
    NSInteger appID = [[selectedShortcut valueForKey:APPLICATION_ID_COL] intValue];
    NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
    
    if ([[_enabledDisabledTextField stringValue] isEqualToString:@"Enabled"]) {

      [DisabledShortcutsModel disableShortcut:shortcutID :appID :userID];
      [self postShortcutWindowShortcutSelectionChanged];
      return;
    }
    if([[_enabledDisabledTextField stringValue] isEqualToString:@"Disabled"]) {

      [DisabledShortcutsModel enableShortcut:shortcutID :appID :userID];
      [self postShortcutWindowShortcutSelectionChanged];
      return;
    }
  }  
}

- (IBAction)disableShortcutInAllApps:(id)sender {
  [DisabledShortcutsModel disableShortcutInAllApps :[[selectedShortcut valueForKey:SHORTCUT_ID_COL] intValue]];
  [self postShortcutWindowShortcutSelectionChanged];
}

- (IBAction)enableShortcutInAllApps:(id)sender {
  [DisabledShortcutsModel enableShortcutInAllApps :[[selectedShortcut valueForKey:SHORTCUT_ID_COL] intValue]];
  [self postShortcutWindowShortcutSelectionChanged];
}

- (void) postShortcutWindowShortcutSelectionChanged {
  NSNotification *notification = [NSNotification notificationWithName:ShortcutWindowShortcutSelectionChanged object:selectedShortcut];
  [self shortcutChanged:notification];
}

- (void) cleanBox {
  _enabledDisabledTextField.stringValue = @"";
  _shortcutStringTextField.stringValue = @"";
  [_enabledDisableButton setTitle:@"Enable / Disable"];
}

@end
