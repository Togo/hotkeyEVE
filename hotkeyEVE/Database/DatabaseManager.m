//
//  DatabaseManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "DatabaseManager.h"
#import "NSFileManager+DirectoryLocations.h"

#import "MIGRATIONV1_3_0.h"
#import "MigrationsV1_3_1.h"
#import "MigrationsV1_3_2.h"
#import "MigrationsV1_3_3.h"
#import "MigrationV1_3_5.h"

@implementation DatabaseManager

@synthesize eveDatabase;

#pragma mark Singleton Methods

+ (id)sharedDatabaseManager {
  static DatabaseManager *databaseManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    databaseManager = [[self alloc] init];
  });
  
  return databaseManager;
}

- (id)init {
  if (self = [super init]) {
    // Initialize Database
    NSString *path = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSString *name = @"eve.db";
    eveDatabase = [[EVEDatabase alloc] initWithNameAndPath:name :path];
    
    DDLogInfo(@"Load Database at Path: %@", [eveDatabase databasePath]);
    
    // Add Migrations
    [eveDatabase addMigrationObject:[MIGRATIONV1_3_0 migration]];
    [eveDatabase addMigrationObject:[MigrationsV1_3_1 migration]];
    [eveDatabase addMigrationObject:[MigrationsV1_3_2 migration]];
    [eveDatabase addMigrationObject:[MigrationsV1_3_3 migration]];
    [eveDatabase addMigrationObject:[MigrationV1_3_5 migration]];
  }
  
  return self;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

@end
