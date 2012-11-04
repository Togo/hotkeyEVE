//
//  MenuBarIndexing.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "MenuBarIndexingThread.h"
#import <UIElements/Application.h>
#import <UIElements/MenuBarIndexing.h>
#import "MenuBarTableModel.h"

@implementation MenuBarIndexingThread

@synthesize indexingActive = _indexingActive;
@synthesize timer;

- (id)init {
	if( self = [super init] ) {
    myWorkerThread = [[NSThread alloc]initWithTarget:self selector:@selector(startIndexing) object:nil];
    [myWorkerThread start];
	}
	return self;
}

- (void) startIndexing {
  @autoreleasepool {
    if (self.timer == nil) {
      self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(runIndexingShortcuts) userInfo:nil repeats:YES];
      [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
      [[NSRunLoop currentRunLoop] run];
    }
  }
}

- (void) stopIndexing {
  [self.timer setFireDate:[NSDate dateWithString:@"9999-03-24 10:45:32 +0600"]];
}

- (void) restartIndexing {
  [self.timer setFireDate:[NSDate dateWithString:@"1000-03-24 10:45:32 +0600"]];
  [self.timer fire];
}

- (void) runIndexingShortcuts {
  
  if(!_indexingActive && [self count] > 0) {
    _indexingActive = YES;
    NSString *bundleIdentifier = [self dequeue];
    
    Application *app = [[Application alloc] initWithBundleIdentifier:bundleIdentifier];
    
    AXUIElementRef appRef = AXUIElementCreateApplication( [[app runningApplication] processIdentifier] );
    MenuBarIndexing *indexMenuBar = [[MenuBarIndexing alloc] init];
    NSArray *elements = [indexMenuBar indexMenuBar:appRef];
    
    [MenuBarTableModel insertShortcutsFromElementArray: elements];
    
    [MenuBarTableModel insertMenuBarElementArray:elements];
    
    DDLogInfo(@"Finsihed Menu Bar Indexing of: %@", bundleIdentifier);
    
    _indexingActive = NO;
  }
}

@end
