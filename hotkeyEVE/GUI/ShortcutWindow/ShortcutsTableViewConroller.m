//
//  ShortcutsTableViewConroller.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ShortcutsTableViewConroller.h"
#import "MenuBarTableModel.h"
#import "UserDataTableModel.h"
#import "DisabledShortcutsModel.h"

enum {
  kRemindMe = 0,
  kDisableInApp = 1,
  kDisableInAllApps = 2
};

@implementation ShortcutsTableViewConroller

- (id)init {
  self = [super init];
  if (self) {
    shortcutList = [NSArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationChanged:)
                                                 name:ShortcutsWindowApplicationDidChanged object:nil];
  }
  
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) applicationChanged :(id) aNotification {
    id object =  [aNotification object];
    shortcutList = [MenuBarTableModel getTitlesAndShortcuts:object];
    [shortcutTable reloadData];
    [shortcutTable selectRowIndexes :[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
  }

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
  return [shortcutList count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [[shortcutList objectAtIndex:row] valueForKey:[tableColumn identifier]];
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {

  if ([[aTableColumn identifier] isEqualToString:DISABLED_SHORTCUT_DYN_COL]) {
    NSInteger shortcutID = [[[shortcutList objectAtIndex:rowIndex] valueForKey:SHORTCUT_ID_COL] intValue];
    NSInteger appID = [[[shortcutList objectAtIndex:rowIndex] valueForKey:APPLICATION_ID_COL] intValue];
    NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
    NSString *title = [[shortcutList objectAtIndex:rowIndex] valueForKey:TITLE_COL];
    if ([anObject intValue] == NSOffState) {
      [DisabledShortcutsModel enableShortcut :shortcutID :appID :userID :title];
    } else {
      [DisabledShortcutsModel disableShortcut :shortcutID :appID :userID :title];
    }
    
    [[shortcutList objectAtIndex:rowIndex] setObject:anObject forKey:DISABLED_SHORTCUT_DYN_COL];
  }  
}

- (IBAction) enableInAllApps :(id)sender {
  NSInteger rowIndex = [shortcutTable selectedRow];
  NSInteger shortcutID = [[[shortcutList objectAtIndex:rowIndex] valueForKey:SHORTCUT_ID_COL] intValue];
  NSString *title = [[shortcutList objectAtIndex:rowIndex] valueForKey:TITLE_COL];
  [DisabledShortcutsModel enableShortcutInAllApps :shortcutID :title];
  [self tableView:shortcutTable setObjectValue:[NSNumber numberWithInt:NSOffState] forTableColumn:[[NSTableColumn alloc] initWithIdentifier:DISABLED_SHORTCUT_DYN_COL] row:rowIndex];
}

- (IBAction) disableInAllApps:(id)sender {
  NSInteger rowIndex = [shortcutTable selectedRow];
  NSInteger shortcutID = [[[shortcutList objectAtIndex:rowIndex] valueForKey:SHORTCUT_ID_COL] intValue];
  NSString *title = [[shortcutList objectAtIndex:rowIndex] valueForKey:TITLE_COL];
  [DisabledShortcutsModel disableShortcutInAllApps :shortcutID :title];
  [self tableView:shortcutTable setObjectValue:[NSNumber numberWithInt:NSOnState] forTableColumn:[[NSTableColumn alloc] initWithIdentifier:DISABLED_SHORTCUT_DYN_COL] row:rowIndex];
}

@end
