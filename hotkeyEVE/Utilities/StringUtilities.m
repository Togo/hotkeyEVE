//
//  StringUtilities.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "StringUtilities.h"

@implementation StringUtilities

+ (NSString*) databaseString :(NSString*) str {
  return [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

@end
