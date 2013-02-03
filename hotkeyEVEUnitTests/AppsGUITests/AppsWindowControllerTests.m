//
//  AppsWindowControllerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsWindowControllerTests.h"
#import <OCMock/OCMock.h>
#import "GUINotifications.h"

@implementation AppsWindowControllerTests

- (void)setUp
{
  [super setUp];
  
  _appsWindowController = [[AppsWindowController alloc] init];
  
  _appsWindow = [[NSWindow alloc] init];
  [_appsWindowController setWindow:_appsWindow];
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

//************************* windowDidLoad *************************//
- (void) test_windowDidLoad_allScenarios_setWindowTitle {
  [_appsWindow setTitle:@""];
  
  [_appsWindowController windowDidLoad];
  
  STAssertTrue([[_appsWindow title] isEqualToString:@"Apps"], @"");
}

//********************** windowDidBecomeKey *********************//
- (void) test_windowDidBecomeKey_windowComeFromBackgroundToFront_sendReloadTableNotification {
    id mock = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:mock
                                                     name:kEVENotificationsRemoveDropedLinesFromTable
                                                   object:nil];
    
    [[mock expect] notificationWithName:kEVENotificationsRemoveDropedLinesFromTable object:[OCMArg any]];
    
    [_appsWindowController windowDidBecomeKey:nil];
    
    [mock verify];
    [[NSNotificationCenter defaultCenter] removeObserver:mock];
}

@end
