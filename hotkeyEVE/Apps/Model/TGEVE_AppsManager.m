//
//  AppsManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/23/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_AppsManager.h"
#import "TGEVE_GUIElementsTableModel.h"
#import "AppModuleTableModel.h"
#import "GrowlNotifications.h"
#import "GUINotifications.h"

@implementation TGEVE_AppsManager

@synthesize receiveAppModule = _receiveAppModule;
@synthesize guiElementTable =_guiElementTable;
@synthesize appModuleTable = _appModuleTable;
@synthesize userNotifications = _userNotifications;

- (id)init
{
  self = [super init];
  if (self) {
    self.receiveAppModule = [ReceiveAppModuleAmazon createReceiverWithAmazonWebService];
    self.guiElementTable = [[TGEVE_GUIElementsTableModel alloc] init];
    self.appModuleTable = [[AppModuleTableModel alloc] init];
    self.userNotifications = [GrowlNotifications growlNotifications];
  }
  
  return self;
}

- (void) addAppsFromArray :(NSArray*) moduleIDs {
  for (NSString *moduleID in moduleIDs) {
    [self performSelectorInBackground:@selector(addAppWithModuleID:) withObject:moduleID];
  }
  
  _appCount = [moduleIDs count];
}

- (BOOL) addAppWithModuleID :(NSString*) aModuleID {
  @synchronized(self) {
    if ( [self grantInstall] ) {
    @try {
      AppModule *app = [_receiveAppModule getAppWithModuleID:aModuleID];
      [_appModuleTable addAppModule:app];
      [_guiElementTable insertGUIElementsFromAppModule:app];
      
      [_userNotifications displayAppInstalledNotification:[[app moduleMetaData] valueForKey:kAppNameKey] :[[app moduleMetaData] valueForKey:kLanguageKey]];
    }
    @catch (NSException *exception) {
      DDLogError(@"AppsManager -> addAppWithModuleID :: exception occured => %@", [exception reason]);
      [[NSAlert alert] showModalAlertSheetForWindow:nil message:@"Error occured!" informativeText:[exception reason] alertStyle:NSCriticalAlertStyle buttonBlocks:nil buttonTitle:@"OK", nil];
      return NO;
    }
    } else {
      [_userNotifications displayRegisterEVEWithCallbackNotification:@"Register EVE, to install more Apps!" :@"You've reached the maximum number of installed Apps"];
      return NO;
    }
  }
  
  [self postTableRefreshNotificationIfNoMoreApps];
  return YES;
}

- (void) removeAppsFromArray :(NSArray*) moduleIDs {
  for (NSString *moduleID in moduleIDs) {
    [self performSelectorInBackground:@selector(removeAppWithModuleID:) withObject:moduleID];
  }
  
    _appCount = [moduleIDs count];
}

- (void) removeAppWithModuleID :(NSString*) aModuleID {
  @synchronized(self) {
    NSDictionary *theModuleRow = [_appModuleTable getModuleEntityWithExternalID:aModuleID];
    if ([theModuleRow count] > 0) {
      NSInteger theID = [[theModuleRow valueForKey:ID_COL] integerValue];
      [_guiElementTable removeGUIElementsWithID:theID];
      [_appModuleTable  removeAppModuleWithID:theID];
      [_userNotifications displayAppRemovedNotification:[theModuleRow valueForKey:kAppNameKey] :[theModuleRow valueForKey:kLanguageKey]];
    } else {
        DDLogError(@"AppsManager -> removeAppWithModuleID :: app with module id %@ not installed",aModuleID);
    }
  }
  
  [self postTableRefreshNotificationIfNoMoreApps];
}

- (id) loadTableDataFromDB {
 [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
return nil;
}

- (void) postTableRefreshNotificationIfNoMoreApps {
  if(--_appCount == 0) // no More Apps Refresh Table
    [[NSNotificationCenter defaultCenter] postNotificationName:kEVENotificationsReloadAppsTable object:nil];
}

- (BOOL) grantInstall {
  if ([[[EVEManager sharedEVEManager] licence] isValid])
    return YES;
  else if ( ![_appModuleTable installedAppsMaximumReached] )
    return YES;
  else
    return NO;
}

- (BOOL) isAppInstalled :(NSString*) moduleID {
  return [_appModuleTable isAppInstalledWithModuleID :moduleID];
}

@end
