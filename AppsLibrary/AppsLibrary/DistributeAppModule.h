//
//  DistributeAppModule.h
//  HotkeyEVE-Apps
//
//  Created by Tobias Sommer on 12/22/12.
//  Copyright (c) 2012 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsLibrary/IWebService.h>

@class AppModule;

@interface DistributeAppModule : NSObject {
  
}

@property (strong) id<IWebService> webService;

- (id) initWithWebService :(id<IWebService>) webService;

- (NSString *)distributeToWebServer:(AppModule *)appModule;

@end
