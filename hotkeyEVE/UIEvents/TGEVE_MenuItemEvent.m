//
//  TGEVEMenuItemEvent.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_MenuItemEvent.h"
#import "NSDictionary+TGEVE_EventDictionary.h"
#import "TGEVE_MenuBarTableModel.h"
#import "GrowlNotifications.h"

@implementation TGEVE_MenuItemEvent

@synthesize menuBarTable = _menuBarTable;
@synthesize userNotifications = _userNotifications;

- (id)init
{
  self = [super init];
  if (self) {
    _menuBarTable = [[TGEVE_MenuBarTableModel alloc] init];
    _userNotifications = [GrowlNotifications growlNotifications];
  }
  return self;
}

- (NSArray*) searchForShortcuts :(UIElement*) element {
  DDLogInfo(@"TGEVE_MenuItemEvent -> searchForShortcuts(element :%@:) :: get called", element);
  if ( [[element shortcutString] length] > 0 ) {
    DDLogInfo(@"TGEVE_MenuItemEvent -> searchForShortcuts() :: shortcut String in element Found");
    return [NSArray arrayWithObject :[NSDictionary dictionaryWithUIElement:element]];
  } else {
    NSMutableArray *shortcutList = [NSMutableArray array];
    NSArray *databaseSearchResult = [_menuBarTable searchInMenuBarTable :element];
    for(NSDictionary *aRow in databaseSearchResult) {
    [shortcutList addObject:[NSDictionary dictionaryWithMenuBarTableRow :aRow]];
    }
    
    DDLogInfo(@"TGEVE_MenuItemEvent -> searchForShortcuts() :: :%li: shortcuts hints in db found ", [shortcutList count]);
    return shortcutList;
  }
}

- (BOOL) displayNotification :(NSArray*) eventHintList {
    DDLogInfo(@"TGEVE_MenuItemEvent -> displayNotification() :: get called");
  if ( [eventHintList count] == 1 )
    [_userNotifications displaySingleShortcutHintNotification:[eventHintList objectAtIndex:0]];
  else if( [eventHintList count] > 1)
    [_userNotifications displayMultipleMatchesNotification :eventHintList];
  
  return YES;
}

@end