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
#import "GUINotifications.h"
#import "EVEManager.h"

@implementation AppsManagerTests

- (void)setUp
{
  [super setUp];
  
  _appsManager = [[AppsManagerAmazon alloc] init];
  [_appsManager setReceiveAppModule:[[ReceiveAppModuleMock alloc] init]];
  
  id notificationsMock = [OCMockObject partialMockForObject:[_appsManager userNotifications]];
  [[notificationsMock stub] displayAppInstalledNotification:OCMOCK_ANY];
  [[notificationsMock stub] displayAppRemovedNotification:OCMOCK_ANY];
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
  
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  BOOL grantInstall = YES;
  [[[appsManagerMock stub] andReturnValue:OCMOCK_VALUE(grantInstall)] grantInstall];
  
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
  
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  BOOL grantInstall = YES;
  [[[appsManagerMock stub] andReturnValue:OCMOCK_VALUE(grantInstall)] grantInstall];
  
  
  [_appsManager addAppWithModuleID:@"1"];
  
  [moduleTableMock verify];
}

- (void) test_addAppWithModuleID_noExceptionFromGetAppModule_addAppModuleDataToGUIElementTable {
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[moduleTableMock stub] addAppModule :OCMOCK_ANY];
  
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock expect] insertGUIElementsFromAppModule :OCMOCK_ANY];
  
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  BOOL grantInstall = YES;
  [[[appsManagerMock stub] andReturnValue:OCMOCK_VALUE(grantInstall)] grantInstall];
  
  [_appsManager addAppWithModuleID:@"1"];
  
  [guiElementTableMock verify];
}

- (void) test_addAppWithModuleID_installationProcessSuccesfull_displayUserNotification {
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[moduleTableMock stub] addAppModule :OCMOCK_ANY];
  
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock stub] insertGUIElementsFromAppModule :OCMOCK_ANY];
  
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  BOOL grantInstall = YES;
  [[[appsManagerMock stub] andReturnValue:OCMOCK_VALUE(grantInstall)] grantInstall];

  
  id notificationsMock = [OCMockObject mockForProtocol:@protocol(IUserNotifications)];
  [[notificationsMock expect] displayAppInstalledNotification:OCMOCK_ANY];
  
  [_appsManager setUserNotifications:notificationsMock];
  [_appsManager addAppWithModuleID:@"1"];
  
  [notificationsMock verify];
}

- (void) test_addAppWithModuleID_installationProcessSuccesfull_sendNotificationToReloadTable {
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[moduleTableMock stub] addAppModule :OCMOCK_ANY];
  
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock stub] insertGUIElementsFromAppModule :OCMOCK_ANY];
  
  id notificationsMock = [OCMockObject mockForProtocol:@protocol(IUserNotifications)];
  [[notificationsMock stub] displayAppInstalledNotification:OCMOCK_ANY];
  
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  [[appsManagerMock expect] postTableRefreshNotification];
  BOOL grantInstall = YES;
  [[[appsManagerMock stub] andReturnValue:OCMOCK_VALUE(grantInstall)] grantInstall];
  
  [_appsManager setUserNotifications:notificationsMock];
  [_appsManager addAppWithModuleID:@"1"];
  
  [appsManagerMock verify];
}

- (void) test_addAppWithModuleID_noLicenceAndLimitInstalled_displayUserNotification {
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  BOOL grantInstall = NO;
  [[[appsManagerMock stub] andReturnValue:OCMOCK_VALUE(grantInstall)] grantInstall];
  
  id notificationsMock = [OCMockObject mockForProtocol:@protocol(IUserNotifications)];
  [[notificationsMock expect] displayRegisterEVEWithCallbackNotification :@"Register EVE, to install more Apps!" :@"You've reached the maximum number of installed Apps"];
  
  [_appsManager setUserNotifications:notificationsMock];
  [_appsManager addAppWithModuleID:@"1"];
  
  [notificationsMock verify];
}

//************************* removeAppsFromArray *************************//
- (void) test_removeAppsFromArray_arrayContainsAModuleID_callMethodRemoveModuleWithThisModuleID {
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  NSString *moduleID = @"1";
  [[appsManagerMock expect] performSelectorInBackground:@selector(removeAppWithModuleID:) withObject:moduleID];
  
  [_appsManager removeAppsFromArray:[NSArray arrayWithObject:moduleID]];
  
  [appsManagerMock verify];
}

