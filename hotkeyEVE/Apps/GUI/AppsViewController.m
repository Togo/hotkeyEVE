//
//  AppsViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsViewController.h"
#import "AppsInstalledViewController.h"

@implementation AppsViewController

@synthesize navigationView = _navigationView;
@synthesize mainContentView = _mainContentView;
@synthesize mainContentViewController = _mainContentViewController;

-(void)awakeFromNib {
  [self viewSelectionDidChanged:kAppsInstalledViewControllerNibName];
}

-(void) viewSelectionDidChanged:(NSString*)viewNibName {
  [[_mainContentViewController view] removeFromSuperview];
  _mainContentViewController = [[NSViewController alloc] initWithNibName:viewNibName bundle:nil];
  
  [_mainContentView addSubview:[_mainContentViewController view]];
}

@end
