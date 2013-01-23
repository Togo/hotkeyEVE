//
//  IAppsTableViewController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/23/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAppsManager.h"

@protocol IAppsTableViewController <NSObject>

@property (strong) id<IAppsManager> appsManager;

@end
