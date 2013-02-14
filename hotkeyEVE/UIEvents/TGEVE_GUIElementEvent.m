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
  NSArray *searchResult = [_guiElementTable searchInGUIElementTable:element];
  if ( [searchResult count] > 1 )
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Found more than one entry with this Identifier" userInfo:nil];
  else if( [searchResult count] == 1 )
    return [NSArray arrayWithObject:[NSDictionary dictionaryWithMenuBarTableRow:[searchResult objectAtIndex:0]]];
  else
    return [NSArray array];
}

- (BOOL) displayNotification :(NSArray*) eventHintList {
  [_userNotifications displaySingleShortcutHintNotification:[eventHintList objectAtIndex:0]];
  return YES;
}

@end
