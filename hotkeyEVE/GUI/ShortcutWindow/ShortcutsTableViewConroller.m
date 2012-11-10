//
//  ShortcutsTableViewConroller.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ShortcutsTableViewConroller.h"
#import "MenuBarTableModel.h"

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
  return [aDatabaseRow valueForKey:identifier];
}

- (void) tableViewSelectionDidChange:(NSNotification *)aNotification {
  DDLogInfo(@"ShortcutsTableViewConroller: %@", [aNotification name]);
  NSInteger selectedRow = [[aNotification object] selectedRow];
  NSDictionary *selectedTableRow = [shortcutList objectAtIndex:selectedRow];
  [[NSNotificationCenter defaultCenter] postNotificationName:ShortcutWindowShortcutSelectionChanged object:selectedTableRow];
}

@end
