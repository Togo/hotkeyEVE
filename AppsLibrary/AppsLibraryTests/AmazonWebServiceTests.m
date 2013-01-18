//
//  WebServiceTests.m
//  HotkeyEVE-Apps
//
//  Created by Tobias Sommer on 12/21/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <AppsLibrary/AppsLibrary.h>
#import <OCMock/OCMock.h>

@interface AmazonWebServiceTests : SenTestCase {
  @private
    AmazonWebService *_webService;
}

@end

@implementation AmazonWebServiceTests

- (void)setUp
{
  [super setUp];
  _webService = [[AmazonWebService alloc] init];
}

- (void)tearDown {
  
  [super tearDown];
}

- (void) test_init_objectCreated_s3ClientIsInitialized {
  STAssertNotNil([_webService s3Client] , @"");
}


- (void) test_init_objectCreated_sdbClientIsInitialized {
  STAssertNotNil([_webService sdbClient] , @"");
}

@end
