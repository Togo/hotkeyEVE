//
//  AppsNotInstalledViewControllerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/15/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsNotInstalledViewControllerTests.h"
#import <AppsLibrary/AppsLibrary.h>
#import <OCMock/OCMock.h>
#import "AppsNotInstalledModel.h"

@implementation AppsNotInstalledViewControllerTests

- (void)setUp
{
  [super setUp];
  _appsNotInstalledController = [[AppsNotInstalledViewController alloc] initWithNibName:kAppsNotInstalledViewControllerNibName bundle:nil];
  
  
  _tableView = [[NSTableView alloc] init];
  [_appsNotInstalledController setTableView:_tableView];
  
  _moduleIDTableColumn = [[NSTableColumn alloc] initWithIdentifier:kModuleID];
  [_appsNotInstalledController setModuleIDTableColumn:_moduleIDTableColumn];
  
  _appNameTableColumn = [[NSTableColumn alloc] initWithIdentifier:kAppNameKey];
  [_appsNotInstalledController setAppNameTableColumn:_appNameTableColumn];
  
  _languageTableColumn = [[NSTableColumn alloc] initWithIdentifier:kLanguageKey];
  [_appsNotInstalledController setLanguageTableColumn:_languageTableColumn];
  
  _userNameTableColumn = [[NSTableColumn alloc] initWithIdentifier:kLanguageKey];
  [_appsNotInstalledController setUserNameTableColumn:_userNameTableColumn];
  
  _credatTableColumn = [[NSTableColumn alloc] initWithIdentifier:kModuleCredatKey];
  [_appsNotInstalledController setCredatTableColumn:_credatTableColumn];
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

//************************* initWithNibName *************************//
- (void) test_initWithNibName_selfDidCreated_modelCreated {
  STAssertNotNil([_appsNotInstalledController model], @"");
}

- (void) test_initWithNibName_selfDidCreated_createBarberAnimation {
  STAssertNotNil([_appsNotInstalledController progressIndicator], @"");
}

//************************* awakeFromNib *************************//
- (void) test_awakeFromNib_allSecenarios_moduleIDColumnHasCorrectIdentifier {
  [[_appsNotInstalledController moduleIDTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController moduleIDTableColumn] identifier] isEqualToString:kModuleID], @"");
}

