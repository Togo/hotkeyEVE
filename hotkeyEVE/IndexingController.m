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
  DDLogInfo(@"IndexingController -> startIndexing :: start with indexing apps");
  [indexingThread startIndexing];
}

- (void) restartIndexing {
  DDLogInfo(@"IndexingController -> restartIndexing :: start with indexing apps");
  [indexingThread restartIndexing];
}

- (void) stopIndexing {
  DDLogInfo(@"IndexingController -> stopIndexing :: stop with indexing apps");
  [indexingThread stopIndexing];
}

- (void) indexingApp :(Application*) app {
  DDLogInfo(@"IndexingController -> indexingApp :: appName => :%@: bundleIdentifier :%@:", [app appName], [app bundleIdentifier]);
  [indexingThread enqueueUnique:app];
}

@end
