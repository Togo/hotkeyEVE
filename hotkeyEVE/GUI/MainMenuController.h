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
    IBOutlet NSMenuItem *activeApp;
    IBOutlet NSMenuItem *pauseMenuItem;;
  __unsafe_unretained NSMenuItem *_startAtLoginItem;
  __unsafe_unretained NSMenuItem *_proVersionSeparator;
}

@property (strong)             NSStatusItem *statusItem;
@property (strong, nonatomic)  Application *activeApplication;
@property (strong, nonatomic)  NSImage *guiSupportIcon;
@property (strong, nonatomic)  NSImage *noGUISupportIcon;


@property (unsafe_unretained) IBOutlet NSMenuItem *startAtLoginItem;

@property (strong, nonatomic)             NSWindowController *ourViewController;
@property (strong, nonatomic, readonly)   NSWindowController *appsWindowController;
@property (strong, nonatomic, readonly)   ShortcutsWindowController *shortcutsWindowController;

- (void) updateStatusIcon :(BOOL) guiSupport;

- (IBAction) showShortcutsWindow :(id) sender;
- (IBAction) showAppsWindow :(id) sender;
- (IBAction) getProVersion :(id)sender;
@end
