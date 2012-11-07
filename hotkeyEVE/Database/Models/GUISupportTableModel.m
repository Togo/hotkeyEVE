//
//  GUISupportTableModel.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "GUISupportTableModel.h"
#import "EVEUtilities.h"

@implementation GUISupportTableModel

+ (NSInteger) hasGUISupport :(NSString*) bundleIdentifier {
  EVEDatabase *db = [[DatabaseManager sharedDatabaseManager] eveDatabase];
  
  NSMutableString *query = [NSMutableString string];
  [query appendFormat:@" SELECT * FROM %@ ", GUI_SUPPORT_TABLE];
  [query appendFormat:@" WHERE %@ like '%@' ", BUNDLE_IDEN_COL, bundleIdentifier];
  [query appendFormat:@" AND %@ like '%@' ", LANG_COL, [EVEUtilities currentLanguage]];
  
  NSArray *result = [db executeQuery:query];
  
  if ([result count] > 0)
   return 1;
  else
    return 0;
}

@end
