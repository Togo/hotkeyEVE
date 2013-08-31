//
//  AppsNotInstalledViewControllerTests.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/15/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TGEVE_AllAppsViewController.h"

@interface TGEVE_AllAppsViewControllerTests : SenTestCase {
  TGEVE_AllAppsViewController *_appsNotInstalledController;
  
  @private
   NSTableView *_tableView;
  NSTableColumn *_installedTableColumn;
  NSTableColumn *_moduleIDTableColumn;
  NSTableColumn *_appNameTableColumn;
  NSTableColumn *_languageTableColumn;
  NSTableColumn *_userNameTableColumn;
  NSTableColumn *_credatTableColumn;
}

@end
