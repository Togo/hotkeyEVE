//
//  TGEVE_ITimer.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/25/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TGEVE_ITimer <NSObject>

// The repeating timer is a weak property.
@property (strong) NSTimer *repeatingTimer;

+ (id<TGEVE_ITimer>) timerWithIntervall :(NSInteger) interval;
- (void) performTimerAction;

@end
