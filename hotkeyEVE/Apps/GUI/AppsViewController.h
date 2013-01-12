//
//  AppsViewController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsNavigationDelegate.h"

@interface AppsViewController : NSObject <AppsNavigationDelegate>

@property (weak) IBOutlet NSView *navigationView;
@property (weak) IBOutlet NSView *mainContentView;
@property (strong) NSViewController *mainContentViewController;
@property (strong) NSViewController *navigationViewController;

- (void) initNavigationView :(NSString*) viewNibName;
@end
