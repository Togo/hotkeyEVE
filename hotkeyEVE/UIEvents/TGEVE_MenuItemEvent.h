//
//  TGEVEMenuItemEvent.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGEVE_IUIEvent.h"


@class TGEVE_MenuBarTableModel;

@interface TGEVE_MenuItemEvent : NSObject <TGEVE_IUIEvent>

@property (strong) TGEVE_MenuBarTableModel *menuBarTable;

@end
