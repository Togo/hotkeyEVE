//
//  AppsNavigationViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsTableNavigationViewController.h"
#import "AppsInstalledViewController.h"
#import "AppsNotInstalledViewController.h"

NSString * const kAppsTableNavigationViewControllerNibName = @"AppsTableNavigationViewController";

@interface AppsTableNavigationViewController ()

@end

@implementation AppsTableNavigationViewController

@synthesize delegate = _delegate;

@synthesize navigationTableView = _navigationTableView;
@synthesize navigationTableColumn = _navigationTableColumn;

@synthesize dataSource = _dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      NSDictionary *installedRow = [NSDictionary dictionaryWithObjectsAndKeys:@"Installed", @"NavigationColumn", [AppsInstalledViewController class],@"Class" ,kAppsInstalledViewControllerNibName, @"NibName", nil];
      NSDictionary *notInstalledRow = [NSDictionary dictionaryWithObjectsAndKeys:@"Not Installed", @"NavigationColumn", [AppsNotInstalledViewController class],@"Class" ,kAppsNotInstalledViewControllerNibName, @"NibName", nil];

      _dataSource = [NSArray arrayWithObjects:installedRow,notInstalledRow,nil];
      
    }

  return self;
}

- (void) loadView {
  [super loadView];

}

-(void)awakeFromNib {
  [_navigationTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
  [_navigationTableColumn setEditable:NO];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [_dataSource count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [[_dataSource objectAtIndex:row] valueForKey:[tableColumn identifier]];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  NSInteger selectedRow = [[notification object] selectedRow];

  if (selectedRow != -1) {
    NSDictionary *theRow = [_dataSource objectAtIndex:selectedRow];
    [_delegate viewSelectionDidChanged:[theRow valueForKey:@"Class"] :[theRow valueForKey:@"NibName"]];
  }
}

@end
