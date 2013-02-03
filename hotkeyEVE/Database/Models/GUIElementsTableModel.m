//
//  GUIElementsTable.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/7/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "GUIElementsTableModel.h"
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"
#import "AppModuleTableModel.h"

@implementation GUIElementsTableModel

+ (void) editGUIElement :(UIElement*) element {
  DDLogInfo(@"GUIElementsTable -> editGUIElement(element => :%@: :: get called", element);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", GUI_ELEMENTS_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", IDENTIFIER_COL, [element uiElementIdentifier]];
  [query appendFormat:@" OR ( %@ like '%@' ", COCOA_IDENTIFIER_COL, [element cocoaIdentifierString]];
  [query appendFormat:@" AND   %@ != '' ) ", COCOA_IDENTIFIER_COL];
  
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

- (void) insertGUIElementsFromAppModule :(AppModule*) app {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  AppModuleTableModel *moduleTable = [[AppModuleTableModel alloc] init];
  NSString *externalModuleID = [[app moduleMetaData] valueForKey:kModuleID];
  
  for (NSDictionary *aGUIElement in [app moduleBody]) {
    NSMutableString *query = [NSMutableString string];
    [query appendFormat:@"INSERT OR REPLACE INTO %@ ", GUI_ELEMENTS_TABLE];
    [query appendFormat:@"VALUES ( "];
    [query appendFormat:@" NULL "];
    [query appendFormat:@" , '%@' ", [aGUIElement valueForKey:kAppsUIElementIdentifierColumn]];
    [query appendFormat:@" , '%@' ", [aGUIElement valueForKey:kAppsCocoaIdentifierColumn]];
    [query appendFormat:@" , '%@' ", [aGUIElement valueForKey:kAppsTitleColumn]];
    [query appendFormat:@" , '%@' ", [aGUIElement valueForKey:kAppsHelpColumn]];
    [query appendFormat:@" , '%@' ", [aGUIElement valueForKey:kAppsShortcutStringColumn]];
    [query appendFormat:@" , %li ",  [[[moduleTable getModuleEntityWithExternalID:externalModuleID] valueForKey:ID_COL] integerValue]];
    [query appendFormat:@" , '%li' ", [ShortcutTableModel getShortcutId:[aGUIElement valueForKey:kAppsShortcutStringColumn]]];
    [query appendFormat:@" ); "];
    
    [db executeQuery:query];
  }
}

- (void) removeGUIElementsWithID :(NSInteger) theID {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
    NSMutableString *query = [NSMutableString string];
    [query appendFormat:@"DELETE FROM %@ ", GUI_ELEMENTS_TABLE];
    [query appendFormat:@" WHERE "];
    [query appendFormat:@" %@ = %li ", MODULE_ID_COL, theID];
  
    [db executeQuery:query];
}
 
@end
