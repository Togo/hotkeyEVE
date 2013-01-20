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
#import "AppsManager.h"

NSString * const kAppsTableNavigationViewControllerNibName = @"AppsTableNavigationViewController";

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
      NSDictionary *installedRow = [NSDictionary dictionaryWithObjectsAndKeys:kInstalledRowHeader, KNavigationColumn, [AppsInstalledViewController class],@"Class" ,kAppsInstalledViewControllerNibName, @"NibName", nil];
      NSDictionary *notInstalledRow = [NSDictionary dictionaryWithObjectsAndKeys:kNotInstalledRowHeader, KNavigationColumn, [AppsNotInstalledViewController class],@"Class" ,kAppsNotInstalledViewControllerNibName, @"NibName", nil];

      _dataSource = [NSArray arrayWithObjects:installedRow,notInstalledRow,nil];
      
      _appsManager = [[AppsManager alloc] init];
    }

  return self;
}

- (void) loadView {
  [super loadView];

}

-(void)awakeFromNib {
  [_navigationTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
  [_navigationTableColumn setEditable:NO];
  
  [_navigationTableView registerForDraggedTypes:[NSArray arrayWithObjects: NSPasteboardTypeString , nil]];
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

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
  // Add code here to validate the drop
  if (row <= [_navigationTableView numberOfRows] -1
      && op == NSTableViewDropOn) {
    return NSDragOperationEvery;
  }
  return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op {
  
  NSPasteboard *pboard = [info draggingPasteboard];
  NSString *moduleID = [pboard stringForType:NSPasteboardTypeString];
  NSArray *moduleIDArray = [moduleID componentsSeparatedByString:@"\n"];
  
  if ([[_dataSource objectAtIndex:row] valueForKey:KNavigationColumn] == kInstalledRowHeader) {
      [_appsManager addAppsFromArray:moduleIDArray];
  } else if ([[_dataSource objectAtIndex:row] valueForKey:KNavigationColumn] == kNotInstalledRowHeader) {
      [_appsManager removeAppsFromArray:moduleIDArray];
  }
  
	return YES;
}

// to stub method in unit tests
- (NSPasteboard*) getDragPasteboard :(id <NSDraggingInfo>)info {
  return  [info draggingPasteboard];
}


@end
