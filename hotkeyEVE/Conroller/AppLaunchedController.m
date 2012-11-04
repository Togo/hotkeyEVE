//
//  AppLaunchedController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "AppLaunchedController.h"
#import <UIElements/Application.h>

@implementation AppLaunchedController

- (void) newAppLaunched :(NSString*) bundleIdentifier {
  DDLogInfo(@"New App started: %@", bundleIdentifier);
  Application *app = [[Application alloc] initWithBundleIdentifier:bundleIdentifier];
  
  [[[EVEManager sharedEVEManager] indexing] indexingApp:app];
}

@end
