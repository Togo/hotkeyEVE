//
//  AppsViewControllerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsViewControllerTests.h"
#import <OCMock/OCMock.h>
#import "TGEVE_AllAppsViewController.h"
#import "TGEVE_AppsWindowViewController.h"
#import "TGEVE_AppsWindowWindowController.h"
#import "TGEVE_AppsNavigationViewController.h"
#import "AppsManagerLocalDB.h"
#import "TGEVE_IAppsViewController.h"
//#import "TGEVE_IAppsTableViewController.h"
#import "AppsManagerMock.h"
#import "TGEVE_AppsManagerAmazon.h"

@implementation AppsViewControllerTests

- (void)setUp
{
  [super setUp];
  _appsViewController = [[TGEVE_AppsWindowViewController alloc] init];
  
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
  [[appsViewControllerMock expect] viewSelectionDidChanged :[TGEVE_AllAppsViewController class] :TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME :[TGEVE_AppsManagerAmazon class]];
  
  [_appsViewController awakeFromNib];
  
  [appsViewControllerMock verify];
}

- (void) test_awakeFromNib_contollerAllocated_setTheNavigationView {
  id appsViewControllerMock = [OCMockObject partialMockForObject:_appsViewController];
  [[appsViewControllerMock expect] initNavigationView:[TGEVE_AppsNavigationViewController class] : TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME];
  
  [_appsViewController awakeFromNib];
  
  [appsViewControllerMock verify];
}

//************************* viewSelectionDidChanged *************************//
- (void) test_viewSelectionDidChanged_allScenarios_setMainContentViewController {
  [_appsViewController setMainContentViewController:nil];
  
  [_appsViewController viewSelectionDidChanged:[TGEVE_AppsNavigationViewController class] :TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME :[AppsManagerMock class]];
  
  STAssertNotNil([_appsViewController mainContentViewController], @"");
}

- (void) test_viewSelectionDidChanged_allScenarios_setTheModel {
 [[_appsViewController mainContentViewController] setAppsManager:nil];
  
  [_appsViewController viewSelectionDidChanged:[TGEVE_AppsNavigationViewController class] :TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME :[AppsManagerLocalDB class]];
  
  STAssertTrue([[[_appsViewController mainContentViewController] appsManager] isKindOfClass:[AppsManagerLocalDB class]], @"");
}

- (void) test_viewSelectionDidChanged_allScenarios_addNewViewToTheMainContentView {
  [_appsViewController setMainContentViewController:nil];
  
  [_appsViewController viewSelectionDidChanged:[TGEVE_AllAppsViewController class] :TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME :[AppsManagerMock class]];
  
  STAssertTrue([[[_appsViewController mainContentView] subviews] count] == 1, @"");
}

- (void) test_viewSelectiondDidChanged_allScenarios_setTheFrameOfSubviewToMainViewFrameBounds {
  [_appsViewController viewSelectionDidChanged:[TGEVE_AllAppsViewController class] :TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME :[AppsManagerMock class]];
  
  NSRect returnValue = [[[_appsViewController mainContentViewController] view] frame];
  NSRect expectedValue = [[_appsViewController mainContentView] bounds];
  
  STAssertEquals(returnValue, expectedValue, @"");
}

- (void) test_viewSelectiondDidChanged_allScenarios_setSubviewToWitdhAndHeightResiziable {
  [_appsViewController viewSelectionDidChanged:[TGEVE_AllAppsViewController class] :TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME :[AppsManagerMock class]];
  NSInteger autoresizMask = NSViewWidthSizable|NSViewHeightSizable;
  STAssertTrue([[[_appsViewController mainContentViewController] view] autoresizingMask] == autoresizMask , @"");
}

//************************* initNavigationView *************************//
- (void) test_initNavigationView_allScenarios_setNavigationViewController {
  [_appsViewController setNavigationViewController:nil];
  
  [_appsViewController initNavigationView:[TGEVE_AppsNavigationViewController class] :TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME];
  
  STAssertNotNil([_appsViewController navigationViewController], @"");
}

- (void) test_initNavigationView_allScenarios_addNewViewToTheNavigationView {
  [_appsViewController setNavigationViewController:nil];
  
  [_appsViewController initNavigationView:[TGEVE_AppsNavigationViewController class] :TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME];
  
  STAssertTrue([[[_appsViewController navigationView] subviews] count] == 1, @"");
}

- (void) test_initNavigationView_allScenarios_setTheFrameOfSubviewToMainViewFrameBounds {
  [_appsViewController initNavigationView:[TGEVE_AppsNavigationViewController class] :TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME];

  NSRect returnValue = [[[_appsViewController navigationViewController] view] frame];
  NSRect expectedValue = [[_appsViewController navigationView] bounds];
  
  STAssertEquals(returnValue, expectedValue, @"");
}

- (void) test_initNavigationView_allScenarios_setSubviewToHeightResiziable {
  [_appsViewController initNavigationView:[TGEVE_AppsNavigationViewController class] :TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME];
  NSInteger autoresizMask = NSViewHeightSizable|NSViewWidthSizable;
  STAssertTrue([[[_appsViewController navigationViewController] view] autoresizingMask] == autoresizMask , @"");
}

- (void) test_initNavigationView_classIsNotKindOfClassNSViewController_throwException {
  STAssertThrows([_appsViewController initNavigationView:[NSWindowController class] :TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME], @"");
}

- (void) test_initNavigationView_delegateHasBeenSet_delegateNotNil {
  [_appsViewController setNavigationViewController:nil];
  
  [_appsViewController initNavigationView:[TGEVE_AppsNavigationViewController class] :TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME];
  
  STAssertNotNil([[_appsViewController navigationViewController] delegate], @"");
}

@end
