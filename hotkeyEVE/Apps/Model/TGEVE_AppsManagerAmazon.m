//
//  AppsManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/20/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_AppsManagerAmazon.h"
#import "AppModuleTableModel.h"

@implementation TGEVE_AppsManagerAmazon

- (id) loadTableDataFromDB {
  return [[super receiveAppModule] getNotInstalledAppList:nil];
}

@end
