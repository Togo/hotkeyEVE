//
//  AppLaunchedController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "AppLaunchedController.h"
#import <UIElements/Application.h>
#import "ApplicationsTableModel.h"
#import "DisabledShortcutsModel.h"

@implementation AppLaunchedController

- (void) indexingAllApps {
  DDLogInfo(@"Start Indexing all Apps");
  NSArray *runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
  for (id aApp in runningApplications) {
    NSString *bundleIdentifier = [aApp bundleIdentifier];
    if (bundleIdentifier) {
      [self newAppLaunched:bundleIdentifier];
    }
  }
}

- (void) newAppLaunched :(NSString*) bundleIdentifier {
  DDLogInfo(@"New App started: %@", bundleIdentifier);
  Application *app = [[Application alloc] initWithBundleIdentifier:bundleIdentifier];
  
  if (![ApplicationsTableModel isInApplicationBlacklist :app]) {
    if ([ApplicationsTableModel isNewApp:app])
      [ApplicationsTableModel insertNewApplication :app];
    
    app.appID = [ApplicationsTableModel getApplicationID:[app appName] :[app bundleIdentifier]];
    
    [[[EVEManager sharedEVEManager] indexing] indexingApp:app];
  }
}

@end
