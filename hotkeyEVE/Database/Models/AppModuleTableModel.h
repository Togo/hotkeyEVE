//
//  AppModuleTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/22/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsLibrary/AppsLibrary.h>

extern NSString * const kEVEInternalIDColumn;
extern NSString * const kEVEExternalIDColumn;

@interface AppModuleTableModel : NSObject

- (void) addAppModule :(AppModule*) appModule;
+ (NSInteger) getModuleIDWithExternalID :(NSString*) external_id;

@end
