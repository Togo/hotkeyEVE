//
//  AppsNavigationViewController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsNavigationView.h"

@interface AppsNavigationViewController : NSViewController <AppsNavigationView>

// this class contains the delegate which will be set from AppsViewController. The AppsViewController contains a AppsNavigationViewController but will be called with a special class of AppsViewController like AppsTableNavigationViewController

@end
