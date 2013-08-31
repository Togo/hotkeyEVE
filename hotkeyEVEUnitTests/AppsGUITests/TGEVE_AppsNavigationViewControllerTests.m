//
//  AppsTableNavigationViewControllerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_AppsNavigationViewControllerTests.h"
#import "TGEVE_AppsNavigationViewController.h"
#import <OCMock/OCMock.h>
#import "TGEVE_AllAppsViewController.h"
#import "TGEVE_AppsManagerAmazon.h"
#import "AppsManagerLocalDB.h"
#import "TGEVE_UpdatableAppsViewController.h"

@implementation TGEVE_AppsNavigationViewControllerTests

- (void)setUp
{
  [super setUp];
  
  _tableNavController = [[TGEVE_AppsNavigationViewController alloc] initWithNibName:TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME bundle:nil];
  
  _tableView = [[NSTableView alloc] init];
  [_tableNavController setNavigationTableView:_tableView];
  
  _navigationTableColumn = [[NSTableColumn alloc] initWithIdentifier:@"NavigationColumn"];
  [_tableNavController setNavigationTableColumn:_navigationTableColumn];
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

//************************* initWithNibName *************************//
- (void) test_initWithNibName_classContainsDelegate_delegateIsNil {
  STAssertNil(_tableNavController.delegate  , @"");
}

- (void) test_initWithNibName_all_appsManagerAlloced {
  STAssertNotNil([_tableNavController appsManager]  , @"");
}

- (void) test_initWithNibName_dataSourceAllAppsRow_dataSourceContainsRowAllAppsColumn {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"NavigationColumn"];
  STAssertTrue([returnValue isEqualToString:@"All Apps"], @"");
}

- (void) test_initWithNibName_dataSourceAllAppsRow_dataSourceContainsRowWithAppsTableViewNibName {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"NibName"];
  STAssertTrue([returnValue isEqualToString:TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME], @"");
}

- (void) test_initWithNibName_dataSourceAllAppsRow_dataSourceContainsRowWithAppsTableViewClass {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"Class"];
  STAssertTrue([returnValue isEqualTo:[TGEVE_AllAppsViewController class]], @"");
}

- (void) test_initWithNibName_dataSourceAllAppsRow_dataSourceContainsRowWithAmazonModel {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"model"];
  STAssertTrue([returnValue isEqualTo:[TGEVE_AppsManagerAmazon class]], @"");
}

- (void) test_initWithNibName_dataSourceAllAppsRow_dataSourceContainsRowUpdatableAppsColumn {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"NavigationColumn"];
  STAssertTrue([returnValue isEqualToString:@"Updatable Apps"], @"");
}

- (void) test_initWithNibName_dataSourceUpdatabaleAppsRow_dataSourceContainsRowWithAppsTableViewNibName {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"NibName"];
  STAssertTrue([returnValue isEqualToString:TGEVE_CONST_APPS_UPDATABLE_NIB_NAME], @"");
}

- (void) test_initWithNibName_dataSourceUpdatableAppsRow_dataSourceContainsRowWithUpdatableAppsViewNibName {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"NibName"];
  STAssertTrue([returnValue isEqualToString:TGEVE_CONST_APPS_UPDATABLE_NIB_NAME], @"");
}

- (void) test_initWithNibName_dataSourceUpdatableAppsRow_dataSourceContainsRowWithUpdatableAppsViewClass {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"Class"];
  STAssertTrue([returnValue isEqualTo:[TGEVE_UpdatableAppsViewController class]], @"");
}

- (void) test_initWithNibName_dataSourceUpdatableAppsRow_dataSourceContainsRowWithAmazonModel {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"model"];
  STAssertTrue([returnValue isEqualTo:[TGEVE_AppsManagerAmazon class]], @"");
}

//************************* loadView *************************//

