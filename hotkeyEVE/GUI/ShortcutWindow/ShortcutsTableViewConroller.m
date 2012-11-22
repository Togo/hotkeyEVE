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

@synthesize activeAppName;

- (id)init {
  self = [super init];
  if (self) {
    shortcutList = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationChanged:)
                                                 name:ShortcutsWindowApplicationDidChanged object:nil];
  }
  
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) menuWillOpen :(NSMenu*) menu {
  NSInteger selectedRow = [shortcutTable selectedRow];
  if ([shortcutTable selectedRow] != -1) {
    BOOL isDisabled = [[[shortcutList objectAtIndex:selectedRow] valueForKey:DISABLED_SHORTCUT_DYN_COL] intValue];
    if (isDisabled) {
      [_disableEnableInOneAppItem setTitle:[NSString stringWithFormat:@"Enable in %@", activeAppName]];
      [_disableEnableInOneAppItem setTag:1];
    } else {
      [_disableEnableInOneAppItem setTitle:[NSString stringWithFormat:@"Disable in %@", activeAppName]];
      [_disableEnableInOneAppItem setTag:0];
    }
  }
}


- (void) applicationChanged :(id) aNotification {
    // Clear
    [shortcutList removeAllObjects];
    NSInteger appID =  [[[aNotification object] valueForKey:ID_COL] intValue];
    activeAppName = [[aNotification object] valueForKey:APP_NAME_COL];
  
    unfilteredShortcutList = [MenuBarTableModel getTitlesAndShortcuts:appID];
    [shortcutList addObjectsFromArray:unfilteredShortcutList];
    if([[_searchField stringValue] length] > 0) {
      [[NSNotificationCenter defaultCenter] postNotificationName:NSControlTextDidChangeNotification object:_searchField];
      }

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
    NSString *title = [[shortcutList objectAtIndex:rowIndex] valueForKey:TITLE_COL];
    if ([anObject intValue] == NSOffState) {
      [DisabledShortcutsModel enableShortcut :shortcutID :appID  :title];
    } else {
      [DisabledShortcutsModel disableShortcut :shortcutID :appID :title];
    }
    
    [[shortcutList objectAtIndex:rowIndex] setObject:anObject forKey:DISABLED_SHORTCUT_DYN_COL];
  }  
}

- (IBAction) enableInAllApps :(id)sender {
  NSIndexSet *selectedRows = [shortcutTable selectedRowIndexes];
  /*int (as commented, unreliable across different platforms)*/
  NSInteger currentIndex = [selectedRows firstIndex];
  while (currentIndex != NSNotFound) {
    //use the currentIndex
    NSInteger shortcutID = [[[shortcutList objectAtIndex:currentIndex] valueForKey:SHORTCUT_ID_COL] intValue];
    NSString *title = [[shortcutList objectAtIndex:currentIndex] valueForKey:TITLE_COL];
    [DisabledShortcutsModel enableShortcutInAllApps :shortcutID :title];
    [self tableView:shortcutTable setObjectValue:[NSNumber numberWithInt:NSOffState] forTableColumn:[[NSTableColumn alloc] initWithIdentifier:DISABLED_SHORTCUT_DYN_COL] row:currentIndex];
    
    //increment
    currentIndex = [selectedRows indexGreaterThanIndex: currentIndex];
  }
}


- (IBAction) disableInAllApps:(id)sender {
  NSIndexSet *selectedRows = [shortcutTable selectedRowIndexes];
  /*int (as commented, unreliable across different platforms)*/
  NSInteger currentIndex = [selectedRows firstIndex];
  while (currentIndex != NSNotFound) {
  NSInteger shortcutID = [[[shortcutList objectAtIndex:currentIndex] valueForKey:SHORTCUT_ID_COL] intValue];
  NSString *title = [[shortcutList objectAtIndex:currentIndex] valueForKey:TITLE_COL];
  [DisabledShortcutsModel disableShortcutInAllApps :shortcutID :title];
  [self tableView:shortcutTable setObjectValue:[NSNumber numberWithInt:NSOnState] forTableColumn:[[NSTableColumn alloc] initWithIdentifier:DISABLED_SHORTCUT_DYN_COL] row:currentIndex];
    
    currentIndex = [selectedRows indexGreaterThanIndex: currentIndex];
  }
}


- (IBAction)disableEnableInOneApp:(id)sender {
  BOOL isDisabled = [sender tag];
  NSIndexSet *selectedRows = [shortcutTable selectedRowIndexes];
  /*int (as commented, unreliable across different platforms)*/
  NSInteger currentIndex = [selectedRows firstIndex];
  while (currentIndex != NSNotFound) {
    NSInteger shortcutID = [[[shortcutList objectAtIndex:currentIndex] valueForKey:SHORTCUT_ID_COL] intValue];
    NSInteger appID = [[[shortcutList objectAtIndex:currentIndex] valueForKey:APPLICATION_ID_COL] intValue];
    NSString *title = [[shortcutList objectAtIndex:currentIndex] valueForKey:TITLE_COL];
    
    if (isDisabled) {
      [DisabledShortcutsModel enableShortcut :shortcutID :appID :title];
      [self tableView:shortcutTable setObjectValue:[NSNumber numberWithInt:NSOffState] forTableColumn:[[NSTableColumn alloc] initWithIdentifier:DISABLED_SHORTCUT_DYN_COL] row:currentIndex];

    } else {
      [DisabledShortcutsModel disableShortcut :shortcutID :appID :title];
      [self tableView:shortcutTable setObjectValue:[NSNumber numberWithInt:NSOnState] forTableColumn:[[NSTableColumn alloc] initWithIdentifier:DISABLED_SHORTCUT_DYN_COL] row:currentIndex];
    }
    
    currentIndex = [selectedRows indexGreaterThanIndex: currentIndex];
  }
}

- (void) controlTextDidChange :(NSNotification *)aNotification {
  if ([_searchField isEqual:[aNotification object]]) {
    NSString *match = [_searchField stringValue];
    NSMutableString *filterQuery = [NSMutableString string];
    [filterQuery appendFormat:@"%@ contains[cd] '%@'", TITLE_COL, match];
    [filterQuery appendFormat:@"OR %@ contains[cd] '%@'", PARENT_TITLE_COL, match];
    [filterQuery appendFormat:@"OR %@ contains[cd] '%@'", SHORTCUT_STRING_COL, match];
    NSPredicate *filter = [NSPredicate predicateWithFormat:filterQuery];
    filteredShortcutList = [unfilteredShortcutList filteredArrayUsingPredicate:filter];
    
    [shortcutList removeAllObjects];
    [shortcutList addObjectsFromArray:filteredShortcutList];
    [shortcutTable reloadData];
    
    // notification mit tabellen eintraegen um in applications zu filtern!!!
    [[NSNotificationCenter defaultCenter] postNotificationName:ShortcutTableSearchUpdate object:match];
  }
}

@end
