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
#import "GUINotifications.h"

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
    self.userNotifications = [GrowlNotifications growlNotifications];
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
    if ([self grantInstall]) {
    @try {
      AppModule *app = [_receiveAppModule getAppWithModuleID:aModuleID];
      [_appModuleTable addAppModule:app];
      [_guiElementTable insertGUIElementsFromAppModule:app];
      
      [_userNotifications displayAppInstalledNotification:[[app moduleMetaData] valueForKey:kAppNameKey]];
      [self postTableRefreshNotification];
    }
    @catch (NSException *exception) {
      DDLogError(@"AppsManager -> addAppWithModuleID :: exception occured => %@", [exception reason]);
      NSAlert *alert = [NSAlert alertWithMessageText:@"Error occured!"
                                       defaultButton:@"OK"
                                     alternateButton:nil
                                         otherButton:nil
                           informativeTextWithFormat:@"%@", [exception reason]];
      [alert beginSheetModalForWindow:nil modalDelegate:self didEndSelector:nil contextInfo:NULL];
    }
    } else {
      [_userNotifications displayRegisterEVEWithCallbackNotification:@"Register EVE, to install more Apps!" :@"You've reached the maximum number of intalled Apps"];
    }
  }
}

- (void) removeAppsFromArray :(NSArray*) moduleIDs {
  for (NSString *moduleID in moduleIDs) {
    [self performSelectorInBackground:@selector(removeAppWithModuleID:) withObject:moduleID];
  }
}

- (void) removeAppWithModuleID :(NSString*) aModuleID {
    @synchronized(self) {
      NSDictionary *theModuleRow = [_appModuleTable getModuleEntityWithExternalID:aModuleID];
      if ([theModuleRow count] > 0) {
        NSInteger theID = [[theModuleRow valueForKey:ID_COL] integerValue];
        [_guiElementTable removeGUIElementsWithID:theID];
        [_appModuleTable  removeAppModuleWithID:theID];
        [_userNotifications displayAppRemovedNotification:[theModuleRow valueForKey:kAppNameKey]];
        [self postTableRefreshNotification];
      } else {
          DDLogError(@"AppsManager -> removeAppWithModuleID :: app with module id %@ not installed",aModuleID);
      }
    }
}

- (id) loadTableSourceData {
 [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
  return nil;
}

- (void) postTableRefreshNotification {
  [[NSNotificationCenter defaultCenter] postNotificationName:kEVENotificationsReloadAppsTable object:nil];
}

- (BOOL) grantInstall {
  if ([[[EVEManager sharedEVEManager] licence] isValid])
    return YES;
  else if (![_appModuleTable installedAppsMaximumReached])
    return YES;
  else
    return NO;
}

@end
