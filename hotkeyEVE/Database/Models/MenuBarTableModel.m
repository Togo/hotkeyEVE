//
//  MenuBarTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "MenuBarTableModel.h"
#import <UIElements/UIElement.h>
#import "StringUtilities.h"
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"
#import "EVEUtilities.h"
#import "UserDataTableModel.h"

@implementation MenuBarTableModel

+ (void) insertMenuBarElementArray :(NSArray*) elements {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  for (id aElement in elements) {
    NSInteger shortcutID = [ShortcutTableModel getShortcutId:[aElement shortcutString]];
    NSInteger applicationID = [ApplicationsTableModel getApplicationID:[[aElement owner] appName] :[[aElement owner] bundleIdentifier]];
    
    if (shortcutID) {
      NSMutableString *query = [NSMutableString string];
      [query appendFormat:@"INSERT OR IGNORE INTO %@ ", MENU_BAR_ITEMS_TABLE];
      [query appendFormat:@"VALUES ( "];
      [query appendFormat:@" NULL "];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[aElement uiElementIdentifier]]];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[aElement title]]];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[aElement help]]];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[aElement parentTitle]]];
      [query appendFormat:@" , '%@' ", [EVEUtilities currentLanguage]];
      [query appendFormat:@" ,  %li ", shortcutID];
      [query appendFormat:@" ,  %li ", applicationID];
      [query appendFormat:@" ); "];
      
      [db executeUpdate:query];
    }
  }
}

+ (NSString*) selectShortcutString :(UIElement*) element {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@,%@ ", SHORTCUTS_TABLE, MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" WHERE %@.shortcut_id = %@.id ", MENU_BAR_ITEMS_TABLE, SHORTCUTS_TABLE];
  [query appendFormat:@" AND %@.identifier like '%@' ", MENU_BAR_ITEMS_TABLE, [element uiElementIdentifier]];
  [query appendFormat:@" AND %@.%@ like '%@' ", MENU_BAR_ITEMS_TABLE, LANG_COL, [EVEUtilities currentLanguage]];
  
  DDLogVerbose(@"MenuBarTableModel -> selectShortcutString :: query => %@", query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    NSString *shortcutString = [[result objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL];
    DDLogInfo(@"MenuBarTableModel -> selectShortcutString :: found a string in the => :%@:", shortcutString);
    return shortcutString;
  } else {
    DDLogWarn(@"MenuBarTableModel -> selectShortcutString :: no shortcutString with the uiElementIdentifier => :%@: in the %@ Table found", element.uiElementIdentifier, MENU_BAR_ITEMS_TABLE);
    return @"";
  }
}

+ (NSArray*) searchInMenuBarTable :(UIElement*) element {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger appId = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];

  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@"SELECT * FROM %@ ", MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" WHERE %@ = %li ", APPLICATION_ID_COL, appId];
  
  NSArray *results = [db executeQuery:query];
  
  DDLogInfo(@"MenuBarTableModel -> searchInMenuBarTable :: add %li items to the %@ Table",[results count], MENU_BAR_SEARCH_TABLE);
  for (id aRow in results) {
    [query setString:@""];
    [query appendFormat:@"INSERT INTO menu_bar_search VALUES "];
    [query appendFormat:@" ( '%@', ",  [aRow valueForKey:IDENTIFIER_COL]];
    [query appendFormat:@"   '%@', ",  [aRow valueForKey:TITLE_COL]];
    [query appendFormat:@"   '%@', ",  [aRow valueForKey:PARENT_TITLE_COL] ];
    [query appendFormat:@"    %i );", [[aRow valueForKey:SHORTCUT_ID_COL] intValue]];
    
    [db executeUpdate:query];
  }

  query = [NSMutableString string];
  [query appendFormat:@" SELECT %@.*, %@.%@ ",MENU_BAR_SEARCH_TABLE, SHORTCUTS_TABLE, SHORTCUT_STRING_COL];
  [query appendFormat:@" FROM %@, %@ ", MENU_BAR_SEARCH_TABLE, SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE %@.%@ MATCH '%@*' ", MENU_BAR_SEARCH_TABLE, IDENTIFIER_COL, [element uiElementIdentifier]];
  [query appendFormat:@" AND %@.%@ = %@.%@ ", MENU_BAR_SEARCH_TABLE, SHORTCUT_ID_COL, SHORTCUTS_TABLE, ID_COL];
  
  DDLogVerbose(@"MenuBarTableModel -> searchInMenuBarTable :: query => %@", query);
  NSArray *result = [db executeQuery:query];
  
  [query setString:@""];
  [query appendFormat:@"DELETE FROM %@", MENU_BAR_SEARCH_TABLE];
  [db executeUpdate:query];

  DDLogInfo(@"MenuBarTableModel -> searchInMenuBarTable :: found %li rows with the identifier  => :%@:",[result count], [element uiElementIdentifier]);
  return result;
}

+ (NSInteger) countShortcuts :(Application*) app {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger applicationID = [ApplicationsTableModel getApplicationID:[app appName] :[app bundleIdentifier]];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" WHERE %@.application_id = %li ", MENU_BAR_ITEMS_TABLE, applicationID];
  [query appendFormat:@" AND %@.shortcut_id != 0 ", MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" AND %@.%@ like '%@' ", MENU_BAR_ITEMS_TABLE, LANG_COL, [EVEUtilities currentLanguage]];
  
  DDLogVerbose(@"query: %@", query);
  NSArray *result = [db executeQuery:query];
  
  return [result count];
}

+ (NSArray*) getTitlesAndShortcuts :(NSInteger) appID {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger userID = [UserDataTableModel getUserID:NSUserName()];
  // First get all Title and Shortcut Strings for this App
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT m.*, s.%@,   ", SHORTCUT_STRING_COL];
  
  [query appendFormat:@"    (  SELECT count(*) "];
  [query appendFormat:@"      FROM %@ ds ", DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@"      WHERE ds.%@ = s.%@ ", SHORTCUT_ID_COL, ID_COL];
  [query appendFormat:@"      AND   ds.%@ = m.%@ ", APPLICATION_ID_COL, APPLICATION_ID_COL];
  [query appendFormat:@"      AND   ds.%@ = m.%@ ", TITLE_COL, TITLE_COL];
  [query appendFormat:@"      AND   ds.%@ = %li ) AS %@, ", USER_ID_COL, userID, DISABLED_SHORTCUT_DYN_COL];
  
  [query appendFormat:@"    (  SELECT count(*) "];
  [query appendFormat:@"      FROM %@ ds ", GLOB_DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@"      WHERE ds.%@ = s.%@ ", SHORTCUT_ID_COL, ID_COL];
  [query appendFormat:@"      AND   ds.%@ = m.%@ ", TITLE_COL, TITLE_COL];
  [query appendFormat:@"      AND   ds.%@ = %li ) AS %@ ", USER_ID_COL, userID, GLOB_DISABLED_SHORTCUT_DYN_COL];
  
  [query appendFormat:@" FROM %@ m, %@ s ", MENU_BAR_ITEMS_TABLE, SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE m.%@ = %li ", APPLICATION_ID_COL, appID];
  [query appendFormat:@" AND s.%@ = m.%@ ", ID_COL, SHORTCUT_ID_COL];
  [query appendFormat:@" AND m.%@ like '%@' ", LANG_COL, [EVEUtilities currentLanguage]];
  [query appendFormat:@" ORDER BY m.%@, s.%@, m.%@", PARENT_TITLE_COL, SHORTCUT_STRING_COL,TITLE_COL ];
  
  NSArray *result = [db executeQuery:query];
  
  return result;
}

@end
