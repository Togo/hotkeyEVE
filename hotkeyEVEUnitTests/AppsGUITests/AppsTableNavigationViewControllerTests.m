//
//  AppsTableNavigationViewControllerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsTableNavigationViewControllerTests.h"
#import "AppsTableNavigationViewController.h"
#import <OCMock/OCMock.h>
#import "AppsInstalledViewController.h"

@implementation AppsTableNavigationViewControllerTests

- (void)setUp
{
  [super setUp];
  
  _tableNavController = [[AppsTableNavigationViewController alloc] initWithNibName:kAppsTableNavigationViewControllerNibName bundle:nil];
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void) test_initWithNibName_classContainsDelegate_delegateIsNil {
  STAssertNil(_tableNavController->delegate  , @"");
}

- (void) test_selectionDidChange_actionPerformed_callDelegateMethodWithViewNibName {
  id navigationDelegateMock = [OCMockObject mockForProtocol:@protocol(AppsNavigationDelegate)];
  [[navigationDelegateMock expect] viewSelectionDidChanged :kAppsInstalledViewControllerNibName];
  
  _tableNavController->delegate  = navigationDelegateMock;
  
  [_tableNavController selectionDidChange:kAppsInstalledViewControllerNibName];
  
  [navigationDelegateMock verify];
}

@end
