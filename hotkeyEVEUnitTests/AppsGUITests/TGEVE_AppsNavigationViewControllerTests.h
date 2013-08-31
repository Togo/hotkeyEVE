//
//  AppsTableNavigationViewControllerTests.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class TGEVE_AppsNavigationViewController;

@interface TGEVE_AppsNavigationViewControllerTests : SenTestCase {
  TGEVE_AppsNavigationViewController *_tableNavController;
  
  @private
    NSTableView *_tableView;
    NSTableColumn *_navigationTableColumn;
}

@end
