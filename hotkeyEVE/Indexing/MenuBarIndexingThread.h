//
//  MenuBarIndexingThread.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

//#import <Database/Database.h>
#import "Queue.h"

@interface MenuBarIndexingThread : Queue {
  @private
    NSThread *myWorkerThread;
  }

@property (unsafe_unretained) BOOL indexingActive;
@property (strong, nonatomic) NSTimer *timer;

- (void) startIndexing;
- (void) stopIndexing;
- (void) restartIndexing;


@end
