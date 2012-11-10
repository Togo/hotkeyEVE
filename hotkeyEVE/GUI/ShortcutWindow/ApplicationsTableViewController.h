//
//  ApplicationsTableViewController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/9/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationsTableViewController : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
  @private
    IBOutlet NSTableView *applicationTable;
    NSArray *applications;
}

@end
