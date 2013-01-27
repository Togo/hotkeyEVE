//
//  AppModuleTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/22/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsLibrary/AppsLibrary.h>

NSString * const kEVEModuleTableName;

NSString * const kEVEInternalIDColumn;
NSString * const kEVEExternalIDColumn;
NSString * const kEVEApplicationIDColumn;

@interface AppModuleTableModel : NSObject

- (void) addAppModule :(AppModule*) appModule;
- (void) removeAppModuleWithID :(NSInteger) theID;

- (NSDictionary*) getModuleEntityWithExternalID :(NSString*) external_id;
- (NSArray*) selectAllInstalledAppModules;
- (BOOL) installedAppsMaximumReached;
@end
