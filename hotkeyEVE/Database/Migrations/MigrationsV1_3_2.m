//
//  MigrationsV1_3_2.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/20/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "MigrationsV1_3_2.h"

@implementation MigrationsV1_3_2

- (void) up {
  CoreDatabase *db =  [[DatabaseManager sharedDatabaseManager] eveDatabase];
    
  DDLogInfo(@"MigrationsV1_3_2 -> up :: run script :%@:", @"INSERT_GUI_ELEMENTS_V1_3_2.sql");
  [db executeScript:@"INSERT_GUI_ELEMENTS_V1_3_2" :@"sql" :@""];
  
  DDLogInfo(@"MigrationsV1_3_2 -> up :: run script :%@:", @"INSERT_GUI_SUPPORT_V1_3_2.sql");
  [db executeScript:@"INSERT_GUI_SUPPORT_V1_3_2" :@"sql" :@""];
  
  DDLogInfo(@"MigrationsV1_3_2 -> up :: run script :%@:", @"INSERT_APPLICATION_BLACKLISTV1_3_2.sql");
  [db executeScript:@"INSERT_APPLICATION_BLACKLISTV1_3_2" :@"sql" :@""];
}

- (void)down {
  
}

@end
