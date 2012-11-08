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
#import "LicenceWindowController.h"


@implementation MainMenuController

@synthesize activeApplication;
@synthesize statusItem;
@synthesize guiSupportIcon;
@synthesize noGUISupportIcon;

@synthesize ourViewController;

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
  
  if(!liceneWindowController) {
    liceneWindowController = [[LicenceWindowController alloc] initWithWindowNibName:@"LicenceWindow"];
  }
  
  [GUIUtilities closeOpenWindow:ourViewController];
  
  ourViewController = liceneWindowController;
  [GUIUtilities showWindow:ourViewController];
}

- (IBAction) getProVeriosn :(id)sender {
  NSURL *url = [NSURL URLWithString:  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"Shop URL"]];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

@end
