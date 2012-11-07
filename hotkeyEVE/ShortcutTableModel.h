//
//  ShortcutTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortcutTableModel : NSObject

+ (void) insertShortcutsFromElementArray :(NSArray*) elements;

+ (NSInteger) getShortcutId :(NSString*) shortcutString;
+ (NSString*) getShortcutString :(NSInteger) shortcutID;
@end
