//
//  AppsNavigationDelegate.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/12/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppsNavigationDelegate <NSObject>

-(void)viewSelectionDidChanged:(id)viewControllerClass :(NSString*) viewNibName;

@end
