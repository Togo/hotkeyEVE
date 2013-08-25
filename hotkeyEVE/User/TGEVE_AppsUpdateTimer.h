//
//  TGEVE_AppsUpdateTimer.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/25/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGEVE_ITimer.h"

@interface TGEVE_AppsUpdateTimer : NSObject <TGEVE_ITimer>

@property (strong) NSWindowController *windowController;
// TODO only for unit test
- (NSTimer*)createTheTimer:(NSInteger)interval;

@end
