//
//  UIElementClickedController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIElements/UIElement.h>

@interface UIElementClickedController : NSObject

@property                     NSInteger messageCount;
@property (strong, nonatomic) Application *lastActiveApp;

- (void) reveicedUIElementClick :(UIElement*) element;

@end
