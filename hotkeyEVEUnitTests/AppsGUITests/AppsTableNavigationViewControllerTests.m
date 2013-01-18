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
#import "AppsNotInstalledViewController.h"

@implementation AppsTableNavigationViewControllerTests

- (void)setUp
{
  [super setUp];
  
  _tableNavController = [[AppsTableNavigationViewController alloc] initWithNibName:kAppsTableNavigationViewControllerNibName bundle:nil];
  
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

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithInstalledColumn {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"NavigationColumn"];
  STAssertTrue([returnValue isEqualToString:@"Installed"], @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithAppsInstalledViewNibName {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"NibName"];
  STAssertTrue([returnValue isEqualToString:kAppsInstalledViewControllerNibName], @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithAppsInstalledClass {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"Class"];
  STAssertTrue([returnValue isEqualTo:[AppsInstalledViewController class]], @"");
}

- (void) test_initWithNibName_dataSourceNotInstalledRow_dataSourceContainsRowWithInstalledColumn {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"NavigationColumn"];
  STAssertTrue([returnValue isEqualToString:@"Not Installed"], @"");
}

- (void) test_initWithNibName_dataSourceNotInstalledRow_dataSourceContainsRowWithAppsInstalledViewNibName {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"NibName"];
  STAssertTrue([returnValue isEqualToString:kAppsNotInstalledViewControllerNibName], @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithAppsNotInstalledClass {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"Class"];
  STAssertTrue([returnValue isEqualTo:[AppsNotInstalledViewController class]], @"");
}

//************************* loadView *************************//


//************************* objectValueForTableColumn *************************//
- (void) test_objectValueForTableColumn_rowSelected_returnNavigationColumnValue {
  NSTableColumn *navTableColumn = [[NSTableColumn alloc] initWithIdentifier:@"NavigationColumn"];
  NSString *returnValue = [_tableNavController tableView:_tableView objectValueForTableColumn:navTableColumn row:0];
  STAssertTrue([returnValue isEqualToString:@"Installed"], @"");
}

//************************* tableViewSelectionDidChange *************************//
- (void)test_tableViewSelectionDidChange_withTableViewAndRow0Selected_callDelegateWithInstalledView {
  NSNotification *notification = [NSNotification notificationWithName:NSTableViewSelectionDidChangeNotification object:_tableView];
  
  id tableViewMock = [OCMockObject partialMockForObject:_tableView];
  NSInteger selectedRow = 0;
  [[[tableViewMock stub] andReturnValue:OCMOCK_VALUE(selectedRow)] selectedRow];
  
  id navigationDelegateMock = [OCMockObject niceMockForProtocol:@protocol(AppsNavigationDelegate)];
  id expectedClass = [[[_tableNavController dataSource] objectAtIndex:selectedRow] valueForKey:@"Class"];
  [[navigationDelegateMock expect] viewSelectionDidChanged:expectedClass :kAppsInstalledViewControllerNibName];
  
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
  [[navigationDelegateMock reject] viewSelectionDidChanged:[OCMArg any] :kAppsInstalledViewControllerNibName];
  
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

@end
