//
//  AppsWindowController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsWindowController.h"
#import "AppsManager.h"

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
  
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"apps_window_firstLaunch"]) {
    [self showDragAndDropOverlay];
    
    AppsManager *manager =  [[AppsManager alloc] init];
    [manager addAppWithModuleID:@"d151508da8d36994e1635f7875594424e8b979c4fb70a23929fd1c75b12c6b03724902bc8474fe6c947a588a4bdd81bc"]; // en Finder
    [manager addAppWithModuleID:@"d151508da8d36994e1635f787559442457a85bc4cc02c74c14b671a196abebab450c6f4cb5c9cf64413fdaf7e28d76c0"]; // de Finder

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"apps_window_firstLaunch"];

    [NSTimer scheduledTimerWithTimeInterval:10.0
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
