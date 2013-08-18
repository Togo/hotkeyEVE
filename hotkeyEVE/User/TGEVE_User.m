//
//  TGEVE_User.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/17/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_User.h"
#import "TGEVE_UserTableModel.h"

@implementation TGEVE_User

@synthesize userName = _userName;
@synthesize userID = _userID;

//untested
+ (id<TGEVE_IUser>) user {
  DDLogInfo(@"TGEVE_User -> user(void) :: get called");
  
  id<TGEVE_IUser> user = [[self alloc] init];
  
  @try {
      [user initUser];
  }
  @catch (NSException *exception) {
    DDLogError(@"TGEVE_User -> user :: I got an Exception :%@:", [exception reason]);
    // TODO close program
  }
  @finally {

  }  
  
  return user;
}

- (void) initUser {
  DDLogInfo(@"TGEVE_User -> loadUser(void) :: get called");
  
  NSString *userName = [self readUserName];
  if ( [userName isEqualToString:@""] || userName == nil ) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"UserName can't be empty or nil!" userInfo:nil];
  }
  
  [self setUserName:userName];
  DDLogInfo(@"TGEVE_User -> loadUser :: set userName to :%@: ", [self userName]);
  
  NSInteger userID = [TGEVE_UserTableModel getUserID:userName];
  if ( userID <= 0  ) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Got an error from the user id select. Close Program" userInfo:nil];
  }
  [self setUserID:userID];
  
  DDLogInfo(@"TGEVE_User -> loadUser :: set userID to :%li: ", [self userID]);
}

// to stub NSUserName() method
- (NSString*) readUserName {
  return NSUserName();
}

@end
