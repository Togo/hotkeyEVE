//
//  TGEVE_MenuItemEventTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_MenuItemEventTests.h"
#import "TGEVE_MenuItemEvent.h"
#import <UIElements/UIElement.h>
#import <OCMock/OCMock.h>
#import "TGEVE_MenuBarTableModel.h"
#import "IUserNotifications.h"

@implementation TGEVE_MenuItemEventTests

- (void)setUp
{
  [super setUp];
  
}

- (void)tearDown
{
  [super tearDown];
}

//************************* init ************************//
- (void) test_init_newObjectCreated_menuBarTableIsNotNil {
  TGEVE_MenuItemEvent *event = [[TGEVE_MenuItemEvent alloc] init];
  STAssertNotNil([event menuBarTable], @"");
}

- (void) test_init_newObjectCreated_userNotificationsIsNotNil {
  TGEVE_MenuItemEvent *event = [[TGEVE_MenuItemEvent alloc] init];
  STAssertNotNil([event userNotifications], @"");
}

//************************* searchForShortcuts ************************//
- (void) test_searchForShortcuts_elementContainsShortcutString_returnArrayWithOneDictionary {
  id<TGEVE_IUIEvent> event = [self createMenuItemEvent];
  
  UIElement *element = [[UIElement alloc] init];
  [element setShortcutString:@"Jahuuuu Shortcut Found"];
  
  NSDictionary *result = [[event searchForShortcuts:element] objectAtIndex:0];
  
  STAssertTrue([result isKindOfClass:[NSDictionary class]], @"");
}

- (void) test_searchForShortcuts_noShortcutString_searchInDatabase {
  TGEVE_MenuItemEvent *event = [self createMenuItemEvent];
  
  UIElement *element = [[UIElement alloc] init];
  [element setShortcutString:@""];
  
  id menuBarTableMock = [OCMockObject niceMockForClass:[TGEVE_MenuBarTableModel class]];
  [[menuBarTableMock expect] searchInMenuBarTable :element];
  
  [event setMenuBarTable :menuBarTableMock];
  [event searchForShortcuts :element];
  
  [menuBarTableMock verify];
}

- (void) test_searchForShortcuts_foundTwoTupleInDatabase_returnArrayWithTwoDictionarys {
  TGEVE_MenuItemEvent *event = [self createMenuItemEvent];
  
  UIElement *element = [[UIElement alloc] init];
  [element setShortcutString:@""];
  
  id menuBarTableMock = [OCMockObject niceMockForClass:[TGEVE_MenuBarTableModel class]];
  [[[menuBarTableMock stub] andReturn:[NSArray arrayWithObjects:[NSDictionary dictionary], [NSDictionary dictionary], nil]] searchInMenuBarTable :element];
  
  [event setMenuBarTable:menuBarTableMock];
  
  NSInteger arraySize = [[event searchForShortcuts:element] count];
  
  STAssertTrue(arraySize == 2, @"");
}

- (void) test_searchForShortcuts_foundNothingInDatabase_returnEmptyArray {
  TGEVE_MenuItemEvent *event = [self createMenuItemEvent];
  
  UIElement *element = [[UIElement alloc] init];
  [element setShortcutString:@""];
  
  id menuBarTableMock = [OCMockObject niceMockForClass:[TGEVE_MenuBarTableModel class]];
  [[[menuBarTableMock stub] andReturn:[NSArray arrayWithObjects: nil]] searchInMenuBarTable :element];
  
  [event setMenuBarTable:menuBarTableMock];
  
  NSInteger arraySize = [[event searchForShortcuts:element] count];
  
  STAssertTrue(arraySize == 0, @"");
}



//************************* displayNotificiation ************************//
- (void) test_displayNotification_shortcutListContains1Shortcut_callDisplaySingleHintNotification {
  TGEVE_MenuItemEvent *event = [self createMenuItemEvent];
  
  NSDictionary *eventDictionary = [NSDictionary dictionary];
  NSArray *eventShortcutList = [NSArray arrayWithObjects:eventDictionary, nil];
  id notificationMock = [OCMockObject niceMockForProtocol:@protocol(IUserNotifications)];
  [[notificationMock expect] displaySingleShortcutHintNotification:eventDictionary];

  [event setUserNotifications :notificationMock];
  [event displayNotification  :eventShortcutList];
  
  [notificationMock verify];
}

- (void) test_displayNotification_shortcutListContainsMoreThan1Shortcut_callDisplayMultipleHintNotificationWithArray {
  TGEVE_MenuItemEvent *event = [self createMenuItemEvent];
  
  NSDictionary *eventDictionary1 = [NSDictionary dictionary];
  NSDictionary *eventDictionary2 = [NSDictionary dictionary];
  NSArray *eventShortcutList = [NSArray arrayWithObjects:eventDictionary1, eventDictionary2, nil];
  id notificationMock = [OCMockObject niceMockForProtocol:@protocol(IUserNotifications)];
  [[notificationMock expect] displayMultipleMatchesNotification:eventShortcutList];
  
  [event setUserNotifications :notificationMock];
  [event displayNotification  :eventShortcutList];
  
  [notificationMock verify];
}












//************************* helper Methods ************************//
- (id) createMenuItemEvent {
  return  [[TGEVE_MenuItemEvent alloc] init];
}

@end
