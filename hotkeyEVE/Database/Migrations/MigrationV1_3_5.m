//
//  MigrationV1_3_5.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/22/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "MigrationV1_3_5.h"

@implementation MigrationV1_3_5

- (void) up {
  DDLogInfo(@"MigrationsV1_3_5 -> up :: get called");
  CoreDatabase *db =  [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  DDLogInfo(@"MigrationsV1_3_5 -> up :: run script :%@:", @"REMOVE_GUI_ELEMENTS_V1_3_5.sql");
  [db executeScript:@"REMOVE_GUI_ELEMENTS_V1_3_5" :@"sql" :@""];
  
  DDLogInfo(@"MigrationsV1_3_5 -> up :: run script :%@:", @"ALTER_TABLE_GUI_ELEMENTS_V1_3_5.sql");
  [db executeScript:@"ALTER_TABLE_GUI_ELEMENTS_V1_3_5" :@"sql" :@""];
  
  DDLogInfo(@"MigrationsV1_3_5 -> up :: run script :%@:", @"CREATE_TABLE_APP_MODULE_V1_3_5.sql");
  [db executeScript:@"CREATE_TABLE_APP_MODULE_V1_3_5" :@"sql" :@""];
}

- (void)down {
  
}

@end
