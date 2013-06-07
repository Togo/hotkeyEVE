//
//  DistributeAppModule.m
//  HotkeyEVE-Apps
//
//  Created by Tobias Sommer on 12/22/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "DistributeAppModule.h"
#import <AppsLibrary/AppsLibrary.h>

@implementation DistributeAppModule

@synthesize webService = _webService;

- (id) initWithWebService :(id<IWebService>) webService {
  self = [super init];
  if (self) {
    self.webService = webService;
  }
  return self;
}

// TODO untested
- (NSString *)distributeToWebServer:(AppModule *)appModule {
  NSString *returnValue;

  returnValue = [_webService uploadToServer :appModule];

  if (returnValue == kUploadSuccessMessage) {
    returnValue =[_webService insertInAppsDatabase :appModule];
  }
  
  return returnValue;
}

@end
