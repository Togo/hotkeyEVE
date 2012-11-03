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

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [self startLogging];
  
  [self openDatabase];
}

- (void) startLogging {
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void) openDatabase {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  [NSThread sleepForTimeInterval:1];
  [db executeMigrations:[db databasePath]];
}

@end
