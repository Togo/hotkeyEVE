//
//  MigrationsV1_3_1.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/18/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "MigrationsV1_3_1.h"

@implementation MigrationsV1_3_1

- (void) up {
  CoreDatabase *db =  [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  DDLogInfo(@"MigrationsV1_3_1 -> up :: run script :%@:", @"CREATE_TABLEV1_3_1");
  [db executeScript:@"CREATE_TABLEV1_3_1" :@"sql" :@""];

  DDLogInfo(@"MigrationsV1_3_1 -> up :: run script :%@:", @"INSERT_APPLICATION_BLACKLISTV1_3_1");
  [db executeScript:@"INSERT_APPLICATION_BLACKLISTV1_3_1" :@"sql" :@""];
}

- (void)down {
  
}

@end
