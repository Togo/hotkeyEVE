//
//  AppsNavigationViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "AppsTableNavigationViewController.h"
#import "TGEVE_AppsTableViewController.h"
#import "TGEVE_AppsManagerAmazon.h"
#import "AppsManagerLocalDB.h"

NSString * const kAppsTableNavigationViewControllerNibName = @"AppsTableNavigationViewController";

NSString * const TGEVE_CONST_ALLAPPS_HEADER = @"All Apps";
NSString * const kInstalledRowHeader = @"Installed";
NSString * const kNotInstalledRowHeader = @"Not Installed";

NSString * const KNavigationColumn = @"NavigationColumn";

@interface AppsTableNavigationViewController ()

@end

@implementation AppsTableNavigationViewController

@synthesize delegate = _delegate;
@synthesize appsManager = _appsManager;

@synthesize navigationTableView = _navigationTableView;
@synthesize navigationTableColumn = _navigationTableColumn;

@synthesize dataSource = _dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//      NSDictionary *installedRow = [NSDictionary dictionaryWithObjectsAndKeys:kInstalledRowHeader, KNavigationColumn, [AppsTableViewController class],@"Class" ,kAppsTableViewControllerNibName, @"NibName", [AppsManagerLocalDB class], @"model", nil];
//      NSDictionary *notInstalledRow = [NSDictionary dictionaryWithObjectsAndKeys:kNotInstalledRowHeader, KNavigationColumn, [AppsTableViewController class],@"Class" ,kAppsTableViewControllerNibName, @"NibName", [AppsManagerAmazon class], @"model", nil];
      
      NSDictionary *allAppsRow = [NSDictionary dictionaryWithObjectsAndKeys:TGEVE_CONST_ALLAPPS_HEADER, KNavigationColumn, [TGEVE_AppsTableViewController class],@"Class" ,kAppsTableViewControllerNibName, @"NibName", [TGEVE_AppsManagerAmazon class], @"model", nil];

      _dataSource = [NSArray arrayWithObjects:allAppsRow,nil];
      
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
  
//  [_navigationTableView registerForDraggedTypes:[NSArray arrayWithObjects: NSPasteboardTypeString , nil]];
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

//- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
//  // Add code here to validate the drop
//  if (row <= [_navigationTableView numberOfRows] -1
//      && op == NSTableViewDropOn) {
//    return NSDragOperationEvery;
//  }
//  return NSDragOperationNone;
//}
//
//- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op {
//  
//  NSPasteboard *pboard = [info draggingPasteboard];
//  NSString *moduleIDsString = [pboard stringForType:NSPasteboardTypeString];
//  NSArray *moduleIDArray = [moduleIDsString componentsSeparatedByString:@"\n"];
//  
//  if ([[_dataSource objectAtIndex:row] valueForKey:KNavigationColumn] == kInstalledRowHeader) {
//      [_appsManager addAppsFromArray:moduleIDArray];
//  } else if ([[_dataSource objectAtIndex:row] valueForKey:KNavigationColumn] == kNotInstalledRowHeader) {
//      [_appsManager removeAppsFromArray:moduleIDArray];
//  }
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kEVENotificationsRemoveDropedLinesFromTable object:nil];
//    
//	return YES;
//}
//
//// to stub method in unit tests
//- (NSPasteboard*) getDragPasteboard :(id <NSDraggingInfo>)info {
//  return  [info draggingPasteboard];
//}


@end
