//
//  UIElementUpdatedObserver.h
//  eve-guireader
//
//  Created by Tobias Sommer on 10/24/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIElements/NotificationObserver.h>
#import <UIElements/UIElement.h>

@interface EVEObserver : NSObject <NotificationObserver> {

}

@property (strong, nonatomic)  NSMutableDictionary *subscribedNotifications;

- (void) subscribeAllNotifications;
- (void) unSubscribeAllNotifications;
@end
