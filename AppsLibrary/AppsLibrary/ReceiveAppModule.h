//
//  ReceiveAppModule.h
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebService.h"

@interface ReceiveAppModule : NSObject

@property (strong) id<IWebService> webService;

- (id) initWithWebService :(id<IWebService>) webService;

@end
