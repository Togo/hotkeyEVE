//
//  ApplicationsTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ApplicationsTableModel.h"
#import "GUISupportTableModel.h"
#import "EVEUtilities.h"

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
    return appID;
  } else {
    DDLogError(@"ApplicationsTableModel -> getApplicationID:: no appID query => :%@:", query);
     return 0;
  }
}

+ (NSArray*) selectAllApplications {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ a ", APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE EXISTS ( "];
  [query appendFormat:@" SELECT rowid FROM %@ m ", MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" WHERE a.%@ = m.%@ ", ID_COL, APPLICATION_ID_COL];
  [query appendFormat:@" AND m.%@ like '%@' ", LANG_COL, [EVEUtilities currentLanguage]];
  [query appendFormat:@" LIMIT 1) "];
  [query appendFormat:@" AND  a.%@ NOT LIKE '%@' ", APP_NAME_COL, @"(null)"];
  [query appendFormat:@" ORDER BY a.%@ COLLATE NOCASE ", APP_NAME_COL];
  
  return  [db executeQuery:query];
}

+ (NSArray*) selectApplicationsFiltered :(NSString*) searchString {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  if (searchString) {
    NSMutableString *query = [NSMutableString string];
    [query appendFormat:@" SELECT * FROM %@ a \n", APPLICATIONS_TABLE];
    [query appendFormat:@" WHERE EXISTS ( \n"];
    [query appendFormat:@"  SELECT rowid FROM %@ m \n", MENU_BAR_ITEMS_TABLE];
    [query appendFormat:@"        WHERE ( m.%@ LIKE '%%%@%%' \n", TITLE_COL,  searchString];
    [query appendFormat:@"        OR  m.%@ LIKE '%%%@%%' ) \n", PARENT_TITLE_COL,  searchString];
    [query appendFormat:@"        AND a.%@ = m.%@ \n", ID_COL, APPLICATION_ID_COL];
    [query appendFormat:@"        AND m.%@ like '%@' ", LANG_COL, [EVEUtilities currentLanguage]];
    [query appendFormat:@"        LIMIT 1) \n"];
    [query appendFormat:@" OR EXISTS ( \n"];
    [query appendFormat:@"  SELECT s.rowid FROM %@ s, %@ m \n", SHORTCUTS_TABLE, MENU_BAR_ITEMS_TABLE];
    [query appendFormat:@"        WHERE ( s.%@ LIKE '%%%@%%' ) \n", SHORTCUT_STRING_COL,  searchString];
    [query appendFormat:@"        AND m.%@ = s.%@ \n", SHORTCUT_ID_COL, ID_COL];
    [query appendFormat:@"        AND a.%@ = m.%@ \n", ID_COL, APPLICATION_ID_COL];
    [query appendFormat:@"        AND m.%@ like '%@' ", LANG_COL, [EVEUtilities currentLanguage]];
    [query appendFormat:@"        LIMIT 1) \n"];
    [query appendFormat:@" AND  a.%@ NOT LIKE '%@' \n", APP_NAME_COL, @"(null)"];
    [query appendFormat:@" ORDER BY a.%@ COLLATE NOCASE \n", APP_NAME_COL];
    
    return [db executeQuery:query];
  }
  
  return [NSArray array];
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
