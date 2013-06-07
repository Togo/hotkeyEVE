//
//  AppModule.h
//  AppsLibrary
//
//  Created by Tobias Sommer on 12/18/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGAPPSLIB_IAppModuleMetaDataCreator.h"

@interface AppModule : NSObject

@property (strong) NSArray *moduleBody;
@property (strong) NSDictionary *moduleMetaData;


+ (AppModule *)createNewAppModule:(NSArray *)tableData metaData:(id<TGAPPSLIB_IAppModuleMetaDataCreator>) creatorDialog;
+ (AppModule*) createNewAppModuleFromJsonString :(NSData*) data;

- (void)updateAppModule:(NSArray *)tableData metaData:(id<TGAPPSLIB_IAppModuleMetaDataCreator>) creatorDialog;

//- (NSDictionary *)createMetaDataDictionary:(NSDictionary *)metaDataDic;
+ (id) createModuleID :(NSString*) appName :(NSString*) userName :(NSString*) credat;

- (id) moduleToJSonString;
- (id) writeObjectToJSonString :(id) object;
- (id) parseJsonDataToObject :(NSData*) data;
@end
