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
#import "AppsTableViewController.h"
#import "AppsManagerAmazon.h"
#import "AppsManagerLocalDB.h"

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

- (void) test_initWithNibName_all_appsManagerAlloced {
  STAssertNotNil([_tableNavController appsManager]  , @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithInstalledColumn {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"NavigationColumn"];
  STAssertTrue([returnValue isEqualToString:@"Installed"], @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithAppsTableViewNibName {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"NibName"];
  STAssertTrue([returnValue isEqualToString:kAppsTableViewControllerNibName], @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithAppsTableViewClass {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"Class"];
  STAssertTrue([returnValue isEqualTo:[AppsTableViewController class]], @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithLocalDBModel {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:0] valueForKey:@"model"];
  STAssertTrue([returnValue isEqualTo:[AppsManagerLocalDB class]], @"");
}

- (void) test_initWithNibName_dataSourceNotInstalledRow_dataSourceContainsRowWithNotInstalledColumn {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"NavigationColumn"];
  STAssertTrue([returnValue isEqualToString:@"Not Installed"], @"");
}

- (void) test_initWithNibName_dataSourceNotInstalledRow_dataSourceContainsRowWithAppsTableViewViewNibName {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"NibName"];
  STAssertTrue([returnValue isEqualToString:kAppsTableViewControllerNibName], @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithAppsTableViewClassw {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"Class"];
  STAssertTrue([returnValue isEqualTo:[AppsTableViewController class]], @"");
}

- (void) test_initWithNibName_dataSourceInstalledRow_dataSourceContainsRowWithAppsAmazonModel {
  NSString *returnValue = [[[_tableNavController dataSource] objectAtIndex:1] valueForKey:@"model"];
  STAssertTrue([returnValue isEqualTo:[AppsManagerAmazon class]], @"");
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
  id expectedViewController = [[[_tableNavController dataSource] objectAtIndex:selectedRow] valueForKey:@"Class"];
  id expectedModelClass = [[[_tableNavController dataSource] objectAtIndex:selectedRow] valueForKey:@"model"];
  [[navigationDelegateMock expect] viewSelectionDidChanged:expectedViewController :kAppsTableViewControllerNibName :expectedModelClass];
  
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
  [[navigationDelegateMock reject] viewSelectionDidChanged:[OCMArg any] :kAppsTableViewControllerNibName :[OCMArg any]];
  
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


- (void) test_awakeFromNib_allSecenarios_registerForDragAndDrop  {
  id tableViewMock = [OCMockObject partialMockForObject:[_tableNavController navigationTableView]];
  [[tableViewMock expect] registerForDraggedTypes:OCMOCK_ANY];
  
  [_tableNavController awakeFromNib];
  
  [tableViewMock verify];
}

//************************* validateDrop *************************//
- (void) test_validateDrop_dropRowInRowCountAndOnRow_allOperationAllowed {
  id tableViewMock = [OCMockObject partialMockForObject:[_tableNavController navigationTableView]];
  NSInteger rowNumbers = 2;
  [[[tableViewMock stub] andReturnValue:OCMOCK_VALUE(rowNumbers)] numberOfRows];
  
  NSInteger  expectedValue = [_tableNavController tableView:_tableView validateDrop:nil proposedRow:1 proposedDropOperation:NSTableViewDropOn];
  
  STAssertTrue(expectedValue == NSDragOperationEvery, @"");
}

- (void) test_validateDrop_dropRowNotInRowCountAndOnRow_noOperationAllowed {
  id tableViewMock = [OCMockObject partialMockForObject:[_tableNavController navigationTableView]];
  NSInteger rowNumbers = 0;
  [[[tableViewMock stub] andReturnValue:OCMOCK_VALUE(rowNumbers)] numberOfRows];
  
  NSInteger  expectedValue = [_tableNavController tableView:_tableView validateDrop:nil proposedRow:2 proposedDropOperation:NSTableViewDropOn];
  
  STAssertTrue(expectedValue == NSDragOperationNone, @"");
}

- (void) test_validateDrop_dropRowInRowCountAndAboveRow_noOperationAllowed {
  id tableViewMock = [OCMockObject partialMockForObject:[_tableNavController navigationTableView]];
  NSInteger rowNumbers = 4;
  [[[tableViewMock stub] andReturnValue:OCMOCK_VALUE(rowNumbers)] numberOfRows];
  
  NSInteger  expectedValue = [_tableNavController tableView:_tableView validateDrop:nil proposedRow:2 proposedDropOperation:NSTableViewDropAbove];
  
  STAssertTrue(expectedValue == NSDragOperationNone, @"");
}

//************************* acceptDrop *************************//
- (void) test_acceptDrop_pasteBoardDropZoneInstallRow_callAppManagerToInstallAppWithArray {
  id appsManagerMock = [OCMockObject mockForClass:[AppsManagerAmazon class]];
  [[appsManagerMock expect] addAppsFromArray:OCMOCK_ANY];
  
  [_tableNavController setAppsManager:appsManagerMock];
  
  [_tableNavController tableView:nil acceptDrop:nil row:0 dropOperation:NSDragOperationEvery];
  
  [appsManagerMock verify];
}

- (void) test_acceptDrop_pasteBoardDropZoneInstallRow_callAppManagerUnInstallAppsFromArray {
  id appsManagerMock = [OCMockObject mockForClass:[AppsManagerAmazon class]];
  [[appsManagerMock expect] removeAppsFromArray:OCMOCK_ANY];
  
  [_tableNavController setAppsManager:appsManagerMock];
  
  [_tableNavController tableView:nil acceptDrop:nil row:1 dropOperation:NSDragOperationEvery];
  
  [appsManagerMock verify];
}

@end
