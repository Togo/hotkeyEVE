//
//  AppsNotInstalledViewControllerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/15/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsTableViewControllerTests.h"
#import <AppsLibrary/AppsLibrary.h>
#import <OCMock/OCMock.h>
#import "TGEVE_IAppsManager.h"
#import "AppsManagerMock.h"
#import "GUINotifications.h"
#import <Objc-Util/Objc_Util.h>
#import "AppModuleTableModel.h"


@implementation AppsTableViewControllerTests

- (void)setUp
{
  [super setUp];
  _appsNotInstalledController = [[TGEVE_AllAppsViewController alloc] initWithNibName:kAppsTableViewControllerNibName bundle:nil];
  
  
  _tableView = [[NSTableView alloc] init];
  [_appsNotInstalledController setTableView:_tableView];
  
  _installedTableColumn = [[NSTableColumn alloc] initWithIdentifier :TGUTIL_TCOLID_INSTALLED];
  [_appsNotInstalledController setInstalledTableColumn:_installedTableColumn];
  
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
  
  [_appsNotInstalledController setAppsManager:[[AppsManagerMock alloc] init]];
  
  id controllerMock = [OCMockObject partialMockForObject:_appsNotInstalledController];
  [[controllerMock stub] registerObserver];
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

//************************* initWithNibName *************************//
- (void) test_initWithNibName_selfDidCreated_appsManagerCreated {
  STAssertNotNil([_appsNotInstalledController appsManager], @"");
}

//************************* awakeFromNib *************************//
- (void) test_awakeFromNib_allSecenarios_moduleIDColumnHasCorrectIdentifier {
  [[_appsNotInstalledController moduleIDTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController moduleIDTableColumn] identifier] isEqualToString:kModuleID], @"");
}

- (void) test_awakeFromNib_allSecenarios_moduleIDColumnIsHidden {
  [[_appsNotInstalledController moduleIDTableColumn] setHidden:NO];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[_appsNotInstalledController moduleIDTableColumn] isHidden], @"");
}

