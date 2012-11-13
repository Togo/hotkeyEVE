//
//  AppLaunchedController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "AppLaunchedController.h"
#import <UIElements/Application.h>
#import "GUISupportTableModel.h"
#import "ApplicationsTableModel.h"
#import "DisabledShortcutsModel.h"

@implementation AppLaunchedController

- (void) indexingAllApps {
  DDLogInfo(@"Start Indexing all Apps");
  NSArray *runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
  for (id aApp in runningApplications) {
    [self newAppLaunched:[aApp bundleIdentifier]];
  }
}

- (void) newAppLaunched :(NSString*) bundleIdentifier {
  DDLogInfo(@"New App started: %@", bundleIdentifier);
  Application *app = [[Application alloc] initWithBundleIdentifier:bundleIdentifier];
  
  app.guiSupport = [GUISupportTableModel hasGUISupport:[app bundleIdentifier]];
  if ([ApplicationsTableModel isNewApp:app])
    [ApplicationsTableModel insertNewApplication :app];
  else
    [ApplicationsTableModel updateApplicationTable:app];
  
  app.appID = [ApplicationsTableModel getApplicationID:[app appName] :[app bundleIdentifier]];
  
  
  [[[EVEManager sharedEVEManager] indexing] indexingApp:app];
}

@end
