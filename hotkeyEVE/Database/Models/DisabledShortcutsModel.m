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
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];

  NSInteger shortcutID = [ShortcutTableModel getShortcutId:shortcutString];
  NSInteger appID = [ApplicationsTableModel getApplicationID:appName :bundleIdentifier];
  NSInteger userID = [UserDataTableModel getUserID:user];
  
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

+ (BOOL) isShortcutDisabled :(UIElement*) element :(NSInteger) shortcutID {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger appID = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];
  NSInteger userID = [UserDataTableModel getUserID:[element user]];
  
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
