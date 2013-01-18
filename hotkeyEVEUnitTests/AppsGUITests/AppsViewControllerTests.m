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
#import "AppsTableNavigationViewController.h"

@implementation AppsViewControllerTests

- (void)setUp
{
  [super setUp];
  _appsViewController = [[AppsViewController alloc] init];
  
  _navigationView = [[NSView alloc] init];
  [_navigationView setBounds:NSMakeRect(99, 99, 1, 1)];
  [_appsViewController setNavigationView:_navigationView];
  
  _mainContentView = [[NSView alloc] init];
  [_mainContentView setBounds:NSMakeRect(1, 1, 99, 99)];
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
  [[appsViewControllerMock expect] viewSelectionDidChanged :[AppsInstalledViewController class] :kAppsInstalledViewControllerNibName];
  
  [_appsViewController awakeFromNib];
  
  [appsViewControllerMock verify];
}

- (void) test_awakeFromNib_contollerAllocated_setTheNavigationView {
  id appsViewControllerMock = [OCMockObject partialMockForObject:_appsViewController];
  [[appsViewControllerMock expect] initNavigationView:[AppsTableNavigationViewController class] :kAppsTableNavigationViewControllerNibName];
  
  [_appsViewController awakeFromNib];
  
  [appsViewControllerMock verify];
}

//************************* viewSelectionDidChanged *************************//
- (void) test_viewSelectionDidChanged_allScenarios_removeCurrentMainViewFromSuperView {
  NSViewController *activeViewController = [[NSViewController alloc] init];
  [_appsViewController setMainContentViewController:activeViewController];
  
  id currentActiveViewMock = [OCMockObject partialMockForObject:[[_appsViewController mainContentViewController] view]];
  [[currentActiveViewMock expect] removeFromSuperview];
  
  [_appsViewController viewSelectionDidChanged:[AppsInstalledViewController class] :kAppsInstalledViewControllerNibName];
  
  [currentActiveViewMock verify];
}

- (void) test_viewSelectionDidChanged_allScenarios_setMainContentViewController {
  [_appsViewController setMainContentViewController:nil];
  
  [_appsViewController viewSelectionDidChanged:[AppsInstalledViewController class] :kAppsInstalledViewControllerNibName];
  
  STAssertNotNil([_appsViewController mainContentViewController], @"");
}

- (void) test_viewSelectionDidChanged_allScenarios_addNewViewToTheMainContentView {
  [_appsViewController setMainContentViewController:nil];
  
  [_appsViewController viewSelectionDidChanged:[AppsInstalledViewController class] :kAppsInstalledViewControllerNibName];
  
  STAssertTrue([[[_appsViewController mainContentView] subviews] count] == 1, @"");
}

- (void) test_viewSelectiondDidChanged_allScenarios_setTheFrameOfSubviewToMainViewFrameBounds {
  [_appsViewController viewSelectionDidChanged:[AppsInstalledViewController class] :kAppsInstalledViewControllerNibName];
  
  NSRect returnValue = [[[_appsViewController mainContentViewController] view] frame];
  NSRect expectedValue = [[_appsViewController mainContentView] bounds];
  
  STAssertEquals(returnValue, expectedValue, @"");
}

- (void) test_viewSelectiondDidChanged_allScenarios_setSubviewToWitdhAndHeightResiziable {
  [_appsViewController viewSelectionDidChanged:[AppsInstalledViewController class] :kAppsInstalledViewControllerNibName];
  NSInteger autoresizMask = NSViewWidthSizable|NSViewHeightSizable;
  STAssertTrue([[[_appsViewController mainContentViewController] view] autoresizingMask] == autoresizMask , @"");
}

//************************* initNavigationView *************************//
- (void) test_initNavigationView_allScenarios_setNavigationViewController {
  [_appsViewController setNavigationViewController:nil];
  
  [_appsViewController initNavigationView:[AppsTableNavigationViewController class] :kAppsTableNavigationViewControllerNibName];
  
  STAssertNotNil([_appsViewController navigationViewController], @"");
}

- (void) test_initNavigationView_allScenarios_addNewViewToTheNavigationView {
  [_appsViewController setNavigationViewController:nil];
  
  [_appsViewController initNavigationView:[AppsTableNavigationViewController class] :kAppsTableNavigationViewControllerNibName];
  
  STAssertTrue([[[_appsViewController navigationView] subviews] count] == 1, @"");
}

- (void) test_initNavigationView_allScenarios_setTheFrameOfSubviewToMainViewFrameBounds {
  [_appsViewController initNavigationView:[AppsTableNavigationViewController class] :kAppsTableNavigationViewControllerNibName];

  NSRect returnValue = [[[_appsViewController navigationViewController] view] frame];
  NSRect expectedValue = [[_appsViewController navigationView] bounds];
  
  STAssertEquals(returnValue, expectedValue, @"");
}

- (void) test_initNavigationView_allScenarios_setSubviewToHeightResiziable {
  [_appsViewController initNavigationView:[AppsTableNavigationViewController class] :kAppsTableNavigationViewControllerNibName];
  NSInteger autoresizMask = NSViewHeightSizable|NSViewWidthSizable;
  STAssertTrue([[[_appsViewController navigationViewController] view] autoresizingMask] == autoresizMask , @"");
}

- (void) test_initNavigationView_classIsNotKindOfClassNSViewController_throwException {
  STAssertThrows([_appsViewController initNavigationView:[NSWindowController class] :kAppsTableNavigationViewControllerNibName], @"");
}

- (void) test_initNavigationView_delegateHasBeenSet_delegateNotNil {
  [_appsViewController setNavigationViewController:nil];
  
  [_appsViewController initNavigationView:[AppsTableNavigationViewController class] :kAppsTableNavigationViewControllerNibName];
  
  STAssertNotNil([[_appsViewController navigationViewController] delegate], @"");
}

@end
