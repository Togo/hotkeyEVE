//
//  MenuBarTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "TGEVE_MenuBarTableModel.h"
#import <UIElements/UIElement.h>
#import "StringUtilities.h"
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"
#import "EVEUtilities.h"

@implementation TGEVE_MenuBarTableModel

- (void) insertMenuBarElementArray :(NSArray*) elements {
  
  for (id aElement in elements) {
    if ([[aElement shortcutString] length] > 0) {
      [self insertMenuBarElement:aElement];
    }
  }
}

- (void) insertMenuBarElement :(UIElement*) element {
  NSInteger shortcutID = [ShortcutTableModel getShortcutId:[element shortcutString]];
  NSInteger applicationID = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];

  if (   shortcutID
      && applicationID) {
    EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
    
    NSMutableString *query = [NSMutableString string];
    [query appendFormat:@"INSERT OR REPLACE INTO %@ ", MENU_BAR_ITEMS_TABLE];
    [query appendFormat:@"VALUES ( "];
    [query appendFormat:@" NULL "];
    [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[element uiElementIdentifier]]];
    [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[element title]]];
    [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[element help]]];
    [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[element parentTitle]]];
    [query appendFormat:@" , '%@' ", [EVEUtilities currentLanguage]];
    [query appendFormat:@" ,  %li ", shortcutID];
    [query appendFormat:@" ,  %li ", applicationID];
    [query appendFormat:@" ); "];
    
    [db executeUpdate:query];
  }
}


- (NSArray*) searchInMenuBarTable :(UIElement*) element {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger appId = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];

  NSMutableString *query = [NSMutableString string];
  
  [query appendFormat:@"INSERT INTO menu_bar_search (\"%@\", \"%@\",  \"%@\",\"%@\") SELECT \"%@\", \"%@\",  \"%@\",\"%@\" FROM menu_bar_items WHERE %@ = %li ", IDENTIFIER_COL, TITLE_COL,PARENT_TITLE_COL, SHORTCUT_ID_COL,IDENTIFIER_COL, TITLE_COL, PARENT_TITLE_COL, SHORTCUT_ID_COL, APPLICATION_ID_COL, appId];
  [db executeUpdate:query];
  
  query = [NSMutableString string];
  [query appendFormat:@" SELECT %@.*, %@.%@ ",MENU_BAR_SEARCH_TABLE, SHORTCUTS_TABLE, SHORTCUT_STRING_COL];
  [query appendFormat:@" FROM %@, %@ ", MENU_BAR_SEARCH_TABLE, SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE %@.%@ MATCH '%@' ", MENU_BAR_SEARCH_TABLE, IDENTIFIER_COL, [element uiElementIdentifier]];
  [query appendFormat:@" AND %@.%@ = %@.%@ ", MENU_BAR_SEARCH_TABLE, SHORTCUT_ID_COL, SHORTCUTS_TABLE, ID_COL];
  
  DDLogVerbose(@"MenuBarTableModel -> searchInMenuBarTable :: query => %@", query);
  NSArray *result = [db executeQuery:query];
  
  query = [NSMutableString string];
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
  
  NSInteger userID = [[[EVEManager sharedEVEManager] eveUser] userID];
  // First get all Title and Shortcut Strings for this App
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT m.*, s.%@,   ", SHORTCUT_STRING_COL];
  
  [query appendFormat:@"    (  SELECT count(*) "];
  [query appendFormat:@"      FROM %@ ds ", DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@"      WHERE ds.%@ = s.%@ ", SHORTCUT_ID_COL, ID_COL];
  [query appendFormat:@"      AND   ds.%@ = m.%@ ", APPLICATION_ID_COL, APPLICATION_ID_COL];
  [query appendFormat:@"      AND   trim(ds.%@) = trim(m.%@) ", TITLE_COL, TITLE_COL];
  [query appendFormat:@"      AND   ds.%@ = %li ) AS %@, ", USER_ID_COL, userID, DISABLED_SHORTCUT_DYN_COL];
  
  [query appendFormat:@"    (  SELECT count(*) "];
  [query appendFormat:@"      FROM %@ ds ", GLOB_DISABLED_SHORTCUTS_TABLE];
  [query appendFormat:@"      WHERE ds.%@ = s.%@ ", SHORTCUT_ID_COL, ID_COL];
  [query appendFormat:@"      AND   trim(ds.%@) = trim(m.%@) ", TITLE_COL, TITLE_COL];
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
