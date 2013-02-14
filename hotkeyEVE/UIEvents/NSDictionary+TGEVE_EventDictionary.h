//
//  NSDictionary+TGEVE_EventDictionary.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIElements/UIElement.h>

extern NSString * const TGEVE_KEY_SHORTCUT_STRING;
extern NSString * const TGEVE_KEY_HELP_STRING;
extern NSString * const TGEVE_KEY_TITLE_STRING;
extern NSString * const TGEVE_KEY_BUNDLE_IDENTIFIER_STRING;
extern NSString * const TGEVE_KEY_PARENT_TITLE_STRING;

@interface NSDictionary (TGEVE_EventDictionary)

+ (NSDictionary*) dictionaryWithUIElement :(UIElement*) element;
+ (NSDictionary*) dictionaryWithMenuBarTableRow :(NSDictionary*) aRow;

@end
