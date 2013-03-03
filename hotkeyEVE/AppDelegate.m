//
//  AppDelegate.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//
#import <Carbon/Carbon.h>

#import "AppDelegate.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"

#import "MenuBarIndexingThread.h"

#import <UIElements/ClickOnUIElementSubject.h>

#import "UserDataTableModel.h"
#import "TGEVE_GUIElementsTableModel.h"

#import "GrowlNotifications.h"
#import "EVEUtilities.h"

@implementation AppDelegate

@synthesize eveAppManager;
@synthesize fileLogger;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSLog(@"EVE has been started");
  NSLog(@"Lang: %@", [EVEUtilities currentLanguage]);
  NSLog(@"User: %@ ", NSUserName());
  
  [self startLogging];
  
  [self openDatabase];
  
  eveAppManager =  [EVEManager sharedEVEManager];
  
  [EVEUtilities checkAccessibilityAPIEnabled];
  
  [self initUserData];
  
//  [self startIndexing];
  
  [self registerListener];
  [[eveAppManager eveObserver] subscribeAllNotifications];
  
  if (![[[EVEManager sharedEVEManager] licence] isValid]) {
    [[GrowlNotifications growlNotifications] displayRegisterEVEWithCallbackNotification :@"Register EVE" :@"\nClick to get an Activation Key"];
  }
}

- (void) applicationWillTerminate:(NSNotification *)notification {
  DDLogInfo(@"EVE Terminated: %@", [notification object]);
}

- (void) startLogging {
//  [DDLog addLogger:[DDASLLogger sharedInstance]]; // systemlog
  [DDLog addLogger:[DDTTYLogger sharedInstance]]; // xcode console
  
  // Log in file
  fileLogger = [[DDFileLogger alloc] init];
  fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
  fileLogger.logFileManager.maximumNumberOfLogFiles = 7;

  [DDLog addLogger:fileLogger];
}

- (void) openDatabase {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  [db executeMigrations:[db databasePath]];
}

- (void) startIndexing {
  [[eveAppManager appLaunched] indexingAllApps];
}

- (void) registerListener {
    ClickOnUIElementSubject *clickListener = [[ClickOnUIElementSubject alloc]init];
    DDLogInfo(@"Register Listener: %@", clickListener);
}

- (void) initUserData {
  [UserDataTableModel insertUser: NSUserName()];
}

@end
