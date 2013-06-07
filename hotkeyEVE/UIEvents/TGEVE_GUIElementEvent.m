//
//  TGEVE_GUIElementEvent.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_GUIElementEvent.h"
#import "TGEVE_GUIElementsTableModel.h"
#import "NSDictionary+TGEVE_EventDictionary.h"
#import "GrowlNotifications.h"

@implementation TGEVE_GUIElementEvent

@synthesize guiElementTable = _guiElementTable;
@synthesize userNotifications = _userNotifications;

- (id)init
{
  self = [super init];
  if (self) {
    _guiElementTable = [[TGEVE_GUIElementsTableModel alloc] init];
    _userNotifications  = [GrowlNotifications growlNotifications];
  }
  return self;
}

- (NSArray*) searchForShortcuts :(UIElement*) element {
  DDLogInfo(@"TGEVE_GUIElementEvent -> searchForShortcuts(element :%@:) :: get called", element);
  NSArray *searchResult = [_guiElementTable searchInGUIElementTable:element];
  if ( [searchResult count] > 1 ) {
    NSMutableArray *shortcutList = [NSMutableArray array];
    for(NSDictionary *aRow in searchResult) {
      [shortcutList addObject:[NSDictionary dictionaryWithGUIElementsTableRow:aRow]];
    }
    return shortcutList;
  } else if( [searchResult count] == 1 ) {
    DDLogInfo(@"TGEVE_GUIElementEvent -> searchForShortcuts() :: :%li: shortcuts hints in db found ", [searchResult count]);
    return [NSArray arrayWithObject:[NSDictionary dictionaryWithMenuBarTableRow:[searchResult objectAtIndex:0]]];
  } else {
    DDLogInfo(@"TGEVE_GUIElementEvent -> searchForShortcuts() :: no hints in db ");
    return [NSArray array];
  }
  
  return nil;
}

- (BOOL) displayNotification :(NSArray*) eventHintList {
  if ([eventHintList count] == 1) {
    DDLogInfo(@"TGEVE_GUIElementEvent -> displayNotification() :: get called");
    [_userNotifications displaySingleShortcutHintNotification:[eventHintList objectAtIndex:0]];

  } else if( [eventHintList count] > 1)
    [_userNotifications displayMultipleMatchesNotification :eventHintList];

  return YES;
}

@end
