//
//  AppsAmazonModelTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsAmazonModelTests.h"

@implementation AppsAmazonModelTests

- (void)setUp
{
  [super setUp];
  _amazonModel = [[AppsAmazonModel alloc] init];
  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

//************************* init *************************//
- (void) test_init_objectCreated_initAmazonAppsDatabase {
  STAssertNotNil([_amazonModel appsDatabase], @"");
}

@end
