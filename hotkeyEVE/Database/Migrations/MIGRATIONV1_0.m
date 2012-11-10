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
  FMDatabase *database =  [[[DatabaseManager sharedDatabaseManager] eveDatabase] database];
  [self executeScript:@"CREATE_TABLE_V1_0" :@"sql" :@"" :database];
  [NSThread sleepForTimeInterval:0.5];
  [self executeScript:@"INSERT_GUI_SUPPORT_V1_0" :@"sql" :@"" :database];
  [self executeScript:@"INSERT_GUI_ELEMENTS_V1_0" :@"sql" :@"" :database];
}

- (void)down {
  
}

@end
