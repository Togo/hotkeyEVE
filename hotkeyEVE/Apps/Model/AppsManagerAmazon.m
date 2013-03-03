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
  return [[super receiveAppModule] getAppList];
}

@end
