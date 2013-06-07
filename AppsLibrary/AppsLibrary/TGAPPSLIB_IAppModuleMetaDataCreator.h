//
//  TGAPPSLIB_IAppModuleMetaDataCreator.h
//  AppsLibrary
//
//  Created by Tobias Sommer on 3/28/13.
//  Copyright (c) 2013 Tobias Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TGAPPSLIB_IAppModuleMetaDataCreator <NSObject>

- (NSMutableDictionary *)createMetaDataDictionary;

@end
