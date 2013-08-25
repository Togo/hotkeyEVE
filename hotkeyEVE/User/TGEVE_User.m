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
@synthesize userData = _userData;

- (id<TGEVE_IUser>)init
{
  self = [super init];
  if (self) {
    
  }
  return self;
}

//untested
+ (id<TGEVE_IUser>) user {

  DDLogInfo(@"TGEVE_User -> user(void) :: get called");
  
  id<TGEVE_IUser> user = [[self alloc] init];
  @try {
    [user loadUser];
  }
  @catch (NSException *exception) {
    DDLogError(@"TGEVE_User -> user :: I got an Exception :%@:", [exception reason]);
    // TODO close program?
  }
  @finally {

  }  
  
  return user;
}

- (void) loadUser {
  DDLogInfo(@"TGEVE_User -> loadUser(void) :: get called");

  [self initializeUserName];
  [self loadUserRecordWith:[self userName]];
}

- (BOOL) loadUserRecordWith :(NSString*) userName {
  DDLogInfo(@"TGEVE_User -> loadUserRecord(userName => :%@:) :: get called", userName);
  NSDictionary *tempUserDic = [TGEVE_UserTableModel getUserRecordFromUserDataTable:userName];

  if ( tempUserDic == nil ) {
   @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Can't read or create a User Record in the database" userInfo:nil];
  }

  [self setUserData:tempUserDic];
  
  DDLogInfo(@"TGEVE_User -> loadUserRecord :: setUserDataTo :%@: and return YES", [self userData]);
  return YES;
}

- (BOOL) initializeUserName {
  NSString *userName = [self readUserName];
  if ( [userName isEqualToString:@""] || userName == nil ) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"UserName can't be empty or nil!" userInfo:nil];
  }
  
  [self setUserName:userName];
  DDLogInfo(@"TGEVE_User -> loadUser :: set userName to :%@: ", userName);
  
  return YES;
}

// to stub NSUserName() method
- (NSString*) readUserName {
  return NSUserName();
}

// TODO untested
- (NSInteger) startAtLogin {
  return (NSInteger)[[self userData] valueForKey:TGDB_CONST_START_AT_LOGIN_COL];
}

// TODO untested
- (void) setStartAtLogin :(NSInteger) startAtLogin {
    [[self userData] setValue:[NSNumber numberWithInteger:startAtLogin] forKey:TGDB_CONST_START_AT_LOGIN_COL];
}

// TODO untested
- (NSInteger) userID {
  return (NSInteger)[[self userData] valueForKey:ID_COL];
}

@end
