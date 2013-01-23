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
   _growlNotifications = [GrowlNotifications growNotifications];
}

- (void)tearDown {
 
  [super tearDown];
}

//************************* growlNotifications *************************//
- (void) test_growlNotifications_allScenarios_createAndReturnGrowlNotificationObject {
  id returnValue =  [GrowlNotifications growNotifications];
  STAssertTrue([returnValue  isKindOfClass:[GrowlNotifications class]], @"");
}

//************************* displayAddApp *************************//
- (void) test_displayAddApp_appModuleNotNil_callMethodToDisplayMessageWithGrowl {
  id growlNotificationMock = [OCMockObject partialMockForObject:_growlNotifications];
  [[growlNotificationMock expect] display:@"Finder Install Succeeded" :@"I add the GUIElements from \"the User\" to HotkeyEVE!" :nil];
  
  [_growlNotifications displayAppInstalledNotification:@"Finder" :@"the User"];
  
  [growlNotificationMock verify];
}

@end
