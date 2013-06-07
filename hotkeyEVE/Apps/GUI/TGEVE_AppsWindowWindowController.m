//
//  AppsWindowController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_AppsWindowWindowController.h"
#import "TGEVE_AppsManager.h"

NSString const * kAppsWindowNibName = @"TGEVE_AppsWindowWindowController";

@interface TGEVE_AppsWindowWindowController ()

@end

@implementation TGEVE_AppsWindowWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  [[self window] setTitle:@"Apps"];
}

- (void) windowDidBecomeKey:(NSNotification *)notification {
   [[NSNotificationCenter defaultCenter] postNotificationName:kEVENotificationsReloadAppsTable object:nil];
}
@end
