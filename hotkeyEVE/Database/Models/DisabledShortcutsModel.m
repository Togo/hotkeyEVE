//
//  DisableShortcutsModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "DisabledShortcutsModel.h"
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"
#import "UserDataTableModel.h"

@implementation DisabledShortcutsModel

+ (void) disableShortcut :appName :bundleIdentifier :shortcutString :user {
  NSInteger shortcutID = [ShortcutTableModel getShortcutId:shortcutString];
  NSInteger appID = [ApplicationsTableModel getApplicationID:appName :bundleIdentifier];
  NSInteger userID = [UserDataTableModel getUserID:user];
  
  [self disableShortcut:shortcutID :appID :userID];
}

+ (void) disableShortcut :(NSInteger) shortcutID :(NSInteger) appID  :(NSInteger) userID {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];

  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , %li ", appID];
  [query appendFormat:@" , %li ", shortcutID];
  [query appendFormat:@" , %li ", userID];
  [query appendFormat:@" ); "];

  [db executeUpdate:query];
}

+ (void) disableShortcutInAllApps :(NSInteger) shortcutID {
  NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
  NSArray *allApps = [ApplicationsTableModel selectAllApplications];
  for (id aRow in allApps) {
    [self disableShortcut:shortcutID :[[aRow valueForKey:ID_COL] intValue] :userID];
  }
}

+ (void) enableShortcut :(NSInteger) shortcutID :(NSInteger) appID  :(NSInteger) userID {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"DELETE FROM %@ ", DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE %@ = %li ", APPLICATION_ID_COL, appID];
  [query appendFormat:@" AND %@ = %li ", SHORTCUT_ID_COL, shortcutID];
  [query appendFormat:@" AND %@ = %li ", USER_ID_COL, userID];
  
  [db executeUpdate:query];
}

+ (void) enableShortcutInAllApps :(NSInteger) shortcutID {
  NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
  NSArray *allApps = [ApplicationsTableModel selectAllApplications];
  for (id aRow in allApps) {
    [self enableShortcut:shortcutID :[[aRow valueForKey:ID_COL] intValue] :userID];
  }
}


+ (BOOL) isShortcutDisabled :(UIElement*) element :(NSInteger) shortcutID {
  NSInteger appID = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];
  NSInteger userID = [UserDataTableModel getUserID:[element user]];
  
  return [self isShortcutDisabled:shortcutID :appID :userID];
}

+ (BOOL) isShortcutDisabled :(NSInteger) shortcutID :(NSInteger) appID  :(NSInteger) userID {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE "];
  [query appendFormat:@" %@ = %li ",APPLICATION_ID_COL, appID];
  [query appendFormat:@" AND %@ = %li ",SHORTCUT_ID_COL, shortcutID];
  [query appendFormat:@" AND %@ = %li ",USER_ID_COL, userID];
  
  NSArray *result = [db executeQuery:query];
  
  if ([result count] > 0) {
    DDLogInfo(@"Shortcut is disabled!");
    return YES;
  } else {
    return NO;
  }
}

@end
