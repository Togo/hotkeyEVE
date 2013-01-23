//
//  AppsManagerTests.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/21/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsManagerTests.h"
#import "AppsManagerAmazon.h"
#import <OCMock/OCMock.h>
#import "ReceiveAppModuleMock.h"
#import "GUIElementsTableModel.h"
#import "AppModuleTableModel.h"

@implementation AppsManagerTests

- (void)setUp
{
  [super setUp];
  
  _appsManager = [[AppsManagerAmazon alloc] init];
  [_appsManager setReceiveAppModule:[[ReceiveAppModuleMock alloc] init]];
  
  id notificationsMock = [OCMockObject partialMockForObject:[_appsManager userNotifications]];
  [[notificationsMock stub] displayAppInstalledNotification:OCMOCK_ANY :OCMOCK_ANY];
}

- (void)tearDown
{
  
  [super tearDown];
}

//************************* init *************************//
- (void) test_init_selfCreated_objectToReceiveAppModuleNotNil {
  [_appsManager setReceiveAppModule:nil];
  _appsManager = [[AppsManagerAmazon alloc] init];
  STAssertNotNil([_appsManager receiveAppModule], @"");
}

- (void) test_init_selfCreated_guiElementsTableModelNotNil {
  STAssertNotNil([_appsManager guiElementTable], @"");
}

- (void) test_init_selfCreated_appModuleTableNotNil {
  STAssertNotNil([_appsManager appModuleTable], @"");
}

- (void) test_init_selfCreated_userNotificationNotNil {
  STAssertNotNil([_appsManager userNotifications], @"");
}


//************************* addAppsFromArray *************************//
- (void) test_addAppsFromArray_arrayContainsAModuleID_callMethodAddModuleWithThisModuleID {
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  NSString *moduleID = @"1";
  [[appsManagerMock expect] performSelectorInBackground:@selector(addAppWithModuleID:) withObject:moduleID];
  
  [_appsManager addAppsFromArray:[NSArray arrayWithObject:moduleID]];
  
  [appsManagerMock verify];
}

- (void) test_addAppsFromArray_arrayContainsMultipleModuleIDs_addThreeAppsWithTheModuleIDS {
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  [[appsManagerMock expect] performSelectorInBackground:@selector(addAppWithModuleID:) withObject:@"1"];
  [[appsManagerMock expect] performSelectorInBackground:@selector(addAppWithModuleID:) withObject:@"2"];
  [[appsManagerMock expect] performSelectorInBackground:@selector(addAppWithModuleID:) withObject:@"3"];
  
  [_appsManager addAppsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
  
  [appsManagerMock verify];
}

//************************* addAppWithModuleID *************************//
- (void) test_addAppWithModuleID_moduleIDNotNil_getAppModuleWithReceiver {
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock stub] insertGUIElementsFromAppModule :OCMOCK_ANY];
  
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[moduleTableMock stub] addAppModule :OCMOCK_ANY];
  
  id receiveAppModuleMock = [OCMockObject partialMockForObject:[_appsManager receiveAppModule]];
  [[receiveAppModuleMock expect] getAppWithModuleID:@"1"];
  
  [_appsManager addAppWithModuleID:@"1"];
  
  [receiveAppModuleMock verify];
}

- (void) test_addAppWithModuleID_noExceptionFromGetAppModule_addModuleToModuleTable {
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock stub] insertGUIElementsFromAppModule:OCMOCK_ANY];
  
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[moduleTableMock expect] addAppModule :OCMOCK_ANY];
  
  
  [_appsManager addAppWithModuleID:@"1"];
  
  [moduleTableMock verify];
}

- (void) test_addAppWithModuleID_noExceptionFromGetAppModule_addAppModuleDataToGUIElementTable {
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[moduleTableMock stub] addAppModule :OCMOCK_ANY];
  
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock expect] insertGUIElementsFromAppModule :OCMOCK_ANY];
  
  
  [_appsManager addAppWithModuleID:@"1"];
  
  [guiElementTableMock verify];
}

- (void) test_addAppWithModuleID_installationProcessSuccesfull_displayUserNotification {
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[moduleTableMock stub] addAppModule :OCMOCK_ANY];
  
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock stub] insertGUIElementsFromAppModule :OCMOCK_ANY];
  
  id notificationsMock = [OCMockObject mockForProtocol:@protocol(IUserNotifications)];
  [[notificationsMock expect] displayAppInstalledNotification:OCMOCK_ANY :OCMOCK_ANY];
  
  [_appsManager setUserNotifications:notificationsMock];
  [_appsManager addAppWithModuleID:@"1"];
  
  [notificationsMock verify];
}

@end
