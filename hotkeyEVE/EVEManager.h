//
//  EVEController.h
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndexingController.h"
#import "UIElementClickedController.h"
#import "EVEObserver.h"
#import "GrowlController.h"
#import "AppLaunchedController.h"
#import "MainMenuController.h"

@interface EVEManager : NSObject

@property (nonatomic, retain)   IndexingController  *indexing;
@property (nonatomic, retain)   EVEObserver  *eveObserver;

@property (nonatomic, retain)   UIElementClickedController  *uiElementClicked;
@property (nonatomic, retain)   AppLaunchedController  *appLaunched;

@property (strong, nonatomic)   GrowlController *growl;
@property (strong, nonatomic)   MainMenuController *mainMenuController;

+ (id) sharedEVEManager;

@end
