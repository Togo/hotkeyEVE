//
//  ApplicationsTableModel.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationsTableModel : NSObject

+ (BOOL) isNewApp :(Application*) app;
+ (void) insertNewApplication :(Application*) app;
+ (void) updateApplicationTable :(Application *)app;

+ (NSInteger) getApplicationID :(NSString*) appName :(NSString*) bundleIdentifier;

+ (NSArray*) selectAllApplications;
+ (NSArray*) selectApplicationsFiltered :(NSString*) searchString;

+ (BOOL) isInApplicationBlacklist :(Application*) app;
@end
