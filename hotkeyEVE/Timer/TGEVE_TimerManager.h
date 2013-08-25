//
//  TGEVE_TimerManager.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/25/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGEVE_ITimer.h"

@interface TGEVE_TimerManager : NSObject

+ (id)sharedTimerManager;
- (id<TGEVE_ITimer>) createTimer :(id) class andInterval :(NSInteger) interval;

@end
