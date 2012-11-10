//
//  UserDataTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "UserDataTableModel.h"

@implementation UserDataTableModel

+ (void) insertUser :(NSString*) user {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", USER_DATA_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , '%@' ", user];
  [query appendFormat:@" , 1); "];
  
  [db executeUpdate:query];

}

+ (NSInteger) getUserID :(NSString*) userName {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", USER_DATA_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", USER_NAME_COL, userName];
  
  NSInteger userID = 0;
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    userID = [[[result objectAtIndex:0] valueForKey:ID_COL] intValue];
  }
  
  return userID;
}

+ (NSInteger) selectStartAtLogin :(NSString*) userName {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT %@ FROM %@ ",START_AT_LOGIN_COL, USER_DATA_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", USER_NAME_COL, userName];
  
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    if ([[[result objectAtIndex:0] valueForKey:START_AT_LOGIN_COL] intValue] == 1) {
      return NSOnState;
    } else {
      return NSOffState;
    }
  }
  
  return NSOffState;
}

@end
