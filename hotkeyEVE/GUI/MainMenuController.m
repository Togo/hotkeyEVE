//
//  MainMenuController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "MainMenuController.h"

#import "EVEUtilities.h"
#import "GUIUtilities.h"

#import "TGEVE_MenuBarTableModel.h"
#import "UserDataTableModel.h"

#import "ShortcutsWindowController.h"
#import "TGEVE_AppsWindowWindowController.h"

@implementation MainMenuController

@synthesize activeApplication;
@synthesize statusItem;
@synthesize guiSupportIcon;
@synthesize noGUISupportIcon;


- (void)awakeFromNib {
  NSString *osxMode = [[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"];
  
    if (osxMode == nil) {
        self.guiSupportIcon = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_ACTIVE.icns"];
    } else {        
        self.guiSupportIcon = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_ACTIVE_DARK_THEME.tiff"];
    }
  [guiSupportIcon setSize:NSMakeSize(14, 14)];
  
  self.noGUISupportIcon = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_NOT_SUPPORTED.icns"];
  [noGUISupportIcon setSize:NSMakeSize(14, 14)];
  
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setHighlightMode:YES];
  [statusItem setMenu:statusMenu];
  [statusItem setImage:guiSupportIcon];
  
  [_startAtLoginItem setState:[UserDataTableModel selectStartAtLogin :NSUserName()]];
  
  [[EVEManager sharedEVEManager] setMainMenuController:self];
}

-(void) menuWillOpen :(NSMenu*) menu {
  activeApplication = [EVEUtilities activeApplication];
  
  NSInteger count = [TGEVE_MenuBarTableModel countShortcuts:activeApplication];
  NSString *title = [NSString stringWithFormat:@"%@ (%li)", [activeApplication appName], count];
  [activeApp setTitle:title];
}

- (IBAction) pauseEve:(id)sender {
  EVEManager *manager = [EVEManager sharedEVEManager];
  if ([sender state] == NSOffState) {
    [sender setState:NSOnState];
    [[manager eveObserver] unSubscribeAllNotifications];
    [[manager indexing] stopIndexing];
  } else {
    [sender setState:NSOffState];
    [[manager eveObserver] subscribeAllNotifications];
    [[manager indexing] restartIndexing];
  }
}

- (void) updateStatusIcon :(BOOL) guiSupport {
  if (guiSupport && ([statusItem image] != guiSupportIcon)) {
    [statusItem setImage:guiSupportIcon];
  } else if (!guiSupport && ([statusItem image] != noGUISupportIcon)) {
    [statusItem setImage:noGUISupportIcon];
  }
}

- (IBAction) showShortcutsWindow :(id) sender {
  
  if(!_shortcutsWindowController) {
    _shortcutsWindowController = [[ShortcutsWindowController alloc] initWithWindowNibName:@"ShortcutsWindow"];
  }
  
  self.ourViewController = _shortcutsWindowController;
  [GUIUtilities showWindow:_ourViewController];
  [[NSNotificationCenter defaultCenter] postNotificationName:RefreshShortcutBrowserApplicationTable object:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:SelectActiveApplication object:[EVEUtilities activeApplication]];
}

- (IBAction) showAppsWindow :(id) sender {
  if(!_appsWindowController) {
    _appsWindowController = [[TGEVE_AppsWindowWindowController alloc] initWithWindowNibName:
                             [NSString stringWithFormat:@"%@",kAppsWindowNibName]];
  }
  
  self.ourViewController = _appsWindowController;
  [GUIUtilities showWindow:_ourViewController];
}

- (IBAction) getProVersion :(id) sender {
  [EVEUtilities openWebShop];
}

- (IBAction)startAtLogin :(id) sender {
  if ([sender state] == NSOffState) {
    [sender setState:NSOnState];
    [EVEUtilities addAppToLoginItems];
  } else {
    [sender setState:NSOffState];
    [EVEUtilities removeAppFromLoginItems];
  }
  
  [UserDataTableModel setStartAtLogin :[sender state]];
}

- (IBAction)sendFeedback :(id) sender {
  NSString* subject = [NSString stringWithFormat:@"Found a bug, or have suggestions?"];
  NSString* body = [NSString stringWithFormat:@"You can contact me in English or German!\n\n Thanks in Advance \nTobias Sommer"];
  NSString* to = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"eMail"];
  
  NSString *encodedSubject = [NSString stringWithFormat:@"SUBJECT=%@", [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSString *encodedBody = [NSString stringWithFormat:@"BODY=%@", [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSString *encodedTo = [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *encodedURLString = [NSString stringWithFormat:@"mailto:%@?%@&%@", encodedTo, encodedSubject, encodedBody];
  NSURL *mailtoURL = [NSURL URLWithString:encodedURLString];
  
  [[NSWorkspace sharedWorkspace] openURL:mailtoURL];
}

@end
