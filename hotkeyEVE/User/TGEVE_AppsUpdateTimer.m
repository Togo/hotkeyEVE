//
//  TGEVE_AppsUpdateTimer.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/25/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_AppsUpdateTimer.h"
#import "TGEVE_AppsUpdateTimerModel.h"

@implementation TGEVE_AppsUpdateTimer

@synthesize repeatingTimer = _repeatingTimer;

+ (id<TGEVE_ITimer>) timerWithIntervall :(NSInteger) interval {
  DDLogInfo(@"TGEVE_AppsUpdateTimer -> timerWithIntervall(interval => :%li:) :: get called ", interval);
  TGEVE_AppsUpdateTimer *updateTimer = [[self alloc] init];
  
  updateTimer.repeatingTimer = [updateTimer createTheTimer:interval];
    DDLogInfo(@"TGEVE_AppsUpdateTimer -> timerWithIntervall:: create UpdatedTimer :%@: ", updateTimer.repeatingTimer);
  [updateTimer.repeatingTimer fire];
  
  return updateTimer;
}

- (NSTimer*)createTheTimer:(NSInteger)interval {
  [self.repeatingTimer invalidate];
  return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(performTimerAction) userInfo:nil repeats:YES];
}

//TODO untested
- (void) performTimerAction {
  DDLogInfo(@"TGEVE_AppsUpdateTimer -> performTimerAction:: performed ");

}

@end
