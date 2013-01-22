//
//  MigrationsV1_3_3.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/26/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "MigrationsV1_3_3.h"

@implementation MigrationsV1_3_3

- (void) up {
  DDLogInfo(@"MigrationsV1_3_3 -> up :: get called");
  CoreDatabase *db =  [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  DDLogInfo(@"MigrationsV1_3_3 -> up :: run script :%@:", @"INSERT_GUI_ELEMENTS_V1_3_3.sql");
  [db executeScript:@"INSERT_GUI_ELEMENTS_V1_3_3" :@"sql" :@""];

  DDLogInfo(@"MigrationsV1_3_3 -> up :: run script :%@:", @"INSERT_GUI_SUPPORT_V1_3_3.sql");
  [db executeScript:@"INSERT_GUI_SUPPORT_V1_3_3" :@"sql" :@""];
  ;
  DDLogInfo(@"MigrationsV1_3_3 -> up :: run script :%@:", @"ALTER_GUI_ELEMENTS_V1_3_3.sql");
  [db executeScript:@"ALTER_GUI_ELEMENTS_V1_3_3" :@"sql" :@""];
}

- (void)down {
  
}

@end
