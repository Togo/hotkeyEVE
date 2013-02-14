//
//  MigrationV1_3_5.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/22/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "MigrationV1_4_1.h"
#import "AppsManager.h"

@implementation MigrationV1_4_1

- (void) up {
  DDLogInfo(@"MigrationsV1_4_1 -> up :: get called");
  CoreDatabase *db =  [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  DDLogInfo(@"MigrationsV1_4_1 -> up :: run script :%@:", @"ALTER_MENU_BAR_ITEMS_V1_4_1.sql");
  [db executeScript:@"ALTER_MENU_BAR_ITEMS_V1_4_1" :@"sql" :@""];
}

- (void)down {
  
}

@end
