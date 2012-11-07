//
//  MenuBarTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuBarTableModel : NSObject

+ (void) insertMenuBarElementArray :(NSArray*) elements;

+ (NSString*) selectShortcutString :(UIElement*) element;
+ (NSArray*) searchInMenuBarTable :(UIElement*) element;

+ (NSInteger) countShortcuts :(Application*) app;
@end
