//
//  AppsManagerMock.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/23/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsManagerMock.h"

@implementation AppsManagerMock

@synthesize receiveAppModule = _receiveAppModule;
@synthesize guiElementTable =_guiElementTable;
@synthesize appModuleTable = _appModuleTable;
@synthesize userNotifications = _userNotifications;

- (void) addAppsFromArray :(NSArray*) moduleIDs {
  
}

- (void) removeAppsFromArray :(NSArray*) moduleIDs {
  
}

- (BOOL) addAppWithModuleID :(NSString*) aModuleID {
  return YES;
}

- (id) loadTableData {
  return nil;
}

- (void) removeAppWithModuleID:(NSString *)aModuleID {
  
}

- (void) postTableRefreshNotification {
  
}

- (BOOL) isAppInstalled :(NSString*) moduleID {
  return YES;
}

@end
