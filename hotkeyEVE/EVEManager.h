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
#import "AppChangedController.h"
#import "MainMenuController.h"
#import "Licence.h"
#import "GlobalHotkeyController.h"

@interface EVEManager : NSObject

@property (nonatomic, retain)   IndexingController  *indexing;
@property (nonatomic, retain)   EVEObserver  *eveObserver;

@property (nonatomic, retain)   UIElementClickedController  *uiElementClicked;

@property (nonatomic, retain)   AppLaunchedController  *appLaunched;
@property (nonatomic, retain)   AppChangedController  *appChangedController;

@property (strong, nonatomic)   GrowlController *growl;
@property (strong, nonatomic)   MainMenuController *mainMenuController;

@property (strong, nonatomic)   Licence *licence;

@property (strong, nonatomic)   GlobalHotkeyController *globalHotkeyController;

+ (id) sharedEVEManager;

@end
