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

#import "MenuBarTableModel.h"
#import "UserDataTableModel.h"

#import "LicenceWindowController.h"
#import "ShortcutsWindowController.h"

@implementation MainMenuController

@synthesize activeApplication;
@synthesize statusItem;
@synthesize guiSupportIcon;
@synthesize noGUISupportIcon;


-(void)awakeFromNib {
  self.guiSupportIcon = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_ACTIVE.icns"];
  [guiSupportIcon setSize:NSMakeSize(14, 14)];
  
  self.noGUISupportIcon = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_NOT_SUPPORTED.icns"];
  [noGUISupportIcon setSize:NSMakeSize(14, 14)];
  
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setHighlightMode:YES];
  [statusItem setMenu:statusMenu];
  [statusItem setImage:guiSupportIcon];
  [statusItem setImage:guiSupportIcon];
  
  [_startAtLoginItem setState:[UserDataTableModel selectStartAtLogin :NSUserName()]];
//  [self startAtLogin:_startAtLoginItem];
  
  // remove licence key and get pro version if full version
  if ([[[EVEManager sharedEVEManager] licence] isValid]) {
    [statusMenu removeItem:enterLicenceItem];
    [statusMenu removeItem:getProVersionItem];
  }
  
  [[EVEManager sharedEVEManager] setMainMenuController:self];
}

-(void) menuWillOpen :(NSMenu*) menu {
  activeApplication = [EVEUtilities activeApplication];
  
  NSInteger count = [MenuBarTableModel countShortcuts:activeApplication];
  NSString *title = [NSString stringWithFormat:@"Scan %@ (%li)", [activeApplication appName], count];
  [scanForShortcutsItem setTitle:title];
}

- (IBAction) scanForShortcuts :(id) sender {
  [[[EVEManager sharedEVEManager] indexing] indexingApp:activeApplication];
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
  if (guiSupport && ([statusItem image] != guiSupportIcon) ) {
    [statusItem setImage:guiSupportIcon];
  } else if (([statusItem image] != noGUISupportIcon)) {
    [statusItem setImage:noGUISupportIcon];
  }
}

- (IBAction) showLicenceKeyWindow :(id) sender {
  
  if(!_liceneWindowController) {
    _liceneWindowController = [[LicenceWindowController alloc] initWithWindowNibName:@"LicenceWindow"];
  }
  
  [GUIUtilities closeOpenWindow:_ourViewController];
  
  self.ourViewController = _liceneWindowController;
  [GUIUtilities showWindow:_ourViewController];
}

- (IBAction) showShortcutsWindow :(id) sender {
  
  if(!_liceneWindowController) {
    _shortcutsWindowController = [[ShortcutsWindowController alloc] initWithWindowNibName:@"ShortcutsWindow"];
  }
  
  if (self.ourViewController.class == _liceneWindowController.class ) {
      [GUIUtilities closeOpenWindow:_ourViewController];
  }
  
  self.ourViewController = _shortcutsWindowController;
  [GUIUtilities showWindow:_ourViewController];
}

- (IBAction) getProVersion :(id)sender {
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
}

@end
