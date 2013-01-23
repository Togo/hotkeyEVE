//
//  EVEMessages.h
//  EVE
//
//  Created by Tobias Sommer on 10/8/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUserNotifications.h"

@interface GrowlNotifications : NSObject <IUserNotifications>

+ (id<IUserNotifications>) growNotifications;


- (void) display :(NSString*) title :(NSString*) description :(NSDictionary*) clickContext;

@end
