//
//  TGEVE_EventDictionaryTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_UIElementDictionaryTests.h"
#import "NSDictionary+TGEVE_EventDictionary.h"
#import <UIElements/UIElement.h>
#import <Database/TableAndColumnNames.h>
#import "UIElements/Application.h"

@implementation TGEVE_UIElementDictionaryTests

- (void)setUp
{
  [super setUp];
  
}

- (void)tearDown
{
  [super tearDown];
}

//*************** dictionaryWithUIElement ******************************//
- (void) test_dictionaryWithUIElement_elementContainsShortcutString_dictionaryWithShortcutString {
  UIElement *element = [[UIElement alloc] init];
  [element setShortcutString:@"Shortcut String"];
  NSDictionary *dic = [NSDictionary dictionaryWithUIElement:element];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_SHORTCUT_STRING] isEqualToString:@"Shortcut String"], @"");
}

- (void) test_dictionaryWithUIElement_elementContainsHelp_dictionaryWithHelp {
  UIElement *element = [[UIElement alloc] init];
  [element setHelp:@"Help"];
  NSDictionary *dic = [NSDictionary dictionaryWithUIElement:element];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_HELP_STRING] isEqualToString:@"Help"], @"");
}

- (void) test_dictionaryWithUIElement_elementContainsTitle_dictionaryWithTitle {
  UIElement *element = [[UIElement alloc] init];
  [element setTitle:@"Title"];
  NSDictionary *dic = [NSDictionary dictionaryWithUIElement:element];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_TITLE_STRING] isEqualToString:@"Title"], @"");
}

- (void) test_dictionaryWithUIElement_elementContainsBundleIdentifier_dictionaryWithBundleIdentifier {
  UIElement *element = [[UIElement alloc] init];
  Application *app = [[Application alloc] init];
  [app setBundleIdentifier:@"Bundle Identifier"];
  [element setOwner:app];
  NSDictionary *dic = [NSDictionary dictionaryWithUIElement:element];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_BUNDLE_IDENTIFIER_STRING] isEqualToString:@"Bundle Identifier"], @"");
}

//*************** dictionaryWithMenuBarTableRow ******************************//
- (void) test_dictionaryWithUIElement_theRowContainsShortcutString_dictionaryWithShortcutString {
  NSDictionary *aRow =  [NSDictionary dictionaryWithObject:@"Shortcut String" forKey:SHORTCUT_STRING_COL];

  NSDictionary *dic = [NSDictionary dictionaryWithMenuBarTableRow:aRow];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_SHORTCUT_STRING] isEqualToString:@"Shortcut String"], @"");
}

- (void) test_dictionaryWithUIElement_theRowContainsHelp_dictionaryWithHelp {
  NSDictionary *aRow =  [NSDictionary dictionaryWithObject:@"Help" forKey:HELP_COL];
  
  NSDictionary *dic = [NSDictionary dictionaryWithMenuBarTableRow:aRow];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_HELP_STRING] isEqualToString:@"Help"], @"");
}

- (void) test_dictionaryWithUIElement_theRowContainsTitle_dictionaryWithTitle {
  NSDictionary *aRow =  [NSDictionary dictionaryWithObject:@"Title" forKey:TITLE_COL];
  
  NSDictionary *dic = [NSDictionary dictionaryWithMenuBarTableRow:aRow];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_TITLE_STRING] isEqualToString:@"Title"], @"");
}

- (void) test_dictionaryWithUIElement_theRowContainsBundleIdentifier_dictionaryWithBundleIdentifier {
  NSDictionary *aRow =  [NSDictionary dictionaryWithObject:@"Bundle Identifier" forKey:BUNDLE_IDEN_COL];
  
  NSDictionary *dic = [NSDictionary dictionaryWithMenuBarTableRow:aRow];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_BUNDLE_IDENTIFIER_STRING] isEqualToString:@"Bundle Identifier"], @"");
}

- (void) test_dictionaryWithUIElement_theRowContainsParentTitle_dictionaryWithParentTitle {
  NSDictionary *aRow =  [NSDictionary dictionaryWithObject:@"Parent Title" forKey:PARENT_TITLE_COL];
  
  NSDictionary *dic = [NSDictionary dictionaryWithMenuBarTableRow:aRow];
  STAssertTrue([[dic valueForKey:TGEVE_KEY_PARENT_TITLE_STRING] isEqualToString:@"Parent Title"], @"");
}

@end
