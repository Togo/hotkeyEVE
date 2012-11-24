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
#import "EVEUtilities.h"

@implementation ApplicationsTableViewController


- (id) init {
  self = [super init];
  
  if (self) {
    applicationsList  = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshApplicationTable:)
                                                 name:RefreshShortcutBrowserApplicationTable object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(newAppIndexed:)
//                                                 name:NewAppIndexedApplicationTable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSearch:)
                                                 name:ShortcutTableSearchUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectCurrentRunningApplication:)
                                                 name:SelectCurrentRunningApplication object:nil];
  }
  
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) awakeFromNib {
  [applicationsList addObjectsFromArray:[ApplicationsTableModel selectAllApplications]];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
  return [applicationsList count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  Application *app = [applicationsList objectAtIndex:row];
  NSString *identifier = [tableColumn identifier];
  return [app valueForKey:identifier];
}

// This method is optional if you use bindings to provide the data
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  // In IB the tableColumn has the identifier set to the same string as the keys in our dictionary
    NSString *identifier = [tableColumn identifier];
    NSDictionary *aRow = [applicationsList objectAtIndex:row];
  
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
    } else {
      cellView.imageView.objectValue = [NSImage imageNamed:@"NSStatusNone"];
    }
  
  return cellView;
}

- (void) tableViewSelectionDidChange :(NSNotification *)aNotification {
  NSDictionary *selectedApp = [applicationsList objectAtIndex:[[aNotification object] selectedRow]];
  if (refreshShorcutTable
      || [[selectedApp valueForKey:ID_COL] intValue] != lastSelectedAppID) {
    lastSelectedAppID = [[selectedApp valueForKey:ID_COL] intValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShortcutsWindowApplicationDidChanged object:selectedApp];
  }

  refreshShorcutTable = YES;
}

//- (void) newAppIndexed :(id) aNotification {
//  DDLogInfo(@"ApplicationsTableViewController : newAppIndexed => add new app to applications list");
//  Application *newApp = [aNotification object];
//  
//  if (newApp
//      && [MenuBarTableModel countShortcuts:newApp]
//      && ![applicationsList containsObject:newApp] ) {
//    NSInteger index = [_applicationTable selectedRow];
//    if (index == -1) {
//      if (_applicationTable.numberOfRows == 0) {
//        index = 0;
//      } else {
//        index = 1;
//      }
//    }
//    
//    NSString *appName = [newApp appName];
//    NSString *bundleIdentifier = [newApp bundleIdentifier];
//    NSNumber *appID = [NSNumber numberWithInteger:[ApplicationsTableModel getApplicationID:appName :bundleIdentifier]];
//    // BUILD Dictionary
//    
//    if ([self isAppInApplicationsTable :[appID intValue]]) {
//      // app selected? then refresh shortcut list
//    } else {
//      NSMutableDictionary *inseration = [NSMutableDictionary dictionary];
//      [inseration setValue:appName forKey:APP_NAME_COL];
//      [inseration setValue:bundleIdentifier forKey:BUNDLE_IDEN_COL];
//      [inseration setValue:appID forKey:ID_COL];
//      
//      if (_applicationTable) {
//          [applicationsList insertObject:inseration atIndex:index];
//          [_applicationTable beginUpdates];
//          [_applicationTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
//          [_applicationTable scrollRowToVisible:index];
//          [_applicationTable endUpdates];
//      } else {
//        [self refreshApplicationTable:nil];
//      }
//    }
//  }
//}

- (void) updateSearch :(id) aNotification {
  NSString *searchString = [aNotification object];
  if ([searchString length] > 0) {
    refreshShorcutTable = NO;
    [self applicationTableWithFilteredApps :searchString];
    
    refreshShorcutTable = NO;
    [self selectLastSelectedRow];
  } else {
    refreshShorcutTable = NO;
    [self applicationTableWithAllApps];
    
    refreshShorcutTable = YES;
    [self selectLastSelectedRow];
  }
}

- (void) refreshApplicationTable :(id) aNotification {
  DDLogInfo(@"ApplicationsTableViewController : refreshApplicationTable => refresh Application Table");
  refreshShorcutTable = NO;
  [self applicationTableWithAllApps];
  
  refreshShorcutTable = YES;
  [self selectLastSelectedRow];
}

- (void) selectCurrentRunningApplication :(id) aNotification {
  DDLogInfo(@"ApplicationsTableViewController(aNotification => :%@:) : selectCurrentRunningApplication => refresh Application Table",[aNotification object]);
  
  lastSelectedAppID = [[aNotification object] appID];
  refreshShorcutTable = YES;
  [self selectLastSelectedRow];
}

- (void) applicationTableWithAllApps {
  [_applicationTable beginUpdates];
  [applicationsList removeAllObjects];
  unfilteredApplications = [ApplicationsTableModel selectAllApplications];
  [applicationsList addObjectsFromArray:unfilteredApplications];
  [_applicationTable reloadData];
  [_applicationTable endUpdates];
}

- (void) applicationTableWithFilteredApps :(NSString*) searchString {
  [_applicationTable beginUpdates];
  filteredApplications = [ApplicationsTableModel selectApplicationsFiltered:searchString];
  [applicationsList removeAllObjects];
  [applicationsList  addObjectsFromArray:filteredApplications];
  [_applicationTable reloadData];
  [_applicationTable endUpdates];
}

- (void) selectLastSelectedRow {
  NSInteger rowToSelect = [self findLastSelectedAppRow];
  [_applicationTable selectRowIndexes:[[NSIndexSet alloc] initWithIndex:rowToSelect] byExtendingSelection:NO];
  [_applicationTable scrollRowToVisible:rowToSelect];
}

- (NSInteger) findLastSelectedAppRow {
  NSInteger index = 0;
  for (NSDictionary *row in applicationsList) {
    if ([[row valueForKey:ID_COL] intValue] == lastSelectedAppID ) {
      return index;
    }
    
  index++;
  }
  
  return 0;
}

- (BOOL) isAppInApplicationsTable :(NSInteger) appID {
  for (id aRow in applicationsList) {
    if([[aRow valueForKey:ID_COL] intValue] == appID)
      return YES;
  }
  return NO;
}

@end
