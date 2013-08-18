//
//  WebServiceStub.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/21/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "ReceiveAppModuleMock.h"
#import <AppsLibrary/AppsLibrary.h>

@implementation ReceiveAppModuleMock

@synthesize webService = _webService;

- (id)loadAppList {
  return nil;
}

- (NSArray*) getAppList {
  return [NSArray array];
}

- (AppModule*) getAppWithModuleID :(NSString*) moduleID {
  return [[AppModule alloc] init];
}

-(NSArray *)getNotInstalledAppList:(NSArray *)installedModuleIDs {
  return nil;
}
@end
