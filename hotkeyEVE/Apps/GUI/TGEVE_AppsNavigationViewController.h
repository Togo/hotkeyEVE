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

extern NSString * const TGEVE_CONST_APPS_TABLE_NAVIGATION_NIB_NAME;

extern NSString * const TGEVE_CONST_APPS_TABLE_VIEW_NIB_NAME;
extern NSString * const TGEVE_CONST_APPS_UPDATABLE_NIB_NAME;


@interface TGEVE_AppsNavigationViewController : AppsNavigationViewController <NSTableViewDataSource, NSTableViewDelegate> {
}

@property (strong) NSArray<NSTableViewDataSource> *dataSource;

@property (weak) IBOutlet NSTableView *navigationTableView;
@property (weak) IBOutlet NSTableColumn *navigationTableColumn;



//- (NSPasteboard*) getDragPasteboard :(id <NSDraggingInfo>)info;
@end
