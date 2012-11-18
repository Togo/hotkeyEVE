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

+ (BOOL) isNewApp :(Application*) app {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  // Already in database?
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT rowid FROM %@ ", APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE %@ = '%@' ", APP_NAME_COL, [app appName]];
  [query appendFormat:@" AND   %@ = '%@' ", BUNDLE_IDEN_COL, [app bundleIdentifier]];
  [query appendFormat:@" LIMIT  1 "];
  
  NSArray *result = [db executeQuery:query];
  
  if ( [result count] == 0 )
    return YES;
  else
    return NO;
}

+ (void) insertNewApplication :(Application*) app  {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];

  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", APPLICATIONS_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , '%@' ", [app appName]];
  [query appendFormat:@" , '%@' ", [app bundleIdentifier]];
  [query appendFormat:@" , %i ", 1];
  [query appendFormat:@" , %i ", 1];
  [query appendFormat:@" , %i ", [[NSNumber numberWithBool:[app guiSupport]] intValue]];
  [query appendFormat:@" ); "];
  
  [db executeUpdate:query];
}

+ (void) updateApplicationTable :(Application *) app  {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"UPDATE %@ ", APPLICATIONS_TABLE];
  [query appendFormat:@"SET %@ = %i ", GUI_SUPPORT_COL, [[NSNumber numberWithBool:[app guiSupport]] intValue]];
  [query appendFormat:@"WHERE %@ = '%@' ", APP_NAME_COL, [app appName]];
  [query appendFormat:@"AND   %@ = '%@' ", BUNDLE_IDEN_COL, [app bundleIdentifier]];
  
  [db executeUpdate:query];
}

+ (NSInteger) getApplicationID :(NSString*) appName :(NSString*) bundleIdentifier {
  DDLogInfo(@"ApplicationsTableModel -> getApplicationID(appName => :%@:, bundleIdentifier => :%@:) :: get called", appName,bundleIdentifier);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", APP_NAME_COL, appName];
  [query appendFormat:@" AND %@ like '%@' ", BUNDLE_IDEN_COL, bundleIdentifier];
  
  DDLogVerbose(@"ApplicationsTableModel -> getApplicationID:: query => :%@:", query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    NSInteger appID = [[[result objectAtIndex:0] valueForKey:ID_COL] intValue];
    DDLogInfo(@"ApplicationsTableModel -> getApplicationID:: found appID => :%li:", appID);
    return appID;
  } else {
    DDLogError(@"ApplicationsTableModel -> getApplicationID:: no appID query => :%@:", query);
     return 0;
  }
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
  [query appendFormat:@" AND  a.%@ NOT LIKE '%@' ", APP_NAME_COL, @"(null)"];
  [query appendFormat:@" LIMIT 1) "];
  [query appendFormat:@" ORDER BY a.%@ ", APP_NAME_COL];
  
  return  [db executeQuery:query];
}

+ (BOOL) isInApplicationBlacklist :(Application*) app {
  DDLogInfo(@"ApplicationsTableModel -> isInApplicationBlacklist(app => :%@:) :: get called ", app);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", APPLICATION_BLACKLIST_TABLE];
  [query appendFormat:@" WHERE "];
  [query appendFormat:@" %@ like '%@' ", BUNDLE_IDEN_COL, [app bundleIdentifier]];
  [query appendFormat:@" LIMIT 1 "];
  
  DDLogVerbose(@"ApplicationsTableModel -> isInApplicationBlacklist :: query %@", query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
   DDLogInfo(@"ApplicationsTableModel -> isInApplicationBlacklist :: The App is in the blacklist. AppName => :%@: BundleIdentifier => :%@: ", [app appName], [app bundleIdentifier]);
    return YES;
  } else {
   return  NO;
  }
}

@end
