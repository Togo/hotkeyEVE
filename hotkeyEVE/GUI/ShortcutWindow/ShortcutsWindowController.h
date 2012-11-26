//
//  ShortcutsWindowController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ShortcutsTableViewConroller.h"

@interface ShortcutsWindowController : NSWindowController <NSWindowDelegate> {
  
  __unsafe_unretained NSSearchField *_searchField;


}

@property (unsafe_unretained) IBOutlet NSSearchField *searchField;

@end
