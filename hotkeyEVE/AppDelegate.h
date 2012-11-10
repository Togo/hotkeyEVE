//
//  AppDelegate.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class DDFileLogger;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) EVEManager *eveAppManager;
@property (strong, nonatomic) DDFileLogger *fileLogger;
@end
