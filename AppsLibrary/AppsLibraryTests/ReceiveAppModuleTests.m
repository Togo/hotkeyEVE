//
//  ReceiveAppModuleTests.m
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "ReceiveAppModuleTests.h"
#import "ReceiveAppModule.h"
#import <OCMock/OCMock.h>
#import "IWebService.h"

@implementation ReceiveAppModuleTests

- (void)setUp
{
  [super setUp];
  
  _receiveAppModule = [[ReceiveAppModule alloc] init];
}

- (void)tearDown
{
  
  [super tearDown];
}

- (void) test_getAppWithModuleID_moduleIDNotNil_callDownloadMethodInWebService {
  id webServiceMock = [OCMockObject mockForProtocol:@protocol(IWebService)];
  [[webServiceMock expect] downloadFromServer:@"moduleID"];
  
  [_receiveAppModule setWebService:webServiceMock];
  
  STAssertThrows([_receiveAppModule getAppWithModuleID :@"moduleID"], @"");
  
  [webServiceMock verify];
}


@end
