//
//  AppsNavigationViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsTableNavigationViewController.h"

NSString * const kAppsTableNavigationViewControllerNibName = @"AppsTableNavigationViewController";

@interface AppsTableNavigationViewController ()

@end

@implementation AppsTableNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    
    return self;
}

- (IBAction)selectionDidChange :(id)sender {
  [delegate viewSelectionDidChanged :sender];
}

@end
