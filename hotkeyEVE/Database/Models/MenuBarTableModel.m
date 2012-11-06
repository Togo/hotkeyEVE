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

@implementation MenuBarTableModel

+ (void) insertShortcutsFromElementArray :(NSArray*) elements {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  for (id aElement in elements) {
    NSString *shortcutString = [[aElement shortcut] composeShortcutString];
    if ([shortcutString length] > 0) {
      NSMutableString *query = [NSMutableString string];
      [query appendFormat:@"INSERT OR IGNORE INTO %@ ", SHORTCUTS_TABLE];
      [query appendFormat:@"VALUES ( "];
      [query appendFormat:@" NULL "];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:shortcutString]];
      [query appendFormat:@" ); "];
      
      [db executeUpdate:query];
    }
  }
}

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
      [query appendFormat:@" ,  %li ", shortcutID];
      [query appendFormat:@" ,  %li ", applicationID];
      [query appendFormat:@" ); "];
      
      
      
      [db executeUpdate:query];
    }
  }
}

+ (void) selectShortcutString :(UIElement*) element {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@,%@ ", SHORTCUTS_TABLE, MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" WHERE %@.shortcut_id = %@.id ", MENU_BAR_ITEMS_TABLE, SHORTCUTS_TABLE];
  [query appendFormat:@" AND %@.identifier like '%@' ", MENU_BAR_ITEMS_TABLE, [element uiElementIdentifier]];
  
  DDLogVerbose(@"query: %@", query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    element.shortcutString = [[result objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL];
  }
}

+ (NSInteger) countShortcuts :(Application*) app {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger applicationID = [ApplicationsTableModel getApplicationID:[app appName] :[app bundleIdentifier]];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", MENU_BAR_ITEMS_TABLE];
  [query appendFormat:@" WHERE %@.application_id = %li ", MENU_BAR_ITEMS_TABLE, applicationID];
  [query appendFormat:@" AND %@.shortcut_id != 0 ", MENU_BAR_ITEMS_TABLE];
  
  DDLogVerbose(@"query: %@", query);
  NSArray *result = [db executeQuery:query];
  return [result count];
}

@end
