//
//  AppsManager.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 1/20/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppsManager : NSObject

- (void) addAppsFromArray :(NSArray*) moduleIDs;
- (void) removeAppsFromArray :(NSArray*) moduleIDs;

@end
