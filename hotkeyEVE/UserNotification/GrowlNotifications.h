//
//  EVEMessages.h
//  EVE
//
//  Created by Tobias Sommer on 10/8/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUserNotifications.h"

extern NSString * const TGEVE_GROWL_MULTIPLE_MATCH;

@interface GrowlNotifications : NSObject <IUserNotifications>

+ (id<IUserNotifications>) growlNotifications;

@end
