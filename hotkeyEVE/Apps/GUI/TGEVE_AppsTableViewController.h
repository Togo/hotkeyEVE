//
//  AppsUninstalledViewController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IAppsTableViewController.h"

extern NSString * const kAppsTableViewControllerNibName;

@interface TGEVE_AppsTableViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, IAppsTableViewController> {

}

@property (strong) NSProgressIndicator *progressIndicator;

@property (strong) NSMutableArray<NSTableViewDataSource> *dataSource;

@property (weak) IBOutlet  NSTableView *tableView;
@property (weak) IBOutlet  NSTableColumn *moduleIDTableColumn;
@property (weak) IBOutlet  NSTableColumn *appNameTableColumn;
@property (weak) IBOutlet  NSTableColumn *languageTableColumn;
@property (weak) IBOutlet  NSTableColumn *userNameTableColumn;
@property (weak) IBOutlet  NSTableColumn *credatTableColumn;
@property (weak) IBOutlet  NSTableColumn *installedTableColumn;

- (void) loadTableData;

- (void) startProgressAnimationinSuperview :(NSView*) superview;
- (void) stopProgressAnimation;
- (void) registerObserver;

@end
