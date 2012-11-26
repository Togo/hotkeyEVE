//
//  EVEMessages.h
//  EVE
//
//  Created by Tobias Sommer on 10/8/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVEMessages : NSObject

+ (void) maxEnabledAppsReachedInWindow :(NSWindow*) window;

+ (void) displayShortcutMessage :(UIElement*) element;
+ (void) displayMultipleMatchesMessage :(NSString*) description;

+ (void) showShortcutDisabledMessage :(NSDictionary*) clickContext;

+ (void) showGrowRegistrationMessage;
@end
