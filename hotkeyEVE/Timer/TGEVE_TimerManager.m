//
//  TGEVE_TimerManager.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/25/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_TimerManager.h"
#import "TGEVE_AppsUpdateTimer.h"

@implementation TGEVE_TimerManager

- (id)init
{
  self = [super init];
  if (self) {
    [self createTimer:[TGEVE_AppsUpdateTimer class] andInterval:172800];
  }
  
  return self;
}

+ (id)sharedTimerManager {
  DDLogInfo(@"TGEVE_TimerManager -> sharedTimerManager() :: get called ");
  static TGEVE_TimerManager *timerManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    timerManager = [[self alloc] init];
  });
  return timerManager;
}


- (id<TGEVE_ITimer>) createTimer :(id) class andInterval :(NSInteger) interval {
 DDLogInfo(@"TGEVE_TimerManager -> createTimer(class :%@:, interval :%li:) :: get called ",class,interval);
 return [class timerWithIntervall:interval];
}

@end
