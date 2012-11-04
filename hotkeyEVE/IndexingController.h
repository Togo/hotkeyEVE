//
//  IndexingController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuBarIndexingThread.h"
#import <UIElements/Application.h>

@interface IndexingController : NSObject

@property (strong, nonatomic) MenuBarIndexingThread *indexingThread;

- (void) startIndexing;
- (void) restartIndexing;
- (void) stopIndexing;

- (void) indexingAllApps;
- (void) indexingApp :(Application*) app;

@end
