//
//  AppsManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/20/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsManagerAmazon.h"

@implementation AppsManagerAmazon


- (id) loadTableSourceData {
  [super loadTableSourceData];
  return [[super receiveAppModule] getNotInstalledAppList];
}

@end
