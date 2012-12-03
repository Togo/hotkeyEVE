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
#import "ShortcutTableModel.h"
#import "ApplicationsTableModel.h"
#import "GUIElementsTable.h"
#import "DisabledShortcutsModel.h"

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
      self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(runIndexing) userInfo:nil repeats:YES];
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

- (void) runIndexing {
  if(!_indexingActive && [self count] > 0) {
    
    Application *app = [self dequeue];
    DDLogInfo(@"MenuBarIndexingThread -> runIndexing() :: start Indexing :%@: ", [app appName]);
    
    _indexingActive = YES;
  
    [self postIndexingAppStarted :app];
    
    [self indexUIElements :app];
    
    [DisabledShortcutsModel disableShortcutsInNewApp :app];
    
    DDLogInfo(@"Finished Menu Bar Indexing of: %@", [app appName]);
    
    [self postIndexingFinished];
    
    _indexingActive = NO;
    if ([self count] == 0) {
      [self postNewAppIndexedApplicationTable];
      [GUIElementsTable updateGUIElementTable];
    }
  }
}

- (void) indexUIElements :(Application*) app {
  AXUIElementRef appRef = AXUIElementCreateApplication( [[app runningApplication] processIdentifier] );
  MenuBarIndexing *indexMenuBar = [[MenuBarIndexing alloc] init];
  NSArray *elements = [indexMenuBar indexMenuBar:appRef];
  
  [ShortcutTableModel insertShortcutsFromElementArray: elements];
  
  [MenuBarTableModel insertMenuBarElementArray:elements];
}

- (void) postIndexingAppStarted :(Application*) app {
  [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationIndexingStarted object:app];
}

- (void) postIndexingFinished {
  [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationIndexingFinished object:nil];
}

- (void) postNewAppIndexedApplicationTable {
    DDLogInfo(@"MenuBarIndexingThread -> postNewAppIndexedApplicationTable() :: get called ");
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshShortcutBrowserApplicationTable  object:nil];
//  [[NSNotificationCenter defaultCenter] postNotificationName:NewAppIndexedApplicationTable object:app];
}

@end
