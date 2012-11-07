//
//  DisplayedShortcutsModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/5/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "DisplayedShortcutsModel.h"
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"
#import "UserDataTableModel.h"

@implementation DisplayedShortcutsModel

+ (void) insertDisplayedShortcut :(UIElement*) element {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger shortcutID = [ShortcutTableModel getShortcutId:[element shortcutString]];
  NSInteger appID = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];
  NSInteger userID = [UserDataTableModel getUserID:[element user]];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT INTO %@ ", DISPLAYED_SHORTCUTS_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , datetime('now') "];
  [query appendFormat:@" , %li ", appID];
  [query appendFormat:@" , %li ", shortcutID];
  [query appendFormat:@" , %li ", userID];
  [query appendFormat:@" ); "];
  
  [db executeUpdate:query];
}

+ (BOOL) checkShortcutTimeIntervall :(NSInteger) shortcutID {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT rowid FROM %@" , DISPLAYED_SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE %@ = %li ", SHORTCUT_ID_COL, shortcutID];
  [query appendFormat:@" AND   %@ >= (DATETIME('now', '-5 Second') ); ", TIMESTAMP];
  
  NSArray *results = [db executeQuery:query];
  
  if ([results count] > 0)
    return NO;
  else
    return YES;
}

@end
