//
//  AppsNotInstalledViewControllerTests.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/15/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AppsNotInstalledViewController.h"

@interface AppsNotInstalledViewControllerTests : SenTestCase {
  AppsNotInstalledViewController *_appsNotInstalledController;
  
  @private
   NSTableView *_tableView;
  NSTableColumn *_moduleIDTableColumn;
  NSTableColumn *_appNameTableColumn;
  NSTableColumn *_languageTableColumn;
  NSTableColumn *_userNameTableColumn;
  NSTableColumn *_credatTableColumn;
}

@end
