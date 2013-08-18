//
//  TGEVE_UserTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/17/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_UserTableModel.h"

@implementation TGEVE_UserTableModel

+ (NSInteger) getUserID :(NSString*) userName {
  DDLogInfo(@"TGEVE_UserTableModel -> getUserID :: getcalled(userName => :%@:) ", userName);
  
  NSInteger userID = 0;
  userID = [self executeGetUserIDStatement :userName];
  if (  userID == -2 ) {
    userID = [self executeGetUserIDStatement:userName];
  }
  
  DDLogInfo(@"TGEVE_UserTableModel -> getUserID :: return UserID :%li: ) ", userID);
  return userID;
}

+ (NSInteger) executeGetUserIDStatement :(NSString *)userName {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  NSInteger userID=0;
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT %@ FROM %@ ", ID_COL, TGDB_CONST_USER_DATA_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ",TGDB_CONST_USER_NAME_COL, userName];
  NSArray *results = [db executeQuery:query];
  
  if ( [results count] == 1 ) {
    userID  = [[[results objectAtIndex:0] valueForKey:ID_COL] integerValue];
    DDLogInfo(@"TGEVE_UserTableModel -> getUserID :: foundUserID :%li:) ", userID);
  } else if ( [results count] == 0 ) {
    DDLogInfo(@"TGEVE_UserTableModel -> getUserID :: no user Found ) ");
    userID = [TGEVE_UserTableModel insertUserWithUserName:userName];
  } else {
    DDLogInfo(@"TGEVE_UserTableModel -> insertUserWithUserName :: more than one entry with this id return an error ) ");
    userID = -1;
  }
  
  return userID;
}

// untested
+ (NSInteger) insertUserWithUserName:(NSString *)userName {
  DDLogInfo(@"TGEVE_UserTableModel -> insertUserWithUserName :: getcalled(userName => :%@:) ", userName);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", TGDB_CONST_USER_DATA_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , '%@' ", userName];
  [query appendFormat:@" , 0 ); "];
  
  Boolean error =  [db executeUpdate:query];
  if ( !error ) {
    DDLogInfo(@"TGEVE_UserTableModel -> insertUserWithUserName :: insertStatementSucceded ) ");
    return -2;
  } else {
    DDLogInfo(@"There went something wrong with the inser Statement => query :%@:", query);
    return -1;
  }
}

@end
