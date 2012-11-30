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
  DDLogInfo(@"GUIElementsTable -> editGUIElement(element => :%@: :: get called", element);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger appID = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", GUI_ELEMENTS_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", IDENTIFIER_COL, [element uiElementIdentifier]];
  [query appendFormat:@" OR ( %@ like '%@' ", COCOA_IDENTIFIER_COL, [element cocoaIdentifierString]];
  [query appendFormat:@" AND   %@ != '' ) ", COCOA_IDENTIFIER_COL];
  [query appendFormat:@" AND %@ = %li ", APPLICATION_ID_COL, appID];
  
  DDLogVerbose(@"GUIElementsTable -> editGUIElement :: query => :%@:", query);
  NSArray *result = [db executeQuery:query];
  if ([result count] > 0) {
    element.title = [[result objectAtIndex:0] valueForKey:TITLE_COL];
    element.parentTitle = [[result objectAtIndex:0] valueForKey:PARENT_TITLE_COL];
    element.help = [[result objectAtIndex:0] valueForKey:HELP_COL];
    element.shortcutString = [[result objectAtIndex:0] valueForKey:SHORTCUT_STRING_COL];
    DDLogInfo(@"GUIElementsTable -> editGUIElement :: found entry in database resultArray => :%@: ", result );
    }
  }

+ (void) updateGUIElementTable  {
  DDLogInfo(@"GUIElementsTable -> updateGUIElementTable:: get called");
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", GUI_ELEMENTS_TABLE];
  [query appendFormat:@" WHERE EXISTS (SELECT rowid FROM %@ ", APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE %@.%@ = %@.%@ ", APPLICATIONS_TABLE, BUNDLE_IDEN_COL, GUI_ELEMENTS_TABLE, BUNDLE_IDEN_COL];
  [query appendFormat:@" OR %@.%@ = %@.%@ )", APPLICATIONS_TABLE, APP_NAME_COL, GUI_ELEMENTS_TABLE, APP_NAME_COL];
  
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
