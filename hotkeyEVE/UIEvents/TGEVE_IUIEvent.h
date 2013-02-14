//
//  TGEVE_IEvent.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 2/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIElements/UIElement.h>
#import "IUserNotifications.h"

@protocol TGEVE_IUIEvent <NSObject>

@property (strong) id<IUserNotifications> userNotifications;

- (NSArray*) searchForShortcuts :(UIElement*) element;
- (BOOL) displayNotification :(NSArray*) shortcutList;

@end