//************************* objectValueForTableColumn *************************//
- (void) test_objectValueForTableColumn_rowSelected_returnNavigationColumnValue {
  NSTableColumn *navTableColumn = [[NSTableColumn alloc] initWithIdentifier:@"NavigationColumn"];
  NSString *returnValue = [_tableNavController tableView:_tableView objectValueForTableColumn:navTableColumn row:0];
  STAssertTrue([returnValue isEqualToString:@"All Apps"], @"");
}

//************************* tableViewSelectionDidChange *************************//
- (void)test_tableViewSelectionDidChange_withTableViewAndRow0Selected_callDelegateWithInstalledView {
  NSNotification *notification = [NSNotification notificationWithName:NSTableViewSelectionDidChangeNotification object:_tableView];
  
  id tableViewMock = [OCMockObject partialMockForObject:_tableView];
  NSInteger selectedRow = 0;
  [[[tableViewMock stub] andReturnValue:OCMOCK_VALUE(selectedRow)] selectedRow];
  
  id navigationDelegateMock = [OCMockObject niceMockForProtocol:@protocol(AppsNavigationDelegate)];
  id expectedViewController = [[[_tableNavController dataSource] objectAtIndex:selectedRow] valueForKey:@"Class"];
  id expectedModelClass = [[[_tableNavController dataSource] objectAtIndex:selectedRow] valueForKey:@"model"];
  [[navigationDelegateMock expect] viewSelectionDidChanged:expectedViewController :TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME :expectedModelClass];
  
  _tableNavController.delegate = navigationDelegateMock;
  
  [_tableNavController tableViewSelectionDidChange:notification];
  
  [navigationDelegateMock verify];
}

- (void)test_tableViewSelectionDidChange_withTableViewNoRowSelected_donothing {
  NSNotification *notification = [NSNotification notificationWithName:NSTableViewSelectionDidChangeNotification object:_tableView];
  
  id tableViewMock = [OCMockObject partialMockForObject:_tableView];
  NSInteger selectedRow = -1;
  [[[tableViewMock stub] andReturnValue:OCMOCK_VALUE(selectedRow)] selectedRow];
  
  id navigationDelegateMock = [OCMockObject niceMockForProtocol:@protocol(AppsNavigationDelegate)];
  [[navigationDelegateMock reject] viewSelectionDidChanged:[OCMArg any] :TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME :[OCMArg any]];
  
  _tableNavController.delegate = navigationDelegateMock;
  
  [_tableNavController tableViewSelectionDidChange:notification];
  
  [navigationDelegateMock verify];
}

//************************* awakeFromNib *************************//
- (void)test_awakeFromNib_allScenarios_setSelectedRowTo0 {
  id tableViewMock = [OCMockObject partialMockForObject:_tableView];
  [[tableViewMock expect] selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
  
  [_tableNavController awakeFromNib];
  
  [tableViewMock verify];
}

- (void)test_awakeFromNib_allScenarios_setNavigationTableColumnNotEditable {
  id navigationTableColumnMock = [OCMockObject partialMockForObject:_navigationTableColumn];
  [[navigationTableColumnMock expect] setEditable:NO];
  
  [_tableNavController awakeFromNib];
  
  [navigationTableColumnMock verify];
}


//***************************  TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME ***************************//
- (void) test_constant_allScenarios_rightTableViewControllerNibName {
  STAssertTrue([TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME isEqualToString:@"TGEVE_AllAppsViewController"], @"");
}

//***************************  TGEVE_CONST_APPS_UPDATABLE_NIB_NAME ***************************//
- (void) test_constant_allScenarios_rightUpdatableAppsControllerNibName {
  STAssertTrue([TGEVE_CONST_APPS_UPDATABLE_NIB_NAME isEqualToString:@"TGEVE_UpdatableAppsViewController"], @"");
}

//***************************  TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME ***************************//
- (void) test_constant_allScenarios_rightTableNavigationControllerNibName {
  STAssertTrue([TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME isEqualToString:@"AppsTableNavigationViewController"], @"");
}

@end
