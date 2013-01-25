//
//  AppsManagerLocalDB.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/23/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsManagerLocalDB.h"
#import "AppModuleTableModel.h"

@implementation AppsManagerLocalDB

- (id) loadTableSourceData {
  return [[super appModuleTable] selectAllInstalledAppModules];
}

@end
