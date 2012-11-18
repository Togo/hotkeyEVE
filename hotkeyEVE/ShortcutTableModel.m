//
//  ShortcutTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ShortcutTableModel.h"
#import "StringUtilities.h"

@implementation ShortcutTableModel

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

+ (NSString*) getShortcutString :(NSInteger) shortcutID {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE %@ =  %li ", ID_COL, shortcutID];
  
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    return [[result objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL] ;
  } else {
    return @"";
  }
}

+ (NSInteger) getShortcutId :(NSString*) shortcutString {
  DDLogInfo(@"ShortcutTableModel -> getShortcutId(shortcutString => :%@:) ::", shortcutString);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE replace(%@,' ','') like replace('%@', ' ', '') ", SHORTCUT_STRING_COL, [StringUtilities databaseString:shortcutString]];
  
  DDLogVerbose(@"ShortcutTableModel -> getShortcutId :: query => %@", query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    NSInteger shortcutID = [[[result objectAtIndex:0] valueForKey:ID_COL] intValue];
    DDLogInfo(@"ShortcutTableModel -> getShortcutId(shortcutString :: found shortcutID => :%li:", shortcutID);
    return shortcutID;
  } else {
    DDLogError(@"ShortcutTableModel -> getShortcutId(shortcutString :: no shortcutID found query => :%@:", query);
    return 0;
  }
}

@end
