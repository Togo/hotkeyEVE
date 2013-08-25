//
//  TGEVE_UserTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/17/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_UserTableModel.h"
#import "EVEDatabase.h"

@implementation TGEVE_UserTableModel

+ (NSDictionary*) getUserRecordFromUserDataTable:(NSString *)userName {
  DDLogInfo(@"TGEVE_UserTableModel -> getUserRecordFromUserDataTable(userName => :%@:) :: get called", userName);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  NSDictionary *userDic;
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", TGDB_CONST_USER_DATA_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", TGDB_CONST_USER_NAME_COL, userName];

  NSInteger attempts = 3;
  do {
    NSArray *rows =  [db executeQuery:query];
    if (   rows == nil || [rows count] == 0 ) {
      DDLogInfo(@"TGEVE_UserTableModel -> getUserRecordFromUserDataTable :: Nothing found, i insert a new record");
      [TGEVE_UserTableModel insertUser:userName];
    } else {
      userDic = [rows objectAtIndex:0];
      DDLogInfo(@"TGEVE_UserTableModel -> getUserRecordFromUserDataTable :: found user: :%@:", userDic);
      break;
    }
    
   attempts--;
  } while ( attempts > 0 );

  DDLogInfo(@"TGEVE_UserTableModel -> getUserRecordFromUserDataTable :: Finished method get user. Return user: :%@:", userDic);
  
  return userDic;
}

+ (void) insertUser :(NSString*) user {
  DDLogInfo(@"TGEVE_UserTableModel -> insertUser(user => :%@:) :: get called", user);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", TGDB_CONST_USER_DATA_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , '%@' ", user];
  [query appendFormat:@" , 0 ); "];
  
  [db executeUpdate:query];
  DDLogInfo(@"TGEVE_UserTableModel -> insertUser :: finished insert");
}

@end
