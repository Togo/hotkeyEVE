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



@end
