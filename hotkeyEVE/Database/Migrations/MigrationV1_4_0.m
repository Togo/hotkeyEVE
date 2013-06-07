//
//  MigrationV1_3_5.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/22/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "MigrationV1_4_0.h"
#import "TGEVE_AppsManager.h"

@implementation MigrationV1_4_0

- (void) up {
  DDLogInfo(@"MigrationsV1_4_0 -> up :: get called");
  CoreDatabase *db =  [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  DDLogInfo(@"MigrationsV1_4_0 -> up :: run script :%@:", @"REMOVE_GUI_ELEMENTS_V1_4_0.sql");
  [db executeScript:@"REMOVE_GUI_ELEMENTS_V1_4_0" :@"sql" :@""];
  
  DDLogInfo(@"MigrationsV1_4_0 -> up :: run script :%@:", @"ALTER_TABLE_GUI_ELEMENTS_V1_4_0.sql");
  [db executeScript:@"ALTER_TABLE_GUI_ELEMENTS_V1_4_0" :@"sql" :@""];
  
  DDLogInfo(@"MigrationsV1_4_0 -> up :: run script :%@:", @"CREATE_TABLE_APP_MODULE_V1_4_0.sql");
  [db executeScript:@"CREATE_TABLE_APP_MODULE_V1_4_0" :@"sql" :@""];
  
  DDLogInfo(@"MigrationsMigrationsV1_4_0 -> up :: run script :%@:", @"ALTER_TABLE_APPLICATIONS_V1_4_0.sql");
  [db executeScript:@"ALTER_TABLE_APPLICATIONS_V1_4_0" :@"sql" :@""];
}

- (void)down {
  
}

@end
