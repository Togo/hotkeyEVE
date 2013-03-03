//
//  NSAlert+BlocksTests.m
//  Objc-Util
//
//  Created by Tobias Sommer on 2/24/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "NSAlert_BlocksTests.h"
#import "Objc_Util.h"
#import <OCMock/OCMock.h>

NSAlert *_alert;

@implementation NSAlert_BlocksTests

- (void)setUp
{
  [super setUp];
  _alert = [NSAlert alert];
  id alertMock = [OCMockObject partialMockForObject:_alert];
  [[alertMock stub] displayAlert :OCMOCK_ANY];
  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

//************************* alert FactoryMethod ***************************//
- (void) test_alert_factoryMethod_newAlertObject {
  STAssertNotNil([NSAlert alert], @"");
}

//************************* showModalAlertSheetForWindow ***************************//
- (void) test_showModalAlertSheetForWindow_noButtonNames_throwException {
  STAssertThrows(([_alert showModalAlertSheetForWindow:nil message:nil informativeText:nil alertStyle:0 buttonBlocks:nil buttonTitle:nil]), @"");
}

- (void) test_showModalAlertSheetForWindow_withOneButtonTitle_alertContainsButtonOne {
  [_alert showModalAlertSheetForWindow:nil message:nil informativeText:nil alertStyle:0 buttonBlocks:nil buttonTitle:@"Button1", nil];
  NSArray *alertButtons = [_alert buttons];
  STAssertTrue([[[alertButtons objectAtIndex:0] title] isEqualToString:@"Button1"], @"");
}

- (void) test_showModalAlertSheetForWindow_withTwoButtonTitles_alertContainsButtonTwo {
  [_alert showModalAlertSheetForWindow:nil message:nil informativeText:nil alertStyle:0 buttonBlocks:nil buttonTitle:@"Button1",@"Button2", nil];
  NSArray *alertButtons = [_alert buttons];
  STAssertTrue([[[alertButtons objectAtIndex:1] title] isEqualToString:@"Button2"], @"");
}

- (void) test_showModalAlertSheetForWindow_withMultipleButtonTitles_alertContainsAllButtons {
  [_alert showModalAlertSheetForWindow:nil message:nil informativeText:nil alertStyle:0 buttonBlocks:nil buttonTitle:@"Button1",@"Button2",@"Button3",@"Button4",@"Button5",@"Button6",nil];
  NSArray *alertButtons = [_alert buttons];
  STAssertTrue([alertButtons count] == 6, @"");
}

- (void) test_showModalAlertSheetForWindow_alertMessageTextIsNil_alertContainsEmptyMessageText {
  [_alert showModalAlertSheetForWindow:nil message:nil informativeText:nil alertStyle:0 buttonBlocks:nil buttonTitle:@"", nil];
  NSString *result = [_alert messageText];
  STAssertTrue([result isEqualToString:@""], @"");
}

- (void) test_showModalAlertSheetForWindow_alertWithMessageText_alertContainsMessageText {
  NSString *messageText = @"Message Text";
  [_alert showModalAlertSheetForWindow:nil message:messageText informativeText:nil alertStyle:0 buttonBlocks:nil buttonTitle:@"", nil];
  NSString *result = [_alert messageText];
  STAssertTrue([result isEqualToString:messageText], @"");
}

- (void) test_showModalAlertSheetForWindow_alertInformativeTextIsNil_alertContainsEmptyInformativeText {
  [_alert showModalAlertSheetForWindow:nil message:nil informativeText:nil alertStyle:0 buttonBlocks:nil buttonTitle:@"", nil];
  NSString *result = [_alert informativeText];
  STAssertTrue([result isEqualToString:@""], @"");
}

- (void) test_showModalAlertSheetForWindow_alertWithInformativeText_alertContainsInformativeText {
  NSString *informativeText = @"Informative Text";
  [_alert showModalAlertSheetForWindow:nil message:nil informativeText:informativeText alertStyle:0 buttonBlocks:nil buttonTitle:@"", nil];
  NSString *result = [_alert informativeText];
  STAssertTrue([result isEqualToString:informativeText], @"");
}

- (void) test_showModalAlertSheetForWindow_alertAlertStyle_alertWithThisAlertStyle {
  [_alert showModalAlertSheetForWindow:nil message:nil informativeText:nil alertStyle:NSInformationalAlertStyle buttonBlocks:nil buttonTitle:@"", nil];
  NSInteger result = [_alert alertStyle];
  STAssertTrue(result == NSInformationalAlertStyle, @"");
}

- (void) test_showModalAlertSheetForWindow_showAlert_displayAlertMessage {
  id alertMock = [OCMockObject partialMockForObject:[NSAlert alert]];
  NSWindow *window = [[NSWindow alloc] init];
  [[alertMock expect] displayAlert :window];
  
  [alertMock showModalAlertSheetForWindow:window message:@"Message" informativeText:@"Informative Text" alertStyle:NSWarningAlertStyle buttonBlocks:nil buttonTitle:@"button1", nil];
  
  [alertMock verify];
}

@end
