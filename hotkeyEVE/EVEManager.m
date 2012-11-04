//
//  EVEController.m
//  hotkeyEVE
//
//  Created by Tobias Sommer on 11/4/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import "EVEManager.h"

@implementation EVEManager

@synthesize indexing;
@synthesize eveObserver;
@synthesize uiElementClicked;
@synthesize growl;

#pragma mark Singleton Methods

+ (id) sharedEVEManager {
  static EVEManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[self alloc] init];
  });
  
  return manager;
}

- (id)init {
  if (self = [super init]) {
    indexing = [[IndexingController alloc] init];
    
    eveObserver = [[EVEObserver alloc] init];
    
    uiElementClicked = [[UIElementClickedController alloc] init];
    
    growl = [[GrowlController alloc] init];
    [GrowlApplicationBridge setGrowlDelegate:growl];
  }
  
  return self;
}


@end
