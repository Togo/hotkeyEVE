//
//  GUIUtilities.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/8/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "GUIUtilities.h"

@implementation GUIUtilities

+ (void) showWindow :(NSWindowController*) windowController {
  [NSApp activateIgnoringOtherApps:YES];
  [windowController showWindow:windowController];
}


+ (void) closeOpenWindow :(NSWindowController*) windowController {
  if(windowController) {
    [[windowController window] close];
  }
}

@end
