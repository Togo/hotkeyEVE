//
//  TGEVE_GUIElementEventTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_GUIElementEventTests.h"
#import "TGEVE_GUIElementEvent.h"
#import "TGEVE_GUIElementsTableModel.h"
#import <OCMock/OCMock.h>

@implementation TGEVE_GUIElementEventTests

//************************* init ************************//
- (void) test_init_newObjectCreated_guiElementTableIsNotNil {
  TGEVE_GUIElementEvent *event = [self createGUIElementEvent];
  STAssertNotNil([event guiElementTable], @"");
}

- (void) test_init_newObjectCreated_userNotificationsIsNotNil {
  TGEVE_GUIElementEvent *event = [self createGUIElementEvent];
  STAssertNotNil([event userNotifications], @"");
}

//************************* searchForShortcuts ************************//
- (void) test_searchForShortcuts_entryFoundInDatabase_returnArrayWithOneDictionary {
  TGEVE_GUIElementEvent *event = [self createGUIElementEvent];
  
  UIElement *element = [[UIElement alloc] init];
  
  id guiElementTableMock = [OCMockObject niceMockForClass:[TGEVE_GUIElementsTableModel class]];
  [[[guiElementTableMock stub] andReturn:[NSArray arrayWithObject:[NSDictionary dictionary]]] searchInGUIElementTable :element];
  
  [event setGuiElementTable :guiElementTableMock];
  NSArray *returnedList = [event searchForShortcuts :element];
  STAssertTrue([returnedList count] == 1, @"");
}

- (void) test_searchForShortcuts_moreThanOneEntryFoundInDatabase_throwException {
  TGEVE_GUIElementEvent *event = [self createGUIElementEvent];
  
  UIElement *element = [[UIElement alloc] init];
  
  id guiElementTableMock = [OCMockObject niceMockForClass:[TGEVE_GUIElementsTableModel class]];
  [[[guiElementTableMock stub] andReturn:[NSArray arrayWithObjects:[NSDictionary dictionary], [NSDictionary dictionary], nil]] searchInGUIElementTable :element];
  
  [event setGuiElementTable :guiElementTableMock];
  STAssertThrows([event searchForShortcuts:element], @"");
}

- (TGEVE_GUIElementEvent*) createGUIElementEvent {
  return [[TGEVE_GUIElementEvent alloc] init];
}

//************************* displayNotificiation ************************//
- (void) test_displayNotification_shortcutListContains1Shortcut_callDisplaySingleHintNotification {
  TGEVE_GUIElementEvent *event = [self createGUIElementEvent];
  
  NSDictionary *eventDictionary = [NSDictionary dictionary];
  NSArray *eventShortcutList = [NSArray arrayWithObjects:eventDictionary, nil];
  id notificationMock = [OCMockObject niceMockForProtocol:@protocol(IUserNotifications)];
  [[notificationMock expect] displaySingleShortcutHintNotification :eventDictionary];
  
  [event setUserNotifications :notificationMock];
  [event displayNotification  :eventShortcutList];
  
  [notificationMock verify];
}

@end
