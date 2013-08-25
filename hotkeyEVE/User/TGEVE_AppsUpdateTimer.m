//
//  TGEVE_AppsUpdateTimer.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/25/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_AppsUpdateTimer.h"
#import "TGEVE_AppsUpdateTimerModel.h"
#import "TGEVE_InfoPopUpWindowController.h"

@implementation TGEVE_AppsUpdateTimer

@synthesize repeatingTimer = _repeatingTimer;
@synthesize windowController = _windowController;

+ (id<TGEVE_ITimer>) timerWithIntervall :(NSInteger) interval {
  TGEVE_AppsUpdateTimer *updateTimer = [[self alloc] init];
  
  updateTimer.repeatingTimer = [updateTimer createTheTimer:interval];
  [updateTimer.repeatingTimer fire];
  
  return updateTimer;
}

- (NSTimer*)createTheTimer:(NSInteger)interval {
  [self.repeatingTimer invalidate];
  return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(performTimerAction) userInfo:nil repeats:YES];
}

//TODO untested
- (void) performTimerAction {
  _windowController = [[TGEVE_InfoPopUpWindowController alloc] initWithWindowNibName:TGEVE_CONST_INFO_POP_UP_WINDOW_NAME];
  [_windowController showWindow:nil];
}

@end
