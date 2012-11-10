//
//  MainMenuController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LicenceWindowController;
@class ShortcutsWindowController;

@interface MainMenuController : NSObject {
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenuItem *scanForShortcutsItem;
    IBOutlet NSMenuItem *pauseMenuItem;
    IBOutlet NSMenuItem *enterLicenceItem;
    IBOutlet NSMenuItem *getProVersionItem;
  
}

@property (strong)             NSStatusItem *statusItem;
@property (strong, nonatomic)  Application *activeApplication;
@property (strong, nonatomic)  NSImage *guiSupportIcon;
@property (strong, nonatomic)  NSImage *noGUISupportIcon;

@property (strong, nonatomic)              NSWindowController *ourViewController;
@property (strong, nonatomic, readonly) NSWindowController *liceneWindowController;
@property (strong, nonatomic, readonly) ShortcutsWindowController *shortcutsWindowController;

- (void) updateStatusIcon :(BOOL) guiSupport;

- (IBAction) showLicenceKeyWindow :(id) sender;
- (IBAction) getProVersion :(id)sender;

@end