- (void) test_removeAppsFromArray_arrayContainsMultipleModuleIDs_removeThreeAppsWithTheModuleIDS {
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  [[appsManagerMock expect] performSelectorInBackground:@selector(removeAppWithModuleID:) withObject:@"1"];
  [[appsManagerMock expect] performSelectorInBackground:@selector(removeAppWithModuleID:) withObject:@"2"];
  [[appsManagerMock expect] performSelectorInBackground:@selector(removeAppWithModuleID:) withObject:@"3"];
  
  [_appsManager removeAppsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
  
  [appsManagerMock verify];
}

//************************* removeAppWithModuleID *************************//
- (void) test_removeAppWithModuleID_moduleIDNotNil_removeAllEntriesInGUIElementTable {
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock expect] removeGUIElementsWithID :1];
  
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[[moduleTableMock stub] andReturn:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"id", nil]] getModuleEntityWithExternalID :OCMOCK_ANY];
  [[moduleTableMock stub] removeAppModuleWithID :1];

  [_appsManager removeAppWithModuleID:@"5"];
  
  [guiElementTableMock verify];
}

- (void) test_removeAppWithModuleID_moduleIDNotNil_removeTheEntryFromTheModuleTable {
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock stub] removeGUIElementsWithID :1];
  
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[[moduleTableMock stub] andReturn:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"id", nil]] getModuleEntityWithExternalID :OCMOCK_ANY];
  [[moduleTableMock expect] removeAppModuleWithID :1];
  
  [_appsManager removeAppWithModuleID:@"5"];
  
  [moduleTableMock verify];
}

- (void) test_removeAppWithModuleID_moduleIDNotNil_sendUserNotification {
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock stub] removeGUIElementsWithID :1];
  
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[[moduleTableMock stub] andReturn:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"id", @"UserName", kUserNameKey, @"AppName", kAppNameKey,  nil]] getModuleEntityWithExternalID :OCMOCK_ANY];
  [[moduleTableMock stub] removeAppModuleWithID :1];
  
  id notificationsMock = [OCMockObject mockForProtocol:@protocol(IUserNotifications)];
  [[notificationsMock expect] displayAppRemovedNotification:@"AppName"];
  
  [_appsManager setUserNotifications:notificationsMock];
  [_appsManager removeAppWithModuleID:@"5"];
  
  [notificationsMock verify];
}

- (void) test_removeAppWithModuleID_appRemoved_sendNotificationToReloadTable {
  id guiElementTableMock = [OCMockObject partialMockForObject:[_appsManager guiElementTable]];
  [[guiElementTableMock stub] removeGUIElementsWithID :1];
  
  id moduleTableMock = [OCMockObject partialMockForObject:[_appsManager appModuleTable]];
  [[[moduleTableMock stub] andReturn:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"id", @"UserName", kUserNameKey, @"AppName", kAppNameKey,  nil]] getModuleEntityWithExternalID :OCMOCK_ANY];
  [[moduleTableMock stub] removeAppModuleWithID :1];
  
  id notificationsMock = [OCMockObject mockForProtocol:@protocol(IUserNotifications)];
  [[notificationsMock stub] displayAppRemovedNotification:@"AppName"];
  
  id appsManagerMock = [OCMockObject partialMockForObject:_appsManager];
  [[appsManagerMock expect] postTableRefreshNotification];
  
  [_appsManager setUserNotifications:notificationsMock];
  [_appsManager removeAppWithModuleID:@"1"];
  
  [appsManagerMock verify];
}

//************************* postTableRefreshNotification *************************//
- (void) test_postTableRefreshNotification_allScenarios_postNotificaion {
  id mock = [OCMockObject observerMock];

  [[NSNotificationCenter defaultCenter] addMockObserver:mock
                                                   name:kEVENotificationsReloadAppsTable
                                                 object:nil];
  
  [[mock expect] notificationWithName:kEVENotificationsReloadAppsTable object:[OCMArg any]];
  
  [_appsManager postTableRefreshNotification];
  
  [mock verify];
  [[NSNotificationCenter defaultCenter] removeObserver:mock];
}


@end
