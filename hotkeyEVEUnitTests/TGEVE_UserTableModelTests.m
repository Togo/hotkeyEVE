//
//  TGEVE_UserTableModelTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/18/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_UserTableModelTests.h"
#import "TGEVE_UserTableModel.h"
#import "EVEDatabase.h"
#import "DatabaseManager.h"
#import <OCMock/OCMock.h>
#import <Database/TableAndColumnNames.h>

@implementation TGEVE_UserTableModelTests

- (void)setUp
{
  [super setUp];
  // dont execute querys on a real database
  [[DatabaseManager sharedDatabaseManager] setEveDatabase:[[EVEDatabase alloc] init]];
}

- (void)tearDown
{
  [super tearDown];
}

//*************************** getUserRecordFromUserDataTable ***************************//

- (void) test_getUserRecordFromUserDataTable_allScenarios_executeCorrectSelect {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", TGDB_CONST_USER_DATA_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", TGDB_CONST_USER_NAME_COL, @"Test"];
  [[dbMock expect] executeQuery:query];
  
  [TGEVE_UserTableModel getUserRecordFromUserDataTable:@"Test"];
  
  [dbMock verify];
}
- (void) test_getUserRecordFromUserDataTable_foundRecordsInDB_returnTheDictionary {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  NSDictionary *firstRow = [NSDictionary dictionary];
  NSDictionary *secondRow = [NSDictionary dictionary];

  
  [[[dbMock stub] andReturn:[NSArray arrayWithObjects:firstRow, secondRow,nil]] executeQuery:OCMOCK_ANY];
  
  NSDictionary *returnedDict = [TGEVE_UserTableModel  getUserRecordFromUserDataTable:OCMOCK_ANY];
  
  STAssertEqualObjects(returnedDict, firstRow, @"");
  
}



- (void) test_getUserRecordFromUserDataTable_foundNothingInDB_insertUserToDBAndTryItAgain {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  
  [[[dbMock expect] andReturn:[NSArray array]] executeQuery:OCMOCK_ANY];
  [[dbMock expect] executeUpdate:OCMOCK_ANY];
  [[dbMock expect] executeQuery:OCMOCK_ANY];
  
  [TGEVE_UserTableModel getUserRecordFromUserDataTable:@"Test"];
  
  [dbMock verify];
}

- (void) test_getUserRecordFromUserDataTable_foundRecordAfterInsert_jumpOutOfWhileLoop {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  
  [[[dbMock expect] andReturn:[NSArray array]] executeQuery:OCMOCK_ANY];
  [[dbMock expect] executeUpdate:OCMOCK_ANY];
  [[[dbMock expect] andReturn:[NSArray arrayWithObject:[NSDictionary dictionary]]] executeQuery:OCMOCK_ANY];
  [[dbMock reject] executeUpdate:OCMOCK_ANY];
  
  [TGEVE_UserTableModel getUserRecordFromUserDataTable:@"Test"];
  
  [dbMock verify];  
}

- (void) test_getUserRecordFromUserDataTable_nothingStillNothingAfterThreeInsertAttempts_returnNilDic {
  NSDictionary *userDic = [TGEVE_UserTableModel getUserRecordFromUserDataTable:@"Test"];
  
  STAssertNil(userDic, @"");
}

@end
