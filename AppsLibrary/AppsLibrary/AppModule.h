//
//  AppModule.h
//  AppsLibrary
//
//  Created by Tobias Sommer on 12/18/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModule : NSObject

@property (strong) NSArray *moduleBody;
@property (strong) NSDictionary *moduleMetaData;

+ (AppModule*) createNewAppModule :(NSArray*) tableData :(NSString*) userName :(NSString*) eMail :(NSString*) appName :(NSString*) bundleIdentifier :(NSString*) appLanguage;

- (NSDictionary*) createMetaDataDictionary :(NSString*) userName :(NSString*) eMail :(NSString*) appName :(NSString*) bundleIdentifier :(NSString*) appLanguage;
- (id) createModuleID :(NSString*) appName :(NSString*) userName :(NSString*) credat;

- (id) moduleToJSonString;
- (id) writeObjectToJSonString :(id) object;

@end
