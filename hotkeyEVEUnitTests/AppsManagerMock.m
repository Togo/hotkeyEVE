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

- (void) addAppWithModuleID :(NSString*) aModuleID {
  
}

- (id) loadTableSourceData {
  return nil;
}

@end
