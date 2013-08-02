//
//  IReceiveAppModule.h
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/20/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebService.h"

@protocol IReceiveAppModule <NSObject>

@property (strong) id<IWebService> webService;

- (AppModule*) getAppWithModuleID :(NSString*) moduleID;
- (id) loadAppList;

@end
