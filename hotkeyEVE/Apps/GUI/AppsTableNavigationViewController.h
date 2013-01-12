//
//  AppsNavigationViewController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/11/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppsNavigationDelegate.h"

extern NSString * const kAppsTableNavigationViewControllerNibName;

@interface AppsTableNavigationViewController : NSViewController {
  @public
    id<AppsNavigationDelegate> delegate;
}

- (IBAction)selectionDidChange:(id)sender;

@end
