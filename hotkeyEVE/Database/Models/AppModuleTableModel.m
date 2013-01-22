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
  [query appendFormat:@" , '%li' ", applicationID];
  [query appendFormat:@" ) "];
  
  [db executeUpdate:query];
}

+ (NSInteger) getModuleIDWithExternalID :(NSString*) external_id {
  DDLogInfo(@"AppModuleTableModel -> getModuleIDWithExternalID(external_id => :%@:) :: get called", external_id);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", kEVEModuleTableName];
  [query appendFormat:@" WHERE %@ like '%@' ", kEVEExternalIDColumn, external_id];
  
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    NSInteger appID = [[[result objectAtIndex:0] valueForKey:kEVEInternalIDColumn] intValue];
    return appID;
  } else {
    DDLogError(@"AppModuleTableModel -> getModuleIDWithExternalID:: no appID query => :%@:", query);
    return 0;
  }
}
@end
