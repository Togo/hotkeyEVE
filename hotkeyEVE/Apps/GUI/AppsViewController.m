//
//  AppsViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsViewController.h"
#import "AppsInstalledViewController.h"
#import "AppsTableNavigationViewController.h"

@implementation AppsViewController

@synthesize navigationView = _navigationView;
@synthesize mainContentView = _mainContentView;
@synthesize mainContentViewController = _mainContentViewController;

-(void)awakeFromNib {
  [self viewSelectionDidChanged:kAppsInstalledViewControllerNibName];
  [self initNavigationView:kAppsTableNavigationViewControllerNibName];
}

- (void) initNavigationView :(NSString*) viewNibName {
  _navigationViewController = [[NSViewController alloc] initWithNibName:viewNibName bundle:nil];
  
  [_navigationView addSubview:[_navigationViewController view]];
  [[_navigationViewController view] setBounds:[_navigationView bounds]];
  [[_navigationViewController view] setAutoresizingMask:NSViewHeightSizable];
}

-(void) viewSelectionDidChanged:(NSString*)viewNibName {
  [[_mainContentViewController view] removeFromSuperview];
  
  _mainContentViewController = [[NSViewController alloc] initWithNibName:viewNibName bundle:nil];
  
  [_mainContentView addSubview:[_mainContentViewController view]];
  [[_mainContentViewController view] setBounds:[_mainContentView bounds]];
  [[_mainContentViewController view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
}

@end
