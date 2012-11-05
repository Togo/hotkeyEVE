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

+ (NSInteger) getShortcutId :(NSString*) shortcutString {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", SHORTCUTS_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", SHORTCUT_STRING_COL, [StringUtilities databaseString:shortcutString]];
  
  NSInteger shortcutID = 0;
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    shortcutID = [[[result objectAtIndex:0] valueForKey:ID_COL] intValue];
  }
  
  return shortcutID;
}

@end
