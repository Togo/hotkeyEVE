//
//  AppsWindowControllerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsWindowControllerTests.h"
#import <OCMock/OCMock.h>

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

@end
