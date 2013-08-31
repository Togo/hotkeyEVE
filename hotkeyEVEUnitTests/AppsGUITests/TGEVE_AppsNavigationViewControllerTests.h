//
//  AppsTableNavigationViewControllerTests.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class AppsTableNavigationViewController;

@interface AppsTableNavigationViewControllerTests : SenTestCase {
  AppsTableNavigationViewController *_tableNavController;
  
  @private
    NSTableView *_tableView;
    NSTableColumn *_navigationTableColumn;
}

@end
