//
//  EVEMessages.m
//  EVE
//
//  Created by Tobias Sommer on 10/8/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "EVEMessages.h"
#import <Growl/Growl.h>

@implementation EVEMessages

+ (void) maxEnabledAppsReachedInWindow :(NSWindow*) window {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"Buy EVE"];
  [alert addButtonWithTitle:@"Cancel"];
  [alert setMessageText:@"You are running the Lite Version."];
  [alert setInformativeText:@"Buy the Full Version to enable more Apps"];
  [alert setAlertStyle:0];
  
  NSInteger answer = [alert runModal];
  
  if (answer == 1000) {
    NSURL *url = [[NSURL alloc] initWithString:@"http://store.kagi.com/cgi-bin/store.cgi?storeID=6FJKK_LIVE"];
    [[NSWorkspace sharedWorkspace] openURL:url];

  }
}

+ (void) registrationFailedInWindow :(NSString*) errorMessage :(NSWindow*) window {
  NSAlert *alert = [NSAlert alertWithMessageText:@"Something went wrong!"
                                   defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:errorMessage];
  [alert beginSheetModalForWindow:window modalDelegate:self didEndSelector:nil contextInfo:NULL];
}

//+ (void) registrationSuccededInWindow :(NSWindow*) window :(EnterLicenceKeyWindowController*) delegate {
//  NSAlert *alert = [NSAlert alertWithMessageText:@"You registration was successfull. \nEVE needs now a restart!"
//                                   defaultButton:@"Restart EVE" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
//  [alert beginSheetModalForWindow:window modalDelegate:delegate didEndSelector:@selector(restartAfterRegistering) contextInfo:NULL];
//}

+ (void) shortcutDisabledGrowl :(NSString*) shortcutString {
  [GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:@"I disabled: %@", shortcutString] description:@"Go to Preferences to undo this!" notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:nil];
}

+ (void) displayShortcutMessage :(UIElement*) element {
  NSMutableString *description = [[NSMutableString alloc] init];
  if ([[element help] length] > 0) {
    [description appendFormat:@"%@ \n", [element help]];
    
  } else {
    [description appendFormat:@"%@ \n", [element title]];
  }
  
  [description appendFormat:@"(click to disable)"];
  
  [GrowlApplicationBridge notifyWithTitle:[element shortcutString] description:description notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:nil];
}

@end