- (void) test_awakeFromNib_allSecenarios_appNameColumnHasCorrectIdentifier {
  [[_appsNotInstalledController appNameTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController appNameTableColumn] identifier] isEqualToString:kAppNameKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_languageColumnHasCorrectIdentifier {
  [[_appsNotInstalledController languageTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController languageTableColumn] identifier] isEqualToString:kLanguageKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_userNameColumnHasCorrectIdentifier {
  [[_appsNotInstalledController userNameTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController userNameTableColumn] identifier] isEqualToString:kUserNameKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_credatColumnHasCorrectIdentifier {
  [[_appsNotInstalledController credatTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController credatTableColumn] identifier] isEqualToString:kModuleCredatKey], @"");
}

//************************* objectValueForTableColumn *************************//
- (void) test_objectValueForTableColumn_rowSelected_returnNavigationColumnValue {
  
  [_appsNotInstalledController setDataSource:[self createDataSource :1]];
  NSString *returnValue = [_appsNotInstalledController tableView:_tableView objectValueForTableColumn:_moduleIDTableColumn row:0];
  STAssertTrue([returnValue isEqualToString:@"value1"], @"");
}

- (void) test_numberOfRowsInTableView_dataSourceWithOnItem_return1 {
  [_appsNotInstalledController setDataSource:[self createDataSource :1]];
  STAssertTrue([_appsNotInstalledController numberOfRowsInTableView:_tableView] == 1, @"");
}

//************************* loadView *************************//
- (void) test_loadView_viewWillBeDisplayed_startBackgroundJobWithLoadingTableData {
  id controllerMock = [OCMockObject partialMockForObject:_appsNotInstalledController];
  [[controllerMock expect] performSelectorInBackground:@selector(loadTableData) withObject:nil];
  
  [_appsNotInstalledController loadView];
  
  [controllerMock verify];
}

//************************* loadTableData *************************//
- (void) test_loadTableData_allScenarios_loadTableDataFromAppsNotInstalledModel {
  id modelMock = [OCMockObject niceMockForProtocol:@protocol(AppsNotInstalledModel)];
  [[modelMock expect] getNotInstalledList];

  [_appsNotInstalledController setModel:modelMock];
  [_appsNotInstalledController loadTableData];
  
  [modelMock verify];
}

- (void) test_loadTableData_allScenarios_reloadTable {
  id tableViewMock = [OCMockObject partialMockForObject:[_appsNotInstalledController tableView]];
  [[tableViewMock expect] reloadData];
  
  [_appsNotInstalledController loadTableData];
  
  [tableViewMock verify];
}

- (void) test_loadTableData_newDataSourceArray_dataSourceIsFromModelReturnedNewDataSource {
  id modelMock = [OCMockObject niceMockForProtocol:@protocol(AppsNotInstalledModel)];
  NSArray *newNotInstalledArray = [self createDataSource:1];
  [[[modelMock stub] andReturn:newNotInstalledArray] getNotInstalledList];
  
  [_appsNotInstalledController setModel:modelMock];
  [_appsNotInstalledController loadTableData];
  
  STAssertEquals([_appsNotInstalledController dataSource], newNotInstalledArray , @"");
}

- (void) test_loadTableData_loadingStarts_startProgressAnimation {
  id controllerMock = [OCMockObject partialMockForObject:_appsNotInstalledController];
  [[controllerMock expect] startProgressAnimationinSuperview:_tableView];
  
  [_appsNotInstalledController loadTableData];
  
  [controllerMock verify];
}

- (void) test_loadTableData_loadingEnds_stopProgressAnimation {
  id controllerMock = [OCMockObject partialMockForObject:_appsNotInstalledController];
  [[controllerMock expect] stopProgressAnimation];
  
  [_appsNotInstalledController loadTableData];
  
  [controllerMock verify];
}

//************************* startProgressAnimation *************************//
- (void) test_startProgressAnimationinSuperview_viewNotNil_addProgressIndicationToSuperview {
  [_appsNotInstalledController startProgressAnimationinSuperview:_tableView];
  STAssertTrue([[_tableView subviews] containsObject:[_appsNotInstalledController progressIndicator]], @"");
}

- (void) test_startProgressAnimationinSuperview_viewNotNil_startAnimation {
  id progressIndicatorMock = [OCMockObject partialMockForObject:[_appsNotInstalledController progressIndicator]];
  [[progressIndicatorMock expect] startAnimation:nil];
  
  [_appsNotInstalledController startProgressAnimationinSuperview:_tableView];
  
  [progressIndicatorMock verify];
}

- (void) test_startProgressAnimationinSuperview_viewNotNil_setTheFrameFromTheSuperview {
  [_tableView setFrame:NSMakeRect(0, 0, 10, 10)];
  [_appsNotInstalledController startProgressAnimationinSuperview:_tableView];
  NSRect expectedResult = [_tableView frame];
  NSRect  result = [[_appsNotInstalledController progressIndicator] frame];
  STAssertTrue(NSEqualRects(result, expectedResult), @"");
}

- (void) test_startProgressAnimationinSuperview_viewIsNil_throwException {
  STAssertThrows([_appsNotInstalledController startProgressAnimationinSuperview:nil], @"");
}

//************************* stopAnimationProgress *************************//
- (void) test_startProgressAnimationinSuperview_viewNotNil_stopAnimation {
  id progressIndicatorMock = [OCMockObject partialMockForObject:[_appsNotInstalledController progressIndicator]];
  [[progressIndicatorMock expect] stopAnimation:nil];
  
  [_appsNotInstalledController stopProgressAnimation];
  
  [progressIndicatorMock verify];
}

- (void) test_startProgressAnimationinSuperview_viewNotNil_removeProgressIndicationToSuperview {
  id progressIndicatorMock = [OCMockObject partialMockForObject:[_appsNotInstalledController progressIndicator]];
  [[progressIndicatorMock expect] removeFromSuperview];
  
  [_appsNotInstalledController stopProgressAnimation];
  
  [progressIndicatorMock verify];
}


- (NSArray<NSTableViewDataSource>*) createDataSource :(NSInteger) items{
  NSMutableArray<NSTableViewDataSource> *rows = [NSMutableArray array];
  for (int i = 1; i <= items; i++) {
    NSString *value = [NSString stringWithFormat:@"value%i", i];
    NSDictionary *aRow = [NSDictionary dictionaryWithObjectsAndKeys:value, kModuleID, nil];
    [rows addObject:aRow];
  }
  
  return rows;
}
@end
