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

- (id)init
{
  self = [super init];
  if (self) {
    self.s3Client = [[AmazonS3Client alloc] initWithAccessKey:kAmazonAccesKey
                                          withSecretKey:kAmazonSecretKey];
    self.sdbClient = [[AmazonSimpleDBClient alloc] initWithAccessKey:kAmazonAccesKey withSecretKey:kAmazonSecretKey];
  }
  
  return self;
}

- (NSString*) uploadToAmazonBucket :(AppModule*) module {
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

-(id) getAppList {
  
  return nil;
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
  SimpleDBReplaceableAttribute *replacableAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"Enabled" andValue:@"NO"andReplace:YES];
  [attributes addObject:replacableAttribute];
  
  return attributes;
}

@end
