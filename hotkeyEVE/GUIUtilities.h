//
//  GUIUtilities.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/8/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GUIUtilities : NSObject


+ (void) showWindow :(NSWindowController*) windowController;
+ (void) closeOpenWindow :(NSWindowController*) windowController;

@end
