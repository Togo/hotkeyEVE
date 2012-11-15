//
//  ShortcutsWindowController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ShortcutsWindowController.h"

@interface ShortcutsWindowController ()

@end

@implementation ShortcutsWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(applicationIndexingStarted:)
                                                   name:ApplicationIndexingStarted object:nil];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(applicationIndexingFinshed:)
                                                   name:ApplicationIndexingFinished object:nil];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    DDLogInfo(@"ShortcutsWindowController : windowDidLoad => shortcut browser window did load");
}

- (void) dealloc {
 [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) applicationIndexingStarted :(id) aNotification {
  Application *startedApp = [aNotification object];
  NSString *title = [NSString stringWithFormat:@"EVE is busy with indexing %@ !", [startedApp appName]];
  [[self window] setTitle:title];
}

- (void) applicationIndexingFinshed :(id) aNotification {
  [[self window] setTitle:@"Shortcut Browser"];
}

@end
