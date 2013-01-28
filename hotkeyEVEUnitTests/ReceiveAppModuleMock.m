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

- (NSArray*) getNotInstalledAppList:(NSArray *)installedModuleIDs {
  return [NSArray array];
}

- (AppModule*) getAppWithModuleID :(NSString*) moduleID {
  return [[AppModule alloc] init];
}


@end
