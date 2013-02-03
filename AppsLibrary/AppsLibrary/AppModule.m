//
//  AppModule.m
//  AppsLibrary
//
//  Created by Tobias Sommer on 12/18/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "AppModule.h"
#import "AppsLibraryConstants.h"
#import "SBJson.h"
#import "NSString+MD5.h"

@implementation AppModule

@synthesize moduleBody = _moduleBody;
@synthesize moduleMetaData = _moduleMetaData;

- (id) init {
  self = [super init];
  
  if (self) {

  }
  
  return self;
}

+ (AppModule*) createNewAppModule :(NSArray*) tableData :(NSString*) userName :(NSString*) eMail :(NSString*) appName :(NSString*) bundleIdentifier :(NSString*) appLanguage {
  if (tableData == nil
      || [tableData count] == 0) {
    NSException *arrayEmptyException = [NSException exceptionWithName:NSInvalidArgumentException reason:@"There is no data in the Table" userInfo:nil];
    @throw arrayEmptyException;
  }
  
  if (userName == nil
      || [userName length] == 0) {
    NSException *emptyUserNameException = [NSException exceptionWithName:NSInvalidArgumentException reason:@"No User Name" userInfo:nil];
    @throw emptyUserNameException;
  }
  
  if (eMail == nil
      || [eMail length] == 0) {
    NSException *emptyEmailException = [NSException exceptionWithName:NSInvalidArgumentException reason:@"No Email" userInfo:nil];
    @throw emptyEmailException;
  }
  
  if (appName == nil
      || [appName length] == 0) {
    NSException *emptyAppNameException = [NSException exceptionWithName:NSInvalidArgumentException reason:@"No Application Name" userInfo:nil];
    @throw emptyAppNameException;
  }
  
  if (bundleIdentifier == nil
      || [bundleIdentifier length] == 0) {
    NSException *emptyBundleIdentifierException = [NSException exceptionWithName:NSInvalidArgumentException reason:@"No Bundle Identifier" userInfo:nil];
    @throw emptyBundleIdentifierException;
  }
  
  if (appLanguage == nil
      || [appLanguage length] == 0) {
    NSException *emptyLanguageException = [NSException exceptionWithName:NSInvalidArgumentException reason:@"No Appliction language" userInfo:nil];
    @throw emptyLanguageException;
  }
  
  AppModule *appModule = [[self alloc] init];
  [appModule setModuleBody:tableData];
  [appModule setModuleMetaData:[appModule createMetaDataDictionary :userName :eMail :appName :bundleIdentifier :appLanguage]];

  return appModule;
}

+ (AppModule*) createNewAppModuleFromJsonString :(NSData*) data {
  AppModule *appModule;
  if ([data length] > 0) {
    appModule = [[self alloc] init];
    id object = [appModule parseJsonDataToObject:data];
    
    NSDictionary *metaData = [appModule parseJsonStringToObject:[object valueForKey:kModuleMetaData]];
    [appModule setModuleMetaData:metaData];
    
    NSArray *body = [appModule parseJsonStringToObject:[object valueForKey:kModuleBody]];
    [appModule setModuleBody:body];
    
    return appModule;
  } else {
    @throw [NSException exceptionWithName:@"NoDataFoundException" reason:@"Can't download Data with this moduleID" userInfo:nil];
  }
}

- (NSDictionary*) createMetaDataDictionary :(NSString*) userName :(NSString*) eMail :(NSString*) appName :(NSString*) bundleIdentifier :(NSString*) appLanguage {
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  [dic setObject:userName forKey:kUserNameKey];
  [dic setObject:eMail forKey:kEMailKey];
  [dic setObject:appName forKey:kAppNameKey];
  [dic setObject:bundleIdentifier  forKey:kBundleIdentifierKey];
  [dic setObject:appLanguage  forKey:kLanguageKey];
  
  NSString *credat = [NSString stringWithFormat:@"%@", [NSDate date]];
  [dic setObject:credat  forKey:kModuleCredatKey];
  
  [dic setObject:[self createModuleID:appName :userName :credat]  forKey:kModuleID];
  
  return dic;
}

- (id) createModuleID :(NSString*) appName :(NSString*) userName :(NSString*) credat {
  return [NSString stringWithFormat:@"%@%@%@",[appName md5], [userName md5], [credat md5]];
}

- (id) moduleToJSonString {
  NSMutableDictionary *jsonDataDictionary = [NSMutableDictionary dictionary];
  [jsonDataDictionary setObject:[self writeObjectToJSonString:_moduleMetaData] forKey:kModuleMetaData];
  [jsonDataDictionary setObject:[self writeObjectToJSonString:_moduleBody] forKey:kModuleBody];
  NSString *jsonString = [self writeObjectToJSonString:jsonDataDictionary];
  return jsonString;
}

- (id) parseJsonDataToObject :(NSData*) data {
  SBJsonParser *parse = [[SBJsonParser alloc] init];
  id object = [parse objectWithData:data];
  return object;
}

- (id) parseJsonStringToObject :(NSString*) data {
  SBJsonParser *parse = [[SBJsonParser alloc] init];
  id object = [parse objectWithString:data];
  return object;
}

- (id) writeObjectToJSonString :(id) object {
  SBJsonWriter *writer = [[SBJsonWriter alloc] init];
  NSString* jsonString = [writer stringWithObject:object];
  return jsonString;
}

@end
