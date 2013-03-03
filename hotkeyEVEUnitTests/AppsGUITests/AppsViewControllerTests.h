//
//  AppsViewControllerTests.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class TGEVE_AppsWindowViewController;

@interface AppsViewControllerTests : SenTestCase {
  TGEVE_AppsWindowViewController *_appsViewController;
  NSView *_navigationView;
  NSView *_mainContentView;
}

@end
