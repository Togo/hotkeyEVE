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
  NSMutableArray *shortcutList;
  NSArray *unfilteredShortcutList;
  NSArray *filteredShortcutList;
  __unsafe_unretained NSSearchField *_searchField;

  __unsafe_unretained NSMenu *_shortcutListMenu;
  __unsafe_unretained NSMenuItem *_disableEnableInOneAppItem;
}

@property (unsafe_unretained) IBOutlet NSSearchField *searchField;


@property (strong) NSString *activeAppName;

@property (unsafe_unretained) IBOutlet NSMenu *shortcutListMenu;

@property (unsafe_unretained) IBOutlet NSMenuItem *disableEnableInOneAppItem;
@end
