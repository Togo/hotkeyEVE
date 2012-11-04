//
//  ApplicationsTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ApplicationsTableModel.h"

@implementation ApplicationsTableModel

+ (void) insertApp :(Application*) app {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", APPLICATIONS_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , '%@' ", [app appName]];
  [query appendFormat:@" , '%@' ", [app bundleIdentifier]];
  [query appendFormat:@" , %i ", 1];
  [query appendFormat:@" , %i ", 1];
  [query appendFormat:@" ); "];
  
  [db executeUpdate:query];
}

+ (NSInteger) getApplicationID :(NSString*) appName :(NSString*) bundleIdentifier {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", APP_NAME_COL, appName];
  [query appendFormat:@" AND %@ like '%@' ", BUNDLE_IDEN_COL, bundleIdentifier];
  
  NSInteger appID = 0;
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    appID = [[[result objectAtIndex:0] valueForKey:ID_COL] intValue];
  }
  
  return appID;
}

@end
