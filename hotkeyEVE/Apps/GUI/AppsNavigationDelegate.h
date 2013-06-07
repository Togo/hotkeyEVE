//
//  AppsNavigationDelegate.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGEVE_IAppsManager.h"

@protocol AppsNavigationDelegate <NSObject>

-(void) viewSelectionDidChanged:(id)viewControllerClass :(NSString*) viewNibName :(id) model;

@end
