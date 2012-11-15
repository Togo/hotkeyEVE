//
//  ApplicationsTableViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ApplicationsTableViewController.h"
#import "ApplicationsTableModel.h"
#import "MenuBarTableModel.h"

@implementation ApplicationsTableViewController

- (id) init {
  self = [super init];
  
  if (self) {
    applications  = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshApplicationTable:)
                                                 name:RefreshShortcutBrowserApplicationTable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newAppIndexed:)
                                                 name:NewAppIndexedApplicationTable object:nil];
  }
  
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) awakeFromNib {
  [applications addObjectsFromArray:[ApplicationsTableModel selectAllApplications]];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
  return [applications count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  Application *app = [applications objectAtIndex:row];
  NSString *identifier = [tableColumn identifier];
  return [app valueForKey:identifier];
}

// This method is optional if you use bindings to provide the data
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  // In IB the tableColumn has the identifier set to the same string as the keys in our dictionary
    NSString *identifier = [tableColumn identifier];
    NSDictionary *aRow = [applications objectAtIndex:row];
  
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    // Then setup properties on the cellView based on the column
    cellView.textField.stringValue = [aRow valueForKey:APP_NAME_COL];
  
    NSArray *runningApplications = [NSRunningApplication runningApplicationsWithBundleIdentifier:[aRow valueForKey:BUNDLE_IDEN_COL]];
    if ([runningApplications count] > 0) {
      NSRunningApplication *runningApp = [runningApplications objectAtIndex:0];
      if (runningApp
          && [runningApp icon]) {
        cellView.imageView.objectValue = [runningApp icon];
      }
    }
  
  return cellView;
}

- (void) tableViewSelectionDidChange :(NSNotification *)aNotification {
    NSInteger selectedRow = [[aNotification object] selectedRow];
  if (selectedRow != -1) {
    NSDictionary *selectedApp = [applications objectAtIndex:selectedRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShortcutsWindowApplicationDidChanged object:[selectedApp valueForKey:ID_COL]];
  }
}

- (void) newAppIndexed :(id) aNotification {
  Application *newApp = [aNotification object];
  
  if (newApp
      && [MenuBarTableModel countShortcuts:newApp]
      && ![applications containsObject:newApp] ) {
    NSInteger index = [_applicationTable selectedRow];
    if (index == -1) {
      if (_applicationTable.numberOfRows == 0) {
        index = 0;
      } else {
        index = 1;
      }
    }
    
    NSString *appName = [newApp appName];
    NSString *bundleIdentifier = [newApp bundleIdentifier];
    NSNumber *appID = [NSNumber numberWithInteger:[ApplicationsTableModel getApplicationID:appName :bundleIdentifier]];
    // BUILD Dictionary
    
    if ([self isAppInApplicationsTable :[appID intValue]]) {
      // app selected? then refresh shortcut list
    } else {
      NSMutableDictionary *inseration = [NSMutableDictionary dictionary];
      [inseration setValue:appName forKey:APP_NAME_COL];
      [inseration setValue:bundleIdentifier forKey:BUNDLE_IDEN_COL];
      [inseration setValue:appID forKey:ID_COL];
      
      if (_applicationTable) {
        [applications insertObject:inseration atIndex:index];
        [_applicationTable beginUpdates];
        [_applicationTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
        [_applicationTable scrollRowToVisible:index];
        [_applicationTable endUpdates];
      }
    }
  }
}

- (void) refreshApplicationTable :(id) aNotification {
  DDLogInfo(@"ApplicationsTableViewController : refreshApplicationTable => refresh Application Table");
  
  [applications removeAllObjects];
  [applications addObjectsFromArray:[ApplicationsTableModel selectAllApplications]];
  
  if ([applications count] > 0)
    [_applicationTable selectRowIndexes:[[NSIndexSet alloc] initWithIndex:0] byExtendingSelection:NO];
  
  [_applicationTable reloadData];
}

- (BOOL) isAppInApplicationsTable :(NSInteger) appID {
  for (id aRow in applications) {
    if([[aRow valueForKey:ID_COL] intValue] == appID)
      return YES;
  }
  return NO;
}

@end
