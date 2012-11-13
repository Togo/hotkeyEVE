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
  [shortcutTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
  NSNotification *notification = [NSNotification notificationWithName:NSTableViewSelectionDidChangeNotification object:shortcutTable];
  [self tableViewSelectionDidChange:notification];
  }

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
  return [shortcutList count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  
  NSDictionary *aDatabaseRow = [shortcutList objectAtIndex:row];
  NSString *identifier = [tableColumn identifier];
  
  if (   [identifier isEqualToString:DISABLED_SHORTCUT_DYN_COL]
      || [identifier isEqualToString:GLOB_DISABLED_SHORTCUT_DYN_COL] )  {
      return [self inverseBoolValue :[[aDatabaseRow valueForKey:identifier] intValue]];
  } else {
    return [aDatabaseRow valueForKey:identifier];
  }
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  
    NSNumber *state = [self inverseBoolValue:[anObject intValue]]; // database view
  
    [[shortcutList objectAtIndex:rowIndex] setObject:state forKey:[aTableColumn identifier]];
    NSInteger shortcutID = [[[shortcutList objectAtIndex:rowIndex] valueForKey:SHORTCUT_ID_COL] intValue];
    NSInteger appID = [[[shortcutList objectAtIndex:rowIndex] valueForKey:APPLICATION_ID_COL] intValue];
    NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
    NSString *title = [[shortcutList objectAtIndex:rowIndex] valueForKey:TITLE_COL];
  
    // Ok the gui checkboxes are inversed against the database. If i have a entry in the disabled_database the checkbox in the gui is disabled. So if you enable the checkbox in the gui you have to delete the entry from the database. The shortcut is active.
  if ([[aTableColumn identifier] isEqualToString:DISABLED_SHORTCUT_DYN_COL]) {
    if ([state intValue] == NSOnState)  // 1
      [DisabledShortcutsModel disableShortcut :shortcutID :appID :userID :title];
    else
      [DisabledShortcutsModel enableShortcut :shortcutID :appID :userID :title];
    
    } else if ([[aTableColumn identifier] isEqualToString:GLOB_DISABLED_SHORTCUT_DYN_COL]) {
    // disable in all apps
    if ([state intValue] == NSOnState) {
      // remove from database
      [DisabledShortcutsModel disableShortcutInAllApps :shortcutID :title];
      // and activate the first checkbox
    } else {
      [DisabledShortcutsModel enableShortcutInAllApps :shortcutID :title];
      // and disable the first checkbox
    }
    [[shortcutList objectAtIndex:rowIndex] setObject:[self inverseBoolValue:[anObject intValue]] forKey:DISABLED_SHORTCUT_DYN_COL];
    [shortcutTable reloadData];
  }
}

- (NSNumber*) inverseBoolValue :(NSInteger) value {
  if (value == NSOnState)
    return [NSNumber numberWithInt:NSOffState];
  else
    return [NSNumber numberWithInt:NSOnState];
}

- (void) tableViewSelectionDidChange :(NSNotification *)aNotification {
  DDLogInfo(@"ShortcutsTableViewConroller: %@", [aNotification name]);
  NSInteger selectedRow = [[aNotification object] selectedRow];
  if (selectedRow != -1) {
    NSDictionary *selectedTableRow = [shortcutList objectAtIndex:selectedRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShortcutWindowShortcutSelectionChanged object:selectedTableRow];
  }
}

@end
