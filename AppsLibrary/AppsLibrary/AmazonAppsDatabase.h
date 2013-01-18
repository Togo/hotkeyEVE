//
//  AmazonAppsDatabase.h
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsDatabase.h"

@class AmazonS3Client;
@class AmazonSimpleDBClient;

@interface AmazonAppsDatabase : NSObject <AppsDatabase>

@property (strong) AmazonS3Client *s3Client;
@property (strong) AmazonSimpleDBClient *sdbClient;

@end
