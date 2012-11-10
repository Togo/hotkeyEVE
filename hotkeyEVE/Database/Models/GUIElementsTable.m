//
//  GUIElementsTable.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/7/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "GUIElementsTable.h"
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"

@implementation GUIElementsTable


+ (void) editGUIElement :(UIElement*) element {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", GUI_ELEMENTS_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", IDENTIFIER_COL, [element uiElementIdentifier]];
  
  DDLogVerbose(@"query: %@", query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    element.title = [[result objectAtIndex:0] valueForKey:TITLE_COL];
    element.parentTitle = [[result objectAtIndex:0] valueForKey:PARENT_TITLE_COL];
    element.help = [[result objectAtIndex:0] valueForKey:HELP_COL];
    element.shortcutString = [[result objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL];
  }
}

+ (void) updateGUIElementTable  {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", GUI_ELEMENTS_TABLE];
  
  NSArray *results = [db executeQuery:query];
  
  for (id aRow in results) {
    NSInteger rowID = [[aRow valueForKey:ID_COL] intValue];
    NSString *shortcutString = [aRow valueForKey:SHORTCUT_STRING_COL];
    NSString *appName = [aRow valueForKey:APP_NAME_COL];
    NSString *bundeIdentifier = [aRow valueForKey:BUNDLE_IDEN_COL];

    NSInteger shortcutID = [ShortcutTableModel getShortcutId:shortcutString];
    if (shortcutID != 0)
      [self setGUIElementShortcutID :shortcutID :rowID];
    
    NSInteger applicationID = [ApplicationsTableModel getApplicationID:appName :bundeIdentifier];
    if (applicationID != 0)
      [self setGUIElementApplicationID :applicationID :rowID];

  }
}

+ (void) setGUIElementShortcutID :(NSInteger) shortcutID :(NSInteger) rowId {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" UPDATE %@  ", GUI_ELEMENTS_TABLE];
  [query appendFormat:@" SET %@ = %li  ", SHORTCUT_ID_COL, shortcutID];
  [query appendFormat:@" WHERE %@ = %li  ", ID_COL, rowId];
  
  [db executeUpdate:query];
}

+ (void) setGUIElementApplicationID :(NSInteger) applicationID :(NSInteger) rowId {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" UPDATE %@  ", GUI_ELEMENTS_TABLE];
  [query appendFormat:@" SET %@ = %li  ", APPLICATION_ID_COL, applicationID];
  [query appendFormat:@" WHERE %@ = %li  ", ID_COL, rowId];
  
  [db executeUpdate:query];
}

@end