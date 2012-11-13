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
  __unsafe_unretained NSButtonCell *_remindCheckBox;
}

@property (unsafe_unretained) IBOutlet NSButtonCell *remindCheckBox;

@end
