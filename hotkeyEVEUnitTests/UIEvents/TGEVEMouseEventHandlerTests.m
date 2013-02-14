//
//  TGEVEMouseEventTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVEMouseEventHandlerTests.h"
#import "TGEVE_IUIEventHandler.h"
#import "TGEVE_MouseEventHandler.h"
#import "TGEVE_MenuItemEvent.h"
#import <UIElements/NullUIElement.h>
#import <UIElements/MenuItem.h>
#import <UIElements/Button.h>
#import <OCMock/OCMock.h>
#import "TGEVE_IUIEvent.h"
#import "TGEVE_GUIElementEvent.h"

@implementation TGEVEMouseEventHandlerTests

- (void)setUp
{
  [super setUp];
  
}

- (void)tearDown
{
  [super tearDown];
}

//*************************** createEvent ***************************//
- (void) test_createEvent_EventOnMenuItem_createMenuItemEvent {
  id event = [self createNewEventObject];
  id result = [event createEvent:[[MenuItem alloc] init]];
  id expected = [TGEVE_MenuItemEvent class];
  STAssertTrue([result isKindOfClass:expected], @"But is class %@", result);
}

- (void) test_createEvent_UIElementNotSupported_returnNil {
  id event = [self createNewEventObject];
  id result = [event createEvent:[[NullUIElement alloc] init]];
  STAssertTrue(result == nil, @"");
}

- (void) test_createEvent_UIElementIsSupportedGUIElement_returnGUIElementEvent {
  id event = [self createNewEventObject];
  id result = [event createEvent:[[Button alloc] init]];
  id expected = [TGEVE_GUIElementEvent class];
  STAssertTrue([result isKindOfClass:expected], @"But is class %@", result);
}


//************************ handleEVEEvent ****************************//
- (void) test_handleEVEEvent_elementIsNil_throwElementNilException {
  id event = [self createNewEventObject];
  STAssertThrows([event handleEVEEvent:nil], @"");
}

- (void) test_handleEVEEvent_shortcutListContainsOneOrMoreEnabledElements_callDisplayNotification {
  id event = [self createNewEventObject];
  
  NSArray *shortcutList = [NSArray arrayWithObjects:@"1 Shortcut Found",@"2 Shortcut Found", nil];
  id menuItemEventMock = [OCMockObject niceMockForProtocol:@protocol(TGEVE_IUIEvent)];
  [[menuItemEventMock expect] displayNotification :shortcutList];
  [[[menuItemEventMock stub] andReturn:shortcutList] searchForShortcuts:OCMOCK_ANY];
  
  id eventMock = [OCMockObject partialMockForObject:event];
  BOOL returnValue = NO;
  [[[eventMock stub] andReturnValue:OCMOCK_VALUE(returnValue)] isShortcutDisabled :shortcutList];

  
  [event setEvent:menuItemEventMock];
  
  [event handleEVEEvent:[[UIElement alloc] init]];
  
  [menuItemEventMock verify];
}

- (void) test_handleEVEEvent_shortcutListContainsOneOrMoreEnabledElements_insertInDisplayedDatabase {
  id event = [self createNewEventObject];
  
  NSArray *shortcutList = [NSArray arrayWithObjects:@"1 Shortcut Found",@"2 Shortcut Found", nil];
  id menuItemEventMock = [OCMockObject niceMockForProtocol:@protocol(TGEVE_IUIEvent)];
  [[menuItemEventMock stub] displayNotification :shortcutList];
  [[[menuItemEventMock stub] andReturn:shortcutList] searchForShortcuts:OCMOCK_ANY];
  
  id eventMock = [OCMockObject partialMockForObject:event];
  BOOL returnValue = NO;
  [[eventMock expect] insertInDisplayedShortcutsDB :shortcutList];
  [[[eventMock stub] andReturnValue:OCMOCK_VALUE(returnValue)] isShortcutDisabled :shortcutList];
  
  
  [event setEvent:menuItemEventMock];
  
  [event handleEVEEvent:[[UIElement alloc] init]];
  
  [eventMock verify];
}

- (void) test_handleEVEEvent_shortcutListContainsOneDisabledElement_dontCallDisplay {
  id event = [self createNewEventObject];
  
  NSArray *shortcutList = [NSArray arrayWithObjects:@"1 Shortcut Found",@"2 Shortcut Found", nil];
  id menuItemEventMock = [OCMockObject niceMockForProtocol:@protocol(TGEVE_IUIEvent)];
  [[menuItemEventMock reject] displayNotification :shortcutList];
  [[[menuItemEventMock stub] andReturn:shortcutList] searchForShortcuts:OCMOCK_ANY];
  
  id eventMock = [OCMockObject partialMockForObject:event];
  BOOL returnValue = YES;
  [[[eventMock stub] andReturnValue:OCMOCK_VALUE(returnValue)] isShortcutDisabled :shortcutList];
  
  
  [event setEvent:menuItemEventMock];
  
  [event handleEVEEvent:[[UIElement alloc] init]];
  
  [menuItemEventMock verify];
}

- (void) test_handleEVEEvent_shortcutListContainsOneTimeIntverallNotOk_dontCallDisplay {
  id event = [self createNewEventObject];
  
  NSArray *shortcutList = [NSArray arrayWithObjects:@"1 Shortcut Found", nil];
  id menuItemEventMock = [OCMockObject niceMockForProtocol:@protocol(TGEVE_IUIEvent)];
  [[menuItemEventMock reject] displayNotification :shortcutList];
  [[[menuItemEventMock stub] andReturn:shortcutList] searchForShortcuts:OCMOCK_ANY];
  
  id eventMock = [OCMockObject partialMockForObject:event];
  BOOL returnValue = NO;
  [[[eventMock stub] andReturnValue:OCMOCK_VALUE(returnValue)] isShortcutDisabled :shortcutList];
  [[[eventMock stub] andReturnValue:OCMOCK_VALUE(returnValue)] isTimeIntevallOk  :shortcutList];
  
  [event setEvent:menuItemEventMock];
  
  [event handleEVEEvent:[[UIElement alloc] init]];
  
  [menuItemEventMock verify];
}

- (void) test_handleEVEEvent_shortcutListContainsNothing_dontCallDisplayMethod {
  id event = [self createNewEventObject];
  
  NSArray *shortcutList = [NSArray array];
  id menuItemEventMock = [OCMockObject niceMockForProtocol:@protocol(TGEVE_IUIEvent)];
  [[menuItemEventMock reject] displayNotification :shortcutList];
  [[[menuItemEventMock stub] andReturn:shortcutList] searchForShortcuts:OCMOCK_ANY];
  
  [event setEvent:menuItemEventMock];
  
  [event handleEVEEvent:[[UIElement alloc] init]];
  
  [menuItemEventMock verify];
}

//*********** Test helper  **************//
- (id) createNewEventObject {
  return [[TGEVE_MouseEventHandler alloc] init];
}

@end


