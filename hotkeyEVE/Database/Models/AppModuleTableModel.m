//
//  AppModuleTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/22/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppModuleTableModel.h"
#import "ApplicationsTableModel.h"


NSString * const kEVEModuleTableName = @"app_module";

NSString * const kEVEInternalIDColumn = @"internal_id";
NSString * const kEVEExternalIDColumn = @"external_id";
NSString * const kEVEApplicationIDColumn = @"application_id";

@implementation AppModuleTableModel

- (void) addAppModule :(AppModule*) appModule {
    DDLogInfo(@"AppModuleTableModel -> addAppModule(appModule => :%@:) :: get called", appModule);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSString *bundleIdentifier = [[appModule moduleMetaData] valueForKey:kBundleIdentifierKey];
  NSString *appName = [[appModule moduleMetaData] valueForKey:kAppNameKey];
  
  NSInteger applicationID = [ApplicationsTableModel getApplicationID:appName :bundleIdentifier];
  
  if (applicationID == 0) {
    @throw [NSException exceptionWithName:@"NoAppFoundException" reason:@"I need at least one start for this Application before you can install the EVEApps module" userInfo:nil];
  }

  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", kEVEModuleTableName];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , '%@' ", [[appModule moduleMetaData] valueForKey:kModuleID]];
  [query appendFormat:@" , '%@' ", [[appModule moduleMetaData] valueForKey:kLanguageKey]];
  [query appendFormat:@" , '%li' ", applicationID];
  [query appendFormat:@" , '%@' ", [[appModule moduleMetaData] valueForKey:kUserNameKey]];
  [query appendFormat:@" , '%@' ", [[appModule moduleMetaData] valueForKey:kModuleCredatKey]];
  [query appendFormat:@" ) "];
  
  [db executeUpdate:query];
}

- (void) removeAppModuleWithID :(NSInteger) theID {
  DDLogInfo(@"AppModuleTableModel -> addAppModule(moduleID => :%li:) :: get called", theID);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"DELETE FROM %@ ", kEVEModuleTableName];
  [query appendFormat:@" WHERE %@ = %li ",ID_COL, theID];

  [db executeUpdate:query];
}

- (NSDictionary*) getModuleEntityWithExternalID :(NSString*) external_id {
  DDLogInfo(@"AppModuleTableModel -> getModuleIDWithExternalID(external_id => :%@:) :: get called", external_id);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT a.%@ AS ApplicationName, m.* FROM %@ m, %@ a", APP_NAME_COL, kEVEModuleTableName, APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", kModuleID, external_id];
  [query appendFormat:@" AND a.%@ = m.%@ ", ID_COL, APPLICATION_ID_COL];
  
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
//    NSInteger appID = [[[result objectAtIndex:0] valueForKey:ID_COL] intValue];
    return [result objectAtIndex:0];
  } else {
    DDLogError(@"AppModuleTableModel -> getModuleIDWithExternalID:: multiple APPIDS that's not correct => :%@:", query);
    return 0;
  }
}

- (NSArray*) selectAllInstalledAppModules {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT a.%@ AS ApplicationName, m.* FROM %@ m, %@ a", APP_NAME_COL, kEVEModuleTableName, APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE a.%@ = m.%@ ", ID_COL, APPLICATION_ID_COL];
  NSArray *result =  [db executeQuery:query];
  
  return result;
}

@end
