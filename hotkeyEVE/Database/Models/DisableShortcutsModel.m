//
//  DisableShortcutsModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "DisableShortcutsModel.h"
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"
#import "UserDataTableModel.h"

@implementation DisableShortcutsModel

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
@end
