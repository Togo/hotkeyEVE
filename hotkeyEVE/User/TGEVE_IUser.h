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
@property (strong) NSDictionary *userData;

+ (id<TGEVE_IUser>) user;

// User Settings
- (NSInteger) startAtLogin;
- (void) setStartAtLogin :(NSInteger) startAtLogin;
- (NSInteger) userID;

// TODO only for tests visible
- (void) loadUser;

- (BOOL) loadUserRecordWith :(NSString*) userName;

- (BOOL) initializeUserName;
- (NSString*) readUserName;

@end
