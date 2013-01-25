//
//  AppsManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/20/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsManagerAmazon.h"
#import "AppModuleTableModel.h"

@implementation AppsManagerAmazon

- (id) loadTableSourceData {
  AppModuleTableModel *appModuleTable = [[AppModuleTableModel alloc] init];
  NSArray *allRows = [appModuleTable selectAllInstalledAppModules];
  NSMutableArray *installedModulesIDs = [NSMutableArray array];
  for (id aRow in allRows) {
    [installedModulesIDs addObject:[aRow valueForKey:kModuleID]];
  }
  
  return [[super receiveAppModule] getNotInstalledAppList :installedModulesIDs];
}

@end
