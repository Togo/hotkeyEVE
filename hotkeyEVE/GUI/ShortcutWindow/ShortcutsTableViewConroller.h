//
//  ShortcutsTableViewConroller.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortcutsTableViewConroller : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
@private
  IBOutlet NSTableView *shortcutTable;
  NSArray *shortcutList;
}

@end
