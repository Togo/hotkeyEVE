//
//  DatabaseManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "DatabaseManager.h"

#import "CREATE_TABLE_V1_0.h"

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
    eveDatabase = [[EVEDatabase alloc] initWithNameAndPath:@"eve.db" :@"/Users/Togo/dev/hotkeyEVE/"];
    
    DDLogInfo(@"Load Database at Path: %@", [eveDatabase databasePath]);
    
    // Add Migrations
    [eveDatabase addMigrationObject:[CREATE_TABLE_V1_0 migration]];
  }
  return self;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

@end
