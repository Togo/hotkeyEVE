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
    // Get the Shortcut ID
    NSString *shortcutString = [[aElement shortcut] composeShortcutString];
    NSMutableString *query = [NSMutableString string];
    [query appendFormat:@" SELECT * FROM %@ ", SHORTCUTS_TABLE];
    [query appendFormat:@" WHERE %@ like '%@' ", SHORTCUT_STRING_COL, [shortcutString stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
    
    NSInteger shortcutID;
    NSArray *result = [db executeQuery:query];
    if ([result count] > 0)
      shortcutID = [[[result objectAtIndex:0] valueForKey:ID_COL] intValue];
      query = [NSMutableString string];
      [query appendFormat:@"INSERT OR IGNORE INTO %@ ", MENU_BAR_ITEMS_TABLE];
      [query appendFormat:@"VALUES ( "];
      [query appendFormat:@" NULL "];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[aElement uiElementIdentifier]]];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[aElement title]]];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[aElement help]]];
      [query appendFormat:@" , '%@' ", [StringUtilities databaseString:[aElement parentTitle]]];
      [query appendFormat:@" ,  %li ", shortcutID];
      [query appendFormat:@" ); "];
      
      [db executeUpdate:query];
    }
}

@end
