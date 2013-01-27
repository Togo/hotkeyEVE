//
//  WebService.m
//  HotkeyEVE-Apps
//
//  Created by Tobias Sommer on 12/21/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "AmazonWebService.h"
#import "AppsLibrary.h"
#import "AmazonS3Client.h"
#import "AmazonSimpleDBClient.h"

@implementation AmazonWebService

@synthesize s3Client = _s3Client;
@synthesize sdbClient = _sdbClient;

- (id)init {
  self = [super init];
  if (self) {
    self.s3Client = [[AmazonS3Client alloc] initWithAccessKey:kAmazonAccesKey
                                          withSecretKey:kAmazonSecretKey];
    self.sdbClient = [[AmazonSimpleDBClient alloc] initWithAccessKey:kAmazonAccesKey withSecretKey:kAmazonSecretKey];
  }
  
  return self;
}

- (NSString*) uploadToServer :(AppModule*) module {
    NSString* returnValue = kUploadSuccessMessage;

    @try {
      // Upload module data.  Remember to set the content type.
      S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:[[module moduleMetaData] valueForKey:kModuleID] inBucket:kAmazonBucketName];
      por.contentType = @"plain/text";
      por.data        = [[module moduleToJSonString] dataUsingEncoding:NSUTF8StringEncoding];
      
      // Put the image data into the specified s3 bucket and object.
      S3PutObjectResponse *putObjectResponse = [_s3Client putObject:por];
      
    }
    @catch (AmazonClientException *exception) {
      returnValue = [NSString stringWithFormat:@"Hmm i reveived the following Error:\n%@", [exception message]];
    }
  
  return returnValue;
}

- (NSString*) insertInAppsDatabase :(AppModule*) module {
  NSString *returnValue = kUploadSuccessMessage;
  
  NSMutableArray *attributes = [self createAttributesArrayWithMetaData :[module moduleMetaData]];

  
  SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:kAmazonAppsDBDomainName andItemName:[[module moduleMetaData] valueForKey:kModuleID] andAttributes:attributes];
  
  @try {
      SimpleDBPutAttributesResponse *putAttributesResponse = [_sdbClient putAttributes:putAttributesRequest];
  }
  @catch (AmazonServiceException *exception) {
    returnValue = [exception message];
  }
  
  return returnValue;
}

- (NSMutableArray*) createAttributesArrayWithMetaData :(NSDictionary*) metaData {
  NSMutableArray *attributes = [NSMutableArray array];
  
  for (id aKey in metaData) {
    if (aKey != kModuleID) { // redundant moduleID is the item name
      SimpleDBReplaceableAttribute *replacableAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:aKey andValue:[metaData valueForKey:aKey] andReplace:YES];
      [attributes addObject:replacableAttribute];
    }
  }
  
  // Set Module Enabled standard to false
  SimpleDBReplaceableAttribute *replacableAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"Enabled" andValue:@"NO" andReplace:YES];
  [attributes addObject:replacableAttribute];
  
  return attributes;
}

- (NSArray*) getNotInstalledAppList :(NSArray*) installedModuleIDs {
  NSArray *entries = nil;
  NSMutableString *select = [NSMutableString string];
  [select appendFormat:@" select * from %@ ", kAmazonAppsDBDomainName];
    [select appendFormat:@" where Enabled = 'YES' "];
  
  NSInteger index = 0;
  for (NSString *aModuleID in installedModuleIDs) {
      [select appendFormat:@" and itemName() != '%@' ", aModuleID];
  }

  SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:select];
  selectRequest.consistentRead = YES;
  
  @try {
    SimpleDBSelectResponse *selectResponse = [_sdbClient select:selectRequest];
    entries =  [self parseAmazonResponseToObjectiveCArrayWithDictionarys :selectResponse];
  }
  @catch (AmazonClientException *exception) {
    NSLog(@"%@", [exception reason]);
  }
  
  return entries;
}

- (NSArray*) parseAmazonResponseToObjectiveCArrayWithDictionarys :(SimpleDBSelectResponse*) selectResponse {
  NSMutableArray *entries = [NSMutableArray array];
  for (SimpleDBItem *aItem in [selectResponse items]) {
    NSMutableDictionary *aEntry = [NSMutableDictionary dictionary];
    [aEntry setValue:[aItem name] forKey:kModuleID];
    for (SimpleDBAttribute *aAttibute in [aItem attributes]) {
      [aEntry setValue:[aAttibute value] forKey:[aAttibute name]];
    }
    [entries addObject:aEntry];
  }
  return entries;
}

- (NSData*) downloadFromServer :(NSString*) moduleID {
  NSData *returnData;
  
  @try {
    S3GetObjectRequest *download = [[S3GetObjectRequest alloc] initWithKey:moduleID withBucket:kAmazonBucketName];

    // Get the image data
    S3GetObjectResponse *getObjectResponse = [_s3Client getObject:download];
    returnData = [getObjectResponse body];
  }
  @catch (AmazonClientException *exception) {
      NSLog(@"%@", [exception reason]);
  }
  
  return returnData;
}

@end