- (void) test_awakeFromNib_allSecenarios_appNameColumnHasCorrectIdentifier {
  [[_appsNotInstalledController appNameTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController appNameTableColumn] identifier] isEqualToString:kAppNameKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_appNameTableSortDescriptorKey {
  [[_appsNotInstalledController appNameTableColumn] setSortDescriptorPrototype:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[[_appsNotInstalledController appNameTableColumn] sortDescriptorPrototype] key] isEqualToString:kAppNameKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_appNameColumnNotEditable  {
  [[_appsNotInstalledController appNameTableColumn] setEditable:YES];
  [_appsNotInstalledController awakeFromNib];
  STAssertFalse([[_appsNotInstalledController appNameTableColumn] isEditable], @"");
}

- (void) test_awakeFromNib_allSecenarios_languageColumnHasCorrectIdentifier {
  [[_appsNotInstalledController languageTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController languageTableColumn] identifier] isEqualToString:kLanguageKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_languageTableSortDescriptorKey {
  [[_appsNotInstalledController languageTableColumn] setSortDescriptorPrototype:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[[_appsNotInstalledController languageTableColumn] sortDescriptorPrototype] key] isEqualToString:kLanguageKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_languageTableColumnNotEditable  {
  [[_appsNotInstalledController languageTableColumn] setEditable:YES];
  [_appsNotInstalledController awakeFromNib];
  STAssertFalse([[_appsNotInstalledController languageTableColumn] isEditable], @"");
}

- (void) test_awakeFromNib_allSecenarios_userNameColumnHasCorrectIdentifier {
  [[_appsNotInstalledController userNameTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController userNameTableColumn] identifier] isEqualToString:kUserNameKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_languageTableColumnIsEditable  {
  [[_appsNotInstalledController installedTableColumn] setEditable:NO];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[_appsNotInstalledController installedTableColumn] isEditable], @"");
}

- (void) test_awakeFromNib_allSecenarios_installedColumnHasCorrectIdentifier {
  [[_appsNotInstalledController installedTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController installedTableColumn] identifier] isEqualToString:TGUTIL_TCOLID_INSTALLED], @"");
}

- (void) test_awakeFromNib_allSecenarios_userNameTableSortDescriptorKey {
  [[_appsNotInstalledController userNameTableColumn] setSortDescriptorPrototype:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[[_appsNotInstalledController userNameTableColumn] sortDescriptorPrototype] key] isEqualToString:kUserNameKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_userNameTableColumnNotEditable  {
  [[_appsNotInstalledController userNameTableColumn] setEditable:YES];
  [_appsNotInstalledController awakeFromNib];
  STAssertFalse([[_appsNotInstalledController userNameTableColumn] isEditable], @"");
}

- (void) test_awakeFromNib_allSecenarios_credatColumnHasCorrectIdentifier {
  [[_appsNotInstalledController credatTableColumn] setIdentifier:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[_appsNotInstalledController credatTableColumn] identifier] isEqualToString:kModuleCredatKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_credatTableSortDescriptorKey {
  [[_appsNotInstalledController credatTableColumn] setSortDescriptorPrototype:nil];
  [_appsNotInstalledController awakeFromNib];
  STAssertTrue([[[[_appsNotInstalledController credatTableColumn] sortDescriptorPrototype] key] isEqualToString:kModuleCredatKey], @"");
}

- (void) test_awakeFromNib_allSecenarios_credatTableColumnNotEditable  {
  [[_appsNotInstalledController credatTableColumn] setEditable:YES];
  [_appsNotInstalledController awakeFromNib];
  STAssertFalse([[_appsNotInstalledController credatTableColumn] isEditable], @"");
}

- (void) test_awakeFromNib_allScenarios_addReloadObserver {
  id controllerMock = [OCMockObject partialMockForObject:_appsNotInstalledController];
  [[controllerMock expect] registerObserver];
  
  [_appsNotInstalledController awakeFromNib];
  
  [controllerMock verify];
}

//************************* objectValueForTableColumn *************************//
- (void) test_objectValueForTableColumn_tablePrintsModuleIDColumn_returnModuleIDCellValue {
  [_appsNotInstalledController setDataSource:[self createDataSource :1]];
  NSString *returnValue = [_appsNotInstalledController tableView:_tableView objectValueForTableColumn:_moduleIDTableColumn row:0];
  STAssertTrue([returnValue isEqualToString:@"value1"], @"");
}

- (void) test_objectValueForTableColumn_dateColumn_formatDateString {
  [_appsNotInstalledController setDataSource:[self createDataSource :1]];
  [[[_appsNotInstalledController  dataSource] objectAtIndex:0] setValue:@"2013-01-26 20:34:52 +0000" forKey:kModuleCredatKey];
  NSString *returnValue = [_appsNotInstalledController tableView:_tableView objectValueForTableColumn:_credatTableColumn row:0];
  STAssertTrue([returnValue isEqualToString:@"2013-01-26 at 21:34"], @"");
}

//************************* numberOfRowsInTableView *************************//
- (void) test_numberOfRowsInTableView_dataSourceWithOnItem_return1 {
  [_appsNotInstalledController setDataSource:[self createDataSource :1]];
  STAssertTrue([_appsNotInstalledController numberOfRowsInTableView:_tableView] == 1, @"");
}


//************************* loadView *************************//
- (void) test_loadView_viewWillBeDisplayed_startBackgroundJobWithLoadingTableData {
  id controllerMock = [OCMockObject partialMockForObject:_appsNotInstalledController];
  [[controllerMock expect] loadTableData];
  [[controllerMock stub] registerObserver];
  
  [_appsNotInstalledController loadView];
  
  [controllerMock verify];
}

- (void) test_loadTableData_loadingStarts_startProgressAnimation {
  id controllerMock = [OCMockObject partialMockForObject:_appsNotInstalledController];
  [[controllerMock expect] startProgressAnimationinSuperview:_tableView];
  
  [_appsNotInstalledController loadTableData];
  
  [controllerMock verify];
}

//************************* startProgressAnimation *************************//
- (void) test_startProgressAnimationinSuperview_viewNotNil_addProgressIndicationToSuperview {
  [_appsNotInstalledController startProgressAnimationinSuperview:_tableView];
  STAssertTrue([[_tableView subviews] containsObject:[_appsNotInstalledController progressIndicator]], @"");
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

- (void) test_writeRowsWithIndexes_oneRowSelected_pasteModuleIDStringToClipboard {
  NSIndexSet *selectedRows = [NSIndexSet indexSetWithIndex:0];
  [_appsNotInstalledController setDataSource:[self createDataSource :1]];
  
  id pasteBoardMock = [OCMockObject partialMockForObject:[NSPasteboard pasteboardWithName:NSDragPboard]];
  [[pasteBoardMock expect] setString:@"value1" forType:NSPasteboardTypeString];
  
  [_appsNotInstalledController tableView:[_appsNotInstalledController tableView] writeRowsWithIndexes:selectedRows toPasteboard:[NSPasteboard pasteboardWithName:NSDragPboard]];
  
  [pasteBoardMock verify];
}

- (void) test_writeRowsWithIndexes_twoRowSelected_pasteModuleIDStringsSeparatedWithNewLineToClipboard {
  NSIndexSet *selectedRows = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
  [_appsNotInstalledController setDataSource:[self createDataSource :2]];
  
  id pasteBoardMock = [OCMockObject partialMockForObject:[NSPasteboard pasteboardWithName:NSDragPboard]];
  [[pasteBoardMock expect] setString:@"value1\nvalue2" forType:NSPasteboardTypeString];
  
  [_appsNotInstalledController tableView:[_appsNotInstalledController tableView] writeRowsWithIndexes:selectedRows toPasteboard:[NSPasteboard pasteboardWithName:NSDragPboard]];
  
  [pasteBoardMock verify];
}

- (void) test_writeRowsWithIndexes_rowsSelected_returnYES {
  NSIndexSet *selectedRows = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
  [_appsNotInstalledController setDataSource:[self createDataSource :2]];
  
  id pasteBoardMock = [OCMockObject partialMockForObject:[NSPasteboard pasteboardWithName:NSDragPboard]];
  [[pasteBoardMock stub] setString:OCMOCK_ANY forType:OCMOCK_ANY];
  
  BOOL result = [_appsNotInstalledController tableView:[_appsNotInstalledController tableView] writeRowsWithIndexes:selectedRows toPasteboard:[NSPasteboard pasteboardWithName:NSDragPboard]];
  STAssertTrue(result, @"");
}

- (void) test_writeRowsWithIndexes_indexSetIsEmpty_returnFalse {
  NSIndexSet *selectedRows = [[NSIndexSet alloc] init];
  [_appsNotInstalledController setDataSource:[self createDataSource :2]];
  
  
  BOOL result = [_appsNotInstalledController tableView:[_appsNotInstalledController tableView] writeRowsWithIndexes:selectedRows toPasteboard:[NSPasteboard pasteboardWithName:NSDragPboard]];
  
  STAssertFalse(result, @"");
}

- (NSMutableArray<NSTableViewDataSource>*) createDataSource :(NSInteger) items{
  NSMutableArray<NSTableViewDataSource> *rows = [NSMutableArray array];
  for (int i = 1; i <= items; i++) {
    NSString *value = [NSString stringWithFormat:@"value%i", i];
    NSMutableDictionary *aRow = [NSMutableDictionary dictionaryWithObjectsAndKeys:value, kModuleID, @"2013-01-26 20:34:52 +000", kModuleCredatKey, nil];
    [rows addObject:aRow];
  }
  
  return rows;
}
//************************* loadTableData *************************//
//- (void) test_loadTableData_returnedArrayContainsAString_showInfoMessage {
//
//  NSString *errorMessage = @"error Message";
//  id  appsManagerMock = [OCMockObject niceMockForProtocol:@protocol(TGEVE_IAppsManager)];
//  [[appsManagerMock stub] andReturn:[NSArray arrayWithObject:errorMessage]];
//  
//  id alertMock = [OCMockObject mockForClass:[NSAlert class]];
//  [_appsNotInstalledController setAppsManager:appsManagerMock];
//  [_appsNotInstalledController setAlertController :alertMock];
//  
//  [[alertMock expect] showModalAlertSheetForWindow:OCMOCK_ANY message:OCMOCK_ANY informativeText:OCMOCK_ANY alertStyle:0 buttonBlocks:nil buttonTitle:@"Oki, doki", nil];
//  [_appsNotInstalledController loadTableData];
//
//  [alertMock verify];
//  }
@end
