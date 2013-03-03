//
//  ReceiveAppModule.m
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "ReceiveAppModule.h"
#import "AmazonWebService.h"
#import "AppModule.h"

@implementation ReceiveAppModule

@synthesize webService = _webService;

+ (ReceiveAppModule*) createReceiverWithAmazonWebService {
  ReceiveAppModule *receiver = [[ReceiveAppModule alloc] init];
  [receiver setWebService:[[AmazonWebService alloc] init]];
  return receiver;
}

- (NSArray*) getAppList {
  return [_webService getAppListFromDB];
}

- (AppModule*) getAppWithModuleID :(NSString*) moduleID {
  NSData *data = [_webService downloadFromServer:moduleID];
  
  return [AppModule createNewAppModuleFromJsonString:data];
}

@end
