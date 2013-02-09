//
//  AppChangedController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/24/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "AppChangedController.h"
#import "ApplicationsTableModel.h"

@implementation AppChangedController

@synthesize activeApplication;

- (void) appFrontChanged :(NSString*) bundleIdentifier {
  DDLogInfo(@"AppChangedController -> appFrontChanged(bundleIdentifier :%@:) :: get called", bundleIdentifier);
  if( ![bundleIdentifier isEqualToString:@"com.togo.hotkeyEVE"] ) {
    activeApplication = [[Application alloc] initWithBundleIdentifier:bundleIdentifier];
    activeApplication.appID = [ApplicationsTableModel getApplicationID:[activeApplication appName] :[activeApplication bundleIdentifier]];
<<<<<<< HEAD
    activeApplication.guiSupport =  YES;
=======
    activeApplication.guiSupport = YES; // delete this property
>>>>>>> V1.4.0-prod
    [[[EVEManager sharedEVEManager] mainMenuController] updateStatusIcon:[activeApplication guiSupport]];
  
  DDLogInfo(@"AppChangedController -> appFrontChanged :: appName => :%@: appID :%li: guiSupport => :%i:",[activeApplication appName], [activeApplication appID], [activeApplication guiSupport]);
  }
}

@end
