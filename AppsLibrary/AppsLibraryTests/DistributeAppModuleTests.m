//
//  DistributeAppModuleTests.m
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/4/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//


#import <SenTestingKit/SenTestingKit.h>
#import "DistributeAppModule.h"
#import <OCMock/OCMock.h>
#import "AppModule.h"
#import "AmazonWebService.h"
#import "AppsLibrary.h"

@interface DistributeAppModuleTests : SenTestCase {
  @private
    DistributeAppModule *_distributeApp;
}

@end

@implementation DistributeAppModuleTests

- (void)setUp
{
  [super setUp];
  _distributeApp = [[DistributeAppModule alloc] init];

}

- (void)tearDown
{
  _distributeApp = nil;
  [super tearDown];
}

- (void) test_distributeToWebserver_exceptionOccured_returnValueContainsReason {
  NSException *invalidArgumentException = [NSException exceptionWithName:NSInvalidArgumentException reason:@"error" userInfo:nil];
  id distributeAppMock = [OCMockObject partialMockForObject:_distributeApp];
  [[[distributeAppMock stub] andThrow:invalidArgumentException] createNewAppModule:[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any]];
  
  NSString *returnValue = [_distributeApp distributeToWebServer:[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any]];
  STAssertTrue([returnValue isEqualToString: [invalidArgumentException reason]], @"");
}

- (void) test_distributeToWebserver_uploadToServerSuccesfull_insertInAppsDB {
  id distributeAppMock = [OCMockObject partialMockForObject:_distributeApp];
  [[[distributeAppMock stub] andReturn:[[AppModule alloc] init]] createNewAppModule:[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any]];
  
  id amazonWebServiceMock = [OCMockObject niceMockForClass:[AmazonWebService class]];
  [[amazonWebServiceMock expect] insertInAppsDatabase:[OCMArg any]];
  [[amazonWebServiceMock stub] insertInAppsDatabase:[OCMArg any]];
  [[[amazonWebServiceMock stub] andReturn:kUploadSuccessMessage] uploadToServer:[OCMArg any]];
  
  [_distributeApp setWebService:amazonWebServiceMock];

  [_distributeApp distributeToWebServer:[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any]];
  
  [amazonWebServiceMock verify];
}

- (void) test_distributeToWebserver_errorInUploadToServerSuccesfull_dontInsertAppInDB {
  id distributeAppMock = [OCMockObject partialMockForObject:_distributeApp];
  [[[distributeAppMock stub] andReturn:[[AppModule alloc] init]] createNewAppModule:[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any]];
  
  id amazonWebServiceMock = [OCMockObject niceMockForClass:[AmazonWebService class]];
  [[amazonWebServiceMock reject] insertInAppsDatabase:[OCMArg any]];
  [[amazonWebServiceMock stub] insertInAppsDatabase:[OCMArg any]];
  [[[amazonWebServiceMock stub] andReturn:@"NO Successed Message"] uploadToServer:[OCMArg any]];
  
  [_distributeApp setWebService:amazonWebServiceMock];
  
  [_distributeApp distributeToWebServer:[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any] :[OCMArg any]];
  
  [amazonWebServiceMock verify];
}

@end
