//
//  GUISupportTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GUISupportTableModel : NSObject

+ (NSInteger) hasGUISupport :(NSString*) bundleIdentifier;

@end
