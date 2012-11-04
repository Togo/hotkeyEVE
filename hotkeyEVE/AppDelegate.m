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
#import <UIElements/ClickOnUIElementSubject.h>

@implementation AppDelegate

@synthesize eveAppManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSLog(@"EVE has been started");
  eveAppManager =  [EVEManager sharedEVEManager];
  
  [self startLogging];
  
  [self openDatabase];
  
  [self startIndexing];
  
  
  [self registerListener];
  [self registerNotifications];
}

- (void) startLogging {
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  
  // Log in file
}

- (void) openDatabase {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  [db executeMigrations:[db databasePath]];
}

- (void) startIndexing {
  [[eveAppManager indexing] indexingAllApps];
}

- (void) registerListener {
    ClickOnUIElementSubject *clickListener = [[ClickOnUIElementSubject alloc]init];
    DDLogInfo(@"Register Listener: %@", clickListener);
}

- (void) registerNotifications {
  [[eveAppManager eveObserver] subscribeToNotificiation:ClickOnUIElementNotification];
  DDLogInfo(@"Subsscribed %@", ClickOnUIElementNotification);
}

@end
