//
//  TGEVE_IUserTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 8/17/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TGEVE_IUserTableModel <NSObject>

+ (NSDictionary*) getUserRecordFromUserDataTable :(NSString*) userName;
//+ (NSInteger) insertUserWithUserName :(NSString*) userName;
//+ (NSInteger)executeGetUserStatement :(NSString *)userName;
@end
