//
//  AppDelegate.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "AppDelegate.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "MenuBarIndexingThread.h"

@implementation AppDelegate

@synthesize eveAppManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSLog(@"EVE has been started");
  
  [self startLogging];
  
  [self openDatabase];
  
  eveAppManager =  [EVEManager sharedEVEManager];
  
  [self startIndexing];
}

- (void) startLogging {
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void) openDatabase {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  [db executeMigrations:[db databasePath]];
}

- (void) startIndexing {
  [[eveAppManager indexing] indexingAllApps];
}

@end
