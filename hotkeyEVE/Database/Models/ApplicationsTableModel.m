//
//  ApplicationsTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ApplicationsTableModel.h"
#import "GUISupportTableModel.h"

@implementation ApplicationsTableModel

+ (void) insertApp :(Application*) app {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger guiSupport = [GUISupportTableModel hasGUISupport:[app bundleIdentifier]];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", APPLICATIONS_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , '%@' ", [app appName]];
  [query appendFormat:@" , '%@' ", [app bundleIdentifier]];
  [query appendFormat:@" , %i ", 1];
  [query appendFormat:@" , %li ", guiSupport];
  [query appendFormat:@" , %li ", guiSupport];
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

+ (NSArray*) getAllApplicationsObjects {
  NSArray *results = [self selectAllApplications];
  NSMutableArray *applications = [NSMutableArray array];
  if ([results count] > 0) {
    for (id aRow in results) {
      Application *aApp = [[Application alloc] initWithBundleIdentifier:[aRow valueForKey:BUNDLE_IDEN_COL]];
      aApp.appID = [[aRow valueForKey:ID_COL] intValue];
      [applications addObject:aApp];
    }
  }
       
  return applications;
}

+ (NSArray*) selectAllApplications {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ a ", APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE EXISTS ( "];
  [query appendFormat:@" SELECT rowid FROM %@ m ", MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" WHERE a.%@ = m.%@ ", ID_COL, APPLICATION_ID_COL];
  [query appendFormat:@" LIMIT 1) "];
  [query appendFormat:@" ORDER BY a.%@ ", APP_NAME_COL];
  
  return  [db executeQuery:query];
}

@end
