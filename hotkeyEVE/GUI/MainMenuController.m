//
//  MainMenuController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "MainMenuController.h"

@implementation MainMenuController

-(void)awakeFromNib {
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:statusMenu];
  [statusItem setHighlightMode:YES];
  NSImage *image = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_ACTIVE.icns"];
  [image setSize:NSMakeSize(14, 14)];
  [statusItem setImage:image];
}

@end
