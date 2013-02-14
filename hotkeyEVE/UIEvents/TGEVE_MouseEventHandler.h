//
//  TGEVEMouseEvent.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGEVE_IUIEventHandler.h"

@interface TGEVE_MouseEventHandler : NSObject <TGEVE_IUIEventHandler>

- (BOOL) isShortcutDisabled :(NSArray*) eventShortcutHintList;
- (BOOL) isTimeIntevallOk :(NSArray*) eventShortcutHintList;
- (void) insertInDisplayedShortcutsDB :(NSArray*) eventShortcutHintList;

@end
