//
//  IAppsTableViewController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/23/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGEVE_IAppsManager.h"

@protocol IAppsTableViewController <NSObject>

@property (strong) id<TGEVE_IAppsManager> appsManager;

@end
