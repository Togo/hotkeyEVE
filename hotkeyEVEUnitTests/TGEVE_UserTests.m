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

//*************************** initUser ***************************//
- (void) test_init_NSUserNameReturnedValidUserName_setTheUserName {
  [_user initUser];

  STAssertTrue([[_user userName] isEqualToString:NSUserName()], @"");
}

- (void) test_init_UserNameIsEmpty_throwException {
  OCMockObject *userNameMock = [OCMockObject partialMockForObject:_user];
  [[[userNameMock stub] andReturn:@""] readUserName];
  
  STAssertThrows([_user initUser], @"");
}

- (void) test_init_UserNameIsNil_throwException {
  OCMockObject *userNameMock = [OCMockObject partialMockForObject:_user];
 [[[userNameMock stub] andReturn:nil] readUserName];
  
  STAssertThrows([_user initUser], @"");
}

- (void) test_initUser_gotAnNegativeValueAsUserID_throwAnException {
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  NSInteger returnedUserID = -1;
  [[[userTableMock stub] andReturnValue:OCMOCK_VALUE(returnedUserID)] getUserID :OCMOCK_ANY];

  STAssertThrows([_user initUser], @"");
}

- (void) test_initUser_got0AsAsUserID_throwAnException {
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  NSInteger returnedUserID = 0;
  [[[userTableMock stub] andReturnValue:OCMOCK_VALUE(returnedUserID)] getUserID :OCMOCK_ANY];
  
  STAssertThrows([_user initUser], @"");
}

- (void) test_init_succefullReceivedUserIDFromDB_setUserIDProperty {
  OCMockObject *userTableMock = [OCMockObject mockForClass:[TGEVE_UserTableModel class]];
  NSInteger returnedUserID = 99;
  [[[userTableMock stub] andReturnValue:OCMOCK_VALUE(returnedUserID)] getUserID :OCMOCK_ANY];
  
  [_user initUser];
  
  STAssertEquals([_user userID], returnedUserID, @"");
}

@end
