//
//  GUIElementsTable.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/7/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "TGEVE_GUIElementsTableModel.h"
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"
#import "AppModuleTableModel.h"
#import "EVEUtilities.h"

@implementation TGEVE_GUIElementsTableModel

- (NSArray*) searchInGUIElementTable :(UIElement*) element {
  DDLogInfo(@"GUIElementsTable -> searchInGUIElementTable(element => :%@: :: get called", element);
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSInteger appID = [ApplicationsTableModel getApplicationID:[[element owner] appName] :[[element owner] bundleIdentifier]];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT g.*, a.* FROM %@ g, app_module m, %@ a", GUI_ELEMENTS_TABLE, APPLICATIONS_TABLE];
  [query appendFormat:@" WHERE ( g.%@ like '%@' ", IDENTIFIER_COL, [element uiElementIdentifier]];
  [query appendFormat:@" OR ( g.%@ like '%@' ", COCOA_IDENTIFIER_COL, [element cocoaIdentifierString]];
  [query appendFormat:@" AND   g.%@ != '' ) )", COCOA_IDENTIFIER_COL];
  [query appendFormat:@" AND ( m.%@ = g.%@  ", ID_COL, MODULE_ID_COL];
  [query appendFormat:@" AND   m.%@ = '%@'  ", TGUTIL_TCOLID_LANGUAGE, [EVEUtilities currentLanguage]];
  [query appendFormat:@" AND   a.%@ = m.%@ ) ", ID_COL, APPLICATION_ID_COL];
  [query appendFormat:@" AND   a.%@ = %li  ", ID_COL, appID];
  [query appendFormat:@" GROUP BY   g.%@  ", ID_COL];

  DDLogInfo(@"GUIElementsTable -> searchInGUIElementTable :: query => :%@:", query);
  
  NSArray *result = [db executeQuery:query];
 return result;
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
