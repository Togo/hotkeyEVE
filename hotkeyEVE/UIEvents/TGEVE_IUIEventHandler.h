//
//  TGEVEIUIEvent.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIElements/UIElement.h>
#import "TGEVE_IUIEvent.h"

@protocol TGEVE_IUIEventHandler <NSObject>

@property (strong) id<TGEVE_IUIEvent> event;

- (void) handleEVEEvent :(UIElement*) element;
- (id<TGEVE_IUIEvent>) createEvent :(UIElement*) element;

@end
