//
//  CREATE_TABLE_V1_0.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "MIGRATIONV1_0.h"

@implementation MIGRATIONV1_0

- (void) up {
  CoreDatabase *db =  [[DatabaseManager sharedDatabaseManager] eveDatabase];
  [db executeScript:@"CREATE_TABLE_V1_0" :@"sql" :@""];
  [NSThread sleepForTimeInterval:3];
  [db executeScript:@"INSERT_GUI_SUPPORT_V1_0" :@"sql" :@""];
  [db executeScript:@"INSERT_GUI_ELEMENTS_V1_0" :@"sql" :@""];
}

- (void)down {
  
}

@end
