//
//  MigrationV1_3_5.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/22/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "MigrationV1_4_3.h"
#import "TGEVE_AppsManager.h"

@implementation MigrationV1_4_3

- (void) up {
  DDLogInfo(@"MigrationsV1_4_3 -> up :: get called");
  CoreDatabase *db =  [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  DDLogInfo(@"MigrationsV1_4_3 -> up :: run script :%@:", @"ALTER_TABLE_GUI_ELEMENTS_V1_4_3.sql");
  [db executeScript:@"ALTER_TABLE_GUI_ELEMENTS_V1_4_3" :@"sql" :@""];
}

- (void)down {
  
}

@end
