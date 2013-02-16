//
//  AppsWindowController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern  NSString const * kAppsWindowNibName;

@interface AppsWindowController : NSWindowController <NSWindowDelegate>

@property IBOutlet NSImageView *dragAndDropOverlay;

@end
