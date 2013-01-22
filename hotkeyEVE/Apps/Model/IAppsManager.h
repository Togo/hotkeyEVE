//
//  IAppsManager.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/21/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsLibrary/AppsLibrary.h>

@class GUIElementsTableModel;
@class AppModuleTableModel;

@protocol IAppsManager <NSObject>

@property (strong) GUIElementsTableModel *guiElementTable;
@property (strong) AppModuleTableModel   *appModuleTable;

@property (strong) id<IReceiveAppModule> receiveAppModule;

- (void) addAppsFromArray :(NSArray*) moduleIDs;
- (void) removeAppsFromArray :(NSArray*) moduleIDs;

- (void) addAppWithModuleID :(NSString*) aModuleID;

- (id) getNotInstalledList;

@end
