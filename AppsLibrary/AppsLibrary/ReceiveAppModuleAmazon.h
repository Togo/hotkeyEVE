//
//  ReceiveAppModuleAmazon.h
//  AppsLibrary
//
//  Created by Tobias Sommer on 1/14/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IReceiveAppModule.h"

@interface ReceiveAppModuleAmazon : NSObject <IReceiveAppModule>

+ (ReceiveAppModuleAmazon*) createReceiverWithAmazonWebService;

@end
