//
//  UserDataTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataTableModel : NSObject

+ (void) insertUser :(NSString*) user;

+ (NSInteger) getUserID :(NSString*) userName;
+ (NSInteger) selectStartAtLogin :(NSString*) userName;

@end
