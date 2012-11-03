//
//  CREATE_TABLE_V1_0.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "CREATE_TABLE_V1_0.h"

@implementation CREATE_TABLE_V1_0

- (void) up {
  FMDatabase *database =  [[[DatabaseManager sharedDatabaseManager] eveDatabase] database];
  [self executeScript:@"CREATE_TABLE_V1_0" :@"sql" :@"" :database];
}

- (void)down {
  
}
@end
