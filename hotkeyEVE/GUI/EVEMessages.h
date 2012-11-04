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
+ (void) registrationFailedInWindow :(NSString*) errorMessage :(NSWindow*) window;
//+ (void) registrationSuccededInWindow :(NSWindow*) window :(EnterLicenceKeyWindowController*) delegate;
+ (void) shortcutDisabledGrowl :(NSString*) shortcutString;
+ (void) displayShortcutMessage :(UIElement*) element;
@end
