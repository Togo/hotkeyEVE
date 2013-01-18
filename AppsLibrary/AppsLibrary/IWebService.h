//
//  IWebService.h
//  HotkeyEVE-Apps
//
//  Created by Tobias Sommer on 12/22/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppModule;

@protocol IWebService <NSObject>

- (NSString*) uploadToAmazonBucket :(AppModule*) module;
- (NSString*) insertInAppsDatabase :(AppModule*) module;

@end
