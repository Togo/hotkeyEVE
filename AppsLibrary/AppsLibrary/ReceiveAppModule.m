//
//  ReceiveAppModule.m
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import "ReceiveAppModule.h"

@implementation ReceiveAppModule

- (id) initWithWebService :(id<IWebService>) webService {
  self = [super init];
  if (self) {
    self.webService = webService;
  }
  return self;
}

@end
