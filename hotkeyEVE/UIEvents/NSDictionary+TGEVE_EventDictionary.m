//
//  NSDictionary+TGEVE_EventDictionary.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "NSDictionary+TGEVE_EventDictionary.h"

NSString * const TGEVE_KEY_SHORTCUT_STRING = @"ShortcutString";
NSString * const TGEVE_KEY_HELP_STRING = @"HelpString";
NSString * const TGEVE_KEY_TITLE_STRING = @"TitleString";
NSString * const TGEVE_KEY_BUNDLE_IDENTIFIER_STRING = @"BundleIdentifierString";
NSString * const TGEVE_KEY_PARENT_TITLE_STRING = @"Parent Title";

@implementation NSDictionary (TGEVE_EventDictionary)

+ (NSDictionary*) dictionaryWithUIElement :(UIElement*) element {
  return [self createDictionary :[element shortcutString]
                                :[element help]
                                :[element title]
                                :[[element owner] bundleIdentifier]
                                :@""
          ];
}

+ (NSDictionary*) dictionaryWithMenuBarTableRow :(NSDictionary*) aRow {
  return [self createDictionary:[aRow valueForKey:SHORTCUT_STRING_COL]
                               :[aRow valueForKey:HELP_COL]
                               :[aRow valueForKey:TITLE_COL]
                               :[aRow valueForKey:BUNDLE_IDEN_COL]
                               :[aRow valueForKey:PARENT_TITLE_COL]
          ];
}

+ (NSDictionary*) dictionaryWithGUIElementsTableRow :(NSDictionary*) aRow {
  return [self createDictionary:[aRow valueForKey:SHORTCUT_STRING_COL]
                               :[aRow valueForKey:HELP_COL]
                               :[aRow valueForKey:TITLE_COL]
                               :[aRow valueForKey:BUNDLE_IDEN_COL]
                               :@""
          ];
}


+ (NSDictionary*) createDictionary :(NSString*) shortcutString :(NSString*) helpString :(NSString*) titleString :(NSString*) bundleIdentifierString :(NSString*) parentTitle {
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  [dic setValue:shortcutString forKey:TGEVE_KEY_SHORTCUT_STRING];
  [dic setValue:helpString forKey:TGEVE_KEY_HELP_STRING];
  [dic setValue:titleString forKey:TGEVE_KEY_TITLE_STRING];
  [dic setValue:bundleIdentifierString forKey:TGEVE_KEY_BUNDLE_IDENTIFIER_STRING];
  [dic setValue:parentTitle forKey:TGEVE_KEY_PARENT_TITLE_STRING];
  
  return dic;
}

@end
