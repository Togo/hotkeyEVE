//
//  ApplicationsTableViewController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "ApplicationsTableViewController.h"
#import "ApplicationsTableModel.h"

@implementation ApplicationsTableViewController

- (id)init {
  self = [super init];
  if (self) {
    applications  = [ApplicationsTableModel getAllApplicationsObjects];
  }
  
  return self;
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
    Application *app = [applications objectAtIndex:row];
  
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    // Then setup properties on the cellView based on the column
    cellView.textField.stringValue = [app appName];
    cellView.imageView.objectValue = [[app runningApplication] icon];
    return cellView;
}

- (void) tableViewSelectionDidChange:(NSNotification *)aNotification {
    DDLogInfo(@"ApplicationsTableViewController: %@", [aNotification name]);
    NSInteger selectedRow = [[aNotification object] selectedRow];
  if (selectedRow != -1) {
    Application *selectedApp = [applications objectAtIndex:selectedRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShortcutsWindowApplicationDidChanged object:selectedApp];
  }
}

@end
