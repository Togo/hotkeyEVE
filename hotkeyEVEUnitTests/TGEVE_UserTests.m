//
//  TGEVE_UserTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/17/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_UserTests.h"
#import "TGEVE_User.h"
#import "TGEVE_IUser.h"
#import <OCMock/OCMock.h>
#import "TGEVE_UserTableModel.h"

@implementation TGEVE_UserTests {
  @private
    id<TGEVE_IUser> _user;
}

- (void)setUp
{
  [super setUp];
  
  _user = [[TGEVE_User alloc] init];
}

- (void)tearDown
{
  [super tearDown];
}

//*************************** loadUser ***************************//
- (void) test_loadUser_allScenarios_initializeUserName {
  OCMockObject *userMock = [OCMockObject  partialMockForObject:_user];
  [[userMock stub] loadUserRecordWith:OCMOCK_ANY];
  [[userMock expect] initializeUserName];
  
  [_user loadUser];
  
  [userMock verify];
}

- (void) test_loadUser_allScenarios_loadUserDataWithUserName {
  OCMockObject *userMock = [OCMockObject  partialMockForObject:_user];
  [[[userMock stub] andReturn:@"Test"] readUserName];
  [[userMock expect] loadUserRecordWith:@"Test"];
  
  [_user loadUser];
  
  [userMock verify];
}

//*************************** initializeUserName ***************************//
- (void) test_initializeUserName_NSUserNameReturnedValidUserName_setTheUserName {
  [_user initializeUserName];

  STAssertTrue([[_user userName] isEqualToString:NSUserName()], @"");
}

- (void) test_initializeUserName_UserNameIsEmpty_throwException {
  OCMockObject *userNameMock = [OCMockObject partialMockForObject:_user];
  [[[userNameMock stub] andReturn:@""] readUserName];
  
  STAssertThrows([_user initializeUserName], @"");
}

- (void) test_initializeUserName_UserNameIsNil_throwException {
  OCMockObject *userNameMock = [OCMockObject partialMockForObject:_user];
 [[[userNameMock stub] andReturn:nil] readUserName];
  
  STAssertThrows([_user initializeUserName], @"");
}



//*************************** loadUserRecord ***************************//
- (void) test_loadUserRecord_gotANilUser_throwException {
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  NSDictionary *user = nil;
  [[[userTableMock stub] andReturnValue:OCMOCK_VALUE(user)] getUserRecordFromUserDataTable :OCMOCK_ANY];
  
  STAssertThrows([_user loadUserRecordWith:OCMOCK_ANY], @"");
}

- (void) test_loadUserRecord_gotAUserRecord_returnYES {
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  NSDictionary *userDic = [NSDictionary dictionary];
  [[[userTableMock stub] andReturnValue:OCMOCK_VALUE(userDic)] getUserRecordFromUserDataTable :OCMOCK_ANY];
  
  STAssertTrue([_user loadUserRecordWith:OCMOCK_ANY], @"");
}

- (void) test_loadUserRecord_gotAUserRecord_setTheUserDataDictionaryWithThisRecord {
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  NSDictionary *userDic = [NSDictionary dictionary];
  [[[userTableMock stub] andReturnValue:OCMOCK_VALUE(userDic)] getUserRecordFromUserDataTable :OCMOCK_ANY];

  [_user loadUserRecordWith:OCMOCK_ANY];
  
  STAssertEqualObjects([_user userData], userDic, @"");
}

- (void) test_loadUserRecord_gotNilAsUserRecord_ThrowAnException {
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  [[[userTableMock stub] andReturn:nil] getUserRecordFromUserDataTable :OCMOCK_ANY];
  
  STAssertThrows([_user loadUserRecordWith:OCMOCK_ANY], @"");
}

- (void) test_loadUserRecord_userNameReadSucceded_getUserDataFromDB {
  [_user setUserName:@"Test"];
  
  OCMockObject *dbMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  NSDictionary *user = [NSDictionary dictionary];
  [[[dbMock expect] andReturn:user] getUserRecordFromUserDataTable :@"Test"];
  
  [_user loadUserRecordWith:@"Test"];
 
  [dbMock verify];
}

@end
