//
//  AppsAmazonModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsAmazonModel.h"

@implementation AppsAmazonModel

@synthesize appsDatabase = _appsDatabase;

- (id)init
{
  self = [super init];
  if (self) {
    self.appsDatabase = [[AmazonAppsDatabase alloc] init];
  }
  return self;
}

- (id) getNotInstalledList {
  return [_appsDatabase getAppList];
}

@end
