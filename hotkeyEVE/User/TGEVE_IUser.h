//
//  TGEVE_IUser.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/17/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TGEVE_IUser <NSObject>

@property (strong) NSString *userName;
@property NSInteger userID;

+ (id<TGEVE_IUser>) user;

- (void) initUser;

// TODO only for tests visible
- (NSString*) readUserName;

@end
