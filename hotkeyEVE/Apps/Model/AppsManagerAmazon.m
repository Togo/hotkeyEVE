//
//  AppsManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/20/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsManagerAmazon.h"
#import "GUIElementsTableModel.h"
#import "AppModuleTableModel.h"

@implementation AppsManagerAmazon

@synthesize receiveAppModule = _receiveAppModule;
@synthesize guiElementTable =_guiElementTable;
@synthesize appModuleTable = _appModuleTable;

- (id)init
{
  self = [super init];
  if (self) {
    self.receiveAppModule = [ReceiveAppModule createReceiverWithAmazonWebService];
    self.guiElementTable = [[GUIElementsTableModel alloc] init];
    self.appModuleTable = [[AppModuleTableModel alloc] init];
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
    }
    @catch (NSException *exception) {
       // todo
    }
  }
}

- (void) removeAppsFromArray :(NSArray*) moduleIDs {
  
}

- (id) getNotInstalledList {
  return [_receiveAppModule getNotInstalledAppList];
}

@end
