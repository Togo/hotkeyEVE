//
//  AppsModuleTests.m
//  AppsLibrary
//
//  Created by Tobias Sommer on 12/18/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AppModule.h"
#import <OCMock/OCMock.h>
#import "AppsLibraryConstants.h"
#import "NSString+MD5.h"

@interface AppModuleTests : SenTestCase {
@private

}

@end

@implementation AppModuleTests

- (void)setUp
{
  [super setUp];

}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void) test_createNewAppModule_NSArrayWithItems_setTheTableBody {
  AppModule *module = [self createTestAppModule];
  STAssertNotNil([module moduleBody], @"");
}

- (void) test_createNewAppModule_NSArrayWithItems_createMetaDataDictionary {
  AppModule *module = [self createTestAppModule];
  STAssertNotNil([module moduleMetaData], @"");
}

- (void) test_createNewAppModule_EmptyArray_throwException {
  STAssertThrows([AppModule createNewAppModule:[NSArray array] metaData:nil], @"");
}

- (void) test_createNewAppModule_nilArray_throwException {
  STAssertThrows([AppModule createNewAppModule:nil metaData:nil], @"");
}

- (void) test_createNewAppModule_metaDataCreationThrowsException_throwThisException {
	id creatorMock = [OCMockObject mockForProtocol:@protocol(TGAPPSLIB_IAppModuleMetaDataCreator)];
	[[[creatorMock stub] andThrow:[NSException exceptionWithName:NSInternalInconsistencyException reason:@"An Exception" userInfo:nil]] createMetaDataDictionary];

	STAssertThrows([AppModule createNewAppModule:[NSArray arrayWithObject:@"1"] metaData:creatorMock], @"");
}

- (void) test_writeObjectToJSonString_metaDataDictionary_methodReturnsStringWithData {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [NSDictionary dictionaryWithObject:@"appName" forKey:kAppNameKey];
  
 id returnValue = [module writeObjectToJSonString :dic];
  STAssertTrue([returnValue length] > 0, @"");
}

- (void) test_writeObjectToJSonString_moduleBody_methodReturnsStringWithArrayOfDictionarys {
  AppModule *module = [self createTestAppModule];

  id returnValue = [module writeObjectToJSonString :[module moduleBody]];
  STAssertTrue([returnValue isEqualToString:@"[{\"key1\":\"1\"}]"], @"");
}

- (void) test_appModuleToJSonString_metaDicAndtableDataArrayCreated_returnNSString {
  AppModule *module = [self createTestAppModule];
  
  id returnValue = [module moduleToJSonString];
  STAssertTrue([returnValue isKindOfClass:[NSString class]], @"");
}

- (void) test_appModuleToJSonString_metaDicAndtableDataArrayCreated_StringContrainsMetaData {
  AppModule *module = [self createTestAppModule];
  
  id returnValue = [module moduleToJSonString];
  STAssertTrue([returnValue rangeOfString:kModuleMetaData].location  != NSNotFound, @"");
}

- (void) test_appModuleToJSonString_metaDicAndtableDataArrayCreated_StringContrainsModuleBody {
  AppModule *module = [self createTestAppModule];
  
  id returnValue = [module moduleToJSonString];
  STAssertTrue([returnValue rangeOfString:kModuleBody].location != NSNotFound, @"");
}

- (void) test_createModuleID_userNameBundleIdentifierContainsValue_retunsNSString {
  AppModule *module = [self createTestAppModule];
  NSString *theID = [AppModule createModuleID :@"AppName" :@"BundleIdentifier" :@"Credat"];
  
  STAssertTrue([theID isKindOfClass:[NSString class]], @"");
}

- (void) test_createModuleID_userNameBundleIdentifierContainsValue_retunValueContainsHashOfAppName {
  AppModule *module = [self createTestAppModule];
  NSString *theID = [AppModule createModuleID :@"AppName" :@"UserName" :@"Credat"];
  
  NSString *expectedAPPNameHash = [@"AppName" md5];
  
  STAssertTrue([theID rangeOfString:expectedAPPNameHash].location != NSNotFound, @"");
}

- (void) test_createModuleID_userNameBundleIdentifierContainsValue_retunValueContainsHashOfUserName {
  AppModule *module = [self createTestAppModule];
  NSString *theID = [AppModule createModuleID :@"AppName" :@"UserName" :@"Credat"];
  NSString *expectedUserNameHash = [@"UserName" md5];
 
  STAssertTrue([theID rangeOfString:expectedUserNameHash].location != NSNotFound, @"");
}

- (void) test_createModuleID_userNameBundleIdentifierContainsValue_retunValueContainsHashOfCredat {
  AppModule *module = [self createTestAppModule];
  NSString *theID = [AppModule createModuleID :@"AppName" :@"UserName" :@"Credat"];
  
  NSString *expectedcredatHash = [@"Credat" md5];
  
  STAssertTrue([theID rangeOfString:expectedcredatHash].location != NSNotFound, @"");
}

- (void) test_createNewAppModuleFromJsonString_noDataDownloaded_throwException {
  STAssertThrows([AppModule createNewAppModuleFromJsonString:[NSData data]], @"");
}

- (void) test_createNewAppModuleFromJsonString_downloadedSomeData_returnAppModule {
  STAssertNotNil([AppModule createNewAppModuleFromJsonString:[NSData dataWithBytes:@"test" length:@"test".length]], @"");
}

- (AppModule*) createTestAppModule {
  NSDictionary *aTableRow = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"key1", nil];
  NSArray *tableData = [NSArray arrayWithObject:aTableRow];

	id creatorMock = [OCMockObject mockForProtocol:@protocol(TGAPPSLIB_IAppModuleMetaDataCreator)];
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:@"Language value" forKey:kLanguageKey];
	[[[creatorMock stub] andReturn:dictionary] createMetaDataDictionary];
  AppModule *module = [AppModule createNewAppModule:tableData metaData:creatorMock];
  return module;
}


@end
