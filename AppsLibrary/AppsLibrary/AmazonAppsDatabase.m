//
//  AmazonAppsDatabase.m
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AmazonAppsDatabase.h"
#import "AppsLibrary.h"
#import "AmazonS3Client.h"
#import "AmazonSimpleDBClient.h"

@implementation AmazonAppsDatabase

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

- (NSArray*) getAppList {
  NSArray *entries = nil;
  NSString *select = [NSString stringWithFormat:@"select * from %@", kAmazonAppsDBDomainName];
  SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:select];
  selectRequest.consistentRead = YES;
  
  @try {
    SimpleDBSelectResponse *selectResponse = [_sdbClient select:selectRequest];
    entries =  [self parseAmazonToObjectiveC :selectResponse];
  }
  @catch (AmazonClientException *exception) {
    NSLog(@"%@", [exception reason]);
  }

  return entries;
}

- (NSArray*) parseAmazonToObjectiveC :(SimpleDBSelectResponse*) selectResponse {
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

@end
