//
//  MenuBarTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGEVE_MenuBarTableModel : NSObject

- (void) insertMenuBarElementArray :(NSArray*) elements;
- (void) insertMenuBarElement :(UIElement*) element;

- (NSArray*) searchInMenuBarTable :(UIElement*) element;

+ (NSInteger) countShortcuts :(Application*) app;
+ (NSArray*) getTitlesAndShortcuts :(NSInteger) appID;

@end
