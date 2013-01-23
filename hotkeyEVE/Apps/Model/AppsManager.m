//
//  AppsManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/23/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsManager.h"
#import "GUIElementsTableModel.h"
#import "AppModuleTableModel.h"
#import "GrowlNotifications.h"

@implementation AppsManager

@synthesize receiveAppModule = _receiveAppModule;
@synthesize guiElementTable =_guiElementTable;
@synthesize appModuleTable = _appModuleTable;
@synthesize userNotifications = _userNotifications;

- (id)init
{
  self = [super init];
  if (self) {
    self.receiveAppModule = [ReceiveAppModule createReceiverWithAmazonWebService];
    self.guiElementTable = [[GUIElementsTableModel alloc] init];
    self.appModuleTable = [[AppModuleTableModel alloc] init];
    self.userNotifications = [GrowlNotifications growNotifications];
  }
  
  return self;
}

- (void) addAppsFromArray :(NSArray*) moduleIDs {
  for (NSString *moduleID in moduleIDs) {
    [self performSelectorInBackground:@selector(addAppWithModuleID:) withObject:moduleID];
  }
}

- (void) addAppWithModuleID :(NSString*) aModuleID {
  @synchronized(self) {
    @try {
      AppModule *app = [_receiveAppModule getAppWithModuleID:aModuleID];
      [_appModuleTable addAppModule:app];
      [_guiElementTable insertGUIElementsFromAppModule:app];
      
      [_userNotifications displayAppInstalledNotification:[[app moduleMetaData] valueForKey:kAppNameKey] :[[app moduleMetaData] valueForKey:kUserNameKey]];
    }
    @catch (NSException *exception) {
      // todo
    }
  }
}

- (void) removeAppsFromArray :(NSArray*) moduleIDs {
  
}

- (id) loadTableSourceData {
  return nil;
}

@end
