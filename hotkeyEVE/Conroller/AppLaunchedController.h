//
//  AppLaunchedController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLaunchedController : NSObject

- (void) indexingAllApps;
- (void) newAppLaunched :(NSString*) bundleIdentifier;

@end
