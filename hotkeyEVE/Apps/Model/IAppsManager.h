//
//  IAppsManager.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/21/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsLibrary/AppsLibrary.h>
#import "IUserNotifications.h"

@class TGEVE_GUIElementsTableModel;
@class AppModuleTableModel;

@protocol IAppsManager <NSObject>

@property (strong) TGEVE_GUIElementsTableModel *guiElementTable;
@property (strong) AppModuleTableModel   *appModuleTable;
@property (strong) id<IUserNotifications> userNotifications;
@property (strong) id<IReceiveAppModule> receiveAppModule;

- (void) addAppsFromArray :(NSArray*) moduleIDs;
- (void) removeAppsFromArray :(NSArray*) moduleIDs;

- (BOOL) addAppWithModuleID :(NSString*) aModuleID;
- (void) removeAppWithModuleID :(NSString*) aModuleID;

- (id) loadTableSourceData;

- (BOOL) isAppInstalled :(NSString*) moduleID;
@end
