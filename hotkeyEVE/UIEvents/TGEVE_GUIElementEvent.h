//
//  TGEVE_GUIElementEvent.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGEVE_IUIEvent.h"

@class TGEVE_GUIElementsTableModel;

@interface TGEVE_GUIElementEvent : NSObject <TGEVE_IUIEvent>

@property (strong) TGEVE_GUIElementsTableModel *guiElementTable;

@end
