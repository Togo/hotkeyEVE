//
//  AppsNavigationViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "TGEVE_AppsNavigationViewController.h"
#import "TGEVE_AllAppsViewController.h"
#import "TGEVE_AppsManagerAmazon.h"
#import "AppsManagerLocalDB.h"
#import "TGEVE_UpdatableAppsViewController.h"

NSString * const TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME = @"AppsTableNavigationViewController";
NSString * const TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME = @"TGEVE_AllAppsViewController";
NSString * const TGEVE_CONST_APPS_UPDATABLE_NIB_NAME = @"TGEVE_UpdatableAppsViewController";

NSString * const TGEVE_CONST_ALLAPPS_HEADER = @"All Apps";
NSString * const TGEVE_CONST_UPDATABLEAPPS_HEADER = @"Updatable Apps";

NSString * const KNavigationColumn = @"NavigationColumn";

@interface TGEVE_AppsNavigationViewController ()

@end

@implementation TGEVE_AppsNavigationViewController

@synthesize delegate = _delegate;
@synthesize appsManager = _appsManager;

@synthesize navigationTableView = _navigationTableView;
@synthesize navigationTableColumn = _navigationTableColumn;

@synthesize dataSource = _dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      NSDictionary *allAppsRow = [NSDictionary dictionaryWithObjectsAndKeys:TGEVE_CONST_ALLAPPS_HEADER, KNavigationColumn, [TGEVE_AllAppsViewController class],@"Class" ,TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME, @"NibName", [TGEVE_AppsManagerAmazon class], @"model", nil];

      NSDictionary *updatableAppsRow = [NSDictionary dictionaryWithObjectsAndKeys:TGEVE_CONST_UPDATABLEAPPS_HEADER, KNavigationColumn, [TGEVE_UpdatableAppsViewController class],@"Class" ,TGEVE_CONST_APPS_UPDATABLE_NIB_NAME, @"NibName", [TGEVE_AppsManagerAmazon class], @"model", nil];

      

      _dataSource = ((NSArray<NSTableViewDataSource>*)[NSArray arrayWithObjects:allAppsRow, updatableAppsRow,nil]);
      
      _appsManager = [[TGEVE_AppsManagerAmazon alloc] init];
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
    [_delegate viewSelectionDidChanged:[theRow valueForKey:@"Class"] :[theRow valueForKey:@"NibName"] :[theRow valueForKey:@"model"]];
  }
}

@end
