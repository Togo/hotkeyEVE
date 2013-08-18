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
  
}

- (void)tearDown
{
  [super tearDown];
}

//*************************** getUserID ***************************//
- (void) test_getUserIDFrom_foundOneUserWithThisUserNameInDB_returnTheUserID {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  NSInteger userID = 77;
  NSDictionary *rowOne = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:userID] forKey:ID_COL];
  NSArray *rows = [NSArray arrayWithObject:rowOne];
  

  [[[dbMock stub] andReturn:rows] executeQuery:OCMOCK_ANY];
  
  NSInteger returnedUserID = [TGEVE_UserTableModel getUserID :@"Test"];
  
  STAssertEquals(returnedUserID, userID, @"");
}

- (void) test_getUserIDFrom_noUserFoundWithThisName_insertUserIntoDB {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  NSArray *rows = [NSArray array];
  
  [[[dbMock stub] andReturn:rows] executeQuery:OCMOCK_ANY];
  
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  [[userTableMock expect] insertUserWithUserName :@"Test"];
  
  [TGEVE_UserTableModel getUserID:@"Test"];
  
  [userTableMock verify];
}

- (void) test_getUserIDFrom_noUserFoundWithThisNameAndInsertStatementSucceded_callGetUserIDStatementAgain {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  [[dbMock stub] executeUpdate:OCMOCK_ANY];
  NSInteger succeded = -2;
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  [[[userTableMock expect] andReturnValue:OCMOCK_VALUE(succeded)]  executeGetUserIDStatement :@"Test"];
  [[userTableMock expect]  executeGetUserIDStatement :@"Test"];
  
  [TGEVE_UserTableModel getUserID:@"Test"];
  
  [userTableMock verify];
}

- (void) test_getUserIDFrom_executeStatementDidCalledTwice_returnTheUserIDFromTheSecondStatement {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  [[dbMock stub] executeUpdate:OCMOCK_ANY];
  NSInteger succeded = -2;
  NSInteger userID = 99;
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  [[[userTableMock expect] andReturnValue:OCMOCK_VALUE(succeded)]  executeGetUserIDStatement :@"Test"];
  [[[userTableMock expect]  andReturnValue:OCMOCK_VALUE(userID)]   executeGetUserIDStatement :@"Test"];
  
  NSInteger returnedUserID = [TGEVE_UserTableModel getUserID:@"Test"];
  
  STAssertEquals(returnedUserID, userID, @"");
}

- (void) test_getUserIDFrom_executeStatementDidCalledTwiceAndReturnedAError_returnTheErrorCode {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];

  NSInteger failed = -1;
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  [[[userTableMock stub] andReturnValue:OCMOCK_VALUE(failed)]  executeGetUserIDStatement :@"Test"];
  [[dbMock stub] executeUpdate:OCMOCK_ANY];
  
  NSInteger  returnedUserID = [TGEVE_UserTableModel getUserID:@"Test"];
  
  STAssertEquals(returnedUserID, failed, @"");
}

- (void) test_getUserIDFrom_foundMoreThanOneIDWithThisUserName_returnError {
  OCMockObject *dbMock = [OCMockObject partialMockForObject:[[DatabaseManager sharedDatabaseManager] eveDatabase]];
  NSDictionary *rowOne = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:77] forKey:ID_COL];
  NSDictionary *rowTwo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:2] forKey:ID_COL];
  NSArray *rows = [NSArray arrayWithObjects:rowOne,rowTwo, nil];
  
  [[[dbMock stub] andReturn:rows] executeQuery:OCMOCK_ANY];
  
  NSInteger expectedError = -1;
  NSInteger returnedUserID =  [TGEVE_UserTableModel getUserID :@"Test"];
  
  STAssertEquals(returnedUserID, expectedError, @"");
}




@end
