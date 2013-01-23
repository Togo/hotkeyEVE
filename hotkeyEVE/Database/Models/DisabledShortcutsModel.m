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
#import "EVEUtilities.h"

@implementation DisabledShortcutsModel

+ (void) disableShortcutWithStrings :(NSString*) appName :(NSString*) bundleIdentifier :(NSString*)shortcutString :(NSString*) user :(NSString*) elementTitle {
  NSInteger shortcutID = [ShortcutTableModel getShortcutId:shortcutString];
  NSInteger appID = [ApplicationsTableModel getApplicationID:appName :bundleIdentifier];
  
  [self disableShortcut:shortcutID :appID :elementTitle];
}

+ (void) disableShortcut :(NSInteger) shortcutID :(NSInteger) appID :(NSString*) elementTitle {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger userID = [UserDataTableModel getUserID:NSUserName()];

  if (shortcutID == 0
      || appID == 0) {
    DDLogError(@"ShortcutTableModel -> disableShortcut:: Can't disable shortcut one of these is 0. appID => :%li:  shortcutID => :%li: ", appID, shortcutID);
  } else {
    NSMutableString *query = [NSMutableString string];
    [query appendFormat:@"INSERT OR IGNORE INTO %@ ", DISABLED_SHORTCUTS_TABLE];
    [query appendFormat:@"VALUES ( "];
    [query appendFormat:@" NULL "];
    [query appendFormat:@" , %li ", appID];
    [query appendFormat:@" , %li ", shortcutID];
    [query appendFormat:@" , %li ", userID];
    [query appendFormat:@" , '%@' ", elementTitle];
    [query appendFormat:@" ); "];
    
    [db executeUpdate:query];

    DDLogInfo(@"ShortcutTableModel -> disableShortcut :: Shortcut disabled. appID => :%li: shortcutID => :%li: elementTitle => :%@:", appID, shortcutID, elementTitle);
  }
}

+ (void) disableShortcutInAllApps :(NSInteger) shortcutID :(NSString*) title {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"INSERT OR IGNORE INTO %@ ", GLOB_DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@"VALUES ( "];
  [query appendFormat:@" NULL "];
  [query appendFormat:@" , %li ", shortcutID];
  [query appendFormat:@" , %li ", userID];
  [query appendFormat:@" , '%@' ", title];
  [query appendFormat:@" ); "];
  
  [db executeUpdate:query];
  
  
  NSArray *allApps = [ApplicationsTableModel selectAllApplications];
  for (id aRow in allApps) {
    [self disableShortcut :shortcutID :[[aRow valueForKey:ID_COL] intValue] :title];
  }
  
}

+ (void) enableShortcut :(NSInteger) shortcutID :(NSInteger) appID :(NSString*) title {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"DELETE FROM %@ ", DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE %@ = %li ", APPLICATION_ID_COL, appID];
  [query appendFormat:@" AND %@ = %li ", SHORTCUT_ID_COL, shortcutID];
  [query appendFormat:@" AND %@ = %li ", USER_ID_COL, userID];
  [query appendFormat:@" AND %@ = '%@' ", TITLE_COL, title];
  
  [db executeUpdate:query];
}

+ (void) enableShortcutInAllApps :(NSInteger) shortcutID :(NSString*) title {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
    NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"DELETE FROM %@ ", GLOB_DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE %@ = %li ", SHORTCUT_ID_COL, shortcutID];
  [query appendFormat:@" AND %@ = %li ", USER_ID_COL, userID];
  [query appendFormat:@" AND %@ = '%@' ", TITLE_COL, title];
  
  [db executeUpdate:query];


  NSArray *allApps = [ApplicationsTableModel selectAllApplications];
  for (id aRow in allApps) {
    [self enableShortcut:shortcutID :[[aRow valueForKey:ID_COL] intValue] :title];
  }
}


+ (BOOL) isShortcutDisabled :(UIElement*) element :(NSInteger) shortcutID {
  NSInteger appID = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];
  NSInteger userID = [UserDataTableModel getUserID:[element user]];
  
  return [self isShortcutDisabled:shortcutID :appID :userID :[element title]];
}

+ (BOOL) isShortcutDisabled :(NSInteger) shortcutID :(NSInteger) appID  :(NSInteger) userID :(NSString*) title {
  DDLogInfo(@"ShortcutTableModel -> isShortcutDisabled(shortcutID => :%li:, appID => :%li:, userID => :%li:, title => :%@:) :: get called", shortcutID, appID, userID, title);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE "];
  [query appendFormat:@" %@ = %li ",APPLICATION_ID_COL, appID];
  [query appendFormat:@" AND %@ = %li ",SHORTCUT_ID_COL, shortcutID];
  [query appendFormat:@" AND %@ = %li ",USER_ID_COL, userID];
  [query appendFormat:@" AND %@ = '%@' ",TITLE_COL, title]; // title because it's possible that in other apps the shortcut id is the same but with another title
  
  DDLogVerbose(@"ShortcutTableModel -> isShortcutDisabled :: query => %@",query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    DDLogInfo(@"ShortcutTableModel -> isShortcutDisabled :: shortcut is disabled");
    return YES;
  } else {
    DDLogInfo(@"ShortcutTableModel -> isShortcutDisabled :: shortcut is not disabled");
    return NO;
  }
}

+ (BOOL) isGlobalDisabled :(NSInteger) shortcutID :(NSInteger) userID :(NSString*) title {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT rowid FROM %@ ", GLOB_DISABLED_SHORTCUT_DYN_COL];
  [query appendFormat:@" WHERE "];
  [query appendFormat:@" %@ = %li ",SHORTCUT_ID_COL, shortcutID];
  [query appendFormat:@" AND %@ = %li ",USER_ID_COL, userID];
  [query appendFormat:@" AND %@ = '%@' ",TITLE_COL, title];
  
  NSArray *result = [db executeQuery:query];
  
  if ([result count] > 0) {
    return YES;
  } else {
    return NO;
  }
}

+ (void) disableShortcutsInNewApp :(Application*) app {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" WHERE %@ = %li ", APPLICATION_ID_COL, [app appID] ];
  [query appendFormat:@" AND %@ = '%@' ", LANG_COL, [EVEUtilities currentLanguage]];
  
  NSArray *result = [db executeQuery:query];
  
  for (id aRow in result) {
    NSString *title = [aRow valueForKey:TITLE_COL];
    NSInteger shortcutID = [[aRow valueForKey:SHORTCUT_ID_COL] intValue];
    NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
    
    if ([self isGlobalDisabled :shortcutID :userID :title]) {
      [self disableShortcut:shortcutID :[app appID] :title];
    }
  }
}

@end
