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

- (void)awakeFromNib {
  // set the view for the first start
  [self viewSelectionDidChanged:[AppsInstalledViewController class]  :kAppsInstalledViewControllerNibName];
  [self initNavigationView:[AppsTableNavigationViewController class] :kAppsTableNavigationViewControllerNibName];
}

- (void) initNavigationView :(id)viewControllerClass :(NSString*) viewNibName {
    _navigationViewController = [[viewControllerClass alloc] initWithNibName:viewNibName bundle:nil];
  
  [[_navigationViewController view] setFrame:[_navigationView bounds]];
  [[_navigationViewController view] setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
  
  [_navigationViewController setDelegate:self];
  
  [_navigationView addSubview:[_navigationViewController view]];
  [_splitView adjustSubviews];
}

- (void)viewSelectionDidChanged:(id)viewControllerClass :(NSString*) viewNibName {
  [[_mainContentViewController view] removeFromSuperview];
  
  _mainContentViewController = [[viewControllerClass alloc] initWithNibName:viewNibName bundle:nil];
  
  [_mainContentView addSubview:[_mainContentViewController view]];
  [[_mainContentViewController view] setFrame:[_mainContentView bounds]];
  [[_mainContentViewController view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
  [_splitView adjustSubviews];
}

@end
