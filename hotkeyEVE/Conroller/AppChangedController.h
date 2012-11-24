//
//  AppChangedController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/24/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppChangedController : NSObject

@property (strong) Application *activeApplication;

- (void) appFrontChanged :(NSString*) bundleIdentifier;

@end
