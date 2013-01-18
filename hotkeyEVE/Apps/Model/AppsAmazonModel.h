//
//  AppsAmazonModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsNotInstalledModel.h"
#import <AppsLibrary/AppsLibrary.h>

@interface AppsAmazonModel : NSObject <AppsNotInstalledModel>

@property AmazonAppsDatabase *appsDatabase;

@end
