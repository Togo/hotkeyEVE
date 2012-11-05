//
//  MainMenuController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainMenuController : NSObject {
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenuItem *scanForShortcutsItem;
    IBOutlet NSMenuItem *pauseMenuItem;
}

@property (strong, nonatomic) Application *activeApplication;
@property (strong) NSStatusItem *statusItem;
@property (strong, nonatomic)  NSImage *guiSupportIcon;
@property (strong, nonatomic)  NSImage *noGUISupportIcon;

- (void) updateStatusIcon :(BOOL) guiSupport;

@end
