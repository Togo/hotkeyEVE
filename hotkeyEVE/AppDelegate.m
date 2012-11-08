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
#import "MenuBarIndexingThread.h"

#import <UIElements/ClickOnUIElementSubject.h>

#import "UserDataTableModel.h"
#import "GUIElementsTable.h"


#import "EVEUtilities.h"


@implementation AppDelegate

@synthesize eveAppManager;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSLog(@"EVE has been started");
  NSLog(@"Lang: %@", [EVEUtilities currentLanguage]);
  NSLog(@"User: %@ ", NSUserName());
  
  [self openDatabase];
  [self initGUIElementTable];
  
  eveAppManager =  [EVEManager sharedEVEManager];
  
  [self startLogging];
  
  [self checkAccessibilityAPIEnabled];
  
  [self initUserData];
  
  [self startIndexing];
  
  [self registerListener];
  [[eveAppManager eveObserver] subscribeAllNotifications];
  
  
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

- (void) initGUIElementTable {
  // Update GUI Element Table and add Shortcut Id's
  [GUIElementsTable updateGUIElementTable];
}

- (void) startIndexing {
  [[eveAppManager indexing] indexingAllApps];
}

- (void) registerListener {
    ClickOnUIElementSubject *clickListener = [[ClickOnUIElementSubject alloc]init];
    DDLogInfo(@"Register Listener: %@", clickListener);
  
//  AppFrontSwichtedSubject *frontSwitchedListener = [[AppFrontSwichtedSubject alloc] init];
}

- (void) initUserData {
  [UserDataTableModel insertUser: NSUserName()];
}

- (void) checkAccessibilityAPIEnabled {
  // We first have to check if the Accessibility APIs are turned on.  If not, we have to tell the user to do it (they'll need to authenticate to do it).  If you are an accessibility app (i.e., if you are getting info about UI elements in other apps), the APIs won't work unless the APIs are turned on.
  if (!AXAPIEnabled()) {
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setMessageText:@"EVE requires that the Accessibility API be enabled."];
    [alert setInformativeText:@"Would you like to launch System Preferences so that you can turn on \"Enable access for assistive devices\"?"];
    [alert addButtonWithTitle:@"Open System Preferences"];
    [alert addButtonWithTitle:@"Continue Anyway"];
    [alert addButtonWithTitle:@"Quit UI"];
    
    NSInteger alertResult = [alert runModal];
    
    switch (alertResult) {
      case NSAlertFirstButtonReturn: {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSSystemDomainMask, YES);
        if ([paths count] == 1) {
          NSURL *prefPaneURL = [NSURL fileURLWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"UniversalAccessPref.prefPane"]];
          [[NSWorkspace sharedWorkspace] openURL:prefPaneURL];
        }
      }
        break;
        
      case NSAlertSecondButtonReturn: // just continue
      default:
        break;
        
      case NSAlertThirdButtonReturn:
        [NSApp terminate:self];
        return;
        break;
    }
  } else {
    DDLogInfo(@"Accessibility API is enabled");
  }
}

@end
