//
//  ReceiveAppModuleAmazon.m
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "ReceiveAppModuleAmazon.h"
#import "AmazonWebService.h"
#import "AppModule.h"

@implementation ReceiveAppModuleAmazon

@synthesize webService = _webService;

+ (ReceiveAppModuleAmazon *) createReceiverWithAmazonWebService {
  ReceiveAppModuleAmazon *receiver = [[ReceiveAppModuleAmazon alloc] init];
  [receiver setWebService:[[AmazonWebService alloc] init]];
  return receiver;
}

- (NSArray*) getNotInstalledAppList :(NSArray*) installedModuleIDs {
  return [_webService getNotInstalledAppList :installedModuleIDs];
}

- (AppModule*) getAppWithModuleID :(NSString*) moduleID {
  if ([moduleID length] == 0) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Please enter a valid ModuleID" userInfo:nil];
  }
  
  NSData *data = [_webService downloadFromServer:moduleID];
  
  return [AppModule createNewAppModuleFromJsonString:data];
}

@end
