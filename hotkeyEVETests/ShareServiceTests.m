//
//  TwitterTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/25/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "ShareService.h"


@interface ShareServiceTests : SenTestCase

@end

@implementation ShareServiceTests

- (void)setUp
{
  [super setUp];
  
  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void)testCreateShareService {
  ShareService *shareService = [ShareService shareService];
  STAssertNotNil(shareService, @"No Share Object created");
  STAssertNotNil(shareService.tweetSharingService, @"No Twitter share object created");
  STAssertNotNil(shareService.facebookSharingService, @"No Facebook share object created");
  STAssertNotNil(shareService.mailSharingService, @"No Facebook share object created");
}

@end
