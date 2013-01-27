//
//  GrowlNotificationTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/23/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "GrowlNotificationTests.h"
#import "GrowlNotifications.h"
#import <OCMock/OCMock.h>

@implementation GrowlNotificationTests

- (void)setUp {
  [super setUp];
   _growlNotifications = [GrowlNotifications growlNotifications];
}

- (void)tearDown {
 
  [super tearDown];
}

//************************* growlNotifications *************************//
- (void) test_growlNotifications_allScenarios_createAndReturnGrowlNotificationObject {
  id returnValue =  [GrowlNotifications growlNotifications];
  STAssertTrue([returnValue  isKindOfClass:[GrowlNotifications class]], @"");
}

//************************* displayAddApp *************************//
- (void) test_displayAddApp_allScenarios_callMethodToDisplayMessageWithGrowl {
  id growlNotificationMock = [OCMockObject partialMockForObject:_growlNotifications];
  [[growlNotificationMock expect] showTheNotification:@"App Name installed" :@"GUI support for App Name was sucessfully installed!" :nil];
 
  [_growlNotifications displayAppInstalledNotification:@"App Name"];
  
  [growlNotificationMock verify];
}

//************************* displayAppRemoved *************************//
- (void) test_displayAppRemoved_allScenarios_callMethodToDisplayMessageWithGrowl {
  id growlNotificationMock = [OCMockObject partialMockForObject:_growlNotifications];
  [[growlNotificationMock expect] showTheNotification:@"App Name removed" :@"GUI support for App Name was removed" :nil];
  
  [_growlNotifications displayAppRemovedNotification:@"App Name"];
  
  [growlNotificationMock verify];
}

@end
