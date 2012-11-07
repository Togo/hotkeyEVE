//
//  GUIElementsTable.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/7/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "GUIElementsTable.h"

@implementation GUIElementsTable


+ (NSString*) selectShortcutString :(UIElement*) element {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT %@ FROM %@ ",SHORTCUT_STRING_COL, GUI_ELEMENTS_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", IDENTIFIER_COL, [element uiElementIdentifier]];
  
  DDLogVerbose(@"query: %@", query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    return[[result objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL];
  } else {
    return @"";
  }
}

@end
