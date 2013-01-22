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
#import <CommonCrypto/CommonDigest.h>
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
  STAssertThrows([AppModule createNewAppModule:[NSArray array] :@"UserName" :@"Email" :@"AppName" :@"BundleIdentifier" :@"de"], @"");
}

- (void) test_createNewAppModule_nilArray_throwException {
  STAssertThrows([AppModule createNewAppModule:nil :@"userName" :@"Email" :@"AppName" :@"BundleIdentifier" :@"de"], @"");
}

- (void) test_createNewAppModule_EmptyUserName_throwException {
  STAssertThrows([AppModule createNewAppModule:[NSArray arrayWithObject:@"1"] :@"" :nil :@"AppName" :@"BundleIdentifier" :@"de"], @"");
}

- (void) test_createNewAppModule_UserNameIsNil_throwException {
  STAssertThrows([AppModule createNewAppModule:[NSArray arrayWithObject:@"1"] :nil :nil :@"AppName" :@"BundleIdentifier" :@"de"], @"");
}

- (void) test_createNewAppModule_EMailIsEmpty_throwException {
  STAssertThrows([AppModule createNewAppModule:[NSArray arrayWithObject:@"1"] :@"UserName" :nil :@"AppName" :@"BundleIdentifier" :@"de"], @"");
}

- (void) test_createNewAppModule_AppNameIsEmpty_throwException {
  STAssertThrows([AppModule createNewAppModule:[NSArray arrayWithObject:@"1"] :@"UserName" :@"EMail" :@"" :@"BundleIdentifier" :@"de"], @"");
}

- (void) test_createNewAppModule_bundleIdentifierIsEmpty_throwException {
  STAssertThrows([AppModule createNewAppModule:[NSArray arrayWithObject:@"1"] :@"UserName" :@"EMail" :@"AppName" :@"" :@"de"], @"");
}

- (void) test_createNewAppModule_languageIsEmpty_throwException {
  STAssertThrows([AppModule createNewAppModule:[NSArray arrayWithObject:@"1"] :@"UserName" :@"EMail" :@"AppName" :@"BundleIdentifier" :@""], @"");
}

- (void) test_createMetaDataDictionary_userNameOk_metaDataDictionaryContainsUserName {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [module createMetaDataDictionary:@"TheUserName" :@"" :@"" :@"" :@""];
  NSString *expectedUserName = [dic valueForKey:kUserNameKey];
  STAssertTrue([expectedUserName isEqualToString:@"TheUserName"], @"");
}

- (void) test_createMetaDataDictionary_userNameOk_metaDataDictionaryContainsUserEmail {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [module createMetaDataDictionary:@"" :@"TheEmail" :@"" :@"" @"" :@""];
  NSString *expectedUserName = [dic valueForKey:kEMailKey];
  STAssertTrue([expectedUserName isEqualToString:@"TheEmail"], @"");
}

- (void) test_createMetaDataDictionary_appNameOk_metaDataDictionaryContainsAppName {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [module createMetaDataDictionary:@"" :@"" :@"AppName" :@"" @"" :@""];
  NSString *expectedAppName = [dic valueForKey:kAppNameKey];
  STAssertTrue([expectedAppName isEqualToString:@"AppName"], @"");
}

- (void) test_createMetaDataDictionary_bundleIdentifierOk_metaDataDictionaryContainsBundleIdentifier {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [module createMetaDataDictionary:@"" :@"" :@"" :@"BundleIdentifier" :@"de"];
  NSString *expectedBundleIdentifier = [dic valueForKey:kBundleIdentifierKey];
  STAssertTrue([expectedBundleIdentifier isEqualToString:@"BundleIdentifier"], @"");
}

- (void) test_createMetaDataDictionary_bundleIdentifierOk_metaDataDictionaryContainsLanguage {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [module createMetaDataDictionary:@"" :@"" :@"" :@"" :@"de"];
  NSString *expectedLanguage = [dic valueForKey:kLanguageKey];
  STAssertTrue([expectedLanguage isEqualToString:@"de"], @"");
}

- (void) test_createMetaDataDictionary_valid_metaDataDictionaryContainsCredat {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [module createMetaDataDictionary:@"" :@"" :@"" :@"" :@""];
  NSString *expectedCretad = [dic valueForKey:kModuleCredatKey];
  STAssertTrue([expectedCretad length] > 0, @"");
}

- (void) test_createMetaDataDictionary_valid_metaDataDictionaryContainsMoudleID {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [module createMetaDataDictionary:@"AppName" :@"UserName" :@"EMail" :@"BundleIdentifier" :@"de"];
  NSString *expectedModuleID = [dic valueForKey:kModuleID];
  STAssertTrue([expectedModuleID length] > 0, @"");
}

- (void) test_writeObjectToJSonString_metaDataDictionary_methodReturnsStringWithData {
  AppModule *module = [[AppModule alloc] init];
  NSDictionary *dic = [module createMetaDataDictionary:@"UserName" :@"TheEmail" :@"AppName" :@"Bundle" :@"de"];
  
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
  NSString *theID = [module createModuleID :@"AppName" :@"BundleIdentifier" :@"Credat"];
  
  STAssertTrue([theID isKindOfClass:[NSString class]], @"");
}

- (void) test_createModuleID_userNameBundleIdentifierContainsValue_retunValueContainsHashOfAppName {
  AppModule *module = [self createTestAppModule];
  NSString *theID = [module createModuleID :@"AppName" :@"UserName" :@"Credat"];
  
  NSString *expectedAPPNameHash = [@"AppName" md5];
  
  STAssertTrue([theID rangeOfString:expectedAPPNameHash].location != NSNotFound, @"");
}

- (void) test_createModuleID_userNameBundleIdentifierContainsValue_retunValueContainsHashOfUserName {
  AppModule *module = [self createTestAppModule];
  NSString *theID = [module createModuleID :@"AppName" :@"UserName" :@"Credat"];
  NSString *expectedUserNameHash = [@"UserName" md5];
 
  STAssertTrue([theID rangeOfString:expectedUserNameHash].location != NSNotFound, @"");
}

- (void) test_createModuleID_userNameBundleIdentifierContainsValue_retunValueContainsHashOfCredat {
  AppModule *module = [self createTestAppModule];
  NSString *theID = [module createModuleID :@"AppName" :@"UserName" :@"Credat"];
  
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
  AppModule *module = [AppModule createNewAppModule:tableData :@"UserName Value" :@"EMail Value" :@"AppName Value" :@"BundleIdentifier Value" :@"Language value"];
  return module;
}


@end
