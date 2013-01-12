//
//  AppsViewControllerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsViewControllerTests.h"
#import <OCMock/OCMock.h>

#import "AppsViewController.h"
#import "AppsInstalledViewController.h"
#import "AppsWindowController.h"

@implementation AppsViewControllerTests

- (void)setUp
{
  [super setUp];
  _appsViewController = [[AppsViewController alloc] init];
  
  _navigationView = [[NSView alloc] init];
  [_appsViewController setNavigationView:_navigationView];
  
  _mainContentView = [[NSView alloc] init];
  [_appsViewController setMainContentView:_mainContentView];
  
  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

//************************* awakeFromNib *************************//
- (void) test_awakeFromNib_contollerAllocated_callViewSelectiondDidChangeWithInstalledAppsView {
  id appsViewControllerMock = [OCMockObject partialMockForObject:_appsViewController];
  [[appsViewControllerMock expect] viewSelectionDidChanged :kAppsInstalledViewControllerNibName];
  
  [_appsViewController awakeFromNib];
  
  [appsViewControllerMock verify];
}

//************************* viewSelectionDidChanged *************************//
- (void) test_viewSelectionDidChanged_allScenarios_removeCurrentMainViewFromSuperView {
  NSViewController *activeViewController = [[NSViewController alloc] init];
  [_appsViewController setMainContentViewController:activeViewController];
  
  id currentActiveViewMock = [OCMockObject partialMockForObject:[[_appsViewController mainContentViewController] view]];
  [[currentActiveViewMock expect] removeFromSuperview];
  
  [_appsViewController viewSelectionDidChanged:kAppsInstalledViewControllerNibName];
  
  [currentActiveViewMock verify];
}

- (void) test_viewSelectionDidChanged_allScenarios_setMainViewControllerWithTheNibNamePassedToTheMethod {
  [_appsViewController setMainContentViewController:nil];
  
  [_appsViewController viewSelectionDidChanged:kAppsInstalledViewControllerNibName];
  
  STAssertNotNil([_appsViewController mainContentViewController], @"");
}

- (void) test_viewSelectionDidChanged_allScenarios_addNewViewToTheMainContentView {
  [_appsViewController setMainContentViewController:nil];
  
  [_appsViewController viewSelectionDidChanged :kAppsInstalledViewControllerNibName];
  
  STAssertTrue([[[_appsViewController mainContentView] subviews] count] == 1, @"");
}

@end
