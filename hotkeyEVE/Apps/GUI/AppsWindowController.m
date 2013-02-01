//
//  AppsWindowController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsWindowController.h"

NSString const * kAppsWindowNibName = @"AppsWindowController";

@interface AppsWindowController ()

@end

@implementation AppsWindowController

@synthesize dragAndDropOverlay = _dragAndDropOverlay;

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
  
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"1_3_5_firstLaunch"]) {
    [self showDragAndDropOverlay];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"1_3_5_firstLaunch"];
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(removeDragAndDropOverlay)
                                   userInfo:nil
                                    repeats:NO];
  }

}

- (void) windowDidBecomeKey:(NSNotification *)notification {
   [[NSNotificationCenter defaultCenter] postNotificationName:kEVENotificationsReloadAppsTable object:nil];
}

- (void) showDragAndDropOverlay {
  [[[self window] contentView] addSubview:_dragAndDropOverlay];
  
}

- (void) removeDragAndDropOverlay {
  [_dragAndDropOverlay removeFromSuperview];
}

@end
