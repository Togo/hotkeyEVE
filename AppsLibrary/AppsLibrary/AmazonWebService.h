//
//  WebService.h
//  HotkeyEVE-Apps
//
//  Created by Tobias Sommer on 12/21/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebService.h"

@class AmazonS3Client;
@class AmazonSimpleDBClient;

@interface AmazonWebService : NSObject <IWebService>

@property (strong) AmazonS3Client *s3Client;
@property (strong) AmazonSimpleDBClient *sdbClient;

@end
