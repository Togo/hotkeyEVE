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

- (NSString*) distributeToWebServer :(NSArray*) tableData :(NSString*) userName :(NSString*) eMail :(NSString*) appName  :(NSString*) bundleIdentifier :(NSString*) appLanguage{
  NSString *workflowStatus;
  NSString *returnValue;
  AppModule *module;
  
  @try {
    module = [self createNewAppModule :tableData :userName :eMail :appName :bundleIdentifier :appLanguage];
  }
  @catch (NSException *exception) {
    returnValue = [exception reason];
    workflowStatus = kAppModuleCreatingFailed;
  }
  
  if (workflowStatus != kAppModuleCreatingFailed) {
      workflowStatus = [_webService uploadToServer :module];
    
    if (workflowStatus == kUploadSuccessMessage) {
      returnValue =[_webService insertInAppsDatabase :module];
    }
  }
  
  return returnValue;
}

- (AppModule*) createNewAppModule :(NSArray*) tableData :(NSString*) userName :(NSString*) eMail :(NSString*) appName :(NSString*) bundleIdentifier :(NSString*) appLanguage {
  return [AppModule createNewAppModule :tableData :userName :eMail :appName :bundleIdentifier :appLanguage];
}

@end
