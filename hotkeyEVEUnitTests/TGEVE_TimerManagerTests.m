//
//  TGEEVE_TimerManagerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/25/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_TimerManagerTests.h"
#import "TGEVE_TimerManager.h"
#import "TGEVE_AppsUpdateTimer.h"
#import "TGEVE_ITimer.h"

@implementation TGEVE_TimerManagerTests

- (void)setUp
{
  [super setUp];
  
}

- (void)tearDown
{
  [super tearDown];
}

//*************************** sharedTimerManager ***************************//
- (void) test_sharedTimerManager_allScenarios_returnTimerManagerObject {
  STAssertTrue([[TGEVE_TimerManager sharedTimerManager] isKindOfClass:[TGEVE_TimerManager class]], @"");
}

- (void) test_createTimer_gotATGEVE_ITimerClass_createATimerWithThisClass {
  TGEVE_TimerManager *tManager = [TGEVE_TimerManager sharedTimerManager];
  id<TGEVE_ITimer> timer = [tManager createTimer:[TGEVE_AppsUpdateTimer class] andInterval:10];
  STAssertTrue([timer isMemberOfClass:[TGEVE_AppsUpdateTimer class]],@"");
}


@end
