//
//  EVEDatabase.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/3/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "EVEDatabase.h"

@implementation EVEDatabase

- (void) printErrorMessage {
  DDLogError(@"%d: %@", [[self database] lastErrorCode], [[self database] lastErrorMessage]);
}

@end
