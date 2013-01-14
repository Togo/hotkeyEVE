//
//  AppsNavigationViewController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppsNavigationDelegate.h"
#import "AppsNavigationViewController.h"

extern NSString * const kAppsTableNavigationViewControllerNibName;

@interface AppsTableNavigationViewController : AppsNavigationViewController <NSTableViewDataSource, NSTableViewDelegate> {
}

@property (strong) NSArray<NSTableViewDataSource> *dataSource;
@property (weak) IBOutlet NSTableView *navigationTableView;
@property (weak) IBOutlet NSTableColumn *navigationTableColumn;

@end
