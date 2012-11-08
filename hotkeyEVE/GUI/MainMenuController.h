//
//  MainMenuController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LicenceWindowController;

@interface MainMenuController : NSObject {
    LicenceWindowController *liceneWindowController;
  
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenuItem *scanForShortcutsItem;
    IBOutlet NSMenuItem *pauseMenuItem;
    IBOutlet NSMenuItem *enterLicenceItem;
    IBOutlet NSMenuItem *getProVersionItem;
}

@property (strong, nonatomic) Application *activeApplication;
@property (strong) NSStatusItem *statusItem;
@property (strong, nonatomic)  NSImage *guiSupportIcon;
@property (strong, nonatomic)  NSImage *noGUISupportIcon;

@property (strong) IBOutlet NSWindowController *ourViewController;

- (void) updateStatusIcon :(BOOL) guiSupport;

- (IBAction) showLicenceKeyWindow :(id) sender;

@end
