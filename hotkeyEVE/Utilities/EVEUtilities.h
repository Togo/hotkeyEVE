//
//  EVEUtilities.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVEUtilities : NSObject

+ (Application*) activeApplication;
+ (NSString*) currentLanguage;
+ (NSString*) getMacAddress;
+ (void) restartEVE;

+ (void) addAppToLoginItems;
+ (void) removeAppFromLoginItems;
+ (void) openWebShop;
+ (void) checkAccessibilityAPIEnabled;


@end
