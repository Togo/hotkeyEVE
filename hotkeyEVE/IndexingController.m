//
//  IndexingController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "IndexingController.h"

@implementation IndexingController

@synthesize indexingThread;

- (id) init {
  if (self = [super init]) {
    indexingThread = [[MenuBarIndexingThread alloc] init];
  }
  return self;
}

- (void) startIndexing {
  [indexingThread startIndexing];
}

- (void) restartIndexing {
  [indexingThread restartIndexing];
}

- (void) stopIndexing {
  [indexingThread stopIndexing];
}

- (void) indexingApp :(Application*) app {
  [indexingThread enqueueUnique:app];
}

@end
