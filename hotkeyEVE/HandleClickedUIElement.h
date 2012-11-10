//
//  HandleClickedUIElement.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleClickedUIElement : NSObject

+ (BOOL) handleMenuElement :(UIElement*) element;
+ (BOOL) handleGUIElement :(UIElement*) element;

@end
