//
//  EVEUtilities.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "EVEUtilities.h"

@implementation EVEUtilities

+ (Application*) activeApplication {
  NSDictionary *appDic = [[NSWorkspace sharedWorkspace] activeApplication];
  NSString *bundleIdentifier = [appDic valueForKey:@"NSApplicationBundleIdentifier"];
  
  return [[Application alloc] initWithBundleIdentifier:bundleIdentifier];
}

@end
