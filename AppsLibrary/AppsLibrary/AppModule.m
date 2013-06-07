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

// untested
- (void)updateAppModule:(NSArray *)tableData metaData:(id<TGAPPSLIB_IAppModuleMetaDataCreator>) creatorDialog {
	[self setModuleBody:tableData];

	NSMutableDictionary *metaDataDic = [creatorDialog createMetaDataDictionary];
	NSString *credat = [NSString stringWithFormat:@"%@", [NSDate date]];
	[metaDataDic setObject:credat  forKey:kModuleCredatKey];
	[metaDataDic setObject:[[self moduleMetaData] valueForKey:kModuleID] forKey:kModuleID];

	[self setModuleMetaData:metaDataDic];
}

+ (AppModule *)createNewAppModule:(NSArray *)tableData metaData:(id<TGAPPSLIB_IAppModuleMetaDataCreator>) creatorDialog {
  if (tableData == nil
      || [tableData count] == 0) {
    NSException *arrayEmptyException = [NSException exceptionWithName:NSInvalidArgumentException reason:@"There is no data in the Table" userInfo:nil];
    @throw arrayEmptyException;
  }
  
  AppModule *appModule = [[self alloc] init];
  [appModule setModuleBody:tableData];


	NSMutableDictionary *metaDataDic;
	@try {
		metaDataDic= [creatorDialog createMetaDataDictionary];
		NSString *credat = [NSString stringWithFormat:@"%@", [NSDate date]];
		[metaDataDic setObject:credat  forKey:kModuleCredatKey];
		[metaDataDic setObject:[self createModuleID:[metaDataDic valueForKey:kAppNameKey] :[metaDataDic valueForKey:kUserNameKey] :credat]  forKey:kModuleID];

		[appModule setModuleMetaData:metaDataDic];
	} @catch (NSException *exception1) {
		@throw exception1;
	}


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
    @throw [NSException exceptionWithName:@"NoAppModuleFoundException" reason:@"Didn't find a Module with this ID!" userInfo:nil];
  }
}

//- (NSDictionary *)createMetaDataDictionary:(NSDictionary *)metaDataDic {
//
//  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//	[dic addEntriesFromDictionary:metaDataDic];
////  [dic setObject:userName forKey:kUserNameKey];
////  [dic setObject:eMail forKey:kEMailKey];
////  [dic setObject:appName forKey:kAppNameKey];
////  [dic setObject:bundleIdentifier  forKey:kBundleIdentifierKey];
////  [dic setObject:metaDataDic forKey:kLanguageKey];
//
//
//
//  return dic;
//}

+ (id) createModuleID :(NSString*) appName :(NSString*) userName :(NSString*) credat {
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
