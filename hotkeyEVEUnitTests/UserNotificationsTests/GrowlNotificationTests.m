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
  [[growlNotificationMock expect] showTheNotification:@"App Name Install Succeeded" :@"I added the GUIElements from \"User Name\" to HotkeyEVE!" :nil];
 
  [_growlNotifications displayAppInstalledNotification:@"App Name" :@"User Name"];
  
  [growlNotificationMock verify];
}

//************************* displayAppRemoved *************************//
- (void) test_displayAppRemoved_allScenarios_callMethodToDisplayMessageWithGrowl {
  id growlNotificationMock = [OCMockObject partialMockForObject:_growlNotifications];
  [[growlNotificationMock expect] showTheNotification:@"App Name Removed" :@"The GUIElements from \"User Name\" are not longer available!" :nil];
  
  [_growlNotifications displayAppRemovedNotification:@"App Name" :@"User Name"];
  
  [growlNotificationMock verify];
}

@end
