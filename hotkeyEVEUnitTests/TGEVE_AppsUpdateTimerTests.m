//
//  TGEVE_AppsUpdateTimerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/25/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_AppsUpdateTimerTests.h"
#import "TGEVE_AppsUpdateTimer.h"
#import "TGEVE_AppsUpdateTimerModel.h"

@implementation TGEVE_AppsUpdateTimerTests

- (void)setUp
{
  [super setUp];
}

- (void)tearDown
{
  [super tearDown];
}

//*************************** timerWithInterval ***************************//
- (void) test_timerWithIntervall_allScenarios_createPropertyWithThisInterval {
  TGEVE_AppsUpdateTimer *timer = [TGEVE_AppsUpdateTimer timerWithIntervall:172800];
  NSInteger returnedInterval =  [[timer repeatingTimer] timeInterval];
  STAssertTrue(returnedInterval == 172800, @"");
}

//*************************** createTimer ***************************//
- (void) test_createTheTimer_allScenarios_cancelPreexistingTimer {
  TGEVE_AppsUpdateTimer *updateTimer = [[TGEVE_AppsUpdateTimer alloc] init];
  OCMockObject *timerMock = [OCMockObject niceMockForClass:[NSTimer class]];
  [[timerMock expect] invalidate];
  
  [updateTimer setRepeatingTimer:(NSTimer*)timerMock];
  
  [updateTimer createTheTimer:200];
  
  [timerMock verify];
}

- (void) test_createTheTimer_allScenarios_setTimerToRepeat {
  TGEVE_AppsUpdateTimer *updateTimer = [[TGEVE_AppsUpdateTimer alloc] init];
  
  OCMockObject *timerMock = [OCMockObject niceMockForClass:[NSTimer class]];
  [[timerMock expect] scheduledTimerWithTimeInterval:200 target:updateTimer selector:@selector(performTimerAction) userInfo:nil repeats:YES];
  [updateTimer createTheTimer:200];
  
  [timerMock verify];
}

//*************************** performTimerAction ***************************//
- (void) test_performTimerAction_allScenarios_createWindowControllerAndShowWindow {
  TGEVE_AppsUpdateTimer *updateTimer = [[TGEVE_AppsUpdateTimer alloc] init];
  [updateTimer performTimerAction];
  
  STAssertNotNil([updateTimer windowController], @"");
}


@end
