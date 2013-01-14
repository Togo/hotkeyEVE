//
//  AppsNavigationView.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/13/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsNavigationDelegate.h"

@protocol AppsNavigationView <NSObject>

@property (strong) id<AppsNavigationDelegate> delegate;

@end
